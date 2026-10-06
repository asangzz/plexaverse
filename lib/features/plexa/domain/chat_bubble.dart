/// One line in the conversation.
///
/// Mirrors `ChatBubble` in the web's `components/chat/PlexaChatKit.tsx`. Kept
/// as a plain class rather than a freezed model: it is never serialised, never
/// compared, and lives only as long as the sheet is open.
class ChatBubble {
  ChatBubble({
    required this.role,
    required this.text,
    this.badge,
    this.badgeTone = ChatBadgeTone.ok,
  }) : id = '${DateTime.now().microsecondsSinceEpoch}-${_seq++}';

  static int _seq = 0;

  /// Unique per bubble, so the list can key on it. Two lines sent in the same
  /// microsecond would otherwise collide and animate as one.
  final String id;

  final ChatRole role;
  final String text;

  /// A small qualifier beside a user line — "copied", for the turn where the
  /// draft went to the clipboard.
  final String? badge;

  /// How that qualifier should read.
  final ChatBadgeTone badgeTone;
}

enum ChatRole { bot, user }

/// What a badge is reporting.
///
/// The web only ever has one of these, and draws it green with a check. This
/// port needs the other: on a phone the hand-off to LinkedIn can genuinely
/// fail, and a green tick beside "linkedin didn't open" would be the app
/// contradicting itself in the same breath.
enum ChatBadgeTone { ok, warn }

/// Typing delays, shared so every Plexa surface has the same cadence.
///
/// Ported from `BOT_DELAY_MS` / `SEQ_FIRST_MS` / `SEQ_NEXT_MS`. These are not
/// decoration: the pauses are what make the thread read as someone thinking
/// rather than as a form that printed itself. A conversation with no latency
/// is a list.
class ChatTiming {
  const ChatTiming._();

  /// A single line.
  static const Duration bot = Duration(milliseconds: 700);

  /// The first line of a sequence — shorter, because the user just acted and
  /// is waiting on an answer.
  static const Duration sequenceFirst = Duration(milliseconds: 600);

  /// Every line after it — longer, because the user is now reading.
  static const Duration sequenceNext = Duration(milliseconds: 950);
}
