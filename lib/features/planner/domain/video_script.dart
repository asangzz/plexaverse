import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_script.freezed.dart';
part 'video_script.g.dart';

/// One line of the shot list.
///
/// Mirrors `VideoBeat` in `lib/video-script-prompts.ts`. The pairing is the
/// whole point: someone is going to hold a phone and film this, and they need
/// to know what to say, roughly when, and what is on screen while they say it.
@freezed
abstract class VideoBeat with _$VideoBeat {
  const VideoBeat._();

  const factory VideoBeat({
    /// Seconds from the start this beat begins.
    @Default(0) int seconds,

    /// What the speaker says. One or two sentences.
    @Default('') String say,

    /// What is on screen — a cut, a demo, text, nothing.
    @Default('') String show,
  }) = _VideoBeat;

  factory VideoBeat.fromJson(Map<String, dynamic> json) =>
      _$VideoBeatFromJson(json);

  /// `0:08`, the way a timecode is read.
  String get timecode {
    final int m = seconds ~/ 60;
    final int s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

/// A script for one of the week's two video days.
///
/// Mirrors `VideoScriptResult` in `lib/services/video-script.service.ts`.
///
/// **We prepare it; we never publish it.** LinkedIn's video upload is a
/// different API from a text share — initialize, binary PUT, finalize, then a
/// share referencing the video URN — and nothing in this product speaks it. So
/// a script is handed over and [isPosted] is set by the user telling us they
/// filmed it, exactly as the newsletter is closed out by hand. There is no
/// other signal: nothing can observe a video going up.
@freezed
abstract class VideoScript with _$VideoScript {
  const VideoScript._();

  const factory VideoScript({
    @Default('') String id,
    @Default(1) int weekNumber,
    @Default(1) int season,

    /// 0–6, Monday-first, matching the plan's slot order.
    @Default(0) int dayIndex,

    @Default('') String title,

    /// The first line. The single most load-bearing sentence in a short video
    /// — it is what decides whether the next four seconds happen.
    @Default('') String hook,

    @Default(<VideoBeat>[]) List<VideoBeat> beats,

    /// What goes in the post alongside the video.
    @Default('') String caption,

    /// 'ready' once written; 'published' only once the user says so.
    @Default('ready') String status,

    String? publishedAt,
  }) = _VideoScript;

  factory VideoScript.fromJson(Map<String, dynamic> json) =>
      _$VideoScriptFromJson(json);

  /// The user has filmed and posted it.
  ///
  /// Reads `status`, not `publishedAt`: the service sets the status and the
  /// web's own panel branches on exactly this. The timestamp is for display.
  bool get isPosted => status == 'published';

  bool get hasBeats => beats.isNotEmpty;

  /// How long the shot list runs, from its last beat. Approximate by
  /// construction — the last beat has a start, not an end — so it is phrased
  /// as "about" wherever it is shown.
  int get runtimeSeconds => beats.isEmpty ? 0 : beats.last.seconds;
}

/// What the planner knows about a hand-off day.
///
/// The three states a video script or the newsletter can be in, which the
/// slot's own `status` cannot express: that column is only ever written by the
/// post-generation path, and a hand-off day never reaches it. Reading it there
/// pinned both rows at "to write" for the life of the week, however much work
/// the user had actually done.
enum HandoffState {
  /// Nothing written for this day yet. Sunday's batch has not run, or failed.
  notWritten,

  /// Written and waiting on the user.
  ready,

  /// The user has filmed it, or pasted it, and said so.
  posted,
}
