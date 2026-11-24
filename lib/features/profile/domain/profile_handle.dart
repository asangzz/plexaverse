/// The public profile's handle — the shape half of the web's
/// `lib/profile-handle.ts` `checkHandle`, for the field's instant feedback.
///
/// The SERVER is the rule: it enforces the shape on every write, keeps the
/// reserved list (every page of the site, and more) and knows who holds a
/// handle. So this checks only what can be judged without asking — empty,
/// length, shape, and the one stem that would let anyone pass as Plexaverse
/// — and the availability check (`GET /profile?handle=`) says the rest,
/// `reserved` and `taken` included, in the server's own sentence.
library;

/// The shortest and longest handle.
const int kHandleMin = 3;
const int kHandleMax = 30;

/// a-z0-9 runs joined by single hyphens. Length is checked separately.
final RegExp _shape = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');

/// What a user typed, as the handle it would be: trimmed and lowercased, a
/// leading `@` or `/` dropped. The web's `normaliseHandle`.
String normaliseHandle(String raw) =>
    raw.trim().replaceFirst(RegExp(r'^[@/]+'), '').toLowerCase();

/// A handle the field can send, or why not — the server's own sentences.
sealed class HandleCheck {
  const HandleCheck();
}

/// [handle] is the normalised form the server stores.
final class HandleOk extends HandleCheck {
  const HandleOk(this.handle);
  final String handle;
}

final class HandleProblem extends HandleCheck {
  const HandleProblem(this.message);
  final String message;
}

/// The shape rule, in the web's words.
HandleCheck checkHandle(String raw) {
  final String handle = normaliseHandle(raw);
  if (handle.isEmpty) {
    return const HandleProblem('Choose a handle for your page.');
  }
  if (handle.length < kHandleMin || handle.length > kHandleMax) {
    return const HandleProblem(
      'A handle is $kHandleMin to $kHandleMax characters long.',
    );
  }
  if (!_shape.hasMatch(handle)) {
    return const HandleProblem(
      'Use only letters and numbers, with single hyphens between them (like '
      'asang-borkar).',
    );
  }
  // The web's IMPERSONATION_STEMS: nobody passes as Plexaverse. The rest of
  // the reserved list is the server's to say.
  if (handle.contains('plexaverse')) {
    return const HandleProblem('That handle is reserved. Try another.');
  }
  return HandleOk(handle);
}

/// The page's address, for "View my page" — the web's `SITE_URL`, never the
/// flavour's API base.
String publicProfileUrl(String handle) => 'https://www.plexaverse.com/$handle';
