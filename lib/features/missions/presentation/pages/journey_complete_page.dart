import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../home/domain/roadmap_planets.dart';
import '../../../preferences/application/preferences_controller.dart';
import '../../application/journey_controller.dart';
import '../../application/missions_controllers.dart';
import '../../domain/missions_repository.dart';
import '../widgets/mission_chrome.dart';

/// **Journey complete** — the web's `/journey-complete`.
///
/// Day 1000 is a finish line, not a loop. This screen says so, and offers the
/// two honest answers: start a new 1000-day journey (optionally toward a new
/// target role), or keep going for now. The auto-post chain keeps posting in
/// the final phase either way, so "not yet" costs the user nothing.
///
/// It replaced the Season Complete screen and its three Season 2 paths. That
/// endless four-week loop is gone from the product; `/season-complete` still
/// routes here because old notifications and shipped deep links name it.
///
/// Reached two ways: home pushes it once per app session when it sees a
/// finished journey ([journeyCompletePromptProvider]), and deep links.
class JourneyCompletePage extends ConsumerStatefulWidget {
  const JourneyCompletePage({super.key});

  @override
  ConsumerState<JourneyCompletePage> createState() =>
      _JourneyCompletePageState();
}

class _JourneyCompletePageState extends ConsumerState<JourneyCompletePage> {
  @override
  void initState() {
    super.initState();
    // Being shown IS the offer, however the user then leaves. Home marks this
    // before it pushes, but a deep link or the `/season-complete` redirect
    // opens the page without home, and the system back or the iOS edge swipe
    // never reach [_leave]. Unmarked, home would push the page straight back
    // the moment it mounts, and back would seem to fail once. After the
    // frame, because a provider cannot be written while the tree builds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(journeyCompletePromptProvider.notifier).markHandled();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<UserPreferences> prefs = ref.watch(
      preferencesControllerProvider,
    );

    return ZaveScaffold(
      title: 'Journey complete',
      leading: ZaveIconButton(
        icon: const Icon(AppIcons.back),
        tooltip: 'Back',
        onPressed: () => _leave(context, ref),
      ),
      body: switch (prefs) {
        AsyncValue<UserPreferences>(
          hasValue: true,
          :final UserPreferences value,
        )
            when !value.journeyFinished =>
          _NotFinished(preferences: value),
        AsyncValue<UserPreferences>(:final UserPreferences? value) => _Finished(
          preferences: value,
        ),
      },
    );
  }
}

/// Back to home, and do not offer this screen again this session.
///
/// Pops when there is something to pop to (the normal case: home pushed this),
/// and goes home otherwise (a cold deep link has no stack under it).
void _leave(BuildContext context, WidgetRef ref) {
  ref.read(journeyCompletePromptProvider.notifier).markHandled();
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(ZaveRoutes.dashboard);
  }
}

/// `1,000`, in the device's locale.
String _count(int value) => NumberFormat.decimalPattern().format(value);

/// `10 November 2026`, in the device's locale and time zone.
String _date(DateTime at) => DateFormat.yMMMMd().format(at.toLocal());

/// The finish line itself.
///
/// [preferences] is null only while they load; the celebration and the start
/// do not depend on them, so the screen does not wait.
class _Finished extends ConsumerWidget {
  const _Finished({required this.preferences});

  final UserPreferences? preferences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<SeasonRecap> recap = ref.watch(seasonRecapProvider);
    final DateTime? startedAt = preferences?.roadmapStartedAt;
    final DateTime? completedAt = preferences?.journeyCompletedAt;

    return ZaveScrollView(
      children: <Widget>[
        Text('JOURNEY COMPLETE', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        Text(
          'You reached day ${_count(roadmapTotalDays)}.',
          style: ZaveType.h2,
        ),
        SizedBox(height: ZaveSpace.md),
        Text(
          <String>[
            if (startedAt != null && completedAt != null)
              'You started on ${_date(startedAt)} and finished on '
                  '${_date(completedAt)}.'
            else if (completedAt != null)
              'You finished on ${_date(completedAt)}.',
            'Very few people keep showing up for this long.',
          ].join(' '),
          style: ZaveType.lead,
        ),

        SizedBox(height: ZaveSpace.xl),

        // The numbers are a nice-to-have. A failed read drops them rather
        // than putting an error card between the user and the decision this
        // screen is for.
        switch (recap) {
          AsyncValue<SeasonRecap>(:final SeasonRecap value) => _Stats(
            recap: value,
          ),
          AsyncValue<SeasonRecap>(hasError: true) => const SizedBox.shrink(),
          _ => const MissionSkeleton(height: 96),
        },

        SizedBox(height: ZaveSpace.xxl),

        _StartCard(
          currentTargetRole: preferences?.targetRole,
          journeyNumber: preferences?.journeyNumber,
        ),
      ],
    );
  }
}

/// Days and posts, side by side.
class _Stats extends StatelessWidget {
  const _Stats({required this.recap});

  final SeasonRecap recap;

