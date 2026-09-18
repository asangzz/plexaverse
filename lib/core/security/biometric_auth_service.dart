import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometric_auth_service.g.dart';

/// Outcome of a biometric / device-credential authentication attempt, mapped
/// from `local_auth` so feature code never touches the plugin's types
/// directly (ProHealth §2.4 DIP — the adapter keeps the plugin contained).
///
/// Plexaverse uses this to gate app re-entry on resume / cold start while a
/// session exists (RULINGS §12 — biometric app lock with device-credential
/// fallback).
enum BiometricOutcome {
  /// The user authenticated successfully (biometric OR device credential).
  success,

  /// The user failed the challenge without a terminal error (e.g. a wrong
  /// fingerprint) — retrying is reasonable.
  failed,

  /// The user dismissed / cancelled the prompt (or the system cancelled it).
  canceled,

  /// Locked out after too many attempts — retry later or fall back to a full
  /// password sign-in.
  lockedOut,

  /// The device can't authenticate: no hardware, nothing enrolled, and no
  /// device credential set. Biometric unlock can't be offered.
  unavailable,
}

/// Adapter around `local_auth`. Authentication always allows the device
/// credential (PIN / pattern / passcode) as a fallback so the user is never
/// stranded if biometrics fail or lock out (`biometricOnly: false`).
class BiometricAuthService {
  BiometricAuthService({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  /// True when the device can authenticate the user — biometrics OR a device
  /// credential. This is what gates whether biometric unlock can be offered.
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported();
    } on Object {
      return false;
    }
  }

  /// Prompt for authentication. [reason] is shown in the system dialog.
  /// Allows the device credential as a fallback (never biometric-only) and
  /// survives the app being backgrounded by the prompt itself.
  Future<BiometricOutcome> authenticate({required String reason}) async {
    try {
      final ok = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      return ok ? BiometricOutcome.success : BiometricOutcome.failed;
    } on LocalAuthException catch (e) {
      return switch (e.code) {
        LocalAuthExceptionCode.userCanceled ||
        LocalAuthExceptionCode.systemCanceled ||
        LocalAuthExceptionCode.timeout =>
          BiometricOutcome.canceled,
        LocalAuthExceptionCode.temporaryLockout ||
        LocalAuthExceptionCode.biometricLockout =>
          BiometricOutcome.lockedOut,
        LocalAuthExceptionCode.noCredentialsSet ||
        LocalAuthExceptionCode.noBiometricsEnrolled ||
        LocalAuthExceptionCode.noBiometricHardware ||
        LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable =>
          BiometricOutcome.unavailable,
        _ => BiometricOutcome.failed,
      };
    } on Object {
      return BiometricOutcome.failed;
    }
  }
}

@Riverpod(keepAlive: true)
BiometricAuthService biometricAuthService(Ref ref) => BiometricAuthService();
