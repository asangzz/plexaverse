import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/zave/zave.dart';

/// What a task card draws where a stat card draws its chart.
///
/// ## Why these are not charts
///
/// A stat card's chart restates its number — a wedge beside `2 of 7`, a
/// sparkline beside `67 BPM`. A task has no quantity to restate: the only
/// number on the card is its XP reward, and drawing that as a rising curve
/// says "this task is growing", which is not a fact about anything.
///
/// So these say what the task IS. A post looks like written lines, a comment
/// like two bubbles, connections like a small network. Nothing here is plotted
/// and nothing implies a measurement, which also means none of it can be a
/// picture of data that does not exist.
///
/// ## Why they still look like the charts
///
/// One paint recipe, shared: the same violet-to-lavender ramp, the same 2pt
/// round-capped stroke, the same full-width composition in the same band. Tone
/// comes from the recipe, not from the subject — which is what lets a bubble
/// and a wedge sit in one scrolling strip without either looking imported.
enum ZaveGlyph {
  /// Written lines. `publish-post`.
  post,

  /// Two bubbles. `comment`.
  comment,

  /// A small network. `connect`.
  connect,

  /// One strong line over a short one. `headline`, `profile-title`.
  headline,

  /// A wide frame with a horizon. `banner`.
  banner,

  /// A paragraph. `about`.
  about,

  /// Arcs spreading from the left. `weekly-reach`.
  reach,

  /// A rising curve. `page-growth` — the one task that IS about a trend.
  growth,
}

/// Maps a roadmap step's stable `key` to its glyph.
///
/// Keyed on `key`, never on `title`: the titles are display copy and are
/// rewritten at runtime (the publish-post overrides do exactly that), so a
/// title match would silently fall back to the default the day the copy
/// changed.
ZaveGlyph? glyphForStepKey(String key) => switch (key) {
  'publish-post' => ZaveGlyph.post,
  'comment' => ZaveGlyph.comment,
  'connect' => ZaveGlyph.connect,
  'headline' || 'profile-title' => ZaveGlyph.headline,
  'banner' => ZaveGlyph.banner,
  'about' => ZaveGlyph.about,
  'weekly-reach' => ZaveGlyph.reach,
  'page-growth' => ZaveGlyph.growth,
  // An unknown key draws nothing. A wrong picture is worse than none: it
  // tells the reader something about a task that is not true.
  _ => null,
};

class ZaveTaskGlyph extends StatelessWidget {
  const ZaveTaskGlyph(this.kind, {this.onViolet = false, super.key});

  final ZaveGlyph kind;

  /// Drawn on a filled violet card.
  ///
  /// The ramp that reads on a near-black ground does not read on violet —
  /// lavender on violet is two neighbours in the same hue. On violet the
  /// stroke goes white and keeps only its left-to-right fade.
  final bool onViolet;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _GlyphPainter(kind, onViolet: onViolet),
    size: Size.infinite,
  );
}

class _GlyphPainter extends CustomPainter {
  _GlyphPainter(this.kind, {required this.onViolet});

  final ZaveGlyph kind;
  final bool onViolet;

  /// The recipe every glyph shares. Left end faint, right end lavender — the
  /// same left-to-right brightening the sparkline has, which is what gives a
  /// static mark a direction without an arrowhead.
  Paint _stroke(Size size, {double width = 2}) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..shader = LinearGradient(
      colors: onViolet
          ? const <Color>[Color(0x66FFFFFF), ZaveColors.white]
          : const <Color>[Color(0x59FFFFFF), ZaveColors.lavenderHi],
    ).createShader(Offset.zero & size);

