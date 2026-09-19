import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/security/pkce.dart';

void main() {
  group('PkcePair', () {
    test('matches the RFC 7636 appendix-B vector', () {
      // The spec's own worked example. If base64url padding, the hash input
      // encoding, or the digest ever change, Google starts rejecting every
      // exchange with invalid_grant — and this catches it here instead.
      const String verifier = 'dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk';
      const String expected = 'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM';

      expect(PkcePair.fromVerifier(verifier).challenge, expected);
    });

    test('generates a 43-char unpadded base64url verifier', () {
      final PkcePair p = PkcePair.generate();
      expect(p.verifier.length, 43);
      expect(p.verifier.contains('='), isFalse);
      // Only the RFC's unreserved set.
      expect(RegExp(r'^[A-Za-z0-9\-._~]+$').hasMatch(p.verifier), isTrue);
    });

    test('challenge is unpadded base64url', () {
      final PkcePair p = PkcePair.generate();
      expect(p.challenge.contains('='), isFalse);
      expect(p.challenge.length, 43);
    });

    test('every pair is distinct', () {
      final Set<String> seen = <String>{
        for (int i = 0; i < 50; i++) PkcePair.generate().verifier,
      };
      expect(seen.length, 50);
    });

    test('method is S256 — never plain', () {
      // The server rejects anything else, and `plain` would defeat the point.
      expect(PkcePair.method, 'S256');
    });
  });
}
