import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/post_review.dart';

/// "Post review" — the server's manual review of the draft, live, as the
/// web's `PostOptimizer` shows it since 25 Nov 2026: a score that moves with
/// the review, each error as the fix to make, and "Passes the review." when
/// there is none.
///
/// It replaced the "Post optimizer" heuristics (an opening hook, 800–2200
/// characters, white space, sentence length — and "3-5 relevant hashtags"),
/// which disagreed with the review the server actually runs: a 330-word post
/// scored 100 here while the web said "Shorten the post", and the hashtag
/// check coached people into what planned posts now refuse. The rules live in
/// `domain/post_review.dart`, held against the server's source by a test.
///
/// The score colours: the web uses green/yellow/red; Zave has no red, so a
/// weak score is amber ("needs work"), a middling one peri, a strong one green.
class PostOptimizerCard extends StatelessWidget {
  const PostOptimizerCard({required this.content, super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    final bool empty = content.trim().isEmpty;
    final PostReview? review = empty ? null : reviewManualPost(content);
    final int score = review?.score ?? 0;
    final Color tone = _tone(score);

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Expanded(child: Text('Post review', style: ZaveType.h3)),
              if (review != null) ...<Widget>[
                Text('$score', style: ZaveType.h3.copyWith(color: tone)),
                Text(' /100', style: ZaveType.caption),
              ],
            ],
          ),
          SizedBox(height: ZaveSpace.xs),
          Text(
            'Checked against the LinkedIn playbook’s writing rules.',
            style: ZaveType.caption,
          ),
          if (review != null) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            ClipRRect(
              borderRadius: ZaveRadius.pillBr,
              child: LinearProgressIndicator(
                value: score / 100,
                minHeight: 6,
                backgroundColor: ZaveGlass.rest,
                valueColor: AlwaysStoppedAnimation<Color>(tone),
              ),
            ),
            SizedBox(height: ZaveSpace.lg),
            if (review.ok)
              Row(
                children: <Widget>[
                  const ZaveDot(ZaveColors.green),
                  SizedBox(width: ZaveSpace.md),
                  Text(
                    'Passes the review.',
                    style: ZaveType.caption.copyWith(color: ZaveColors.green),
                  ),
                ],
              )
            else
              for (final String error in review.errors)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: ZaveSpace.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        // Nudges the 9px dot onto the first line's optical
                        // centre.
                        padding: EdgeInsets.only(top: ZaveSpace.xs + 2),
                        child: const ZaveDot(ZaveColors.amber),
                      ),
                      SizedBox(width: ZaveSpace.md),
                      Expanded(
                        child: Text(
                          error,
                          style: ZaveType.caption.copyWith(
                            color: ZaveColors.ink85,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            if (!review.ok) ...<Widget>[
              SizedBox(height: ZaveSpace.sm),
              Text(
                'Suggestions only — your own words are never rewritten for you.',
                style: ZaveType.caption,
              ),
            ],
          ],
          if (empty) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text('Start typing to see the review.', style: ZaveType.caption),
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
