/// Normalising what someone typed into E.164.
///
/// A Dart mirror of `normalisePhone` in the web's `lib/whatsapp.ts`. The
/// server normalises again and is the authority; this exists so the app can
/// show the resolved number BACK to the user before anything is sent.
///
/// ## Why the preview is not cosmetic
///
/// A mistyped country code is the single mistake here that texts a stranger:
/// someone who never signed up, cannot unsubscribe, and whose only recourse
/// is to report us to Meta — which costs the sending number's quality rating.
/// Showing `+91 98765 43210` back before the send makes the assumption
/// visible instead of silent.
///
/// ## Why no country is guessed
///
/// This product is India-first, so assuming +91 would be right most of the
/// time. The times it is wrong, a code lands on a phone in another country.
/// A bare national number is accepted only with an explicit country code the
/// caller passed in.
///
/// Deliberately hand-rolled, like the web's: pulling a phone library in to
/// validate one field is a bad trade. It accepts some numbers that are not
/// really assignable; Meta rejects those at send time, which is the authority
/// that actually matters.
library;

/// E.164: a leading +, then 8–15 digits, the first of which is not 0.
final RegExp _e164 = RegExp(r'^\+[1-9]\d{7,14}$');
final RegExp _digitsOnly = RegExp(r'^\+\d+$');
final RegExp _separators = RegExp(r'[\s\-().]');
final RegExp _leadingZeros = RegExp(r'^0+');

/// The outcome of reading a typed number.
class PhoneResult {
  const PhoneResult.ok(String this.e164) : error = null;
  const PhoneResult.bad(String this.error) : e164 = null;

  /// Full E.164, only when this is ok.
  final String? e164;

  /// One finished sentence, safe to show.
  final String? error;

  bool get isOk => e164 != null;
}

/// Read [raw] as E.164, using [defaultCc] only when it carries no `+`.
PhoneResult normalisePhone(String raw, {String? defaultCc}) {
  final String trimmed = raw.trim();
  if (trimmed.isEmpty) return const PhoneResult.bad('Enter your WhatsApp number.');

  // Everything people type between digits: spaces, dashes, dots, brackets.
  final String cleaned = trimmed.replaceAll(_separators, '');

  // 00 is the international prefix in much of the world and means +.
  final String plussed = cleaned.startsWith('00') ? '+${cleaned.substring(2)}' : cleaned;

  String candidate = plussed;
  if (!candidate.startsWith('+')) {
    if (defaultCc == null || defaultCc.isEmpty) {
      return const PhoneResult.bad(
        'Include your country code, like +91 98765 43210.',
      );
    }
    final String cc = defaultCc.startsWith('+') ? defaultCc : '+$defaultCc';
    // A national number written with its trunk prefix — 0 98765 43210.
    candidate = '$cc${candidate.replaceFirst(_leadingZeros, '')}';
  }

  if (!_digitsOnly.hasMatch(candidate)) {
    return const PhoneResult.bad('That does not look like a phone number.');
  }
  if (!_e164.hasMatch(candidate)) {
    return const PhoneResult.bad(
      'That number is the wrong length. Check the country code and try again.',
    );
  }
  return PhoneResult.ok(candidate);
}
