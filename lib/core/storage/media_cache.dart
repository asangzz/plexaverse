import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'db_key_manager.dart';
import 'secure_storage.dart';
import 'storage_keys.dart';

part 'media_cache.g.dart';

/// Encrypted filesystem-backed media cache (ProHealth §7, §8, §11.2).
///
/// Layout:
///   - `media/` — uploaded items keyed by server media id (encrypted)
///   - `media/pending/<jobId>/` — items captured but not yet uploaded
///     (encrypted)
///
/// Files on disk are AES-256-GCM ciphertext: `[12-byte nonce][ciphertext]
/// [16-byte tag]`. The key is generated on first launch and lives in
/// `flutter_secure_storage` under [StorageKeys.mediaEncryptionKey] — a rooted
/// device can read the file blobs but cannot decrypt them without also
/// extracting the Keystore/Keychain entry. The media key is deliberately
/// distinct from the DB key (see [StorageKeys]).
///
/// Eviction (§7.7): app-start sweep deletes files older than
/// `AppConfig.mediaRetention` belonging to completed-or-discarded jobs — see
/// `media_cache_sweeper.dart`.
class MediaCache {
  MediaCache._(this._root, this._cipher, this._key);

  final Directory _root;
  final AesGcm _cipher;
  final SecretKey _key;

  static const _nonceLength = 12;

  static Future<MediaCache> create(SecureStorageService secure) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'media'));
    if (!dir.existsSync()) await dir.create(recursive: true);
    final cipher = AesGcm.with256bits();
    final key = await _resolveKey(secure, cipher);
    return MediaCache._(dir, cipher, key);
  }

  Directory pendingDirFor(String jobId) {
    return Directory(p.join(_root.path, 'pending', jobId));
  }

  File fileForMediaId(String mediaId) {
    return File(p.join(_root.path, mediaId));
  }

  /// Encrypts [plaintext] and writes it to a new file under
  /// `media/pending/<jobId>/<filename>`. The caller hands the encrypted
  /// [File] to its repository, which later passes it to [commitUpload] once
  /// the server has issued a media id.
  Future<File> writeEncrypted({
    required String jobId,
    required String filename,
    required Uint8List plaintext,
  }) async {
    final dir = pendingDirFor(jobId);
    if (!dir.existsSync()) await dir.create(recursive: true);
    final file = File(p.join(dir.path, filename));
    final blob = await _encrypt(plaintext);
    await file.writeAsBytes(blob, flush: true);
    return file;
  }

  /// Reads and decrypts an on-disk media file. Throws
  /// [SecretBoxAuthenticationError] if the file has been tampered with —
  /// callers should treat that as "file is corrupt, discard" rather than
  /// retrying.
  Future<Uint8List> readDecrypted(File file) async {
    final blob = await file.readAsBytes();
    return _decrypt(blob);
  }

  /// Moves a captured file from the pending area into the cache keyed by the
  /// server-issued media id (§11.2 stage 5). The file content is already
  /// encrypted; this is a plain filesystem rename.
  Future<File> commitUpload({
    required File pending,
    required String mediaId,
  }) async {
    final target = fileForMediaId(mediaId);
    if (target.existsSync()) await target.delete();
    return pending.rename(target.path);
  }

  /// Conservative sweep — only deletes when the caller confirms the
  /// containing job is completed/discarded via [isEligible]. The drift-side
  /// bookkeeping is wired in `media_cache_sweeper.dart` alongside the sync
  /// engine.
  Future<int> evictOlderThan(
    Duration age, {
    required bool Function(File) isEligible,
  }) async {
    if (!_root.existsSync()) return 0;
    final cutoff = DateTime.now().subtract(age);
    var removed = 0;
    await for (final entity in _root.list(recursive: true)) {
      if (entity is! File) continue;
      final stat = entity.statSync();
      if (stat.modified.isAfter(cutoff)) continue;
      if (!isEligible(entity)) continue;
      await entity.delete();
      removed++;
    }
    return removed;
  }

  Future<List<int>> _encrypt(Uint8List plaintext) async {
    final nonce = _cipher.newNonce();
    final box =
        await _cipher.encrypt(plaintext, secretKey: _key, nonce: nonce);
    return <int>[...nonce, ...box.cipherText, ...box.mac.bytes];
  }

  Future<Uint8List> _decrypt(Uint8List blob) async {
    if (blob.length < _nonceLength + 16) {
      throw const FormatException('media blob shorter than nonce + mac');
    }
    final nonce = blob.sublist(0, _nonceLength);
    final macStart = blob.length - 16;
    final cipherText = blob.sublist(_nonceLength, macStart);
    final mac = Mac(blob.sublist(macStart));
    final box = SecretBox(cipherText, nonce: nonce, mac: mac);
    final plain = await _cipher.decrypt(box, secretKey: _key);
    return Uint8List.fromList(plain);
  }

  /// Resolves the 32-byte AES key. Reuses [DbKeyManager]'s hex generation /
  /// validation idiom so both encrypted subsystems share one convention,
  /// while keeping the key VALUE independent (distinct storage key).
  static Future<SecretKey> _resolveKey(
    SecureStorageService secure,
    AesGcm cipher,
  ) async {
    final existing = await secure.read(StorageKeys.mediaEncryptionKey);
    if (existing != null && DbKeyManager.isValid64HexKey(existing)) {
      return SecretKey(_decodeHex(existing));
    }
    final hex = DbKeyManager.generateHexKey();
    await secure.write(StorageKeys.mediaEncryptionKey, hex);
    return SecretKey(_decodeHex(hex));
  }

  static List<int> _decodeHex(String hex) {
    final out = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < out.length; i++) {
      out[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return out;
  }
}

@Riverpod(keepAlive: true)
Future<MediaCache> mediaCache(Ref ref) async {
  return MediaCache.create(ref.watch(secureStorageProvider));
}
