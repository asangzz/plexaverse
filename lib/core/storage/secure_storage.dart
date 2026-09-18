import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

/// Adapter over `flutter_secure_storage`. Features never import the package
/// directly (ProHealth §8, `direct_package_import` convention) — everything
/// goes through this seam.
///
/// All keys are looked up via `StorageKeys`; raw string literals are flagged
/// by the `hardcoded_storage_key` convention.
///
/// Platform errors (Keystore wipe after biometric re-enrol, Keychain access
/// denial while backgrounded, corrupted entries) are translated into a typed
/// [SecureStorageException]. Callers that can recover (e.g. by re-running the
/// encryption-key generator) catch the typed exception; others let it
/// propagate so the zone guard records it.
class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } on PlatformException catch (e, st) {
      throw SecureStorageException(
        operation: 'read',
        key: key,
        cause: e,
        stackTrace: st,
      );
    }
  }

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } on PlatformException catch (e, st) {
      throw SecureStorageException(
        operation: 'write',
        key: key,
        cause: e,
        stackTrace: st,
      );
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } on PlatformException catch (e, st) {
      throw SecureStorageException(
        operation: 'delete',
        key: key,
        cause: e,
        stackTrace: st,
      );
    }
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } on PlatformException catch (e, st) {
      throw SecureStorageException(
        operation: 'deleteAll',
        key: null,
        cause: e,
        stackTrace: st,
      );
    }
  }
}

class SecureStorageException implements Exception {
  SecureStorageException({
    required this.operation,
    required this.key,
    required this.cause,
    required this.stackTrace,
  });

  final String operation;
  final String? key;
  final PlatformException cause;
  final StackTrace stackTrace;

  @override
  String toString() =>
      'SecureStorageException(op=$operation, key=$key, cause=${cause.code})';
}

const _secureStorage = FlutterSecureStorage(
  // v10 ignores `encryptedSharedPreferences`; default Android storage is
  // encrypted. iOS uses first-unlock-this-device so background reads work
  // after the first unlock but the entry never syncs to other devices.
  aOptions: AndroidOptions.defaultOptions,
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  ),
);

@Riverpod(keepAlive: true)
SecureStorageService secureStorage(Ref ref) {
  return SecureStorageService(_secureStorage);
}