  @override
  Widget build(BuildContext context) {
    // IntrinsicHeight because `stretch` needs a bounded cross axis and this
    // Row sits in a scroll view; without it the layout asserts and the page
    // renders blank.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ZaveStatCard(label: 'Days', value: _count(roadmapTotalDays)),
          ),
          SizedBox(width: ZaveSpace.sm),
          Expanded(
            child: ZaveStatCard(
              label: 'Posts published',
              // `100+` when the count hit its page limit — an honest ceiling
              // beats a number the app cannot stand behind.
              value: recap.postsAtLeast
                  ? '${_count(recap.postsPublished)}+'
                  : _count(recap.postsPublished),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Start a new journey", with the optional new target role, and "Keep going
/// for now".
///
/// Stateful for the text field and the journey number seen before a start. The in-flight flag is on
/// [journeyStartControllerProvider], so popping mid-request cannot leave a
/// second start available.
class _StartCard extends ConsumerStatefulWidget {
  const _StartCard({
    required this.currentTargetRole,
    required this.journeyNumber,
  });

  final String? currentTargetRole;

  /// The journey this screen is finishing, or null while preferences load.
  final int? journeyNumber;

  @override
  ConsumerState<_StartCard> createState() => _StartCardState();
}

class _StartCardState extends ConsumerState<_StartCard> {
  final TextEditingController _targetRole = TextEditingController();

  /// The server's own cap (`TARGET_ROLE_MAX_LENGTH`); longer is refused.
  static const int _maxRoleLength = 120;

  @override
  void dispose() {
    _targetRole.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    if (ref.read(journeyStartControllerProvider)) return;
    // Captured before the await: the success path leaves this screen, and the
    // confirmation has to land on whatever is showing afterwards.
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final String role = _targetRole.text.trim();
    // Read before the call: the start refetches preferences, and the number
    // has to be the one this screen was finishing.
    final int? before = widget.journeyNumber;
    final JourneyStartResult result;
    try {
      result = await ref
          .read(journeyStartControllerProvider.notifier)
          .start(targetRole: role.isEmpty ? null : role);
    } on Object {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              "That didn't go through. Nothing changed.",
              style: ZaveType.body,
            ),
          ),
        );
      return;
    }
    if (!result.startedAfter(before)) {
      // The server refused because this journey is not finished — the app's
      // day-1000 fallback reads the device clock, which can run ahead of the
      // server's. Nothing changed, so say that and stay put.
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Your journey is not finished yet.',
              style: ZaveType.body,
            ),
          ),
        );
      return;
    }
    // Started, or already started by an earlier tap or another device —
    // either way the user is on a new journey now, and home is where it
    // begins.
    ref.read(journeyCompletePromptProvider.notifier).markHandled();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Your new journey starts today.', style: ZaveType.body),
        ),
      );
    if (mounted) context.go(ZaveRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final bool starting = ref.watch(journeyStartControllerProvider);
    final String? current = widget.currentTargetRole?.trim();

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Start a new journey', style: ZaveType.h3),
          SizedBox(height: ZaveSpace.sm),
          Text(
            'A fresh ${_count(roadmapTotalDays)} days, starting at day 1. '
            'Your posts, articles and history stay where they are.',
            style: ZaveType.bodyMuted,
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveField(
            controller: _targetRole,
            label: 'New target role (optional)',
            hint: (current != null && current.isNotEmpty)
                ? 'Keep "$current"'
                : 'e.g. Head of Product',
            helper:
                'Leave it blank if you have arrived where you were heading.',
            maxLength: _maxRoleLength,
            enabled: !starting,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveButton.primary(
            label: 'Start a new journey',
            expand: true,
            busy: starting,
            onPressed: starting ? null : _start,
          ),
          SizedBox(height: ZaveSpace.sm),
          ZaveButton(
            label: 'Keep going for now',
            expand: true,
            onPressed: starting ? null : () => _leave(context, ref),
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            'Until you start a new one, your posts keep going as they are.',
            style: ZaveType.caption,
          ),
        ],
      ),
    );
  }
}

/// A deep link that arrived while the journey is still running — an old
/// notification, or a link opened after a new journey already started.
///
/// The web redirects these to the dashboard. Saying so is kinder than a
/// silent bounce, and offering the start here would only be refused.
class _NotFinished extends ConsumerWidget {
  const _NotFinished({required this.preferences});

  final UserPreferences preferences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ZaveScrollView(
      children: <Widget>[
        Text(
          preferences.journeyNumber > 1
              ? 'JOURNEY ${preferences.journeyNumber}'
              : 'YOUR JOURNEY',
          style: ZaveType.kicker,
        ),
        SizedBox(height: ZaveSpace.md),
        Text(
          'Day ${_count(preferences.journeyDay)} of '
          '${_count(roadmapTotalDays)}',
          style: ZaveType.h2,
        ),
        SizedBox(height: ZaveSpace.md),
        Text(
          'Your journey is still running. This page opens when you reach '
          'day ${_count(roadmapTotalDays)}.',
          style: ZaveType.lead,
        ),
        SizedBox(height: ZaveSpace.xl),
        ZaveButton.primary(
          label: 'Back to home',
          expand: true,
          onPressed: () => _leave(context, ref),
        ),
      ],
    );
  }
}
