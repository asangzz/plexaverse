import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/weekly_article.dart';

/// The italic serif accent the web planner uses for exactly three words:
/// "Planner" in the h1, "article" in this panel's heading, and the article
/// headline itself (Instrument Serif, italic, 400).
///
/// Zave's type pairing is Manrope + Urbanist, and this is the one deliberate
/// exception — scoped to the planner, the way Space Grotesk is scoped to the
/// roadmap. It is an editorial accent rather than a third UI face, and dropping
/// it would be a visible divergence from the web on the product's flagship
/// screen.
TextStyle plannerSerif({required double size, Color? color}) =>
    GoogleFonts.instrumentSerif(
      fontSize: size,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w400,
      color: color ?? ZaveColors.white,
      height: 1.15,
    );

/// The week's newsletter, as a card on the planner.
///
/// It ran on SUNDAY before the week was rebuilt and now runs on
/// THURSDAY — `WEEK_SHAPE` in the web's `lib/week-shape.ts`. Sunday is
/// a rest day. The day is no longer written into the labels here,
/// because the one place that decides it is that table.
///
/// The action is **Copy**, not Publish, and that is the whole design. LinkedIn's
/// API cannot publish an article or a newsletter edition, so the app prepares
/// the body and the user pastes it into LinkedIn's own composer. "I published
/// it" is then the only signal that exists for closing it out — which is why
/// [onMarkPublished] is a separate, explicitly user-driven action.
class ArticleCard extends StatelessWidget {
  const ArticleCard({
    required this.state,
    required this.onOpen,
    required this.onCopy,
    required this.onMarkPublished,
    required this.onNameNewsletter,
    required this.onSetReminder,
    super.key,
  });

  final ArticleState state;
  final VoidCallback onOpen;

  /// Copying needs the BODY, which the summary does not carry — the page
  /// fetches it. The card cannot do it itself without learning about the
  /// repository, and a card that fetches is a card that cannot be previewed.
  final VoidCallback onCopy;

  final VoidCallback onMarkPublished;

  /// Opens the name-your-newsletter sheet. Only reachable while
  /// [ArticleState.isFirstArticle] and no name has been recorded.
  final VoidCallback onNameNewsletter;

  /// Picks a time to be reminded, or clears the one that is set. Never
  /// offered on a published article — there is nothing left to remind about.
  final VoidCallback onSetReminder;

