import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../placement/presentation/widgets/placement_level_hint.dart';
import '../../application/contest_home_controllers.dart';
import '../../domain/contest_dates.dart';
import '../../domain/contest_repository.dart';
import '../../domain/contest_words.dart';
import 'contest_kit.dart';

/// One rule of the contest, as the join card states it.
class ContestRule {
  const ContestRule(this.title, this.detail);

  final String title;
  final String detail;
}

/// "How it scores", in the web's words (`rulesFor` in `ContestJoin.tsx`).
///
/// No numbers but the ones the overview carries: the scoring weights live on
/// the admin page, and "the streak weighs most" changes behaviour where "50
/// + 10 per day up to 20" mostly does not.
List<ContestRule> contestRules(ContestInfo c) {
  final String months = plural(c.rewardMonths, 'month', 'months');
  final String topN = formatCount(c.rewardTopN);
  final int weekComplete = c.weekComplete ?? 0;
  return <ContestRule>[
    const ContestRule(
      'Your streak weighs most',
      'Finish today’s lesson on its own day, every day of the week. Each day '
          'in a row raises your bonus, up to a ceiling, so a late start can '
          'still catch up.',
    ),
    if (weekComplete > 0)
      ContestRule(
        'Finish every day’s lesson in a week: +${formatCount(weekComplete)} XP',
        'Every day’s lesson from Sunday to Saturday — the days you were in '
            'the contest — and the week pays its bonus once. Miss one and '
            'that week’s bonus is gone.',
      ),
    const ContestRule(
      'A lesson a day, partly written for you',
      'Each lesson mixes set questions with questions written for your '
          'profession.',
    ),
    const ContestRule(
      'Harder levels earn more',
      'A right answer is worth more at a higher level.',
    ),
    const ContestRule(
      'Only your first try counts',
      'A wrong first answer costs a few points. A second try earns nothing '
          'either way.',
    ),
    const ContestRule(
      'LinkedIn tasks count',
      'Every day: complete a comment on a post in your field, then post it — '
          'right first time pays — and post five valuable comments on posts '
          'in your own feed. We check those links: a false claim loses the '
          'XP and more on top. Monday and Thursday: connect with leaders in '
          'your field. Saturday: send this week’s invites and upload a '
          'screenshot — its XP lands at once, and we check every screenshot: '
          'a fake one loses that XP and the same again as a penalty. Sunday, '
          'the first day of the week: plan this week in the Planner — nothing '
          'to share that day. The day a video or your article goes out: '
          'share its link. Levels open one after another. Post links pay '
          'once we have checked them.',
    ),
    const ContestRule(
      'The leaderboard opens for the last $kLeaderboardRevealDays days',
      'Until then it is you against yesterday: your XP and your streak, no '
          'ranking. The board, and your place on it, open on the contest’s '
          'last days.',
    ),
    const ContestRule(
      'Published posts count',
      'A post LinkedIn confirms you published through Plexaverse adds '
          'points. Nothing you report yourself does.',
    ),
    ContestRule(
      '${plural(c.freeDays, 'day', 'days')} free, then a plan',
      'Your free days start the day you join. After that, scoring needs a '
          'plan. Lessons stay open either way.',
    ),
    ContestRule(
      'Top $topN get $months free',
      'First place wins ${c.prizeTitle}. The top $topN get $months free for '
          'the next contest. Ties go to first-try accuracy on the questions '
          'written for you, then to whoever got there first. Never a draw.',
    ),
  ];
}

/// The join card: the prize, the window, the rules, and one choice. A port
/// of the web's `ContestJoin.tsx`.
///
/// ## Every rule, in plain words, before the button
///
/// A prize contest has to state every material condition where the offer is
/// made, and the one a quick reader would miss — scoring after the free days
/// needs a plan — sits in the list beside the prize and again under the
/// button, next to the word "free". Never only in a footnote.
///
/// ## The box is consent, so it starts empty
///
/// Ticking it records `contest_leaderboard`: this person's name and photo
/// are shown to every other entrant. That has to be an affirmative act,
/// which a pre-ticked box is not. Declining keeps nobody out — they compete
/// as "Participant" — and the copy says so beside the box, so leaving it
/// empty never reads as opting out of the contest.
///
/// ## The window by its dates
///
/// "1 Nov 2026 – 8 Feb 2027" and "Day 11" — never how many days it runs.
class ContestJoinCard extends ConsumerStatefulWidget {
  const ContestJoinCard({required this.overview, super.key});

