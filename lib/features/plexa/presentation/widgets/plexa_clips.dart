/// Every Plexa clip, and the one frame they all share.
///
/// A port of the web's `components/plexa/clips.ts` — read that file's doc for
/// how the clips are cut. The short of it: every clip is cut to the same
/// 568×432 window, so the standing bird sits in exactly the same place in each,
/// and one clip can hand over to the next on the frame the last one ended on.
///
/// The files in `assets/videos/` are byte-for-byte copies of the web's
/// `public/videos/`, minus the content hash in the name (that exists for HTTP
/// caching, which a bundled asset never goes through). Copy all six again
/// whenever the web re-cuts one — a clip from a different cut will not line
/// up with the others.
library;

/// The encoded frame.
abstract final class PlexaFrame {
  static const double width = 568;
  static const double height = 432;
  static const double aspect = width / height;
}

/// The standing bird within [PlexaFrame], as fractions: crest, feet, and the
/// middle of the body.
abstract final class PlexaBird {
  static const double top = 50 / 720;
  static const double bottom = 680 / 720;
  static const double centerX = (636 - 156) / 946;
}

enum PlexaClip {
  /// Swings in on a vine, turns round, waves; ends standing. 10 s.
  hello,

  /// Standing → wings out, star eyes. 4 s.
  excited,

  /// Wings down to standing, then takes a notepad out of the bag and writes.
  /// 7.9 s. Starts on the frame [excited] ends on.
  notes;

  String get video => 'assets/videos/plexa_$name.mp4';

  /// The clip's last frame — shown instead of it under reduced motion, or when
  /// it cannot play.
  String get still => 'assets/videos/plexa_${name}_still.jpg';
}