  Paint _fill(Size size) => Paint()
    ..shader = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: onViolet
          ? const <Color>[Color(0x33FFFFFF), Color(0xB3FFFFFF)]
          : const <Color>[Color(0x335E3DE6), Color(0xCC8B6BF2)],
    ).createShader(Offset.zero & size);

  @override
  void paint(Canvas canvas, Size size) {
    switch (kind) {
      case ZaveGlyph.post:
        _lines(canvas, size, <double>[1.0, 0.82, 0.55], heavyFirst: true);
      case ZaveGlyph.about:
        _lines(canvas, size, <double>[0.95, 1.0, 0.88, 0.4]);
      case ZaveGlyph.headline:
        _lines(canvas, size, <double>[0.78, 0.36], heavyFirst: true, gap: 14);
      case ZaveGlyph.comment:
        _comment(canvas, size);
      case ZaveGlyph.connect:
        _connect(canvas, size);
      case ZaveGlyph.banner:
        _banner(canvas, size);
      case ZaveGlyph.reach:
        _reach(canvas, size);
      case ZaveGlyph.growth:
        _growth(canvas, size);
    }
  }

  /// Horizontal rules, as written text reads. [widths] are fractions of the
  /// box; the first can be heavier to read as a title line.
  void _lines(
    Canvas canvas,
    Size size,
    List<double> widths, {
    bool heavyFirst = false,
    double? gap,
  }) {
    final double step = gap ?? size.height / (widths.length + 0.6);
    double y = size.height - step * (widths.length - 1);
    for (int i = 0; i < widths.length; i++) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width * widths[i], y),
        _stroke(size, width: heavyFirst && i == 0 ? 3.5 : 2),
      );
      y += step;
    }
  }

  void _comment(Canvas canvas, Size size) {
    final Paint p = _stroke(size);
    final double h = size.height * 0.52;

    // The near bubble, with the tail that makes it a bubble rather than a box.
    final Rect near = Rect.fromLTWH(0, size.height - h, size.width * 0.58, h);
    canvas.drawRRect(
      RRect.fromRectAndRadius(near, const Radius.circular(8)),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(near.left + 10, near.bottom)
        ..lineTo(near.left + 6, near.bottom + 6)
        ..lineTo(near.left + 18, near.bottom),
      p,
    );

    // The far one, set back and up — a reply.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.46, 0, size.width * 0.54, h * 0.8),
        const Radius.circular(8),
      ),
      p,
    );
  }

  void _connect(Canvas canvas, Size size) {
    final Paint p = _stroke(size);
    final double midY = size.height * 0.5;
    final List<Offset> nodes = <Offset>[
      Offset(5, size.height - 6),
      Offset(size.width * 0.34, midY - 8),
      Offset(size.width * 0.66, midY + 6),
      Offset(size.width - 5, 6),
    ];
    for (int i = 0; i < nodes.length - 1; i++) {
      canvas.drawLine(nodes[i], nodes[i + 1], p);
    }
    for (final Offset n in nodes) {
      canvas.drawCircle(n, 3.5, p);
    }
  }

  void _banner(Canvas canvas, Size size) {
    final Paint p = _stroke(size);
    final Rect frame = Rect.fromLTWH(0, 2, size.width, size.height - 4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(frame, const Radius.circular(6)),
      p,
    );
    // A horizon and a sun: the smallest mark that reads as an image rather
    // than an empty box.
    canvas.drawLine(
      Offset(frame.left + 6, frame.bottom - 9),
      Offset(frame.right - 6, frame.bottom - 9),
      p,
    );
    canvas.drawCircle(Offset(frame.right - 14, frame.top + 11), 4, p);
  }

  void _reach(Canvas canvas, Size size) {
    final Paint p = _stroke(size);
    final Offset origin = Offset(2, size.height - 2);
    // Arcs spreading from the corner. Deliberately evenly spaced — uneven
    // rings would read as measurements, and reach is not being measured here.
    for (int i = 1; i <= 3; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: origin, radius: size.height * 0.34 * i),
        -math.pi / 2,
        math.pi / 2,
        false,
        p,
      );
    }
    canvas.drawCircle(origin, 3, p);
  }

  void _growth(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height)
        ..cubicTo(
          size.width * 0.45,
          size.height,
          size.width * 0.55,
          size.height * 0.18,
          size.width,
          size.height * 0.18,
        )
        ..lineTo(size.width, size.height)
        ..close(),
      _fill(size),
    );
  }

  @override
  bool shouldRepaint(_GlyphPainter old) =>
      old.kind != kind || old.onViolet != onViolet;
}
