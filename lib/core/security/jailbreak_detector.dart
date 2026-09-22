import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:freerasp/freerasp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../logging/app_logger.dart';

part 'jailbreak_detector.g.dart';

/// RASP wrapper around `freerasp` (Talsec). Replaces the long-stale
/// `flutter_jailbreak_detection`. Login is blocked when the device is
/// privileged-access (root/jailbreak) or hooked (Frida/Magisk/etc).
///
/// freerasp is event-driven: `start()` boots the Talsec native runtime,
/// then threats arrive asynchronously through the listener. The first few
/// hundred milliseconds after start are the only window we can miss; the
/// AuthController is expected to call `start()` once during app boot and
/// then `isCompromised()` right before submitting credentials, by which
/// point the first sweep is complete.
class JailbreakDetector {
  JailbreakDetector({
    required TalsecConfig config,
    required AppLogger logger,
  })  : _config = config,
        _logger = logger;
  // ignore_for_file: prefer_initializing_formals

  final TalsecConfig _config;
  final AppLogger _logger;

  bool _privilegedAccess = false;
  bool _hooks = false;
  bool _simulator = false;
  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;
    unawaited(
      Future<void>.sync(
        () => Talsec.instance.attachListener(_buildCallback()),
      ),
    );
    await _safeStartTalsec();
  }

  ThreatCallback _buildCallback() {
    return ThreatCallback(
      onPrivilegedAccess: _flagPrivilegedAccess,
      onHooks: _flagHooks,
      onSimulator: _flagSimulator,
      onDebug: () => _logger.warn('RASP: debugger attached'),
      onAppIntegrity: () => _logger.warn('RASP: app integrity failed'),
      onUnofficialStore: () => _logger.warn('RASP: unofficial store install'),
      onObfuscationIssues: () => _logger.warn('RASP: obfuscation issues'),
      onDeviceBinding: () => _logger.warn('RASP: device binding failed'),
      onDeviceID: () => _logger.warn('RASP: device id mismatch'),
      onPasscode: () => _logger.warn('RASP: device passcode not set'),
      onSecureHardwareNotAvailable: () =>
          _logger.warn('RASP: no secure hardware'),
      onSystemVPN: () => _logger.warn('RASP: system VPN active'),
    );
  }

  void _flagPrivilegedAccess() {
    _privilegedAccess = true;
    _logger.warn('RASP: privileged access detected');
  }

  void _flagHooks() {
    _hooks = true;
    _logger.warn('RASP: hooks detected');
  }

  void _flagSimulator() {
    _simulator = true;
    _logger.warn('RASP: simulator detected');
  }

  /// Don't lock users out of the app if Talsec init blows up (e.g. an old
  /// OS version Talsec doesn't support). Log loudly and let login proceed.
  Future<void> _safeStartTalsec() async {
    try {
      await Talsec.instance.start(_config);
    } on Object catch (error, stack) {
      _logger.error(
        'RASP: Talsec.start failed',
        error: error,
        stackTrace: stack,
      );
    }
  }

  /// True when login should be blocked. Simulators fire constantly in
  /// debug, so they only count in release builds.
  Future<bool> isCompromised() async {
    if (_privilegedAccess || _hooks) return true;
    if (!kDebugMode && _simulator) return true;
    return false;
  }
}

/// Talsec needs the production bundle id / package name + signing cert
/// hashes + Apple team id. These MUST be filled in before release — the
/// wrong values cause Talsec to flag every install as `appIntegrity`,
/// blocking real users.
///
/// `watcherMail` receives the per-install threat reports; register at
/// https://www.talsec.app to obtain one.
//
// TODO(security): replace the placeholder Talsec config (watcherMail,
// signing cert hashes, Apple team id) with real values before prod rollout
// (RULINGS §12). `bootstrap/release_guards.dart` refuses a prod boot until
// this is done.
TalsecConfig buildTalsecConfig() {
  return TalsecConfig(
    watcherMail: 'security@plexaverse.com',
    isProd: !kDebugMode,
    androidConfig: AndroidConfig(
      packageName: 'com.plexaverse.app',
      // freeRASP validates the hash FORMAT at AndroidConfig construction time
      // (valid base64 decoding to exactly 32 bytes) even in debug, where the
      // integrity checks don't actually run (isProd=false). The real release
      // placeholder isn't a valid hash, so it crashes debug/dev runs on Android
      // ("Invalid hash length"). Use a valid 32-byte dummy in debug so the app
      // boots; keep the real placeholder for release builds — the release guard
      // in bootstrap/release_guards.dart still refuses a prod boot on it.
      // Release builds take the hash from a BUILD-TIME define rather than an
      // edited source file: it is environment-specific, not secret, and
      // hard-coding it means every developer with a different keystore has to
      // edit and un-edit the same line.
      //
      //   --dart-define=ANDROID_SIGNING_CERT_SHA256=<base64 of the 32 raw bytes>
      //
      // BASE64, not the colon-separated hex `keytool -list` prints. freeRASP
      // validates the format at construction and an hex string fails as
      // "Invalid hash length".
      //
      // Unset, it stays the placeholder — which the release guard in
      // bootstrap/release_guards.dart refuses to boot prod with, deliberately.
      signingCertHashes: kDebugMode
          ? const <String>['AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=']
          : const <String>[
              String.fromEnvironment(
                'ANDROID_SIGNING_CERT_SHA256',
                defaultValue: 'REPLACE_WITH_RELEASE_SIGNING_CERT_SHA256',
              ),
            ],
      supportedStores: const <String>['com.android.vending'],
    ),
    iosConfig: IOSConfig(
      bundleIds: const <String>['com.plexaverse.app'],
      teamId: 'REPLACE_WITH_APPLE_TEAM_ID',
    ),
  );
}

@Riverpod(keepAlive: true)
JailbreakDetector jailbreakDetector(Ref ref) {
  return JailbreakDetector(
    config: buildTalsecConfig(),
    logger: ref.watch(appLoggerProvider),
  );
}
