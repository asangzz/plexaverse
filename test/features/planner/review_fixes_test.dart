import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/planner/application/planner_controller.dart';
import 'package:plexaverse/features/planner/data/planner_repositories.dart';
import 'package:plexaverse/features/planner/domain/plan_slot.dart';
import 'package:plexaverse/features/planner/domain/planner_repository.dart';
import 'package:plexaverse/features/planner/presentation/widgets/slot_card.dart';

/// A held approve answers with the RAW stored row (no read-time
/// reconciliation, no previews): it must never replace the planner's state.
class _Holding extends FakePlannerRepository {
  int reads = 0;

  @override
  Future<PlannerState> fetchWeek({int? week, int? season}) {
    reads++;
    return super.fetchWeek(week: week, season: season);
  }

  @override
  Future<ApproveResult> approveSlot({
    required String planId,
    required int slotIndex,
  }) async {
    final PlannerState s = await super.fetchWeek();
    final WeekPlan raw = s.plan!.copyWith(
      posts: <PlanSlot>[
        for (final PlanSlot p in s.plan!.posts)
          p.copyWith(
            status: SlotStatus.approved,
            previewImageUrl: null,
            fullImageUrl: null,
          ),
      ],
    );
    return ApproveResult(plan: raw, held: true);
  }
}

class _Counting extends FakePlannerRepository {
  int reads = 0;

  @override
  Future<PlannerState> fetchWeek({int? week, int? season}) {
    reads++;
    return super.fetchWeek(week: week, season: season);
  }
}

void main() {
  test('a held approve re-reads the week instead of showing the raw row', () async {
    final _Holding repo = _Holding();
    final ProviderContainer c = ProviderContainer(
      overrides: [plannerRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    c.listen(plannerControllerProvider, (_, _) {});
    await c.read(plannerControllerProvider.future);
    final int before = repo.reads;

    final ApproveResult? r = await c
        .read(plannerControllerProvider.notifier)
        .approve(2);
    expect(r?.held, isTrue);
    final PlannerState after = await c.read(plannerControllerProvider.future);
    expect(repo.reads, greaterThan(before), reason: 're-read, not replaced');
    // Wednesday is still waiting on the user, as the reconciled read says.
    expect(after.plan!.posts[2].status, SlotStatus.generated);
  });

  test('a normal approve re-reads too: its answer is the raw row', () async {
    final _Counting repo = _Counting();
    final ProviderContainer c = ProviderContainer(
      overrides: [plannerRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    c.listen(plannerControllerProvider, (_, _) {});
    await c.read(plannerControllerProvider.future);
    final int before = repo.reads;

    final ApproveResult? r = await c
        .read(plannerControllerProvider.notifier)
        .approve(2);
    expect(r?.held, isFalse);
    await c.read(plannerControllerProvider.future);
    expect(repo.reads, greaterThan(before));
  });

  group('the news line on a day card', () {
    Map<String, dynamic> news() => <String, dynamic>{
      'candidates': <Map<String, dynamic>>[
        <String, dynamic>{
          'title': 'A real headline',
          'source': 'Mint',
          'url': 'https://www.livemint.com/a',
          'publishedAt': '2026-11-01',
          'summary': '',
        },
      ],
      'pickedIndex': 0,
      'fetchedAt': '2026-11-02T04:00:00.000Z',
      'query': 'q',
      'formatId': 'industry_take',
    };

    Future<void> pump(WidgetTester tester, PlanSlot slot) =>
        tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 340,
                child: SlotCard(slot: slot, isToday: false),
              ),
            ),
          ),
        );

    testWidgets('a written news post names its headline', (tester) async {
      await pump(
        tester,
        PlanSlot.fromJson(<String, dynamic>{
          'day': 'Friday',
          'kind': 'post',
          'role': 'opinion',
          'formatId': 'industry_take',
          'status': 'generated',
          'postId': 'p',
          'news': news(),
        }),
      );
      expect(find.textContaining('Written from: A real headline'), findsOneWidget);
    });

    testWidgets('a day written in its usual format (stale pick) does not', (
      tester,
    ) async {
      await pump(
        tester,
        PlanSlot.fromJson(<String, dynamic>{
          'day': 'Friday',
          'kind': 'post',
          'role': 'opinion',
          // The server wrote it in the fallback format and left the news.
          'formatId': 'myth_flip',
          'status': 'generated',
          'postId': 'p',
          'news': news(),
        }),
      );
      expect(find.textContaining('A real headline'), findsNothing);
    });
  });
}
