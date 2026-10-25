import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'plexa_clips.dart';

/// Plexa, the cockatiel, playing whichever clip the screen asks for.
///
/// A port of `components/plexa/PlexaMascot.tsx`, playing the same MP4s.
///
/// ## How a switch works
///
/// Every clip in [PlexaMascot.clips] gets a player up front, so the next one
/// has loaded before Continue is pressed. A loaded player already holds its
/// first frame — video_player draws it into the texture without being played —
/// and that frame is the one the previous clip ended on (see
/// `plexa_clips.dart`). So a switch shows the new clip's texture and starts it
/// in the same frame, and the handover does not show.
///
/// The web cannot do that: a `<video>` that has never played has no frame to
/// show, so it starts the new clip hidden and swaps when it reports `playing`.
/// Copying that here would swap late — the controller only reports position on
/// a 100 ms tick — and the bird would jump by the motion in between.
///
/// ## Why a colour filter, and not the web's blend mode
///
/// The clips are a light bird on black. The web makes the black vanish with
/// `mix-blend-mode: screen`, which Flutter has no equivalent of for a video
/// texture. Instead [_blackToClear] derives alpha from brightness: anything
/// darker than a quarter-grey fades towards transparent, anything brighter is
/// solid. On a dark ground that is indistinguishable from the web's blend —
/// and unlike the blend it is not undone by an Opacity or Transform above it,
/// because the alpha is a property of the pixels, not of how they composite.
///
/// ## Why the box is not the video
///
/// The size you give is the bird's footprint: [PlexaMascot.height] tall (or
/// the height it is laid out at), 3:4 like the still artwork this replaced. The video overflows it, placed so the
/// crest touches the top and the feet the bottom — spacing is laid out against
/// the bird, not against the empty margin the wings, the bag and the swing
/// need.
class PlexaMascot extends StatefulWidget {
  const PlexaMascot({
    required this.clip,
    required this.clips,
    this.height,
    this.hold = false,
    super.key,
  });

  /// What Plexa is doing. Changing it plays that clip from its first frame.
  final PlexaClip clip;

  /// Every clip this screen can switch to, loaded up front. Must include
  /// [clip].
  final List<PlexaClip> clips;

  /// Crest to feet. Null fills the height it is given — what `/plexa` does,
  /// animating that height as the bird flies into the chat's top row.
  final double? height;

  /// Don't start the current clip yet — the web's `hold`. Plexa stays off
  /// stage (the hello clip's first frame is empty anyway) and starts from
  /// frame one when released.
  ///
  /// It only ever DELAYS a clip that has not started. Toggling it must never
  /// replay one: on the web, a refetch flickered `hold` mid-onboarding and the
  /// notepad clip jumped back to frame one while the chat was asking
  /// questions.
  final bool hold;

  /// Footprint width ÷ height.
  static const double boxAspect = 3 / 4;

  @override
  State<PlexaMascot> createState() => _PlexaMascotState();
}

class _PlexaMascotState extends State<PlexaMascot> {
  final Map<PlexaClip, VideoPlayerController> _players =
      <PlexaClip, VideoPlayerController>{};
  final Set<PlexaClip> _loaded = <PlexaClip>{};

  /// Clips that could not load. They show their last frame instead — their
  /// first would be wrong as well as static: `hello` opens on the empty branch
  /// before the swing.
  final Set<PlexaClip> _stills = <PlexaClip>{};

  /// The clip on screen. Null until the first one has loaded.
  PlexaClip? _shown;

  /// The clip last started. See [PlexaMascot.hold].
  PlexaClip? _startedClip;

  bool _reduceMotion = false;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) return;
    // The one asked for first, so it is not queued behind the others.
    for (final PlexaClip id in <PlexaClip>[
      widget.clip,
      ...widget.clips.where((PlexaClip c) => c != widget.clip),
    ]) {
      unawaited(_load(id));
    }
  }

  Future<void> _load(PlexaClip id) async {
    final VideoPlayerController player = VideoPlayerController.asset(
      id.video,
      // The clips are silent, but a player still claims the audio session —
      // and without this, opening the screen would stop whatever the user was
      // listening to.
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _players[id] = player;
    try {
      await player.initialize();
      await player.setVolume(0);
      if (!mounted) return;
      _loaded.add(id);
      if (widget.clip == id && !widget.hold) _play(id);
    } catch (_) {
      if (mounted) setState(() => _stills.add(id));
    }
  }

  @override
  void didUpdateWidget(PlexaMascot old) {
    super.didUpdateWidget(old);
    // Not loaded yet: _load plays it the moment it is, and the current clip
    // holds its last frame — the same frame — until then. A clip that has
    // already started is never restarted, whatever changed.
    if (!_reduceMotion &&
        !widget.hold &&
        _startedClip != widget.clip &&
        _loaded.contains(widget.clip)) {
      _play(widget.clip);
    }
  }

  void _play(PlexaClip id) {
    _startedClip = id;
    setState(() => _shown = id);
    for (final PlexaClip other in _loaded) {
      if (other != id) unawaited(_players[other]!.pause());
    }
    unawaited(_players[id]!.play());
  }

  @override
  void dispose() {
    for (final VideoPlayerController player in _players.values) {
      unawaited(player.dispose());
    }
    super.dispose();
  }

  Widget? _frame() {
    if (_reduceMotion || _stills.contains(widget.clip)) {
      return Image.asset(widget.clip.still, fit: BoxFit.fill);
    }
    final PlexaClip? shown = _shown;
    return shown == null ? null : VideoPlayer(_players[shown]!);
  }

  @override
  Widget build(BuildContext context) {
    final double? height = widget.height;
    if (height != null) return _box(height);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          _box(constraints.maxHeight),
    );
  }

  Widget _box(double height) {
    final double boxHeight = height;
    final double boxWidth = boxHeight * PlexaMascot.boxAspect;
    final double videoHeight = boxHeight / (PlexaBird.bottom - PlexaBird.top);
    final double videoWidth = videoHeight * PlexaFrame.aspect;
    final Widget? frame = _frame();

    return ExcludeSemantics(
      child: SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            if (frame != null)
              Positioned(
                left: boxWidth / 2 - PlexaBird.centerX * videoWidth,
                top: -PlexaBird.top * videoHeight,
                width: videoWidth,
                height: videoHeight,
                child: IgnorePointer(
                  child: ColorFiltered(
                    colorFilter: _blackToClear,
                    child: frame,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Alpha from brightness: colour untouched, alpha = 4 × luminance, clamped.
///
/// Four, so that the bird's grey shading (well above a quarter) stays fully
/// opaque and keeps its true colour — the pink of the mouth, the blue of the
/// eyes — while the black ground and the soft shadow under the feet fade out.
/// A factor of 1 would make every grey semi-transparent and the bird would
/// look washed into whatever is behind it.
const ColorFilter _blackToClear = ColorFilter.matrix(<double>[
  1, 0, 0, 0, 0, //
  0, 1, 0, 0, 0, //
  0, 0, 1, 0, 0, //
  0.2126 * 4, 0.7152 * 4, 0.0722 * 4, 0, 0,
]);
