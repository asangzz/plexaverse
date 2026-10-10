import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
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

class _SchedulesPageState extends ConsumerState<SchedulesPage> {
  /// Ids of the rows with a write in flight, NOT one screen-wide flag.
  ///
  /// A single boolean cannot say WHICH row is mutating, so pausing one
  /// schedule used to disable and spin every other row for the whole
  /// round-trip. Per-id, the same way `PostLibraryState.busyIds` solves it in
  /// the posts slice. Held in the State rather than a provider: it is
  /// ephemeral per-view UI state and dies with the screen.
  final Set<String> _busyIds = <String>{};

  /// A create is in flight. Separate from [_busyIds] because the row being
  /// created has no id yet.
  bool _creating = false;

  /// The last write failed. Shown inline — Zave has no snackbar.
  String? _error;

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
    // The CTA stays disabled until the account list has actually arrived —
    // enabling it and then failing on submit is worse than a moment of
    // patience. `_creating` is deliberately NOT folded in here: ZaveButton
    // already refuses taps while busy, and passing null would dim the button
    // behind its own spinner.
    final bool accountsLoaded = accounts.hasValue;
    final List<CalendarAccount> connected =
        accounts.value ?? const <CalendarAccount>[];
    final bool canCreate = accountsLoaded && connected.isNotEmpty;

    return ZaveScrollView(
      children: <Widget>[
        Text('Configure when AI generates your posts.', style: ZaveType.lead),
        SizedBox(height: ZaveSpace.xl),

        if (accountsLoaded && connected.isEmpty) ...<Widget>[
          const _NoAccountNotice(),
          SizedBox(height: ZaveSpace.lg),
        ],

        if (_error != null) ...<Widget>[
          _ErrorNotice(
            message: _error!,
            onDismiss: () => setState(() => _error = null),
          ),
          SizedBox(height: ZaveSpace.lg),
        ],

        ZaveButton(
          label: 'Add schedule',
          kind: ZaveButtonKind.primarySmall,
          icon: const Icon(Icons.add),
          expand: true,
          busy: _creating,
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
              busy: _busyIds.contains(rows[i].id),
              onToggle: (bool isActive) => _run(
                () => ref
                    .read(schedulesControllerProvider.notifier)
                    .setActive(rows[i].id, isActive: isActive),
                rowId: rows[i].id,
              ),
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
    if (draft == null || !mounted) return;

    await _run(
      () => ref
          .read(schedulesControllerProvider.notifier)
          .create(
            linkedinAccountId: draft.linkedinAccountId,
            dayOfWeek: draft.dayOfWeek,
            timeOfDay: draft.timeOfDay,
            topicId: draft.topicId,
          ),
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

    await _run(
      () => ref.read(schedulesControllerProvider.notifier).remove(schedule.id),
      rowId: schedule.id,
    );
  }

  /// Runs a write behind one busy marker and one error surface, so every
  /// mutation on this page fails the same visible way.
  ///
  /// [rowId] scopes the busy marker to the schedule being written; omitting it
  /// means the create, which has no row yet. Nothing here may raise a
  /// screen-wide flag — that is what made one tap freeze the whole list.
  Future<void> _run(Future<void> Function() action, {String? rowId}) async {
    setState(() {
      _setBusy(rowId, busy: true);
      _error = null;
    });
    try {
      await action();
      if (!mounted) return;
      setState(() => _setBusy(rowId, busy: false));
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _setBusy(rowId, busy: false);
        _error = '$error';
      });
    }
  }

  /// Call inside a [setState]; mutates in place rather than returning state.
  void _setBusy(String? rowId, {required bool busy}) {
    if (rowId == null) {
      _creating = busy;
    } else if (busy) {
      _busyIds.add(rowId);
    } else {
      _busyIds.remove(rowId);
    }
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
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const ZaveDot(ZaveColors.ink35),
            SizedBox(width: ZaveSpace.sm),
            Text('NOTHING AUTOMATED YET', style: ZaveType.kicker),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        Text('No schedules yet', style: ZaveType.h3),
        SizedBox(height: ZaveSpace.md),
        Text(
          'Create a schedule to automate your LinkedIn posting.',
          style: ZaveType.bodyMuted,
        ),
      ],
    ),
  );
}

class _SchedulesSkeleton extends StatelessWidget {
  const _SchedulesSkeleton();

  @override
  Widget build(BuildContext context) => ZaveScrollView(
    children: <Widget>[
      _SkeletonBlock(height: ZaveSpace.section * 0.6),
      SizedBox(height: ZaveSpace.xl),
      for (int i = 0; i < 3; i++) ...<Widget>[
        if (i > 0) SizedBox(height: ZaveSpace.lg),
        _SkeletonBlock(height: ZaveSpace.section * 2.4),
      ],
    ],
  );
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) =>
      Container(height: height, decoration: ZaveSurface.card);
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
