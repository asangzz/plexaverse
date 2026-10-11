import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/schedule_write_controller.dart';
import '../../application/schedules_controller.dart';
import '../../domain/post_schedule.dart';
import '../widgets/calendar_sheet.dart';
import '../widgets/schedule_card.dart';
import '../widgets/schedule_form_sheet.dart';

/// **Schedules** — the web's `/schedules`.
///
/// Recurring auto-post rules: "write and publish something about topic X every
/// weekday at 09:00". Not a queue of posts — the web's own subtitle,
/// "Configure when AI generates your posts", is kept verbatim because users who
/// read this screen as their queue go looking for drafts here and find none.
///
/// ## One web bug deliberately not ported
///
/// `app/(dashboard)/schedules/page.tsx` hard-codes `const accounts = []`. The
/// consequence on the web today is that "Add Schedule" is permanently disabled,
/// the yellow "LinkedIn account required" notice always renders, and the create
/// modal's account dropdown is always empty — for every user, connected or not.
/// That is a bug rather than a design, so this screen reads the real account
/// list and the notice appears only when it is true.
class SchedulesPage extends ConsumerStatefulWidget {
  const SchedulesPage({super.key});

  @override
  ConsumerState<SchedulesPage> createState() => _SchedulesPageState();
}

/// Holds no write state of its own. Which row is mutating, whether a create is
/// in flight and how the last write went all live on [ScheduleWriteController]
/// — they are in-flight flags for an async use case and the result of a
/// repository call, and a page the user is free to leave mid-round-trip cannot
/// be their owner. See that controller for the failure this page used to
/// discard.
class _SchedulesPageState extends ConsumerState<SchedulesPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<PostSchedule>> schedules = ref.watch(
      schedulesControllerProvider,
    );
    final AsyncValue<List<CalendarAccount>> accounts = ref.watch(
      scheduleAccountsProvider,
    );
    // Watched, not merely read when the sheet opens. These are autoDispose
    // providers: one that nothing is watching is created and torn down inside
    // the same frame, so a `ref.read` at sheet-open time would hand the form an
    // empty topic list every single time.
    final AsyncValue<List<ScheduleTopic>> topics = ref.watch(
      scheduleTopicsProvider,
    );

    return ZaveScaffold(
      largeTitle: 'Schedules',
      subtitle: 'When AI generates your posts',
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref
            ..invalidate(schedulesControllerProvider)
            ..invalidate(scheduleAccountsProvider)
            ..invalidate(scheduleTopicsProvider);
          await ref.read(schedulesControllerProvider.future);
        },
        child: schedules.when(
          loading: () => const _SchedulesSkeleton(),
          error: (Object error, StackTrace _) => _SchedulesError(
            onRetry: () => ref.invalidate(schedulesControllerProvider),
          ),
          data: (List<PostSchedule> rows) => _body(rows, accounts, topics),
        ),
      ),
    );
  }

  Widget _body(
    List<PostSchedule> rows,
    AsyncValue<List<CalendarAccount>> accounts,
    AsyncValue<List<ScheduleTopic>> topics,
  ) {
    // Which row is writing, whether a create is in flight, and the last
    // failure. On the controller so none of the three dies with this screen.
    final ScheduleWriteState write = ref.watch(scheduleWriteControllerProvider);

    // The CTA stays disabled until the account list has actually arrived —
    // enabling it and then failing on submit is worse than a moment of
    // patience. `write.creating` is deliberately NOT folded in here:
    // ZaveButton already refuses taps while busy, and passing null would dim
    // the button behind its own spinner.
    final bool accountsLoaded = accounts.hasValue;
    final List<CalendarAccount> connected =
        accounts.value ?? const <CalendarAccount>[];
    final bool canCreate = accountsLoaded && connected.isNotEmpty;

    return ZaveScrollView(
      children: <Widget>[
        if (accountsLoaded && connected.isEmpty) ...<Widget>[
          const _NoAccountNotice(),
          SizedBox(height: ZaveSpace.lg),
        ],

        if (write.error case final String message) ...<Widget>[
          _ErrorNotice(
            message: message,
            onDismiss: () => ref
                .read(scheduleWriteControllerProvider.notifier)
                .acknowledge(),
          ),
          SizedBox(height: ZaveSpace.lg),
        ],

        ZaveButton(
          label: 'Add schedule',
          kind: ZaveButtonKind.primarySmall,
          icon: const Icon(AppIcons.add),
          expand: true,
          busy: write.creating,
          onPressed: canCreate
              ? () => _openForm(
                  connected,
                  topics.value ?? const <ScheduleTopic>[],
                )
              : null,
        ),
        SizedBox(height: ZaveSpace.xl),

        if (rows.isEmpty)
          const _SchedulesEmpty()
        else
          for (int i = 0; i < rows.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: ZaveSpace.lg),
            ScheduleCard(
              schedule: rows[i],
              busy: write.isBusy(rows[i].id),
              onToggle: (bool isActive) => ref
                  .read(scheduleWriteControllerProvider.notifier)
                  .setActive(rows[i].id, isActive: isActive),
              onDelete: () => _confirmDelete(rows[i]),
            ),
          ],
      ],
    );
  }

  Future<void> _openForm(
    List<CalendarAccount> accounts,
    List<ScheduleTopic> topics,
  ) async {
    final ScheduleDraft? draft = await ScheduleFormSheet.show(
      context,
      accounts: accounts,
      topics: topics,
    );
    // `mounted` still guards the START of the write — `ref.read` on a disposed
    // ConsumerState throws — but no longer its OUTCOME: that is the
    // controller's now, and survives the user leaving mid-round-trip.
    if (draft == null || !mounted) return;

    await ref
        .read(scheduleWriteControllerProvider.notifier)
        .create(
          linkedinAccountId: draft.linkedinAccountId,
          dayOfWeek: draft.dayOfWeek,
          timeOfDay: draft.timeOfDay,
          topicId: draft.topicId,
        );
  }

  Future<void> _confirmDelete(PostSchedule schedule) async {
    final bool? confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => CalendarSheet(
        footer: Row(
          children: <Widget>[
            Expanded(
              child: ZaveButton(
                label: 'Keep',
                expand: true,
                onPressed: () => Navigator.of(sheetContext).pop(false),
              ),
            ),
            SizedBox(width: ZaveSpace.md),
            Expanded(
              child: ZaveButton(
                label: 'Delete',
                kind: ZaveButtonKind.primarySmall,
                expand: true,
                onPressed: () => Navigator.of(sheetContext).pop(true),
              ),
            ),
          ],
        ),
        children: <Widget>[
          const CalendarSheetTitle(
            kicker: 'Delete schedule',
            title: 'Stop posting on this schedule?',
          ),
          SizedBox(height: ZaveSpace.lg),
          Text(
            '${schedule.accountLabel} · ${schedule.daysLabel}. '
            'Posts already generated are not affected — only the rule that '
            'keeps generating them.',
            style: ZaveType.bodyMuted,
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    // The round-trip's state is the controller's. Deleting a schedule and
    // leaving the screen used to discard the outcome entirely — no notice, no
    // log, and a rule that may or may not still be posting for the user.
    await ref
        .read(scheduleWriteControllerProvider.notifier)
        .remove(schedule.id);
  }
}

/// The web's yellow "LinkedIn account required" card, in Zave's amber.
class _NoAccountNotice extends StatelessWidget {
  const _NoAccountNotice();

  @override
  Widget build(BuildContext context) => ZaveCard(
    size: ZaveCardSize.small,
    padding: ZaveSpace.rowPad,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            // Amber is Zave's "waiting on something" — the same meaning the
            // web's yellow carries here.
            const ZaveDot(ZaveColors.amber),
            SizedBox(width: ZaveSpace.sm),
            Expanded(
              child: Text('LINKEDIN ACCOUNT REQUIRED', style: ZaveType.kicker),
            ),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        Text(
          'Connect your LinkedIn account to create posting schedules.',
          style: ZaveType.bodyMuted,
        ),
      ],
    ),
  );
}

