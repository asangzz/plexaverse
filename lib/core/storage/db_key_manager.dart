import 'dart:math';

import 'secure_storage.dart';
import 'storage_keys.dart';

/// Resolves the 256-bit SQLCipher key for the encrypted Drift database
/// (RULINGS ruling 9, ProHealth §8/§9).
///
/// The key is generated on first launch with `Random.secure()` (32 bytes →
/// 64 lowercase hex chars), persisted into `flutter_secure_storage` under
/// [StorageKeys.driftEncryptionKey], and format-validated on every read. A
/// missing or malformed key regenerates — acceptable during dev because we
/// ship a fresh `schemaVersion = 1` with no migration path (RULINGS ruling
/// 9: wiping the local DB is acceptable at this stage).
///
/// Extracted from the database file (which ProHealth inlines) per the shared
/// manifest, which names `db_key_manager.dart` as its own seam so the media
/// cache and any future encrypted store share the same generation idiom.
class DbKeyManager {
  const DbKeyManager(this._secure);

  final SecureStorageService _secure;

  /// Returns a valid 64-char hex key, generating + persisting one on first
  /// launch (or when the stored value fails validation).
  Future<String> resolveHexKey() async {
    final existing = await _secure.read(StorageKeys.driftEncryptionKey);
    if (existing != null && isValid64HexKey(existing)) {
      return existing;
    }
    final hex = generateHexKey();
    await _secure.write(StorageKeys.driftEncryptionKey, hex);
    return hex;
  }

  /// 32 secure-random bytes hex-encoded to 64 lowercase chars.
  static String generateHexKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  /// True iff [candidate] is exactly 64 hexadecimal characters (upper or
  /// lower case). Used to reject partially-written / corrupted entries so a
  /// bad key regenerates rather than bricking the open.
  static bool isValid64HexKey(String candidate) {
    if (candidate.length != 64) return false;
    for (final code in candidate.codeUnits) {
      final isDigit = code >= 0x30 && code <= 0x39;
      final isLowerHex = code >= 0x61 && code <= 0x66;
      final isUpperHex = code >= 0x41 && code <= 0x46;
      if (!isDigit && !isLowerHex && !isUpperHex) return false;
    }
    return true;
  }
}
