import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/ui/app_icons.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../application/contest_home_controllers.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/contest_words.dart';
import '../contest_kit.dart';
import '../contest_skeletons.dart';
import 'rail_card.dart';

/// What a quest's tile shows.
enum QuestIcon { bolt, check, task }

/// One of today's quests. Derived — there is no quest table.
class Quest {
  const Quest({
    required this.id,
    required this.title,
    required this.done,
    required this.goal,
    required this.icon,
    this.kind,
    this.note,
  });

  final String id;
  final String title;
  final int done;
  final int goal;
  final QuestIcon icon;

  /// The level's kind, for a task quest's glyph.
  final PathNodeKind? kind;

  /// Said under the bar when the number alone would mislead — "Waiting for
  /// review".
  final String? note;
}

/// Today's quests, read off the path and today's lesson. The web's
/// `questsFor`, pure, for the tests.
///
/// The lesson is counted in parts, so each checkpoint moves the bar, and it
/// is finished only when every part is — a skipped part (17 Nov 2026) is not
/// passed; the right answers come from the lesson
/// read; every other level of today that has something to do is one quest of
/// one. A quest is only a way of looking at the day, so it cannot disagree
/// with the path above it.
List<Quest> questsFor(PathDay? today, LessonProgress? lesson) {
  if (today == null) return const <Quest>[];
  final List<Quest> out = <Quest>[];
  final List<PathNode> parts = lessonPartsOf(today);
  if (parts.isNotEmpty) {
    out.add(
      Quest(
        id: 'lesson',
        title: 'Finish today’s lesson',
        done: parts.where((PathNode n) => isHandedIn(n.state)).length,
        goal: parts.length,
        icon: QuestIcon.bolt,
        note: parts.any((PathNode n) => n.state == PathNodeState.skipped)
            ? 'A part is skipped, still open today'
            : null,
      ),
    );
  }
  if (lesson != null && lesson.total > 0) {
    out.add(
      Quest(
        id: 'right',
        title: 'Get ${formatCount(lesson.total)} answers right',
        done: lesson.correct > lesson.total ? lesson.total : lesson.correct,
        goal: lesson.total,
        icon: QuestIcon.check,
      ),
    );
  }
  for (final PathNode n in today.nodes) {
    if (n.kind == PathNodeKind.lesson || n.state == PathNodeState.unavailable) {
      continue;
    }
    final String? detail = n.detail;
    // The follow level counts its top learners, one bar step each.
    final FollowProgress? counted =
        n.kind == PathNodeKind.followWinners &&
            n.follow != null &&
            n.follow!.total > 0
        ? n.follow
        : null;
    out.add(
      Quest(
        id: n.id,
        title: n.title,
        done: counted != null
            ? (counted.done < counted.total ? counted.done : counted.total)
            : (isHandedIn(n.state) ? 1 : 0),
        goal: counted?.total ?? 1,
        icon: QuestIcon.task,
        kind: n.kind,
        note: switch (n.state) {
          PathNodeState.pending => 'Waiting for review',
          PathNodeState.rejected => 'Sent back — try again',
          PathNodeState.revoked =>
            detail != null && detail.isNotEmpty
                ? detail
                : 'Removed after review',
          PathNodeState.skipped => 'Skipped, still open today',
          _ => null,
        },
      ),
    );
  }
  return out;
}

/// "Daily quests", resetting at the CONTEST's midnight — the day the path
/// draws is the contest's, and so is the quests'. The web's `DailyQuests`.
class DailyQuests extends StatelessWidget {
  const DailyQuests({
    required this.quests,
    this.emptyNote,
    this.loading = false,
    super.key,
  });

  final List<Quest> quests;

  /// Replaces "nothing to do" when the day is unknown rather than empty.
  final String? emptyNote;

  /// The day is on its way: the rows are drawn in outline.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final Widget body;
    if (loading) {
      body = const RailRowsSkeleton(label: 'Loading today’s quests');
    } else if (quests.isEmpty) {
      body = Text(
        emptyNote ?? 'Nothing to do today. Come back tomorrow.',
        style: railMuted,
      );
    } else {
      body = Column(
        children: <Widget>[
          for (int i = 0; i < quests.length; i++)
            _QuestRow(quests[i], first: i == 0),
        ],
      );
    }
    return RailCard(
      title: 'Daily quests',
      aside: const RailAside('Resets at midnight'),
      child: body,
    );
  }
}

class _QuestRow extends StatelessWidget {
  const _QuestRow(this.quest, {required this.first});

  final Quest quest;
  final bool first;

  static const LinearGradient _fill = LinearGradient(
    colors: <Color>[ContestColors.amber, Color(0xFFF5A623)],
  );

  @override
  Widget build(BuildContext context) {
    final double share = quest.goal > 0
        ? (quest.done / quest.goal).clamp(0, 1).toDouble()
        : 0;
    final (IconData glyph, Color colour, Color tile) = switch (quest.icon) {
      QuestIcon.bolt => (
        AppIcons.bolt,
        ContestColors.amber,
        const Color(0x26FFD166),
      ),
      QuestIcon.check => (
        AppIcons.check,
        ContestColors.green,
        const Color(0x2600DC82),
      ),
      QuestIcon.task => (
        contestKindIcon(quest.kind ?? PathNodeKind.connectLeaders),
        quest.kind == PathNodeKind.planWeek
            ? const Color(0xFF34D399)
            : const Color(0xFF3AA0FF),
        const Color(0x330A66C2),
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: first
          ? null
          : const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0x14FFFFFF))),
            ),
      child: Row(
        children: <Widget>[
          ExcludeSemantics(
            child: Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tile,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Icon(glyph, size: 18, color: colour),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  quest.title,
                  style: ZaveType.label.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ZaveColors.white,
                  ),
                ),
                const SizedBox(height: 7),
                Semantics(
                  label: quest.title,
                  value: '${quest.done} of ${quest.goal}',
                  excludeSemantics: true,
                  child: _Bar(share: share, quest: quest),
                ),
                if (quest.note case final String note) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(note, style: railMuted),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The 14px amber bar, with "2 / 3" inside it — in ink once the fill is
/// under it.
class _Bar extends StatelessWidget {
  const _Bar({required this.share, required this.quest});

  final double share;
  final Quest quest;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: ZaveRadius.pillBr,
      child: SizedBox(
        height: 14,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const ColoredBox(color: Color(0x1AFFFFFF)),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: share,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: _QuestRow._fill,
                  borderRadius: ZaveRadius.pillBr,
                ),
              ),
            ),
            Center(
              child: Text(
                '${formatCount(quest.done)} / ${formatCount(quest.goal)}',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  color: share >= 0.5
                      ? ContestColors.ink
                      : const Color(0xCCFFFFFF),
                  fontFeatures: const <FontFeature>[
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
