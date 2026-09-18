import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/topic.dart';

/// One saved topic.
///
/// The web renders these as a responsive grid (1 / 2 / 3 columns); a phone gets
/// the single column, which is the web's own rendering below `md`.
///
/// **The gradient icon chip is dropped.** The web puts a 40px
/// `from-[#5761EB]/30 to-[#00DC82]/30` tile with a green tag glyph beside each
/// name. That is two brand colours spent on decoration, which Zave forbids
/// outright — colour here names one thing only, and on this card the one thing
/// worth naming is whether the topic is active.
///
/// **The card is not tappable.** Neither is the web's: `/topics` has no detail
/// view, no edit control and no delete. Making it tappable would promise a
/// screen that does not exist on either platform.
class TopicCard extends StatelessWidget {
  const TopicCard({required this.topic, super.key});

  final Topic topic;

  /// The web shows the first five keywords and rolls the rest into a "+n more"
  /// chip.
  static const int _visibleKeywords = 5;

  @override
  Widget build(BuildContext context) {
    final List<String> shown = topic.keywords
        .take(_visibleKeywords)
        .toList(growable: false);
    final int overflow = topic.keywords.length - shown.length;
    final String? description = topic.description;

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: Text(topic.name, style: ZaveType.h3)),
              SizedBox(width: ZaveSpace.md),
              ZavePill(
                label: topic.isActive ? 'Active' : 'Inactive',
                // Green is "done / live" and ink-35 is "inert" — the two
                // states this pill actually has.
                color: topic.isActive ? ZaveColors.green : ZaveColors.ink35,
                leading: ZaveDot(
                  topic.isActive ? ZaveColors.green : ZaveColors.ink35,
                ),
              ),
            ],
          ),
          if (description != null && description.isNotEmpty) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(
              description,
              style: ZaveType.bodyMuted,
              // The web's `line-clamp-2`.
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (shown.isNotEmpty) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            Wrap(
              spacing: ZaveSpace.sm,
              runSpacing: ZaveSpace.sm,
              children: <Widget>[
                for (final String keyword in shown)
                  ZavePill(label: keyword, color: ZaveColors.ink62),
                if (overflow > 0)
                  ZavePill(label: '+$overflow more', color: ZaveColors.ink35),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
