import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/settings/domain/phone_number.dart';

/// Reading a typed number, against the web's `normalisePhone`.
///
/// The preview this feeds is the only thing standing between a mistyped
/// country code and a verification code landing on a stranger's phone — a
/// person who never signed up, cannot unsubscribe, and whose only recourse is
/// to report us to Meta. So the cases below are the ways a number goes wrong,
/// not the ways it goes right.
void main() {
  group('what it accepts', () {
    test('a plain E.164 number', () {
      expect(normalisePhone('+919876543210').e164, '+919876543210');
    });

    test('the spacing people actually type', () {
      for (final String typed in <String>[
        '+91 98765 43210',
        '+91-98765-43210',
        '+91 (98765) 43210',
        '  +91.98765.43210  ',
      ]) {
        expect(normalisePhone(typed).e164, '+919876543210', reason: typed);
      }
    });

    test('00 as the international prefix', () {
      // 00 means + across much of the world, and a user who dials that way
      // types it that way.
      expect(normalisePhone('0091 98765 43210').e164, '+919876543210');
    });

    test('a national number with an explicit country code', () {
      expect(
        normalisePhone('98765 43210', defaultCc: '+91').e164,
        '+919876543210',
      );
      expect(
        normalisePhone('9876543210', defaultCc: '91').e164,
        '+919876543210',
      );
    });

    test('a trunk prefix is dropped, not kept', () {
      // 0 98765 43210 is how the number is written inside India. Keeping the
      // 0 produces +910987654321, which is a different, wrong number.
      expect(
        normalisePhone('098765 43210', defaultCc: '+91').e164,
        '+919876543210',
      );
    });
  });

  group('what it refuses', () {
    test('nothing typed', () {
      expect(normalisePhone('   ').isOk, isFalse);
      expect(normalisePhone('').error, contains('Enter your WhatsApp number'));
    });

    test('a bare national number with NO country code', () {
      // The one that matters. Guessing +91 would be right most of the time in
      // this product — and the times it is wrong, a code lands on a phone in
      // another country belonging to someone who never asked for it.
      final PhoneResult r = normalisePhone('9876543210');
      expect(r.isOk, isFalse);
      expect(r.error, contains('country code'));
    });

    test('letters', () {
      expect(normalisePhone('+91 call-me').isOk, isFalse);
      expect(normalisePhone('not a number').isOk, isFalse);
    });

    test('too short and too long', () {
      expect(normalisePhone('+1234567').isOk, isFalse, reason: '7 digits');
      expect(normalisePhone('+1234567890123456').isOk, isFalse, reason: '16 digits');
      expect(normalisePhone('+12345678').isOk, isTrue, reason: '8 is the floor');
    });

    test('a country code starting with zero', () {
      // E.164 has no +0 country code; accepting it sends to nowhere.
      expect(normalisePhone('+09876543210').isOk, isFalse);
    });

    test('a wrong-length number says to check the country code', () {
      // The error has to point at the likely cause. "Invalid number" sends
      // the user to re-check the digits they got right.
      expect(
        normalisePhone('+911').error,
        contains('country code'),
      );
    });
  });

  group('the preview it exists for', () {
    test('shows what will actually be messaged, not what was typed', () {
      final PhoneResult r = normalisePhone('98765 43210', defaultCc: '+1');
      // A user who meant India and whose app defaulted to +1 sees +1 here,
      // before anything is sent. That is the whole point.
      expect(r.e164, '+19876543210');
      expect(r.e164, isNot('+919876543210'));
    });
  });
}
