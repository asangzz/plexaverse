import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/compose_draft.dart';

/// Renders whatever a [ComposeImage] currently holds.
///
/// A composer image arrives one of two ways and they need different widgets:
///
///   • a `data:image/…;base64,…` URI, straight out of `POST /ai/poster`. The
///     poster is composited server-side and handed back inline so the user
///     sees it without a second round-trip.
///   • an `https://` URL, once the image has been uploaded to storage.
///
/// The base64 is decoded **once per URI**, in [didUpdateWidget], and not in
/// `build`. A poster is a few hundred kilobytes; decoding it on every frame of
/// a scroll would be visible.
class ComposeImageView extends StatefulWidget {
  const ComposeImageView({
    required this.image,
    this.height,
    this.fit = BoxFit.cover,
    super.key,
  });

  final ComposeImage image;

  /// Null lets the image size itself to its own aspect ratio, which is what the
  /// LinkedIn preview wants; the attached-image panel caps it instead.
  final double? height;

  final BoxFit fit;

  @override
  State<ComposeImageView> createState() => _ComposeImageViewState();
}

class _ComposeImageViewState extends State<ComposeImageView> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _decode();
  }

  @override
  void didUpdateWidget(ComposeImageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image.dataUri != widget.image.dataUri) _decode();
  }

  void _decode() {
    final String? uri = widget.image.dataUri;
    if (uri == null) {
      _bytes = null;
      return;
    }
    // `data:image/jpeg;base64,<payload>` — everything after the first comma.
    final int comma = uri.indexOf(',');
    final String payload = comma == -1 ? uri : uri.substring(comma + 1);
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
    final Uint8List? bytes = _bytes;
    if (bytes != null) {
      return Image.memory(
        bytes,
        height: widget.height,
        width: double.infinity,
        fit: widget.fit,
        // The bytes are already in memory and never change identity, so a
        // fade-in would only ever flash on first attach.
        gaplessPlayback: true,
      );
    }

    final String? url = widget.image.url;
    if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        height: widget.height,
        width: double.infinity,
        fit: widget.fit,
        placeholder: (BuildContext _, String _) =>
            _Placeholder(height: widget.height),
        errorWidget: (BuildContext _, String _, Object _) =>
            _Placeholder(height: widget.height),
      );
    }

    return _Placeholder(height: widget.height);
  }
}

/// The rest-fill block shown while an image loads or when it cannot be shown.
/// A fill step, not a spinner: Zave builds depth out of fills, and a spinner
/// inside a card that is already the right size just adds motion.
class _Placeholder extends StatelessWidget {
  const _Placeholder({this.height});

  final double? height;

  @override
  Widget build(BuildContext context) => Container(
    height: height ?? 160,
    width: double.infinity,
    color: ZaveGlass.rest,
  );
}
