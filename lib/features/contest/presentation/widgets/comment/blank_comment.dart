import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../domain/contest_repository.dart';
import '../contest_kit.dart';
import 'comment_words.dart';

/// The comment, whole, with its blanks where they fall — so each word is
/// chosen in context. A port of the blanks in the web's `CommentLevel.tsx`.
///
/// A blank is dashed while empty, periwinkle-blue once filled, and after a
/// check green when right or red with "→ the right word" when wrong. Tapping
/// a filled blank sends its word back to the bank.
class BlankComment extends StatelessWidget {
  const BlankComment({
    required this.parts,
    required this.words,
    this.verdicts,
    this.onTakeBack,
    super.key,
  });

  final List<CommentPart> parts;

  /// The word in each blank, by slot; null is empty.
  final List<String?> words;

  /// The last submission's verdict for each blank, while it is up.
  final List<CommentBlank>? verdicts;

  /// Null while nothing may move — a verdict is up or a submission is out.
  final ValueChanged<int>? onTakeBack;

  Widget _blank(int slot) {
    final String? word = slot < words.length ? words[slot] : null;
    final CommentBlank? v = verdicts != null && slot < verdicts!.length
        ? verdicts![slot]
        : null;
    return _Blank(
      n: slot + 1,
      word: word,
      look: switch (v) {
        CommentBlank(correct: true) => _Look.right,
        CommentBlank() => _Look.wrong,
        null => word == null ? _Look.empty : _Look.filled,
      },
      answer: v?.answer,
      onTap: onTakeBack == null ? null : () => onTakeBack!(slot),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style = ZaveType.body.copyWith(
      fontSize: 18.sp,
      height: 2.2,
      color: const Color(0xFFD4D8EA),
    );
    return Semantics(
      label: 'The comment',
      container: true,
      child: Text.rich(
        TextSpan(
          style: style,
          children: <InlineSpan>[
            for (final CommentPart part in parts)
              switch (part) {
                CommentText(:final String text) => TextSpan(text: text),
                CommentSlot(:final int slot) => WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: _blank(slot),
                ),
              },
          ],
        ),
      ),
    );
  }
}

/// The finished comment, its filled words drawn in green over the sentence.
/// A screen reader hears the plain sentence — the one that is copied.
class FinishedComment extends StatelessWidget {
  const FinishedComment({
    required this.parts,
    required this.answers,
    required this.comment,
    super.key,
  });

  final List<CommentPart> parts;
  final List<String> answers;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: comment,
      excludeSemantics: true,
      child: Text.rich(
        TextSpan(
          style: ZaveType.body.copyWith(
            fontSize: 16.sp,
            height: 2,
            color: ZaveColors.white,
          ),
          children: <InlineSpan>[
            for (final CommentPart part in parts)
              switch (part) {
                CommentText(:final String text) => TextSpan(text: text),
                CommentSlot(:final int slot) => WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: _Blank(
                    n: slot + 1,
                    word: slot < answers.length ? answers[slot] : null,
                    // The server's own answers, so drawn as right.
                    look: _Look.right,
                    fontSize: 16,
                  ),
                ),
              },
          ],
        ),
      ),
    );
  }
}

/// How a blank is drawn. A verdict picks right or wrong, and only the
/// server's reply gives one.
enum _Look { empty, filled, right, wrong }

/// The comment's blue for a filled blank — the web's `#5761EB`.
const Color _filled = Color(0xFF5761EB);

/// Tailwind's `red-400`, the web's wrong blank.
const Color _red = Color(0xFFF87171);

/// The right word beside a wrong one.
const Color _answer = Color(0xFF8DF0C4);

class _Blank extends StatelessWidget {
  const _Blank({
    required this.n,
    required this.word,
    required this.look,
    this.answer,
    this.onTap,
    this.fontSize = 18,
  });

  /// 1-based, for the label.
  final int n;
  final String? word;
  final _Look look;

  /// The right word, beside a wrong one.
  final String? answer;
  final VoidCallback? onTap;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final String? w = word;
    final (Color border, Color fill) = switch (look) {
      _Look.right => (
        ContestColors.green,
        ContestColors.green.withValues(alpha: 0.10),
      ),
      _Look.wrong => (
        _red.withValues(alpha: 0.70),
        _red.withValues(alpha: 0.10),
      ),
      _Look.filled => (_filled, _filled.withValues(alpha: 0.15)),
      _Look.empty => (const Color(0x4DFFFFFF), Colors.transparent),
    };
    final String label = switch (look) {
      _Look.right => 'Blank $n: $w, right',
      _Look.wrong => 'Blank $n: $w, wrong, the right word is $answer',
      _Look.filled => 'Blank $n: $w',
      _Look.empty => 'Blank $n',
    };
    final bool graded = look == _Look.right || look == _Look.wrong;
    final TextStyle text = ZaveType.body.copyWith(
      fontSize: fontSize.sp,
      height: 1.4,
      color: ZaveColors.white,
      fontWeight: graded ? FontWeight.w600 : FontWeight.w500,
    );

    Widget box = Container(
      constraints: BoxConstraints(minWidth: 88.w, minHeight: 34.h),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(8.r),
        border: look == _Look.empty
            ? null
            : Border.all(color: border, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(child: Text(w ?? ' ', style: text)),
          if (look == _Look.wrong && answer != null) ...<Widget>[
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                '→ $answer',
                style: text.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: _answer,
                ),
              ),
            ),
          ],
        ],
      ),
    );
    if (look == _Look.empty) {
      // Dashed while empty: a gap waiting for a word, not a box holding one.
      box = CustomPaint(
        foregroundPainter: _DashedOutline(color: border, radius: 8.r),
        child: box,
      );
    }
    final bool canTap = onTap != null && w != null;
    return Semantics(
      button: true,
      enabled: canTap,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: canTap ? onTap : null,
        child: box,
      ),
    );
  }
}

/// A 2px dashed rounded outline, inset by the blank's margin.
class _DashedOutline extends CustomPainter {
  const _DashedOutline({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    // The container's margin sits inside the painted box; the outline
    // follows the decoration, not the margin.
    final Rect box = Rect.fromLTRB(
      4.w + 1,
      2.h + 1,
      size.width - 4.w - 1,
      size.height - 2.h - 1,
    );
    final Path outline = Path()
      ..addRRect(RRect.fromRectAndRadius(box, Radius.circular(radius)));
    const double dash = 5;
    const double space = 4;
    for (final PathMetric metric in outline.computeMetrics()) {
      double at = 0;
      while (at < metric.length) {
        canvas.drawPath(metric.extractPath(at, at + dash), paint);
        at += dash + space;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedOutline old) =>
      old.color != color || old.radius != radius;
}
