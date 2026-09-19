import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// A PKCE verifier/challenge pair (RFC 7636).
///
/// The app generates a high-entropy VERIFIER, sends only its SHA-256
/// CHALLENGE to start the flow, and presents the verifier when redeeming the
/// authorization code. An attacker who intercepts the code — by claiming the
/// custom scheme, or off a shared browser — cannot redeem it without the
/// verifier, which never leaves the device.
///
/// So: keep the pair in a LOCAL VARIABLE across the browser await. Never in
/// shared_preferences, never in secure storage. It is single-use and lives for
/// seconds; persisting it only creates something to steal.
class PkcePair {
  const PkcePair({required this.verifier, required this.challenge});

  /// 43–128 unreserved characters. Sent only at redemption.
  final String verifier;

  /// `base64url(sha256(verifier))`, no padding. Sent at authorize time.
  final String challenge;

  /// The challenge method. The spec permits `plain`; we never use it, and the
  /// server rejects anything but this.
  static const String method = 'S256';

  static final Random _random = Random.secure();

  factory PkcePair.generate() {
    // 32 bytes → a 43-char base64url verifier, the length the RFC's own
    // example uses and the minimum it allows.
    final List<int> bytes = List<int>.generate(32, (_) => _random.nextInt(256));
    return PkcePair.fromVerifier(_base64UrlNoPad(bytes));
  }

  /// Derives the challenge for an existing verifier.
  ///
  /// The single derivation both the generator and the tests go through, so a
  /// change to the encoding cannot pass the suite while breaking the flow.
  factory PkcePair.fromVerifier(String verifier) => PkcePair(
    verifier: verifier,
    challenge: _base64UrlNoPad(sha256.convert(utf8.encode(verifier)).bytes),
  );

  /// base64url WITHOUT padding. The `=` padding is not in the RFC's
  /// unreserved set and Google rejects a padded challenge.
  static String _base64UrlNoPad(List<int> bytes) =>
      base64UrlEncode(bytes).replaceAll('=', '');
}