  @override
  Widget build(BuildContext context) {
    final WeeklyArticle? article = state.article;

    if (article == null) {
      // Not a failure state. A missing article means the week plan has not
      // been generated yet, or article generation degraded — which is
      // deliberately non-fatal: a model hiccup must never cost the user their
      // week, so the plan is written regardless.
      return ZaveCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('NEWSLETTER', style: ZaveType.kicker),
            SizedBox(height: ZaveSpace.md),
            Text(
              'No article for this week yet',
              style: ZaveType.h3.copyWith(color: ZaveColors.ink62),
            ),
            SizedBox(height: ZaveSpace.sm),
            Text(
              'It is written with the week plan, on Saturday.',
              style: ZaveType.caption,
            ),
          ],
        ),
      );
    }

    return ZaveCard(
      size: ZaveCardSize.large,
      onTap: onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('THURSDAY', style: ZaveType.kicker),
              SizedBox(width: ZaveSpace.sm),
              Text(
                'article',
                style: plannerSerif(size: 15, color: ZaveColors.peri),
              ),
              const Spacer(),
              if (article.isPublished) ...<Widget>[
                const ZaveDot(ZaveColors.green),
                SizedBox(width: ZaveSpace.sm),
                Text(
                  'Published',
                  style: ZaveType.caption.copyWith(color: ZaveColors.green),
                ),
              ],
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(article.title, style: plannerSerif(size: 23)),
          if (article.thesis != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(article.thesis!, style: ZaveType.bodyMuted, maxLines: 3),
          ],
          SizedBox(height: ZaveSpace.lg),
          Row(
            children: <Widget>[
              Text('${article.readMinutes} min read', style: ZaveType.caption),
              if (state.newsletterName != null) ...<Widget>[
                SizedBox(width: ZaveSpace.md),
                Text('·', style: ZaveType.caption),
                SizedBox(width: ZaveSpace.md),
                Expanded(
                  child: Text(
                    state.newsletterName!,
                    style: ZaveType.caption,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          // The create-a-newsletter note stays up even after the name is
          // recorded, and that is deliberate: `isFirstArticle` does not mean
          // "has a name", it means LinkedIn will ask the user to CREATE the
          // newsletter while they publish this edition. Saving the name here
          // records it; LinkedIn is where the thing comes into being. The web
          // keeps the step for the same reason.
          if (state.isFirstArticle) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            Container(
              padding: ZaveSpace.rowPad,
              decoration: ZaveSurface.row,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const ZaveDot(ZaveColors.amber),
                      SizedBox(width: ZaveSpace.md),
                      Expanded(
                        child: Text(
                          'You will need to create a newsletter on LinkedIn '
                          'first.',
                          style: ZaveType.caption.copyWith(
                            color: ZaveColors.ink62,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // The way out of the loop. Without it this note was a
                  // standing instruction with nothing behind it: the name
                  // could not be recorded from a phone at all, so the note
                  // came back every week however many newsletters the user
                  // had made.
                  if (state.newsletterName == null) ...<Widget>[
                    SizedBox(height: ZaveSpace.md),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ZaveButton(
                        label: 'Name your newsletter',
                        onPressed: onNameNewsletter,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          // The reminder. Only before publishing, and worded so it cannot be
          // read as scheduling a publish: LinkedIn has no articles endpoint on
          // our scopes, so the only thing a time buys is a nudge.
          if (!article.isPublished) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            _ReminderRow(at: article.reminderAt(), onTap: onSetReminder),
          ],
          SizedBox(height: ZaveSpace.lg),
          // Stacked, like the engagement cards and for the same arithmetic.
          //
          // The flex 3 / 2 this replaces was described as tuned so the
          // primary label would fit; on a 402-point screen it was rendering
          // "Copy & ..." and "I pu...". A button spends most of a narrow
          // column on padding and its icon, so two of them in a card leave
          // under a hundred points of text each. Full width is the only
          // split that holds on a 375-point phone too.
          ZaveButton(
            label: 'Copy & open editor',
            kind: ZaveButtonKind.primarySmall,
            icon: const Icon(Icons.copy_all_outlined),
            expand: true,
            onPressed: onCopy,
          ),
          if (!article.isPublished) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            ZaveButton(
              label: 'I published it',
              expand: true,
              onPressed: onMarkPublished,
            ),
          ],
        ],
      ),
    );
  }
}

/// "Remind me when it is time to paste this in."
///
/// Says `Remind me` when nothing is set and the time when one is — the same
/// row either way, because a control that disappears once used gives no way
/// back when the plan changes.
class _ReminderRow extends StatelessWidget {
  const _ReminderRow({required this.at, required this.onTap});

  /// Null when no reminder is set, or when the time has already passed — a
  /// nudge that has already fired is not a reminder.
  final DateTime? at;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ZavePress(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: ZaveSpace.rowPad,
        decoration: ZaveSurface.row,
        child: Row(
          children: <Widget>[
            Icon(
              AppIcons.schedule,
              size: 15,
              color: at == null ? ZaveColors.ink45 : ZaveColors.lavenderLo,
            ),
            SizedBox(width: ZaveSpace.md),
            Expanded(
              child: Text(
                at == null
                    // Names what it does, not what it schedules. "Schedule"
                    // would promise a publish the product cannot perform.
                    ? 'Remind me to post this'
                    : 'Reminder set for ${_when(at!)}',
                style: ZaveType.caption.copyWith(
                  color: at == null ? ZaveColors.ink62 : ZaveColors.ink85,
                ),
              ),
            ),
            Icon(AppIcons.chevronRight, size: 12, color: ZaveColors.ink45),
          ],
        ),
      ),
    ),
  );

  /// "Thu 09:00", or "12 Nov 09:00" once it is more than a week out — a
  /// weekday alone stops being unambiguous past seven days.
  static String _when(DateTime at) {
    const List<String> days = <String>[
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final String time =
        '${at.hour.toString().padLeft(2, '0')}:'
        '${at.minute.toString().padLeft(2, '0')}';
    return at.difference(DateTime.now()).inDays < 7
        ? '${days[at.weekday - 1]} $time'
        : '${at.day} ${months[at.month - 1]} $time';
  }
}
