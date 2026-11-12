import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/placement/data/placement_repositories.dart';
import 'package:plexaverse/features/placement/domain/placement_repository.dart';

/// The mock flavour's placement test emits only states the server can.
///
/// Each rule below is the web's `lib/services/placement.service.ts` or
/// `lib/placement/engine.ts`, stated once. A fake that drifts from them makes
/// the mock app demo a screen production never draws — and hides the one
/// production does. Folded into `test/mock/fixtures_agree_with_server_test.dart`
/// when the app's integration lands.
void main() {
  FakePlacementRepository fake([
    FakePlacementSeed seed = FakePlacementSeed.fresh,
  ]) => FakePlacementRepository(seed: seed, latency: Duration.zero);

  /// The server's status rules, for any status.
  void agrees(PlacementStatus s) {
    expect(s.hasPlacement, s.latest != null, reason: 'hasPlacement = !!latest');
    // An open attempt can always be continued; only a fresh one waits.
    expect(s.canStart, s.inProgress != null || s.nextRetakeAt == null);
    final PlacementSummary? latest = s.latest;
    if (s.nextRetakeAt != null) {
      expect(latest, isNotNull);
      expect(
        s.nextRetakeAt,
        latest!.completedAt!.add(const Duration(days: 30)),
        reason: 'RETAKE_COOLDOWN_DAYS from completedAt',
      );
    }
    if (latest == null) {
      expect(s.band, defaultBand, reason: 'B2 until a test completes');
    } else {
      expect(latest.band, isNotNull);
      expect(s.band, latest.band);
      expect(latest.completedAt, isNotNull);
    }
    // Round-trips the wire: the fake builds nothing fromJson cannot read.
    expect(PlacementStatus.fromJson(s.toJson()), s);
  }

  /// The server's step rules, for any step.
  void stepAgrees(PlacementStep step) {
    if (step.stage == PlacementStage.writing) {
      expect(step.item, isNull);
      expect(step.skill, isNull);
      expect(step.closesAt, isNull, reason: 'a completed attempt never closes');
      expect(step.writingTask, isNotNull);
    } else {
      final PublicPlacementItem item = step.item!;
      expect(step.skill, isNotNull);
      expect(item.skill, step.skill);
      expect(
        item.id,
        'step-${step.answered}',
        reason: 'a handle, not a bank id',
      );
      expect(item.options, hasLength(4));
      expect(item.options.toSet(), hasLength(4));
      expect(step.closesAt, isNotNull);
      expect(step.estimatedTotal, greaterThan(step.answered));
      expect(step.writingTask, isNull);
    }
    expect(PlacementStep.fromJson(step.toJson()), step);
  }

  test('every seed\'s status is one the server can send', () async {
    for (final FakePlacementSeed seed in FakePlacementSeed.values) {
      agrees(await fake(seed).fetchStatus());
    }
  });

  test('a whole test: parts in order, each step well-formed, the band set '
      'by the last answer', () async {
    final FakePlacementRepository repo = fake();
    PlacementStep step = await repo.start();
    final List<ObjectiveSkill> seen = <ObjectiveSkill>[];
    while (step.stage == PlacementStage.objective) {
      stepAgrees(step);
      if (seen.isEmpty || seen.last != step.skill) seen.add(step.skill!);
      agrees(await repo.fetchStatus());
      step = await repo.answer(
        attemptId: step.attemptId,
        itemId: step.item!.id,
        value: step.item!.options.last,
      );
    }
    stepAgrees(step);
    expect(
      seen,
      ObjectiveSkill.values,
      reason: 'vocabulary → grammar → reading',
    );

    final PlacementStatus after = await repo.fetchStatus();
    agrees(after);
    expect(after.hasPlacement, isTrue);
    expect(after.inProgress, isNull);
    expect(after.latest?.attemptId, step.attemptId);
    expect(after.latest?.writingPending, isTrue);
  });

  test('a handle already answered replays the current step', () async {
    final FakePlacementRepository repo = fake();
    final PlacementStep first = await repo.start();
    final PlacementStep second = await repo.answer(
      attemptId: first.attemptId,
      itemId: first.item!.id,
      value: first.item!.options.first,
    );
    final PlacementStep again = await repo.answer(
      attemptId: first.attemptId,
      itemId: first.item!.id,
      value: first.item!.options.first,
    );
    expect(again, second);
  });

  test('a handle ahead, or a value not offered, is a 400', () async {
    final FakePlacementRepository repo = fake();
    final PlacementStep first = await repo.start();
    await expectLater(
      repo.answer(
        attemptId: first.attemptId,
        itemId: 'step-5',
        value: first.item!.options.first,
      ),
      throwsA(isA<PlacementRejected>()),
    );
    await expectLater(
      repo.answer(
        attemptId: first.attemptId,
        itemId: first.item!.id,
        value: 'not an option',
      ),
      throwsA(isA<PlacementRejected>()),
    );
  });

  test('Start resumes an open attempt rather than drawing a new one', () async {
    final FakePlacementRepository repo = fake(FakePlacementSeed.inProgress);
    final String open = (await repo.fetchStatus()).inProgress!.attemptId;
    final PlacementStep step = await repo.start();
    expect(step.attemptId, open);
    expect(step.answered, 3);
  });

  test('Start inside the cooldown is a COOLDOWN carrying the date', () async {
    final FakePlacementRepository repo = fake(FakePlacementSeed.placed);
    final PlacementStatus status = await repo.fetchStatus();
    await expectLater(
      repo.start(),
      throwsA(
        isA<PlacementCooldown>().having(
          (PlacementCooldown c) => c.nextRetakeAt,
          'nextRetakeAt',
          status.nextRetakeAt,
        ),
      ),
    );
  });

  test('finish before the three parts are done is NOT_READY', () async {
    final FakePlacementRepository repo = fake(FakePlacementSeed.inProgress);
    final String open = (await repo.fetchStatus()).inProgress!.attemptId;
    await expectLater(repo.finish(open), throwsA(isA<PlacementNotReady>()));
  });

  test(
    'writing: consent is checked before the text, once per result',
    () async {
      final FakePlacementRepository repo = fake(FakePlacementSeed.placed);
      final String id = (await repo.fetchStatus()).latest!.attemptId;

      // Too short AND no consent: the consent refusal comes first.
      await expectLater(
        repo.submitWriting(attemptId: id, text: 'short'),
        throwsA(isA<PlacementConsentRequired>()),
      );
      await repo.grantWritingConsent();
      expect((await repo.fetchStatus()).writingConsent, isTrue);
      await expectLater(
        repo.submitWriting(attemptId: id, text: 'short'),
        throwsA(isA<PlacementRejected>()),
      );

      final PlacementResult graded = await repo.submitWriting(
        attemptId: id,
        text: 'I run a support team and we halved our response time this year.',
      );
      expect(graded.writingSubmitted, isTrue);
      expect(graded.writingBand, isNotNull);
      expect(graded.writingFeedback?.isEmpty, isFalse);
      agrees(await repo.fetchStatus());

      await expectLater(
        repo.submitWriting(attemptId: id, text: 'x' * 40),
        throwsA(isA<PlacementAlreadyComplete>()),
      );
    },
  );

  test('skipping the writing changes nothing', () async {
    final FakePlacementRepository repo = fake(FakePlacementSeed.placed);
    final PlacementStatus before = await repo.fetchStatus();
    final PlacementResult result = await repo.finish(before.latest!.attemptId);
    expect(result.writingSubmitted, isFalse);
    expect(result.band, before.band);
    expect(await repo.fetchStatus(), before);
  });

  test('a closed-early result marks the part it never scored', () async {
    final PlacementStatus status = await fake(
      FakePlacementSeed.retake,
    ).fetchStatus();
    final PlacementSummary latest = status.latest!;
    expect(latest.closedEarly, isTrue);
    expect(latest.measured.of(ObjectiveSkill.reading), isFalse);
    expect(
      status.canStart,
      isTrue,
      reason: 'forty days on, the cooldown is over',
    );
  });
}
