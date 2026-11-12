/// Plexa's two other clip sets: the contest quiz's, and her one-off moments.
///
/// A port of `QUIZ_CLIPS` and `MOMENT_CLIPS` in the web's
/// `components/plexa/clips.ts` — read that file's doc for how each set is cut.
/// Neither is cut to [PlexaFrame], which is why neither goes through
/// `PlexaMascot`: its bird-footprint geometry assumes the shared mascot frame.
///
/// The files in `assets/videos/` are byte-for-byte copies of the web's
/// `public/videos/`, minus the content hash, with the web id's hyphens as
/// underscores. Copy them again whenever the web re-cuts one (b50bd28 re-cut
/// six at once) — the hash in `clips.ts` is how to tell which file is current.
///
/// Only the clips some app screen plays are bundled. The rest of the web's
/// moments are not wired on the web (`rank-up`, `reminder-clock`), cannot fire
/// (`rest-day`: every contest day has a lesson), or belong to screens the app
/// does not have (`voice-practice`, and the planner's post modal's
/// `lesson-writing`, `poster-painting` and `post-sent`). Bundling a clip costs
/// every install its bytes, so one goes in with the screen that plays it.
library;

import 'package:flutter/widgets.dart';

import 'plexa_clips.dart' show PlexaFrame;

/// The quiz set's frame: narrower than [PlexaFrame], so the spread wing of
/// the thumbs-up fits.
abstract final class QuizFrame {
  static const double width = 520;
  static const double height = 432;
  static const double aspect = width / height;
}

/// What Plexa is doing in the quiz: looking a question over, or reacting to
/// its answer. One clip each.
///
/// They hand over to EACH OTHER, frame to frame: [inspect] ends on the
/// close-up a reaction starts from, and a reaction ends standing, where
/// [inspect] starts — so a question, its answer and the next question play as
/// one take (see `QuizPlexa`).
enum QuizMood {
  /// Standing → leans into a magnifying glass (close-up). 4.2 s.
  inspect,

  /// Close-up → steps back, thumbs up, wing out → standing. 8 s.
  correct,

  /// Close-up → lowers the glass, a little crestfallen → standing. 7.5 s.
  wrong;

  bool get isReaction => this != inspect;

  String get video => 'assets/videos/plexa_quiz_$name.mp4';

  /// Shown instead of the clip under reduced motion or when it cannot play:
  /// the close-up for [inspect], the thumbs-up at 4.5 s for [correct],
  /// standing crestfallen at 5.5 s for [wrong].
  String get still => 'assets/videos/plexa_quiz_${name}_still.jpg';
}

/// Every moment is cropped to its own box, then padded to this frame.
abstract final class MomentFrame {
  static const double width = 568;
  static const double height = 432;
  static const double aspect = width / height;
}

/// Plexa's MOMENTS — one clip for a single spot on a single screen
/// (`PLEXA_STORYBOARD.md` §2 on the web). Unlike the mascot and quiz sets they
/// never hand over to one another: Flow framed each take its own way.
///
/// [loop] clips play while something is in progress; the rest play once and
/// rest on their still. Every placement is decoration — the screen says in
/// words whatever the moment means.
enum PlexaMomentClip {
  /// Raises a telescope and scans the horizon, cheerful shrug. No contest
  /// running, or one that ended without you.
  waitingRoom('waiting_room'),

  /// Holds up a gold ticket, hops. The first minutes after joining.
  contestJoined('contest_joined'),

  /// Drumroll, confetti, raises a trophy. The contest has ended.
  contestFinale('contest_finale'),

  /// A small flame between her wings. A streak milestone.
  streakFlame('streak_flame'),

  /// Shrugs, then shakes it off. After a broken streak.
  streakReset('streak_reset'),

  /// Five gold stars around her head, a bow. The day's lesson finished well.
  quizScore('quiz_score'),

  /// Surprised, fixes the air with a wrench, thumbs-up. Something failed to
  /// load.
  oopsWrench('oops_wrench'),

  /// Reads a book, taps a pencil. During the placement test. Loops.
  placementStudying('placement_studying', loop: true),

  /// Unrolls a blank certificate, delighted. The placement band revealed.
  placementResult('placement_result'),

  /// Taps her chin, thought dots. An AI wait. Loops.
  thinking('thinking', loop: true);

  const PlexaMomentClip(this.stem, {this.loop = false});

  /// The file name between `plexa_` and the extension. Spelled out rather
  /// than derived from [name]: the enum is camelCase, the files are not.
  final String stem;

  /// Whether the clip repeats rather than resting on its still. A looping
  /// clip starts and ends on the same pose, so the repeat does not jump.
  final bool loop;

  String get video => 'assets/videos/plexa_$stem.mp4';

  /// The clip's last frame — what it rests on, and what reduced motion or a
  /// clip that cannot play shows instead.
  String get still => 'assets/videos/plexa_${stem}_still.jpg';
}

/// Alpha from brightness: colour untouched, alpha = 4 × luminance, clamped —
/// the same matrix as `PlexaMascot`'s private one, and for the same reason.
///
/// The web makes the renders' black vanish with `mix-blend-mode: screen`,
/// which Flutter has no equivalent of for a video texture. Deriving alpha from
/// brightness does the same on a dark ground, and an Opacity or Transform
/// above it cannot undo it, because the alpha is a property of the pixels.
/// Four, so the bird's grey shading stays fully opaque in its true colour
/// while the black ground and the soft shadow under her fade out.
const ColorFilter plexaBlackToClear = ColorFilter.matrix(<double>[
  1, 0, 0, 0, 0, //
  0, 1, 0, 0, 0, //
  0, 0, 1, 0, 0, //
  0.2126 * 4, 0.7152 * 4, 0.0722 * 4, 0, 0,
]);
