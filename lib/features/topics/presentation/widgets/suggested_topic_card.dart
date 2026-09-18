import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/topic.dart';

/// One AI suggestion, with the action that turns it into a real topic.
///
/// **The button is a ghost, not the white primary.** The web makes every "Add
/// to My Topics" an indigo filled button, which on a phone would put three
/// solid buttons on screen at once. Zave allows one primary action per screen
/// and that one is "Add Topic" in the header; these three are the same verb
/// offered three times, so they take the secondary treatment.
///
/// The card is otherwise the web's: name, three lines of description, the
/// keywords the model proposed, then the action.
class SuggestedTopicCard extends StatelessWidget {
  const SuggestedTopicCard({
    required this.topic,
    required this.onAdd,
    required this.busy,
    super.key,
  });

  final SuggestedTopic topic;
  final VoidCallback onAdd;

  /// True while THIS card's add is in flight. Passed per card rather than as a
  /// page-wide flag so two adds in quick succession do not both spin.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(topic.name, style: ZaveType.h3),
          if (topic.description.isNotEmpty) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(
              topic.description,
              style: ZaveType.bodyMuted,
              // The web's `line-clamp-3`.
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (topic.keywords.isNotEmpty) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            Wrap(
              spacing: ZaveSpace.sm,
              runSpacing: ZaveSpace.sm,
              children: <Widget>[
                for (final String keyword in topic.keywords)
                  // The web prefixes these with '#'; the saved-topic card does
                  // not. Kept, because it is what distinguishes a proposal
                  // from a stored keyword at a glance.
                  ZavePill(label: '#$keyword', color: ZaveColors.peri),
              ],
            ),
          ],
          SizedBox(height: ZaveSpace.lg),
          ZaveButton(
            label: 'Add to My Topics',
            icon: const Icon(Icons.add),
            expand: true,
            busy: busy,
            onPressed: busy ? null : onAdd,
          ),
        ],
      ),
    );
  }
}
