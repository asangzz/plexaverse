import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

import '../../theme/zave/zave.dart';
import '../app_icons.dart';
import 'zave_skeleton.dart';

/// Decoded `data:` payloads, held so a rebuild does not decode them again.
///
/// Two reasons, and the second is the one that matters. The obvious one is
/// cost: these run to 1.6 MB of base64 on the live table, and a preview
/// rebuilds on every "see more" tap. The subtler one is that Flutter's own
/// image cache is keyed on the [Uint8List] IDENTITY — hand `Image.memory` a
/// fresh list each build and it re-rasterises a megabyte every time, which is
/// far dearer than the base64 decode.
///
/// Capped at one full carousel. A decoded JPEG here is roughly three quarters
/// of its base64 length, so the ceiling is a few megabytes of bytes plus
/// whatever Flutter's `ImageCache` keeps of the rasters.
const int _dataUriCacheLimit = 9;
final Map<String, Uint8List?> _dataUriCache = <String, Uint8List?>{};

/// Bytes for a `data:` URL, or null when it will not parse.
///
/// A null is cached too: a malformed payload is malformed on every rebuild,
/// and re-parsing it to fail again is the same waste as re-parsing a good one.
Uint8List? _decodeDataUri(String url) {
  if (_dataUriCache.containsKey(url)) return _dataUriCache[url];

  Uint8List? bytes;
  try {
    bytes = UriData.parse(url).contentAsBytes();
  } on Object {
    // Truncated base64, a missing comma, a mime type we cannot read. The
    // placeholder is the honest answer; a thrown exception in a build is not.
    bytes = null;
  }

  // Insertion-ordered, so the first key is the oldest.
  if (_dataUriCache.length >= _dataUriCacheLimit) {
    _dataUriCache.remove(_dataUriCache.keys.first);
  }
  _dataUriCache[url] = bytes;
  return bytes;
}

/// How much of a story the failed and loading states tell.
enum ZaveImageTone {
  /// A glyph, and a line of text when one is given. For an image the user
  /// asked to see.
  spoken,

  /// A fill and nothing else. For a thumbnail inside a list: a broken-image
  /// glyph on a card nobody asked to load is noise, and the row still reads
  /// correctly without it.
  quiet,
}

/// The app's one image loader.
///
/// ## Why this is in the kit and not in a feature
///
/// Because `imageUrl` is a `data:` URI on most of the posts in the live
/// table — the generated poster is written straight into the column — and
/// `Image.network` cannot load one. It parses the string as an address,
/// fails, and runs the error builder. So every surface that used
/// `Image.network` was drawing a failure for a poster that exists and is
/// right there in memory.
///
/// That was four surfaces: the planner's day sheet and its slot cards, the
/// post detail screen's poster block, and the full-bleed poster sheet. Post
/// detail showed an amber "could not be loaded" on the majority of posts.
///
/// A correct loader already existed — private to `post_card.dart`, with the
/// decode cache above, reachable only through a `PostImage` wrapper that was
/// used in exactly zero other files. One loader, in the kit, so the `data:`
/// branch they all depend on cannot be fixed in one and missed in the rest.
///
/// ## The three sources
///
///   * `data:image/…;base64,…` — decoded once per URI and held.
///   * `http(s)://…` — through `cached_network_image`.
///   * anything else, or empty — the placeholder. Never a thrown exception
///     during paint.
class ZaveImage extends StatelessWidget {
  const ZaveImage({
    required this.source,
    this.fit = BoxFit.cover,
    this.tone = ZaveImageTone.spoken,
    this.label,
    this.errorMessage,
    this.placeholderAspectRatio,
    super.key,
  });

  /// A data URI, an http(s) URL, or null/empty for "nothing yet".
  final String? source;

  final BoxFit fit;

  /// Whether the loading and failed states say anything. See [ZaveImageTone].
  final ZaveImageTone tone;

  /// Shown under the glyph while there is nothing to draw.
  final String? label;

