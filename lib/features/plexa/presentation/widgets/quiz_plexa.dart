import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'plexa_moments.dart';
import 'retire_video.dart';

export 'plexa_moments.dart' show QuizMood;

/// Plexa in the contest's lesson and comment levels: she leans into a
/// magnifying glass over each question and reacts to the answer.
///
/// A port of the web's `components/contest/QuizPlexa.tsx`. What plays when is
/// [QuizTake]'s; this widget only drives the players it asks for.
///
/// ## One take across the lesson
///
/// The clips hand over frame to frame ([QuizMood]): inspect ends on the
/// close-up a reaction starts from, and a reaction ends standing, where
/// inspect starts. So this widget must stay mounted from question to
/// question — the question player must not be keyed per question.
///
/// ## How a switch works
///
/// Every clip gets a player up front. A clip off screen is parked on its
/// first frame — the frame every hand-over starts from — so a switch shows
/// the new clip's texture and starts it in the same frame, as `PlexaMascot`
/// does. The web instead starts the new `<video>` hidden and swaps when it
/// reports `playing`, because a `<video>` that has not played has no frame to
/// show. Copying that here would swap late, on the controller's 100 ms
/// position tick, and the bird would jump by the motion in between.
///
/// Reduced motion, or a clip that cannot play, shows stills throughout.
class QuizPlexa extends StatefulWidget {
  const QuizPlexa({
    required this.take,
    required this.mood,
    this.react = false,
    this.height = 96,
    super.key,
  });

  /// Changes with each question: a new take plays inspect again.
  final String take;

  final QuizMood mood;

  /// Play the reaction even though this take never showed the question
  /// unanswered — for a screen whose whole point is the reaction (the score).
  final bool react;

  /// The box's height; the width follows the 520×432 frame.
  final double height;

  @override
  State<QuizPlexa> createState() => _QuizPlexaState();
}

class _QuizPlexaState extends State<QuizPlexa> {
  final QuizTake _take = QuizTake();
  final Map<QuizMood, VideoPlayerController> _players =
      <QuizMood, VideoPlayerController>{};
  final Map<QuizMood, VoidCallback> _ticks = <QuizMood, VoidCallback>{};

  /// Players that have loaded, and can start without a wait.
  final Set<QuizMood> _loaded = <QuizMood>{};

  /// Clips that could not load. Asked for, they show their still.
  final Set<QuizMood> _broken = <QuizMood>{};

  /// Clips sitting on their last frame, as their players last reported — so
  /// an end is acted on once, not on every tick after it.
  final Set<QuizMood> _finished = <QuizMood>{};

  /// The clip being rewound to start. Until that lands its player still
  /// reports the end of its last run, which is not an end of this one.
  QuizMood? _starting;

  /// The clip whose texture shows, once one has started.
  QuizMood? _shown;

  /// A still in front of everything, or null when a video is what shows.
  QuizMood? _still;

  bool _reduceMotion = false;

