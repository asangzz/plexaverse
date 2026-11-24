import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/core/links/plexaverse.dart';
import 'package:plexaverse/core/platform/link_opening.dart';
import 'package:plexaverse/features/contest/application/contest_controllers.dart';
import 'package:plexaverse/features/contest/application/follow_winners_controllers.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/domain/levels_words.dart';
import 'package:plexaverse/features/contest/presentation/pages/contest_follow_page.dart';
import 'package:plexaverse/features/contest/presentation/widgets/contest_kit.dart';
import 'package:plexaverse/features/profile/data/profile_repositories.dart';
import 'package:plexaverse/features/profile/domain/public_profile.dart';

/// "Follow last round's top learners" (owner, 24 Nov 2026) in the app: the
/// level's node on the path, its two steps per top learner, and what pays.
///
/// The server's rules are pinned in the web's
/// `__tests__/lib/follow-winners-service.test.ts`; here the mock's server
/// plays them, and the app is held to sending the right steps in the right
/// order — step 2 only after the follow itself.
void main() {
  setUp(FakeContestWorld.reset);

  FakeContestRepository fake([
    FakeContestScenario scenario = FakeContestScenario.running,
  ]) => FakeContestRepository(scenario: scenario, latency: Duration.zero);

  group('the level on the path', () {
    test('one node at the end of today, outside the order: open while the '
        'learner is behind a locked level, never skippable', () async {
      final ContestPath path = await fake().fetchPath();
      final List<PathNode> today = path.today!.nodes;
      final PathNode node = today.last;
      expect(node.kind, PathNodeKind.followWinners);
      expect(node.title, kFollowWinnersTitle);
      expect(node.state, PathNodeState.today);
      expect(node.canSkip, isFalse);
      expect(node.follow, const FollowProgress(done: 0, total: 2));
      expect(node.points, 40, reason: '20 for each of the two left');
      // Earlier levels are still locked behind the lesson: the follow level
      // waits on none of them.
      expect(
        today.where((PathNode n) => n.state == PathNodeState.locked),
        isNotEmpty,
      );
      expect(contestLevelRoute(node), '/contest/follow');
    });

    test('no round, no level', () async {
      expect(
        (await fake(FakeContestScenario.noContest).fetchPath()).today,
        isNull,
      );
      expect(
        (await fake(FakeContestScenario.ended).fetchFollowWinners()).status,
        FollowWinnersStatus.unavailable,
      );
    });
  });

  group('the two steps', () {
    test('both done pays once, whichever lands second; a repeat pays '
        'nothing', () async {
      final FakeContestRepository repo = fake();
      final int before = (await repo.fetchOverview())!.entry!.total;

      FollowWinnerStepResult r = await repo.recordFollowWinnerStep(
        handle: 'asha-rao',
        step: FollowWinnerStep.linkedin,
      );
      expect(r.pointsApplied, 0);
      expect(r.view.winner('asha-rao')!.linkedinDone, isTrue);
      expect(r.view.winner('asha-rao')!.done, isFalse);

      r = await repo.recordFollowWinnerStep(
        handle: 'asha-rao',
        step: FollowWinnerStep.plexaverse,
      );
      expect(r.pointsApplied, 20);
      expect(r.view.winner('asha-rao')!.done, isTrue);
      expect(r.view.winner('asha-rao')!.paid, 20);

      // A double tap, a retry: nothing more.
      for (final FollowWinnerStep step in FollowWinnerStep.values) {
        r = await repo.recordFollowWinnerStep(handle: 'asha-rao', step: step);
        expect(r.pointsApplied, 0, reason: step.name);
      }
      expect((await repo.fetchOverview())!.entry!.total, before + 20);

      // The other order pays just the same.
      r = await repo.recordFollowWinnerStep(
        handle: 'vikram-shah',
        step: FollowWinnerStep.plexaverse,
      );
      expect(r.pointsApplied, 0);
      r = await repo.recordFollowWinnerStep(
        handle: 'vikram-shah',
        step: FollowWinnerStep.linkedin,
      );
      expect(r.pointsApplied, 20);
      expect(r.view.status, FollowWinnersStatus.done);

      // Every one followed today: the node stays, done, until the day ends.
      final PathNode node = (await repo.fetchPath()).today!.nodes.last;
      expect(node.state, PathNodeState.done);
      expect(node.points, 40);
      expect(node.follow, const FollowProgress(done: 2, total: 2));
    });

    test('someone not in the level is refused', () async {
      await expectLater(
        fake().recordFollowWinnerStep(
          handle: 'someone-else',
          step: FollowWinnerStep.linkedin,
        ),
        throwsA(isA<ContestNotInLevel>()),
      );
    });

    test('paused scoring records the steps and pays nothing', () async {
      final FakeContestRepository repo = fake(FakeContestScenario.paused);
      await repo.recordFollowWinnerStep(
        handle: 'asha-rao',
        step: FollowWinnerStep.linkedin,
      );
      final FollowWinnerStepResult r = await repo.recordFollowWinnerStep(
        handle: 'asha-rao',
        step: FollowWinnerStep.plexaverse,
      );
      expect(r.view.winner('asha-rao')!.done, isTrue);
      expect(r.pointsApplied, 0);
    });

    test('the consistency meter counts the level on neither side', () async {
      final FakeContestRepository repo = fake();
      final ConsistencyView before = await repo.fetchConsistency();
      await repo.recordFollowWinnerStep(
        handle: 'asha-rao',
        step: FollowWinnerStep.linkedin,
      );
      await repo.recordFollowWinnerStep(
        handle: 'asha-rao',
        step: FollowWinnerStep.plexaverse,
      );
      final ConsistencyView after = await repo.fetchConsistency();
      expect(after.available, before.available);
      expect(after.earned, before.earned);
    });
  });

  group('the controller', () {
    test(
      'step 2 follows on Plexaverse FIRST, then has the level re-check',
      () async {
        final _Profiles profiles = _Profiles();
        final _Steps contest = _Steps();
        final ProviderContainer c = ProviderContainer(
          overrides: [
            envProvider.overrideWithValue(Env.mock),
            contestRepositoryProvider.overrideWithValue(contest),
            profileRepositoryProvider.overrideWithValue(profiles),
          ],
        );
        addTearDown(c.dispose);
        await c.read(followWinnersProvider.future);
        final bool ok = await c
            .read(followWinnersActionsProvider.notifier)
            .followOnPlexaverse('asha-rao');
        expect(ok, isTrue);
        expect(
          <String>[...profiles.calls, ...contest.calls],
          <String>['follow:asha-rao', 'step:asha-rao:plexaverse'],
        );
        expect(profiles.order.first < contest.order.first, isTrue);
      },
    );

    test('a refused follow sends no step, and says why on that card', () async {
      final _Profiles profiles = _Profiles(refuse: const ProfileNotFound());
      final _Steps contest = _Steps();
      final ProviderContainer c = ProviderContainer(
        overrides: [
          envProvider.overrideWithValue(Env.mock),
          contestRepositoryProvider.overrideWithValue(contest),
          profileRepositoryProvider.overrideWithValue(profiles),
        ],
      );
      addTearDown(c.dispose);
      final bool ok = await c
          .read(followWinnersActionsProvider.notifier)
          .followOnPlexaverse('asha-rao');
      expect(ok, isFalse);
      expect(contest.calls, isEmpty);
      final FollowWinnerBusy busy = c.read(followWinnersActionsProvider);
      expect(busy.errorFor, 'asha-rao');
      expect(busy.error, 'That profile is not public.');
    });
  });

  group('the page', () {
    Future<_Opener> pump(
      WidgetTester tester,
      ContestRepository repo, {
      ProfileRepository? profiles,
    }) async {
      tester.view.physicalSize = const Size(1125, 4000);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final _Opener opener = _Opener();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            envProvider.overrideWithValue(Env.mock),
            contestRepositoryProvider.overrideWithValue(repo),
            profileRepositoryProvider.overrideWithValue(
              profiles ?? FakeProfileRepository(latency: Duration.zero),
            ),
            linkOpeningProvider.overrideWithValue(opener),
          ],
          child: const MaterialApp(home: ContestFollowPage()),
        ),
      );
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      return opener;
    }

    testWidgets('each top learner, their two steps, what pays — and step 1 '
        'opens LinkedIn and is recorded', (WidgetTester tester) async {
      final FakeContestRepository repo = fake();
      final _Opener opener = await pump(tester, repo);

      expect(find.text(kFollowWinnersTitle), findsOneWidget);
      expect(find.text(followWinnersLead(20)), findsOneWidget);
      expect(
        find.text(
          'The top learners of the round that ended 31 October 2026 who '
          'agreed to be featured.',
        ),
        findsOneWidget,
      );
      expect(find.text('Asha Rao'), findsOneWidget);
      expect(find.text('Vikram Shah'), findsOneWidget);
      expect(find.text(kFollowOnLinkedIn), findsNWidgets(2));
      expect(find.text(kFollowOnPlexaverse), findsNWidgets(2));
      expect(find.text(kLinkedInSelfReportedLine), findsNWidgets(2));
      expect(find.text('+20 XP'), findsNWidgets(2));

      await tester.tap(find.text(kFollowOnLinkedIn).first);
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(
        opener.opened.single,
        'https://www.linkedin.com/in/plexaverse-demo-learner-10',
      );
      expect(find.text('Tapped'), findsOneWidget);

      await tester.tap(find.text(kFollowOnPlexaverse).first);
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.text('Following on Plexaverse'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('To do'), findsOneWidget);
    });

    // Review of 24 Nov 2026: the actions run one step at a time and drop a
    // second. Step 1 on another card used to stay tappable meanwhile — it
    // opened LinkedIn and silently recorded nothing.
    testWidgets('while any step is in flight, no card’s step 1 can be tapped '
        '— never a LinkedIn open whose tap is dropped', (
      WidgetTester tester,
    ) async {
      final _HeldProfiles held = _HeldProfiles();
      final _Opener opener = await pump(tester, fake(), profiles: held);
      ContestGhostPill pill(Finder label) => tester.widget<ContestGhostPill>(
        find.ancestor(of: label, matching: find.byType(ContestGhostPill)),
      );
      final Finder otherLinkedIn = find.text(kFollowOnLinkedIn).last;
      expect(pill(otherLinkedIn).onPressed, isNotNull);

      // Step 2 on the first card: the follow is held in flight.
      await tester.tap(find.text(kFollowOnPlexaverse).first);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Following…'), findsOneWidget);

      // Step 1 on the OTHER card cannot be pressed while it is in flight.
      expect(pill(otherLinkedIn).onPressed, isNull);
      expect(opener.opened, isEmpty);

      held.release();
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      // Free again: the same button opens LinkedIn and is recorded.
      expect(pill(find.text(kFollowOnLinkedIn).last).onPressed, isNotNull);
      await tester.ensureVisible(find.text(kFollowOnLinkedIn).last);
      await tester.pump();
      await tester.tap(find.text(kFollowOnLinkedIn).last);
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(opener.opened, hasLength(1));
      expect(find.text('Tapped'), findsOneWidget);
    });

    testWidgets('nothing to follow is said in words', (
      WidgetTester tester,
    ) async {
      await pump(tester, fake(FakeContestScenario.noContest));
      expect(find.text('Nothing to follow'), findsOneWidget);
      expect(
        find.text(
          'No round of levels is running right now. The next one starts soon.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('the rules link opens how the level pays', (
      WidgetTester tester,
    ) async {
      final _Opener opener = await pump(tester, fake());
      final Finder link = find.bySemanticsLabel('How this level pays');
      await Scrollable.ensureVisible(tester.element(link), alignment: 0.5);
      await tester.pump();
      await tester.tap(link);
      await tester.pump();
      expect(opener.opened, <String>['$plexaverseLevelsRulesUrl#xp']);
    });
  });
}

