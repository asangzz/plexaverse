import 'dart:async';

import 'package:video_player/video_player.dart';

/// How long a retired player is kept before it is disposed: far longer than
/// the plugin's end-of-clip pause and seek take, far shorter than anyone
/// would notice a paused, unseen decoder.
const Duration kVideoRetireGrace = Duration(milliseconds: 600);

/// Disposes [player] once video_player's own end-of-clip work has landed.
///
/// When a clip that does not loop ends, video_player runs an UNAWAITED
/// `pause().then(seekTo(end))` of its own. A controller disposed while that
/// seek is in flight throws "A VideoPlayerController was used after being
/// disposed" from inside the plugin, where no caller can catch it — an
/// unhandled zone error in debug builds. It happens whenever a screen closes
/// as a clip ends, or a widget lets its player go the moment the clip ends.
///
/// So: pause it (queued behind the plugin's own pause), wait a short grace,
/// then dispose. A player that never initialized has no clip to end and is
/// disposed at once — which is every player in a widget test, so no timer is
/// left pending there.
///
/// Callers remove their own listeners first; nothing should react to a
/// retired player.
void retireVideo(VideoPlayerController player) {
  if (!player.value.isInitialized) {
    unawaited(player.dispose());
    return;
  }
  unawaited(_retire(player));
}

Future<void> _retire(VideoPlayerController player) async {
  try {
    await player.pause();
  } catch (_) {
    // Already gone, or the platform refused: dispose regardless.
  }
  await Future<void>.delayed(kVideoRetireGrace);
  await player.dispose();
}
