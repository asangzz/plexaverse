/// Translators between the design JSON's CSS-flavoured values and Flutter's.
///
/// A Studio design is authored by a web editor and stores web values: colours
/// as `#rrggbb` / `rgba(…)` / `transparent`, weights as numbers, alignment as
/// the CSS keyword. Nothing here is a Zave token and nothing here should ever
/// be used for the app's own chrome — these are the USER's colours inside
/// their own artwork, which is the one place in the app that is not painted
/// from the palette.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Parses a CSS colour string.
///
/// Handles `transparent`, `#rgb`, `#rrggbb`, `#rrggbbaa`, `rgb(…)` and
/// `rgba(…)`. Anything else — a gradient, a named colour, a `var(--x)` — falls
/// back to [fallback] rather than throwing: a design that uses one is still
/// mostly renderable, and a crash would cost the user the whole preview.
Color cssColor(String? value, {Color fallback = Colors.transparent}) {
  final String raw = (value ?? '').trim().toLowerCase();
  if (raw.isEmpty || raw == 'transparent' || raw == 'none') {
    return Colors.transparent;
  }

  if (raw.startsWith('#')) {
    final String hex = raw.substring(1);
    switch (hex.length) {
      case 3:
        final int? v = int.tryParse(hex, radix: 16);
        if (v == null) return fallback;
        // #rgb → #rrggbb by doubling each nibble.
        final int r = ((v >> 8) & 0xF) * 0x11;
        final int g = ((v >> 4) & 0xF) * 0x11;
        final int b = (v & 0xF) * 0x11;
        return Color.fromARGB(0xFF, r, g, b);
      case 6:
        final int? v = int.tryParse(hex, radix: 16);
        return v == null ? fallback : Color(0xFF000000 | v);
      case 8:
        // CSS is #rrggbbaa; Flutter is 0xAARRGGBB.
        final int? v = int.tryParse(hex, radix: 16);
        if (v == null) return fallback;
        return Color(((v & 0xFF) << 24) | (v >> 8));
      default:
        return fallback;
    }
  }

  if (raw.startsWith('rgb')) {
    final int open = raw.indexOf('(');
    final int close = raw.indexOf(')');
    if (open < 0 || close <= open) return fallback;
    final List<String> parts = raw
        .substring(open + 1, close)
        .split(',')
        .map((String p) => p.trim())
        .toList(growable: false);
    if (parts.length < 3) return fallback;
    final int? r = int.tryParse(parts[0]);
    final int? g = int.tryParse(parts[1]);
    final int? b = int.tryParse(parts[2]);
    if (r == null || g == null || b == null) return fallback;
    final double a = parts.length > 3
        ? (double.tryParse(parts[3]) ?? 1).clamp(0.0, 1.0)
        : 1.0;
    return Color.fromARGB(
      (a * 255).round(),
      r.clamp(0, 255),
      g.clamp(0, 255),
      b.clamp(0, 255),
    );
  }

  return fallback;
}

/// Numeric CSS weight → the nearest [FontWeight].
FontWeight cssFontWeight(int? weight) {
  final int w = weight ?? 400;
  if (w >= 850) return FontWeight.w900;
  if (w >= 750) return FontWeight.w800;
  if (w >= 650) return FontWeight.w700;
  if (w >= 550) return FontWeight.w600;
  if (w >= 450) return FontWeight.w500;
  if (w >= 350) return FontWeight.w400;
  if (w >= 250) return FontWeight.w300;
  if (w >= 150) return FontWeight.w200;
  return FontWeight.w100;
}

/// CSS `text-align` → [TextAlign]. Absent means left, as on the web.
TextAlign cssTextAlign(String? align) => switch (align) {
  'center' => TextAlign.center,
  'right' => TextAlign.right,
  _ => TextAlign.left,
};

/// Horizontal placement of a text box's content, matching the flexbox
/// `justifyContent` the web derives from the same keyword.
Alignment cssTextAlignment(String? align) => switch (align) {
  'center' => Alignment.center,
  'right' => Alignment.centerRight,
  _ => Alignment.centerLeft,
};

/// Flutter has no `text-transform`, so the STRING is transformed.
///
/// Doing it in a style would break anything that reads the text back — the
/// layer editor's own field, most obviously, which would then show the user
/// shouting text they never typed.
String cssTextTransform(String text, String? transform) => switch (transform) {
  'uppercase' => text.toUpperCase(),
  'lowercase' => text.toLowerCase(),
  'capitalize' =>
    text
        .split(' ')
        .map(
          (String w) =>
              w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}',
        )
        .join(' '),
  _ => text,
};

/// Resolves an element's `imageUrl` to something Flutter can draw.
///
/// Two forms arrive and they need different providers: an `https://` URL from
/// storage, and a `data:image/…;base64,…` URI, which is what the AI Designer
/// and `/ai/image` hand back inline so the client can render without a second
/// round-trip. Returns null for anything unusable, so the caller draws a
/// placeholder instead of a broken-image box.
ImageProvider<Object>? studioImageProvider(String? url) {
  final String raw = (url ?? '').trim();
  if (raw.isEmpty) return null;

  if (raw.startsWith('data:')) {
    final int comma = raw.indexOf(',');
    if (comma < 0) return null;
    try {
      final Uint8List bytes = base64Decode(raw.substring(comma + 1));
      return MemoryImage(bytes);
    } on FormatException {
      return null;
    }
  }

  if (raw.startsWith('http://') || raw.startsWith('https://')) {
    return CachedNetworkImageProvider(raw);
  }
  return null;
}