int _clock = 0;

/// The follow, recorded — or refused.
class _Profiles extends FakeProfileRepository {
  _Profiles({this.refuse}) : super(latency: Duration.zero);

  final ProfileFailure? refuse;
  final List<String> calls = <String>[];
  final List<int> order = <int>[];

  @override
  Future<FollowState> follow(String handle) async {
    calls.add('follow:$handle');
    order.add(_clock++);
    final ProfileFailure? no = refuse;
    if (no != null) throw no;
    return const FollowState(following: true, followers: 3);
  }
}

/// A follow held in flight until [release] — the in-between a slow network makes.
class _HeldProfiles extends FakeProfileRepository {
  _HeldProfiles() : super(latency: Duration.zero);

  final Completer<void> _gate = Completer<void>();

  void release() => _gate.complete();

  @override
  Future<FollowState> follow(String handle) async {
    await _gate.future;
    return super.follow(handle);
  }
}

/// The level's steps, recorded.
class _Steps extends FakeContestRepository {
  _Steps() : super(latency: Duration.zero);

  final List<String> calls = <String>[];
  final List<int> order = <int>[];

  @override
  Future<FollowWinnerStepResult> recordFollowWinnerStep({
    required String handle,
    required FollowWinnerStep step,
  }) {
    calls.add('step:$handle:${step.wire}');
    order.add(_clock++);
    return super.recordFollowWinnerStep(handle: handle, step: step);
  }
}

class _Opener implements LinkOpeningService {
  final List<String> opened = <String>[];

  @override
  Future<LinkOpenResult> open(String url) async {
    opened.add(url);
    return const LinkOpened();
  }
}
