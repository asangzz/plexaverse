import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'plexa_moments.dart';

export 'plexa_moments.dart' show PlexaMomentClip;

/// Plexa playing one MOMENT clip in one spot — a reaction (joined, a streak,
/// the lesson done…) or a wait (thinking, studying).
///
/// A port of the web's `components/plexa/PlexaMoment.tsx`, playing the same
/// MP4s (see `plexa_moments.dart` for which moment belongs where).
///
/// - Plays once and rests on its last frame, or loops while [loop] (the
///   clip's own default) is true.
/// - Reduced motion, or a clip that cannot play, shows the still — never a
///   frozen first frame, which for most moments is the bird before she has
///   done anything.
/// - A new [moment] in the same spot starts afresh.
///
/// It is decoration: excluded from semantics, so the screen must still say
/// in words whatever the moment means.
///
/// ## Phones see it too
///
/// The web hides every moment but `thinking` below 640 px. The app is all
/// phone, so copying that literally would show none of them; the app shows
/// them, at the size the screen asks for.
///
/// ## Not before its first frame
///
/// The web gives the `<video>` the still as its `poster`, because a video
/// that has not played has nothing to show. Here a loaded player already
/// holds its first frame (see `PlexaMascot`), so nothing is drawn until it
/// has loaded — the still first would show the clip's END and then jump back
/// to its start.
class PlexaMoment extends StatefulWidget {
  const PlexaMoment(this.moment, {this.width = 220, this.loop, super.key});

  final PlexaMomentClip moment;

  /// Rendered width; the height follows the 568×432 frame. Never wider than
  /// the room it is given — a narrower parent shrinks it, keeping the shape.
  final double width;

  /// Override the clip's own default (waits loop, reactions play once).
  final bool? loop;

  @override
  State<PlexaMoment> createState() => _PlexaMomentState();
}

class _PlexaMomentState extends State<PlexaMoment> {
  VideoPlayerController? _player;

  /// Loaded and showing its first frame — until then the box is empty.
  bool _ready = false;

  /// A clip that played once to its end rests on its still.
  bool _ended = false;

  /// The clip could not load or play. Its still stands in.
  bool _failed = false;

  bool _reduceMotion = false;

  /// Whether the first [didChangeDependencies] has run.
  bool _started = false;

  bool get _loops => widget.loop ?? widget.moment.loop;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_started && reduceMotion == _reduceMotion) return;
    _started = true;
    _reduceMotion = reduceMotion;
    _restart();
  }

  @override
  void didUpdateWidget(PlexaMoment old) {
    super.didUpdateWidget(old);
    if (old.moment != widget.moment) {
      _restart();
    } else if (old.loop != widget.loop) {
      if (_ended && _loops) {
        // It rested on its still; a loop has to start it again.
        _restart();
      } else {
        unawaited(_player?.setLooping(_loops));
      }
    }
  }

  /// Drops whatever was playing and starts [PlexaMoment.moment] from frame
  /// one — or not at all, under reduced motion.
  void _restart() {
    _release();
    _ready = false;
    _ended = false;
    _failed = false;
    if (!_reduceMotion) unawaited(_load());
  }

  Future<void> _load() async {
    final VideoPlayerController player = VideoPlayerController.asset(
      widget.moment.video,
      // Silent clips, but a player still claims the audio session; without
      // this, a moment would stop whatever the user was listening to.
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _player = player;
    try {
      await player.initialize();
      await player.setVolume(0);
      await player.setLooping(_loops);
      // A newer moment replaced this one while it loaded.
      if (!mounted || _player != player) return;
      player.addListener(_onTick);
      setState(() => _ready = true);
      await player.play();
    } catch (_) {
      if (mounted && _player == player) setState(() => _failed = true);
    }
  }

  void _onTick() {
    final VideoPlayerController? player = _player;
    if (player == null || _ended || _failed) return;
    if (player.value.hasError) {
      setState(() => _failed = true);
    } else if (player.value.isCompleted && !_loops) {
      setState(() => _ended = true);
      // The still is the frame it ended on, so the player has nothing left
      // to show — let its decoder go once the still has replaced it.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_player == player) _release();
      });
    }
  }

  /// Lets the current player go. The [VideoPlayer] drawing it leaves the
  /// tree in the same frame, before the controller's own async dispose ends.
  void _release() {
    final VideoPlayerController? player = _player;
    if (player == null) return;
    _player = null;
    player.removeListener(_onTick);
    unawaited(player.dispose());
  }

  @override
  void dispose() {
    _release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final VideoPlayerController? player = _player;
    final bool showStill = _reduceMotion || _failed || (_ended && !_loops);
    // The box is the clip's own 568×432 shape, so the texture filling it is
    // the web's object-contain.
    final Widget? frame = showStill
        ? Image.asset(widget.moment.still, fit: BoxFit.contain)
        : (_ready && player != null)
        ? VideoPlayer(player)
        : null;

    return ExcludeSemantics(
      child: IgnorePointer(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.width),
          child: AspectRatio(
            aspectRatio: MomentFrame.aspect,
            child: frame == null
                ? null
                : ColorFiltered(colorFilter: plexaBlackToClear, child: frame),
          ),
        ),
      ),
    );
  }
}
