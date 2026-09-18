import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// Renders whatever an AI tool currently holds for an image.
///
/// Every surface in this slice deals with both forms and they need different
/// widgets:
///
///   • a `data:image/…;base64,…` URI — what `POST /festive/generate` and
///     `POST /ai/headshot` return. Composited server-side and handed back
///     inline so the user sees it without a second round-trip.
///   • an `https://` URL — a template's stored preview, or a poster after it
///     has been through `POST /upload/image`.
///
/// The base64 is decoded **once per URI**, in [didUpdateWidget], never in
/// `build`. A poster is a few hundred kilobytes; decoding it on every frame of
/// a scroll would be visible.
///
/// There is deliberately no remote placeholder. The web falls back to a
/// `via.placeholder.com` URL when a preview 404s — a second network request,
/// to a third party, to render a grey box. The fallback here is a Zave rest
/// fill, which costs nothing and leaks nothing.
class AiToolImage extends StatefulWidget {
  const AiToolImage({
    required this.source,
    this.aspectRatio,
    this.fit = BoxFit.cover,
    this.label,
    super.key,
  });

  /// A data URI, an http(s) URL, or null/empty for "nothing yet".
  final String? source;

  /// Width / height. Null lets the image size itself.
  final double? aspectRatio;

  final BoxFit fit;

  /// Shown in the placeholder when there is nothing to draw — the template's
  /// size, say, which is what the web's no-thumbnail branch prints.
  final String? label;

  @override
  State<AiToolImage> createState() => _AiToolImageState();
}

class _AiToolImageState extends State<AiToolImage> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _decode();
  }

  @override
  void didUpdateWidget(AiToolImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) _decode();
  }

  void _decode() {
    final String? src = widget.source;
    if (src == null || !src.startsWith('data:')) {
      _bytes = null;
      return;
    }
    // `data:image/png;base64,<payload>` — everything after the first comma.
    final int comma = src.indexOf(',');
    final String payload = comma == -1 ? src : src.substring(comma + 1);
    try {
      _bytes = base64Decode(payload);
    } on FormatException {
      // A malformed payload is a server bug, not something the user can act
      // on. Fall through to the placeholder rather than throwing inside build.
      _bytes = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = _build();
    final double? ratio = widget.aspectRatio;
    return ratio == null
        ? child
        : AspectRatio(aspectRatio: ratio, child: child);
  }

  Widget _build() {
    final Uint8List? bytes = _bytes;
    if (bytes != null) {
      return Image.memory(
        bytes,
        width: double.infinity,
        fit: widget.fit,
        // The bytes are already in memory and never change identity, so a
        // fade-in would only ever flash on first render.
        gaplessPlayback: true,
      );
    }

    final String? src = widget.source;
    if (src != null && src.isNotEmpty && !src.startsWith('data:')) {
      return CachedNetworkImage(
        imageUrl: src,
        width: double.infinity,
        fit: widget.fit,
        placeholder: (BuildContext _, String _) =>
            _Placeholder(label: widget.label),
        errorWidget: (BuildContext _, String _, Object _) =>
            _Placeholder(label: widget.label),
      );
    }

    return _Placeholder(label: widget.label);
  }
}

/// The rest-fill block shown while an image loads, or when there is none.
///
/// A fill step, not a spinner: Zave builds depth out of fills, and a spinner
/// inside a box that is already the right size just adds motion for its own
/// sake.
class _Placeholder extends StatelessWidget {
  const _Placeholder({this.label});

  final String? label;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: ZaveGlass.rest,
    child: Center(
      child: label == null
          ? const SizedBox.shrink()
          : Text(
              label!,
              style: ZaveType.caption.copyWith(color: ZaveColors.ink35),
            ),
    ),
  );
}
