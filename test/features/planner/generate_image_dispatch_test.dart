import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/planner/application/planner_controller.dart';
import 'package:plexaverse/features/planner/data/planner_repositories.dart';
import 'package:plexaverse/features/planner/domain/plan_slot.dart';
import 'package:plexaverse/features/planner/domain/planner_repository.dart';
import 'package:plexaverse/features/planner/domain/post_formats.dart';

/// Which image is made right after a day's text is written.
///
/// The old controller drew an AI poster for every `text_image` day. On the
/// playbook week that is wrong four ways out of five: a photo day wants the
/// user's photo, a card day a card, and an AI poster on either charges for an
/// image the format never uses (PLANNER_REDESIGN.md §3.8). These pin the
/// dispatch: playbook days go through /planner/image by their kind, a photo
/// day with no photo waits for one, and only a legacy day gets the old poster.
class _Recording extends FakePlannerRepository {
  final List<String> calls = <String>[];

  /// Days written in this test, so a re-read shows their post — the server
  /// stamps the slot's postId (and any fallback format) before it answers.
  final Map<int, String> written = <int, String>{};

  /// A format the server fell back to at generation, per day.
  final Map<int, String> fellBackTo = <int, String>{};

  /// Slot 1 (Tuesday, a rest day in the playbook week) stands in for a
  /// legacy `text_image` post day from a week planned before 25 Nov 2026.
  @override
  Future<PlannerState> fetchWeek({int? week, int? season}) async {
    final PlannerState s = await super.fetchWeek(week: week, season: season);
    final WeekPlan plan = s.plan!;
    return s.copyWith(
      plan: plan.copyWith(
        posts: <PlanSlot>[
          for (int i = 0; i < plan.posts.length; i++)
            _asWritten(
              i,
              i == 1
                  ? const PlanSlot(
                      day: 'Tuesday',
                      rawKind: 'post',
                      format: 'text_image',
                      title: 'A legacy post',
                    )
                  : plan.posts[i],
            ),
        ],
      ),
    );
  }

  PlanSlot _asWritten(int i, PlanSlot slot) {
    final String? id = written[i];
    if (id == null) return slot;
    final String? format = fellBackTo[i];
    return slot.copyWith(
      postId: id,
      status: SlotStatus.generated,
      formatId: format ?? slot.formatId,
      rawImageKind: format == null ? slot.rawImageKind : null,
    );
  }

  @override
  Future<GeneratedSlot> generateSlotPost({
    required String planId,
    required int slotIndex,
    bool force = false,
  }) async {
    written[slotIndex] = 'new-$slotIndex';
    return GeneratedSlot(postId: 'new-$slotIndex', content: 'Body');
  }

  @override
  Future<String?> generateSlotPoster({
    required String topic,
    required String content,
    required String posterTitle,
    required String slotType,
    required String userName,
    String? profileImageUrl,
    String? posterTag,
  }) async {
    calls.add('poster');
    return 'https://example.test/poster.png';
  }

  @override
  Future<void> attachPostImage({
    required String postId,
    required String imageUrl,
  }) async => calls.add('attach');

  @override
  Future<SlotImageMade> makeSlotImage({
    required int weekNumber,
    required int season,
    required int dayIndex,
    required SlotImageMode mode,
    bool consent = false,
  }) async {
    calls.add('image:${mode.wire}:$dayIndex:consent=$consent');
    return const SlotImageMade(imageUrl: 'https://example.test/i.jpg');
  }
}

void main() {
  late _Recording repo;
  late ProviderContainer container;

  setUp(() async {
    repo = _Recording();
    container = ProviderContainer(
      overrides: [plannerRepositoryProvider.overrideWithValue(repo)],
    );
    // Held open: the controller is auto-dispose, and a bare read lets it go
    // before the generate call reads its plan.
    container.listen(plannerControllerProvider, (_, _) {});
    await container.read(plannerControllerProvider.future);
  });

  tearDown(() => container.dispose());

  Future<void> generate(int day) async {
    await container
        .read(plannerControllerProvider.notifier)
        .generate(day, force: true);
  }

  test('an AI-poster playbook day is made through /planner/image, auto', () async {
    await generate(4); // Friday: industry_take, ai_poster
    expect(repo.calls, <String>['image:auto:4:consent=false']);
  });

  test('a photo day with no photo makes no image — the step asks for one', () async {
    await generate(2); // Wednesday: mistake_lesson, photo, no photo yet
    expect(repo.calls, isEmpty);
  });

  test('never the old poster on a playbook day', () async {
    await generate(0); // Monday: numbered_steps, ai_poster
    expect(repo.calls, isNot(contains('poster')));
  });

  test('a legacy text_image day still gets the old poster', () async {
    await generate(1);
    expect(repo.calls, <String>['poster', 'attach']);
  });

  test('the image follows the format the post was WRITTEN in', () async {
    // Wednesday was planned as a photo story with no photo, but its story was
    // spent in between: the server wrote it as numbered steps (an AI poster)
    // and rewrote the slot. The image is made for what was written.
    repo.fellBackTo[2] = 'numbered_steps';
    await generate(2);
    expect(repo.calls, <String>['image:auto:2:consent=false']);
  });

  test('a poster day that fell back to a photo format waits for a photo', () async {
    // Friday was planned as the news post (AI poster); the pick went stale
    // and the server wrote it as a photo format. No fallback card is drawn.
    repo.fellBackTo[4] = 'repetition';
    await generate(4);
    expect(repo.calls, isEmpty);
  });

  test('consent is never sent unless the user ticked the box', () async {
    // The auto image after generation carries no consent of its own.
    await generate(4);
    expect(repo.calls.single, endsWith('consent=false'));
  });
}
