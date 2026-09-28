import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/library_post.dart';
import '../post_signal.dart';

/// `Sep 18, 2026` — the web's
/// `toLocaleDateString('en-US',{month:'short',day:'numeric',year:'numeric'})`.
final DateFormat kPostDateFormat = DateFormat('MMM d, yyyy');

/// One row of the post library.
///
/// The web ships two layouts for this row — a stacked one under its `sm`
/// breakpoint and a three-column one above it. A phone renders the stacked one,
/// so that is what this is: thumbnail beside the meta and title, body below,
/// actions on their own line.
///
/// Restated in Zave rather than transcribed: the web's `.dark-card` list with
/// `divide-y` hairlines becomes separate glass cards, because Zave has no
/// divided list and a card IS how this system groups a row's content.
class PostCard extends StatelessWidget {
  const PostCard({
    required this.post,
    required this.onOpen,
    this.onApprove,
    this.onDelete,
    this.onOpenLinkedIn,
    this.busy = false,
    super.key,
  });

  final LibraryPost post;
  final VoidCallback onOpen;

  /// Null when the post is already published or approved — the web hides the
  /// Approve button in exactly those two cases.
  final VoidCallback? onApprove;

  final VoidCallback? onDelete;

  /// The web's "View on LinkedIn" link, which this now is rather than
  /// approximates: the URL opens in the LinkedIn app through the same
  /// App Link / Universal Link hand-off the web's `target="_blank"` uses.
  /// Copying is the fallback when nothing on the device can open it — see
  /// `core/platform/link_opening.dart`.
  ///
  /// Null when there is no URL, which is every unpublished post.
  final VoidCallback? onOpenLinkedIn;

  /// A mutation is in flight for this post.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final ({Color color, String label}) signal = postSignal(post.status);
    final String? thumb = post.imageSrc;

    return ZaveCard(
      onTap: onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (thumb != null) ...<Widget>[
                _Thumbnail(url: thumb, count: post.allImages.length),
                SizedBox(width: ZaveSpace.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ZaveDot(signal.color),
                        SizedBox(width: ZaveSpace.sm),
                        Text(
                          signal.label.toUpperCase(),
                          style: ZaveType.kicker.copyWith(color: signal.color),
                        ),
                        SizedBox(width: ZaveSpace.md),
                        Expanded(
                          child: Text(
                            kPostDateFormat.format(post.displayDate),
                            style: ZaveType.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ZaveSpace.sm),
                    Text(
                      post.displayTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // `.navItem` metrics — Manrope 16/600. The nearest token
                      // to the web's 16px/500 white row title; ZaveType.h3
                      // (20/800) is the card-heading role and reads far too
                      // heavy repeated down a list.
                      style: ZaveType.navLabel.copyWith(
                        color: ZaveColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (post.content.trim().isNotEmpty) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(
              post.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              // The web clamps this at 14px; Zave's reading face starts at 17
              // (`ZaveType.body`), so the excerpt takes the muted body step
              // rather than a size that is not in the scale.
              style: ZaveType.bodyMuted,
            ),
          ],

          if (post.isPublished && post.metrics != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            _Metrics(metrics: post.metrics!),
          ],

          SizedBox(height: ZaveSpace.lg),
          _Actions(
            post: post,
            busy: busy,
            onApprove: onApprove,
            onDelete: onDelete,
            onOpenLinkedIn: onOpenLinkedIn,
          ),
        ],
      ),
    );
  }
}

/// The post's image, with a count badge when it is a carousel.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.url, required this.count});

  final String url;

  /// Total images on the post; the badge only appears above one.
  final int count;

  /// A circle, at the same 44pt every list row in the app opens with.
  ///
  /// It was a 64px rounded square ported from the web. The reference has no
  /// square thumbnails anywhere — every row, whether it leads with a photo, an
  /// icon or a letter, opens with the same disc, and that shared diameter is
  /// what lines the titles up down a scrolling page. A square here made the
  /// post list the one list that did not.
  static const double _size = ZaveRowCircle.size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _size,
      width: _size,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ClipOval(
            child: _PostImage(url: url, fit: BoxFit.cover),
          ),
          if (count > 1)
            Positioned(
              right: ZaveSpace.xs,
              bottom: ZaveSpace.xs,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ZaveSpace.sm,
                  vertical: ZaveSpace.xs / 2,
                ),
                decoration: BoxDecoration(
                  // `.mono` block fill — black at 35%. The nearest token to the
                  // web's `bg-black/70`; Zave has no darker scrim.
                  color: ZaveGlass.codeFill,
                  borderRadius: ZaveRadius.pillBr,
                ),
                child: Text(
                  '+${count - 1}',
                  style: ZaveType.caption.copyWith(color: ZaveColors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Impressions and comments for a published post — the web's desktop row shows
/// exactly these two.
class _Metrics extends StatelessWidget {
  const _Metrics({required this.metrics});

  final PostMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _MetricChip(
          icon: Icons.visibility_outlined,
          value: NumberFormat.decimalPattern().format(metrics.impressions),
        ),
        SizedBox(width: ZaveSpace.lg),
        _MetricChip(
          icon: Icons.mode_comment_outlined,
          value: '${metrics.comments}',
        ),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 16, color: ZaveColors.ink50),
        SizedBox(width: ZaveSpace.sm),
        Text(value, style: ZaveType.caption),
      ],
    );
  }
}

