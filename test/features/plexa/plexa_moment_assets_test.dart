import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/plexa/presentation/widgets/plexa_moments.dart';

/// Every moment and quiz clip the app can ask for is bundled.
///
/// pubspec bundles `assets/videos/` whole, so a file missing from disk fails
/// only at runtime — as a still that never comes, on the one screen and state
/// that needs it. The stems are spelled out by hand ([PlexaMomentClip.stem]),
/// which is exactly where a typo would hide.
void main() {
  test('every moment has its clip and its still', () {
    for (final PlexaMomentClip clip in PlexaMomentClip.values) {
      expect(File(clip.video).existsSync(), isTrue, reason: clip.video);
      expect(File(clip.still).existsSync(), isTrue, reason: clip.still);
    }
  });

  test('every quiz mood has its clip and its still', () {
    for (final QuizMood mood in QuizMood.values) {
      expect(File(mood.video).existsSync(), isTrue, reason: mood.video);
      expect(File(mood.still).existsSync(), isTrue, reason: mood.still);
    }
  });

  test('the files are named the app way: no hash, underscores', () {
    // The web names files by content hash for HTTP caching; a bundled asset
    // never goes through that, and a copied hashed name would go stale on
    // the next re-cut while still existing on disk.
    final RegExp appName = RegExp(r'^assets/videos/plexa_[a-z_]+\.(mp4|jpg)$');
    for (final PlexaMomentClip clip in PlexaMomentClip.values) {
      expect(clip.video, matches(appName));
      expect(clip.still, matches(appName));
    }
    for (final QuizMood mood in QuizMood.values) {
      expect(mood.video, matches(appName));
      expect(mood.still, matches(appName));
    }
  });

  test('only the waits loop', () {
    expect(
      PlexaMomentClip.values.where((PlexaMomentClip c) => c.loop).toSet(),
      <PlexaMomentClip>{
        PlexaMomentClip.placementStudying,
        PlexaMomentClip.thinking,
      },
    );
  });
}