class _ErrorNotice extends StatelessWidget {
  const _ErrorNotice({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => ZaveCard(
    size: ZaveCardSize.small,
    padding: ZaveSpace.rowPad,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            // Amber, not red: Zave has no red.
            const ZaveDot(ZaveColors.amber),
            SizedBox(width: ZaveSpace.sm),
            Expanded(child: Text('THAT DID NOT SAVE', style: ZaveType.kicker)),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        Text(message, style: ZaveType.bodyMuted),
        SizedBox(height: ZaveSpace.md),
        Align(
          alignment: Alignment.centerLeft,
          child: ZaveButton(label: 'Dismiss', onPressed: onDismiss),
        ),
      ],
    ),
  );
}

class _SchedulesEmpty extends StatelessWidget {
  const _SchedulesEmpty();

  @override
  Widget build(BuildContext context) => const ZaveEmptyState(
    kicker: 'NOTHING AUTOMATED YET',
    title: 'No schedules yet',
    body: 'Create a schedule to automate your LinkedIn posting.',
  );
}

class _SchedulesSkeleton extends StatelessWidget {
  const _SchedulesSkeleton();

  @override
  Widget build(BuildContext context) => ZaveShimmer(
    child: ZaveScrollView(
      children: <Widget>[
        ZaveSkeleton.block(height: ZaveSpace.section * 0.6),
        SizedBox(height: ZaveSpace.xl),
        for (int i = 0; i < 3; i++) ...<Widget>[
          if (i > 0) SizedBox(height: ZaveSpace.lg),
          ZaveSkeleton.block(height: ZaveSpace.section * 2.4),
        ],
      ],
    ),
  );
}

class _SchedulesError extends StatelessWidget {
  const _SchedulesError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => ZaveScrollView(
    children: <Widget>[
      ZaveCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                // Amber, not red: Zave has no red, and a failed fetch is
                // "needs attention", not a destructive state.
                const ZaveDot(ZaveColors.amber),
                SizedBox(width: ZaveSpace.sm),
                Text('COULD NOT LOAD', style: ZaveType.kicker),
              ],
            ),
            SizedBox(height: ZaveSpace.md),
            Text('Your schedules did not load.', style: ZaveType.h3),
            SizedBox(height: ZaveSpace.lg),
            ZaveButton(label: 'Try again', onPressed: onRetry),
          ],
        ),
      ),
    ],
  );
}
