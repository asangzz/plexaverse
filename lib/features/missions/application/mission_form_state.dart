import 'package:flutter/foundation.dart';

/// Which way a [MissionNotice] reads.
///
/// This lived on `MissionMessage` in `presentation/widgets/mission_chrome.dart`
/// while the message itself lived on each page's `State`. Both moved together:
/// a notice a controller cannot express is a notice that has to stay on the
/// widget.
enum MissionTone {
  /// Something landed. Green is "done" in this system.
  success,

  /// Something needs attention, or did not go through.
  ///
  /// **Amber, not red.** Zave has no red at all, and none of the things these
  /// screens report — an empty checklist, a short About section, a generation
  /// that failed — is destructive.
  warning,
}

/// The one line a mission screen has to say about the last thing it did.
///
/// It belongs to a controller rather than to the page because every way it is
/// set is a decision the use case made: a repository call came back, or an
/// input was rejected before one was sent. Recorded behind a widget's
/// `mounted` check it is lost the moment the user leaves the screen, which is
/// the defect `50121c1` fixed on the calendar.
@immutable
class MissionNotice {
  const MissionNotice.success(this.text) : tone = MissionTone.success;
  const MissionNotice.warning(this.text) : tone = MissionTone.warning;

  final String text;
  final MissionTone tone;
}

/// The Headline Hook's three operations, and what they had to say.
///
/// Three flags and not one enum. The screen has three independently spinning
/// buttons, and collapsing them would disable the other two for the length of
/// any one call — a behaviour change, which this move deliberately is not.
@immutable
class HeadlineHookState {
  const HeadlineHookState({
    this.suggesting = false,
    this.saving = false,
    this.finishing = false,
    this.notice,
  });

  /// `POST /ai/suggest-title` is open.
  final bool suggesting;

  /// The headline is being written to the preferences row.
  final bool saving;

  /// The step is being recorded.
  final bool finishing;

  final MissionNotice? notice;

  HeadlineHookState copyWith({
    bool? suggesting,
    bool? saving,
    bool? finishing,
    MissionNotice? notice,
    bool clearNotice = false,
  }) => HeadlineHookState(
    suggesting: suggesting ?? this.suggesting,
    saving: saving ?? this.saving,
    finishing: finishing ?? this.finishing,
    notice: clearNotice ? null : (notice ?? this.notice),
  );
}

/// The About Odyssey's skill list, its two operations, and what they said.
@immutable
class AboutOdysseyState {
  const AboutOdysseyState({
    this.skills,
    this.generating = false,
    this.finishing = false,
    this.notice,
  });

  /// The edited skill list — **null until the user touches it**, in which case
  /// the preferences row's own list is both what is shown and what is sent.
  ///
  /// Null rather than a seeded copy because seeding would mean writing to a
  /// provider from inside `build()`, which Riverpod forbids: the page can only
  /// reach the profile from `AsyncValue.when(data:)`, and that runs while the
  /// tree is building. Reading through the null keeps the seed where it was —
  /// in the server's row — and costs nothing.
  ///
  /// It is here and not on the page because it is the thing that gets SENT:
  /// `finish` posts `{'summary': …, 'skills': …}`, and the add/remove rules
  /// (no duplicates, at most ten) are decisions about that payload.
  final List<String>? skills;

  /// `POST /ai/generate-about` is open.
  final bool generating;

  /// The summary is being saved and the step recorded.
  final bool finishing;

  final MissionNotice? notice;

  AboutOdysseyState copyWith({
    List<String>? skills,
    bool? generating,
    bool? finishing,
    MissionNotice? notice,
    bool clearNotice = false,
  }) => AboutOdysseyState(
    skills: skills ?? this.skills,
    generating: generating ?? this.generating,
    finishing: finishing ?? this.finishing,
    notice: clearNotice ? null : (notice ?? this.notice),
  );
}

/// Banner Blueprint's two operations, and what they said.
@immutable
class BannerBlueprintState {
  const BannerBlueprintState({
    this.saving = false,
    this.finishing = false,
    this.notice,
  });

  /// The banner is being rendered to a PNG and handed to the share sheet.
  final bool saving;

  /// The step is being recorded.
  final bool finishing;

  final MissionNotice? notice;

  BannerBlueprintState copyWith({
    bool? saving,
    bool? finishing,
    MissionNotice? notice,
    bool clearNotice = false,
  }) => BannerBlueprintState(
    saving: saving ?? this.saving,
    finishing: finishing ?? this.finishing,
    notice: clearNotice ? null : (notice ?? this.notice),
  );
}