  final ContestOverview overview;

  @override
  ConsumerState<ContestJoinCard> createState() => _ContestJoinCardState();
}

class _ContestJoinCardState extends ConsumerState<ContestJoinCard> {
  /// The leaderboard consent. Unticked until the learner ticks it.
  bool _showName = false;

  @override
  Widget build(BuildContext context) {
    final ContestOverview overview = widget.overview;
    final ContestInfo contest = overview.contest;
    final ContestJoinBusy busy = ref.watch(contestJoinActionsProvider);
    final String when = overview.isRunning
        ? 'Day ${formatCount(overview.dayNumber)}. You can join any day it runs.'
        : 'Starts ${dayKeyShort(contest.firstDayKey)}. You can join now or '
              'any day it runs.';
    final String months = plural(contest.rewardMonths, 'month', 'months');
    final String? image = contest.prizeImageUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ContestKicker(
          '${dayKeyShort(contest.firstDayKey)} – '
          '${dayKeyShort(contest.lastDayKey)}',
        ),
        SizedBox(height: ZaveSpace.md),
        Semantics(
          header: true,
          child: Text(contest.title, style: ContestType.pageTitle),
        ),
        SizedBox(height: ZaveSpace.md),
        Text(when, style: ContestType.lead),
        SizedBox(height: ZaveSpace.xxl),

        // ── The prize ──────────────────────────────────────────────────────
        ContestPanel(
          padding: EdgeInsets.all(ZaveSpace.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (image != null && image.isNotEmpty) ...<Widget>[
                Semantics(
                  image: true,
                  label: contest.prizeTitle,
                  excludeSemantics: true,
                  child: Container(
                    width: 120,
                    height: 120,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                      border: Border.all(color: ZaveGlass.restBorder),
                    ),
                    child: ZaveImage(source: image, tone: ZaveImageTone.quiet),
                  ),
                ),
                SizedBox(height: ZaveSpace.xl),
              ],
              Text('First place', style: ContestType.meta),
              SizedBox(height: ZaveSpace.sm),
              Text(contest.prizeTitle, style: ContestType.sectionTitle),
              SizedBox(height: ZaveSpace.sm),
              Text(
                'The top ${formatCount(contest.rewardTopN)} get $months free '
                'for the next contest. Winner announced '
                '${shortDate(contest.endsAt.toLocal())}.',
                style: ZaveType.body.copyWith(
                  fontSize: 15,
                  height: 1.6,
                  color: ZaveColors.ink62,
                ),
              ),
              if (overview.entrants > 0) ...<Widget>[
                SizedBox(height: ZaveSpace.sm),
                Text(
                  '${plural(overview.entrants, 'person has', 'people have')} '
                  'joined.',
                  style: ContestType.meta,
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: ZaveSpace.xxl),

        // ── The rules ──────────────────────────────────────────────────────
        Semantics(
          header: true,
          child: Text('How it scores', style: ContestType.sectionTitle),
        ),
        SizedBox(height: ZaveSpace.lg),
        ContestPanel(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (final (int i, ContestRule r) in contestRules(
                contest,
              ).indexed)
                _RuleRow(r, first: i == 0),
            ],
          ),
        ),
        SizedBox(height: ZaveSpace.xxl),

        // Before the join, not after it: "harder levels earn more" is the
        // rule just above, and the band it means is set there. Draws nothing
        // once the learner has placed.
        const PlacementLevelHint(),
        SizedBox(height: ZaveSpace.xxl),

        // ── Join ───────────────────────────────────────────────────────────
        ContestPanel(
          padding: EdgeInsets.all(ZaveSpace.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _ShowNameBox(
                value: _showName,
                onChanged: busy.joining
                    ? null
                    : (bool v) => setState(() => _showName = v),
              ),
              SizedBox(height: ZaveSpace.xl),
              ContestPrimaryPill(
                label: busy.joining ? 'Joining…' : 'Join the contest',
                onPressed: busy.joining
                    ? null
                    : () => ref
                          .read(contestJoinActionsProvider.notifier)
                          .join(showName: _showName),
              ),
              SizedBox(height: ZaveSpace.lg),
              Text(
                'Joining is free. After your first '
                '${freePeriod(contest.freeDays)}, scoring needs a plan.',
                style: ZaveType.body.copyWith(
                  fontSize: 14,
                  height: 1.6,
                  color: ZaveColors.ink50,
                ),
              ),
              if (busy.error case final String error) ...<Widget>[
                SizedBox(height: ZaveSpace.lg),
                // The server's words. NOT_RUNNING is not a failure — the
                // contest closed between loading this card and pressing the
                // button — so it is said in the neutral tone, not amber.
                Semantics(
                  liveRegion: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      busy.nothingToJoin
                          ? const ContestDot(
                              tone: ContestTone.idle,
                              label: 'Nothing to join',
                            )
                          : const ContestDot(
                              tone: ContestTone.waiting,
                              label: 'Not joined yet',
                            ),
                      SizedBox(height: ZaveSpace.xs),
                      Text(error, style: ContestType.meta),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow(this.rule, {required this.first});

  final ContestRule rule;
  final bool first;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ZaveSpace.xl,
        vertical: ZaveSpace.gutter,
      ),
      decoration: first
          ? null
          : const BoxDecoration(
              border: Border(top: BorderSide(color: ZaveColors.rule)),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            rule.title,
            style: GoogleFonts.manrope(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.34,
              color: ZaveColors.white,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
          SizedBox(height: ZaveSpace.xs),
          Text(
            rule.detail,
            style: ZaveType.body.copyWith(
              fontSize: 15,
              height: 1.6,
              color: ZaveColors.ink62,
            ),
          ),
        ],
      ),
    );
  }
}

/// "Show my name on the leaderboard" — a checkbox in its tile, the whole
/// tile its tap target. Drawn here: Zave has a switch but no checkbox, and
/// the web's control is a box that is ticked, not a setting that is on.
class _ShowNameBox extends StatelessWidget {
  const _ShowNameBox({required this.value, required this.onChanged});

  final bool value;

  /// Null while the join is in flight: the consent sent is the one shown.
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final ValueChanged<bool>? change = onChanged;
    final BorderRadius radius = ZaveRadius.cardSmBr;
    return Semantics(
      checked: value,
      enabled: change != null,
      label: 'Show my name on the leaderboard',
      excludeSemantics: true,
      onTap: change == null ? null : () => change(!value),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: change == null ? null : () => change(!value),
          borderRadius: radius,
          child: Ink(
            padding: EdgeInsets.all(ZaveSpace.lg),
            decoration: BoxDecoration(
              color: ZaveGlass.rest,
              border: Border.all(color: ZaveGlass.restBorder),
              borderRadius: radius,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(top: 2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: value ? ZaveColors.white : Colors.transparent,
                    border: Border.all(
                      color: value ? ZaveColors.white : ZaveColors.ink50,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  child: value
                      ? const Icon(
                          AppIcons.check,
                          size: 13,
                          color: ContestColors.ink,
                        )
                      : null,
                ),
                SizedBox(width: ZaveSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Show my name on the leaderboard',
                        style: ZaveType.body.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: ZaveSpace.xs),
                      Text(
                        'Other entrants will see your name and profile photo '
                        'beside your rank. Leave it off and you still '
                        'compete, shown as Participant. You can change this '
                        'in Settings.',
                        style: ZaveType.body.copyWith(
                          fontSize: 14,
                          height: 1.6,
                          color: ZaveColors.ink50,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