/// The row's action bar.
///
/// One primary action at most, per Zave's one-white-button rule: Approve when
/// the post needs it, and otherwise a static state. Everything else is a glass
/// icon button.
class _Actions extends StatelessWidget {
  const _Actions({
    required this.post,
    required this.busy,
    this.onApprove,
    this.onDelete,
    this.onOpenLinkedIn,
  });

  final LibraryPost post;
  final bool busy;
  final VoidCallback? onApprove;
  final VoidCallback? onDelete;
  final VoidCallback? onOpenLinkedIn;

  @override
  Widget build(BuildContext context) {
    // Exactly one leading element, and it fills the row so the delete button is
    // always in the same place on every card. `busy` is passed to the button
    // rather than nulling `onPressed`: ZaveButton keeps a busy button at full
    // opacity (so its spinner stays visible) and disabled-dims only a button
    // with no handler at all.
    final Widget? leading;

    // A button fills the row; a pill is a label and stays its own width.
    final bool fills;

    if (onApprove != null) {
      fills = true;
      leading = ZaveButton(
        label: 'Approve',
        kind: ZaveButtonKind.primarySmall,
        busy: busy,
        expand: true,
        onPressed: onApprove,
      );
    } else if (post.isReady) {
      // Static — a state, not a control, so a pill rather than a chip.
      fills = false;
      leading = const ZavePill(
        label: 'Ready to publish',
        color: ZaveColors.scheduled,
        leading: ZaveDot(ZaveColors.scheduled),
      );
    } else if (post.isPublished && post.linkedinUrl != null) {
      fills = true;
      leading = ZaveButton(
        label: 'View on LinkedIn',
        icon: const Icon(Icons.open_in_new_rounded),
        onPressed: onOpenLinkedIn,
      );
    } else {
      fills = false;
      leading = null;
    }

    return Row(
      children: <Widget>[
        if (leading != null)
          Expanded(
            child: fills
                ? leading
                : Align(alignment: Alignment.centerLeft, child: leading),
          )
        else
          const Spacer(),
        if (onDelete != null) ...<Widget>[
          SizedBox(width: ZaveSpace.sm),
          ZaveIconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete post',
            onPressed: busy ? null : onDelete,
          ),
        ],
      ],
    );
  }
}

/// Shared image loader.
///
/// `cached_network_image` for http(s); a plain [Image.network] cannot be used
/// for the `data:` URLs some older posts still carry in `imageUrl` (generated
/// before the Supabase upload pipeline was wired into Cloud Tasks), so those
/// fall through to a placeholder rather than throwing during paint.
/// Decoded `data:` payloads, held so a rebuild does not decode them again.
///
/// Two reasons, and the second is the one that matters. The obvious one is
/// cost: these run to 1.6 MB of base64 on the live table, and the preview
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

class _PostImage extends StatelessWidget {
  const _PostImage({required this.url, this.fit = BoxFit.cover});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    // A `data:` URL is an image, not an address.
    //
    // This branch is why the LinkedIn preview was drawing an empty grey box
    // instead of the post. `image_url` holds an inline base64 JPEG on 152 of
    // the 246 posts that have an image at all — the generated poster is
    // written straight into the column — and the guard below rejects anything
    // that is not `http`, so `CachedNetworkImage` never saw them and the
    // placeholder was all that was ever drawn.
    //
    // The web has no such branch because it does not need one: it renders
    // `<img src={post.imageUrl}>` and a browser reads `data:` natively. This
    // is the same behaviour, spelled out for a toolkit that does not.
    if (url.startsWith('data:')) {
      final Uint8List? bytes = _decodeDataUri(url);
      if (bytes == null) return const ColoredBox(color: ZaveGlass.rest);
      return Image.memory(
        bytes,
        fit: fit,
        // The preview toggles "see more" under the image; without this the
        // picture blinks out and back on every tap.
        gaplessPlayback: true,
        errorBuilder: (BuildContext _, Object _, StackTrace? _) =>
            const ColoredBox(color: ZaveGlass.rest),
      );
    }

    if (!url.startsWith('http')) {
      return const ColoredBox(color: ZaveGlass.rest);
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      fadeInDuration: ZaveMotion.fast,
      placeholder: (BuildContext context, String _) =>
          const ColoredBox(color: ZaveGlass.rest),
      errorWidget: (BuildContext context, String _, Object _) =>
          const ColoredBox(color: ZaveGlass.rest),
    );
  }
}

/// The post's images, as the detail screen shows them.
///
/// Exported from here so one loader serves the list thumbnail, the preview's
/// single image and its carousel — and so the `data:` branch they all depend
/// on cannot be fixed in one of the three and missed in the others.
class PostImage extends StatelessWidget {
  const PostImage({required this.url, this.fit = BoxFit.cover, super.key});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => _PostImage(url: url, fit: fit);
}