  /// Shown under the glyph when the image failed. Defaults to [label].
  final String? errorMessage;

  /// Shape held by the loading and failed states, and by them only — the
  /// loaded image keeps its own.
  ///
  /// For a frame whose size comes from the picture itself: the poster sheet
  /// is `Flexible`, so without this it opens at the height of a glyph and
  /// then jumps to full size when the bytes arrive.
  final double? placeholderAspectRatio;

  Widget _state({String? message, bool loading = false}) {
    final Widget state = _ZaveImageState(
      tone: tone,
      message: message,
      loading: loading,
    );
    final double? ratio = placeholderAspectRatio;
    return ratio == null
        ? state
        : AspectRatio(aspectRatio: ratio, child: state);
  }

  @override
  Widget build(BuildContext context) {
    final String? src = source;

    if (src == null || src.isEmpty) return _state(message: label);

    // A `data:` URL is an image, not an address.
    //
    // The web has no such branch because it does not need one: it renders
    // `<img src={post.imageUrl}>` and a browser reads `data:` natively. This
    // is the same behaviour, spelled out for a toolkit that does not.
    if (src.startsWith('data:')) {
      final Uint8List? bytes = _decodeDataUri(src);
      if (bytes == null) return _state(message: errorMessage ?? label);
      return Image.memory(
        bytes,
        fit: fit,
        width: double.infinity,
        // The bytes never change identity, and a preview toggles "see more"
        // under the image; without this the picture blinks out on every tap.
        gaplessPlayback: true,
        errorBuilder: (_, _, _) => _state(message: errorMessage ?? label),
      );
    }

    if (!src.startsWith('http')) return _state(message: label);

    return CachedNetworkImage(
      imageUrl: src,
      fit: fit,
      width: double.infinity,
      fadeInDuration: ZaveMotion.fast,
      placeholder: (_, _) => _state(message: label, loading: true),
      errorWidget: (_, _, _) => _state(message: errorMessage ?? label),
    );
  }
}

/// What fills the frame when there is no picture in it.
///
/// A fill and a glyph, not a spinner: a spinner inside a box that is already
/// the right size adds motion for its own sake. These used to be a bare
/// `ColoredBox` — the right SIZE, and nothing in it, so a slow image and a
/// missing one looked identical and neither looked deliberate.
///
/// ## The sweep runs only while [loading]
///
/// This one widget is BOTH states, and in the quiet tone it used to return
/// before `loading` was read at all — so a shimmer added naively here would
/// have run forever on a permanently broken image, which is the most
/// misleading thing a loading indicator can do. The sweep is gated on the
/// flag, and in the quiet tone the flag is now read.
///
/// The glyph and the caption sit OUTSIDE the sweep, on top of it. A caption
/// under a travelling highlight strobes, and this one is text the user is
/// meant to read.
class _ZaveImageState extends StatelessWidget {
  const _ZaveImageState({
    required this.tone,
    this.message,
    this.loading = false,
  });

  final ZaveImageTone tone;
  final String? message;
  final bool loading;

  /// The block behind everything — swept while loading, at rest otherwise.
  Widget get _ground => loading
      ? const ZaveShimmer(child: ZaveSkeleton.block())
      : const ColoredBox(color: ZaveGlass.rest);

  @override
  Widget build(BuildContext context) {
    if (tone == ZaveImageTone.quiet) return _ground;

    // Amber, because Zave has no red — and only for a real failure. A frame
    // still loading gets the neutral picture glyph, so "wait" and "gone" are
    // not the same colour.
    final Color tint = loading ? ZaveColors.ink35 : ZaveColors.amber;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _ground,
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                loading ? AppIcons.image : AppIcons.warning,
                size: 24,
                color: tint,
              ),
              if (message case final String text
                  when text.isNotEmpty) ...<Widget>[
                SizedBox(height: ZaveSpace.xs),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ZaveSpace.md),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ZaveType.caption.copyWith(color: ZaveColors.ink45),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
