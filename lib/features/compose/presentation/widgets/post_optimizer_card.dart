import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// One of the five things the optimizer checks.
class PostCheck {
  const PostCheck({required this.label, required this.met});

  /// The web's exact string — these are the words users learn the rules from,
  /// and paraphrasing them would make the two platforms teach different
  /// lessons.
  final String label;

  final bool met;
}

/// The result of scoring a draft.
class PostScore {
  const PostScore({required this.score, required this.checks});

  /// 0–100.
  final int score;

  final List<PostCheck> checks;

  /// Ports `analyzeContent` from `components/automate/PostOptimizer.tsx`
  /// verbatim, including the partial-credit rules, which are NOT symmetric:
  /// length and hashtags award 10 for "something rather than nothing", hook,
  /// formatting and readability award 20 or 0. Changing that here would make
  /// the same post score differently on a phone than in a browser, which is
  /// the one thing a score like this cannot afford.
  factory PostScore.of(String text) {
    if (text.isEmpty) {
      return PostScore(
        score: 0,
        checks: _checks(false, false, false, false, false),
      );
    }

    int score = 0;

    // 1. Hook — the first line has to do some work.
    final String firstLine = text.split('\n').first;
    final bool hasHook =
        firstLine.length > 10 &&
        (firstLine.contains('?') ||
            firstLine.contains('!') ||
            firstLine.toUpperCase() == firstLine ||
            (firstLine.length > 30 && firstLine.length < 100));
    if (hasHook) score += 20;

    // 2. Length.
    final int length = text.length;
    final bool optimalLength = length >= 800 && length <= 2200;
    if (optimalLength) {
      score += 20;
    } else if (length > 0) {
      score += 10;
    }

    // 3. Hashtags.
    final int hashtagCount = RegExp(r'#[a-zA-Z0-9]+').allMatches(text).length;
    final bool optimalHashtags = hashtagCount >= 3 && hashtagCount <= 5;
    if (optimalHashtags) {
      score += 20;
    } else if (hashtagCount > 0) {
      score += 10;
    }

    // 4. Formatting — blank lines between paragraphs.
    final bool wellFormatted = text.split('\n\n').length >= 3;
    if (wellFormatted) score += 20;

    // 5. Readability — average characters per sentence.
    final List<String> sentences = text
        .split(RegExp(r'[.!?]'))
        .where((String s) => s.trim().isNotEmpty)
        .toList();
    final double avgSentence = sentences.isEmpty
        ? 0
        : text.length / sentences.length;
    final bool readable = avgSentence > 0 && avgSentence < 120;
    if (readable) score += 20;

    return PostScore(
      score: score,
      checks: _checks(
        hasHook,
        optimalLength,
        optimalHashtags,
        wellFormatted,
        readable,
      ),
    );
  }

  static List<PostCheck> _checks(
    bool hook,
    bool length,
    bool hashtags,
    bool formatting,
    bool readability,
  ) => <PostCheck>[
    PostCheck(
      label: 'Strong opening hook (question, exclamation, or bold statement)',
      met: hook,
    ),
    PostCheck(
      label: 'Optimal length for engagement (800 - 2200 characters)',
      met: length,
    ),
    PostCheck(label: 'Use 3-5 relevant hashtags', met: hashtags),
    PostCheck(label: 'Good use of white space and paragraphs', met: formatting),
    PostCheck(label: 'Maintain readable sentence lengths', met: readability),
  ];
}

/// "Post optimizer" — the live score and its five checks.
///
/// Ports `PostOptimizer` (recon §4.3) with one omission, stated plainly: the
/// web's **radar chart is not here**. It is a 160px SVG filled
/// `rgba(112,0,255,0.3)` with a `#7000ff` stroke — a purple that exists nowhere
/// else in the product and has no Zave counterpart, and the five numbers it
/// plots are the same five the checklist below already states in words. A
/// 160px decorative chart is also the wrong use of a phone's width. The score,
/// the bar and the five checks — the parts that tell the user what to change —
/// are all here.
///
/// The score colours are the other change. The web uses green/yellow/red
/// thresholds; Zave has no red, so a weak score is amber ("needs work"), a
/// middling one is peri, and a strong one is green. Nothing here is an error.
class PostOptimizerCard extends StatelessWidget {
  const PostOptimizerCard({required this.content, super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    final PostScore result = PostScore.of(content);
    final Color tone = _tone(result.score);

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Expanded(child: Text('Post optimizer', style: ZaveType.h3)),
              Text('${result.score}', style: ZaveType.h3.copyWith(color: tone)),
              Text(' /100', style: ZaveType.caption),
            ],
          ),

          SizedBox(height: ZaveSpace.lg),
          Text('VIRAL POTENTIAL', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          ClipRRect(
            borderRadius: ZaveRadius.pillBr,
            child: LinearProgressIndicator(
              value: result.score / 100,
              minHeight: 6,
              backgroundColor: ZaveGlass.rest,
              valueColor: AlwaysStoppedAnimation<Color>(tone),
            ),
          ),

          SizedBox(height: ZaveSpace.lg),
          for (final PostCheck check in result.checks) ...<Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: ZaveSpace.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    // Nudges the 9px dot onto the first line's optical centre.
                    padding: EdgeInsets.only(top: ZaveSpace.xs + 2),
                    child: ZaveDot(
                      check.met ? ZaveColors.green : ZaveColors.ink35,
                    ),
                  ),
                  SizedBox(width: ZaveSpace.md),
                  Expanded(
                    child: Text(
                      check.label,
                      style: ZaveType.caption.copyWith(
                        color: check.met ? ZaveColors.ink85 : ZaveColors.ink50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (content.trim().isEmpty) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(
              'Start typing to see real-time optimization suggestions.',
              style: ZaveType.caption,
            ),
          ],
        ],
      ),
    );
  }

  /// Zave has no red — see the class doc.
  static Color _tone(int score) {
    if (score >= 80) return ZaveColors.green;
    if (score >= 50) return ZaveColors.peri;
    return ZaveColors.amber;
  }
}