  /// Whether the first [didChangeDependencies] has run.
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_started && reduceMotion == _reduceMotion) return;
    _started = true;
    _reduceMotion = reduceMotion;
    if (!reduceMotion && _players.isEmpty) {
      // The one asked for first, so it is not queued behind the others.
      for (final QuizMood id in <QuizMood>[
        widget.mood,
        ...QuizMood.values.where((QuizMood m) => m != widget.mood),
      ]) {
        unawaited(_load(id));
      }
    }
    _ask();
  }

  @override
  void didUpdateWidget(QuizPlexa old) {
    super.didUpdateWidget(old);
    _ask();
  }

  void _ask() => _act(
    _take.request(
      take: widget.take,
      mood: widget.mood,
      react: widget.react,
      stillsOnly: _reduceMotion || _broken.contains(widget.mood),
    ),
  );

  void _act(QuizCue? cue) {
    switch (cue) {
      case null:
        return;
      case PlayCue(:final QuizMood clip):
        unawaited(_start(clip));
      case StillCue(:final QuizMood clip):
        setState(() {
          _still = clip;
          for (final QuizMood other in QuizMood.values) {
            _park(other);
          }
        });
    }
  }

  Future<void> _load(QuizMood id) async {
    final VideoPlayerController player = VideoPlayerController.asset(
      id.video,
      // Silent clips, but a player still claims the audio session; without
      // this, a lesson would stop whatever the user was listening to.
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _players[id] = player;
    try {
      await player.initialize();
      await player.setVolume(0);
      if (!mounted) return;
      void tick() => _onTick(id);
      _ticks[id] = tick;
      player.addListener(tick);
      _loaded.add(id);
      if (_take.wanted == id) unawaited(_start(id));
    } catch (_) {
      if (!mounted) return;
      _broken.add(id);
      _act(_take.failed(id));
    }
  }

  Future<void> _start(QuizMood id) async {
    if (_broken.contains(id)) {
      _act(_take.failed(id));
      return;
    }
    final VideoPlayerController? player = _loaded.contains(id)
        ? _players[id]
        : null;
    // Still loading: _load starts it the moment it has.
    if (player == null) return;
    _starting = id;
    try {
      await player.seekTo(Duration.zero);
    } catch (_) {
      // Not seekable: play() starts a finished clip from the top anyway.
    }
    if (_starting == id) _starting = null;
    if (!mounted || _take.wanted != id) return;
    setState(() {
      _shown = id;
      _still = null;
    });
    for (final QuizMood other in QuizMood.values) {
      if (other != id) _park(other);
    }
    try {
      await player.play();
    } catch (_) {
      if (mounted) _act(_take.failed(id));
    }
  }

  void _onTick(QuizMood id) {
    final VideoPlayerController? player = _players[id];
    if (!mounted || player == null) return;
    final VideoPlayerValue value = player.value;
    if (value.hasError) {
      _act(_take.failed(id));
    } else if (!value.isCompleted) {
      _finished.remove(id);
    } else if (_finished.add(id) && id != _starting) {
      // Only the moment it ends; it keeps ticking on its last frame after.
      _act(_take.ended(id));
    }
  }

  /// Pauses [id] and rewinds it to its first frame, off screen, so the next
  /// time it is asked for there is nothing stale in its texture to show.
  void _park(QuizMood id) {
    final VideoPlayerController? player = _loaded.contains(id)
        ? _players[id]
        : null;
    if (player == null || player.value.position == Duration.zero) return;
    unawaited(_rewind(player));
  }

  Future<void> _rewind(VideoPlayerController player) async {
    try {
      await player.pause();
      await player.seekTo(Duration.zero);
    } catch (_) {
      // A player that cannot seek starts from the top on play() anyway.
    }
  }

  @override
  void dispose() {
    for (final MapEntry<QuizMood, VideoPlayerController> e
        in _players.entries) {
      final VoidCallback? tick = _ticks[e.key];
      if (tick != null) e.value.removeListener(tick);
      // Not a bare dispose(): leaving as a reaction ends would dispose it
      // under the plugin's own end-of-clip seek. See retireVideo.
      retireVideo(e.value);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final QuizMood? still = _still;
    final QuizMood? shown = _shown;
    final VideoPlayerController? player = shown == null
        ? null
        : _players[shown];
    final Widget? frame = still != null
        ? Image.asset(still.still, fit: BoxFit.contain)
        : player != null
        ? VideoPlayer(player)
        : null;

    return ExcludeSemantics(
      child: IgnorePointer(
        child: SizedBox(
          width: widget.height * QuizFrame.aspect,
          height: widget.height,
          child: frame == null
              ? null
              : ColorFiltered(colorFilter: plexaBlackToClear, child: frame),
        ),
      ),
    );
  }
}

/// What [QuizTake] asks the players for.
sealed class QuizCue {
  const QuizCue(this.clip);

  final QuizMood clip;

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      other is QuizCue &&
      other.clip == clip;

  @override
  int get hashCode => Object.hash(runtimeType, clip);

  @override
  String toString() => '$runtimeType(${clip.name})';
}

/// Play [clip] from its first frame.
final class PlayCue extends QuizCue {
  const PlayCue(super.clip);
}

/// Stop everything and show [clip]'s still.
final class StillCue extends QuizCue {
  const StillCue(super.clip);
}

/// The rules of [QuizPlexa]'s one take, apart from the players — so they can
/// be held to without a video plugin.
///
/// - It never cuts a clip short: whatever is asked for next waits for the
///   clip on screen to end. Most learners press Next long before the
///   8-second thumbs-up is over, and some answer before the 4-second zoom is;
///   cutting either would jump mid-gesture.
/// - What waits is at most [inspect, reaction] — the current question's. A
///   new question drops whatever still waits from the one before, so a
///   learner racing ahead never leaves her a question behind.
/// - A reaction plays only for an answer given while she was looking that
///   question over. A take that arrives already answered — a question
///   reopened, or reached with Next — shows the reaction's still:
///   re-celebrating an old answer would be noise, and it would start from a
///   close-up she never zoomed into. `react` overrides this.
class QuizTake {
  /// The clip last asked to play. Null while a still is what shows.
  QuizMood? get wanted => _wanted;
  QuizMood? _wanted;

  /// [wanted] has played to its end.
  bool _done = false;

  /// What plays next, in order, once [wanted] ends.
  List<QuizMood> get queued => List<QuizMood>.unmodifiable(_queued);
  final List<QuizMood> _queued = <QuizMood>[];

  /// The request last acted on, so a rebuild never restarts a clip.
  String? _handled;

  /// The take she has looked over unanswered — the one whose answer she may
  /// react to.
  String? _looked;

  /// The screen now asks for [mood] on [take]. Null: nothing to do now —
  /// the same request again, or one that waits for the clip on screen.
  QuizCue? request({
    required String take,
    required QuizMood mood,
    required bool react,
    required bool stillsOnly,
  }) {
    final String request = '$take|${mood.name}|$react|$stillsOnly';
    if (_handled == request) return null;
    _handled = request;
    if (mood == QuizMood.inspect) _looked = take;
    final bool live = react || _looked == take;

    if (stillsOnly || (mood.isReaction && !live)) return _showStill(mood);
    if (_wanted != null && !_done) {
      _enqueue(mood);
      return null;
    }
    _queued.clear();
    return _play(mood);
  }

  /// [clip] played to its end: what waited, if anything, plays now.
  QuizCue? ended(QuizMood clip) {
    if (clip != _wanted) return null;
    _done = true;
    if (_queued.isEmpty) return null;
    return _play(_queued.removeAt(0));
  }

  /// [clip] cannot play. If it is the one asked for, its still stands in.
  QuizCue? failed(QuizMood clip) => clip == _wanted ? _showStill(clip) : null;

  void _enqueue(QuizMood clip) {
    if (!clip.isReaction) {
      _queued
        ..clear()
        ..add(clip);
    } else if (_queued.isNotEmpty && _queued.last.isReaction) {
      _queued[_queued.length - 1] = clip;
    } else {
      _queued.add(clip);
    }
  }

  QuizCue _play(QuizMood clip) {
    _wanted = clip;
    _done = false;
    return PlayCue(clip);
  }

  QuizCue _showStill(QuizMood clip) {
    _wanted = null;
    _queued.clear();
    return StillCue(clip);
  }
}

/// Plexa looking today's work over, as a picture: the quiz's inspect still
/// (or another mood's), never a clip.
///
/// For the contest path's current node, where a looping video would play for
/// the whole time someone reads the path.
class QuizPlexaStill extends StatelessWidget {
  const QuizPlexaStill(this.mood, {this.height = 118, super.key});

  final QuizMood mood;

  /// The box's height; the width follows the 520×432 frame.
  final double height;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: IgnorePointer(
        child: SizedBox(
          width: height * QuizFrame.aspect,
          height: height,
          child: ColorFiltered(
            colorFilter: plexaBlackToClear,
            child: Image.asset(mood.still, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
