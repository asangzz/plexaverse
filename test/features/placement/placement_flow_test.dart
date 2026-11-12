import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/placement/application/placement_controllers.dart';
import 'package:plexaverse/features/placement/data/placement_repositories.dart';
import 'package:plexaverse/features/placement/domain/placement_repository.dart';
import 'package:plexaverse/features/placement/domain/placement_words.dart';

/// The placement page's state machine: intro → questions → writing → result,
/// and what happens when the attempt on screen ends under the learner.
///
/// Every refusal that means "this attempt moved on" goes back to the intro
/// only after a fresh status read, and the notice is decided by that read —
/// never by the refusal, which cannot say how the attempt ended.

/// A fake whose next call of one kind can be made to refuse, and which counts
/// what it was asked.
class _Scripted extends FakePlacementRepository {
  _Scripted({super.seed}) : super(latency: Duration.zero);

  Object? failStart;
  Object? failAnswer;
  Object? failWriting;
  Object? failFinish;
  Object? failStatus;

  /// Set to make the next status read report this instead of the fake's own.
  PlacementStatus? statusOverride;

  int statusReads = 0;
  final List<({String attemptId, String itemId, String value})> answers =
      <({String attemptId, String itemId, String value})>[];
  final List<String> writings = <String>[];

  @override
  Future<PlacementStatus> fetchStatus() async {
    statusReads++;
    final Object? fail = failStatus;
    if (fail != null) throw fail;
    final PlacementStatus? fixed = statusOverride;
    if (fixed != null) return fixed;
    return super.fetchStatus();
  }

  @override
  Future<PlacementStep> start() async {
    final Object? fail = failStart;
    if (fail != null) {
      failStart = null;
      throw fail;
    }
    return super.start();
  }

  @override
  Future<PlacementStep> answer({
    required String attemptId,
    required String itemId,
    required String value,
  }) async {
    answers.add((attemptId: attemptId, itemId: itemId, value: value));
    final Object? fail = failAnswer;
    if (fail != null) {
      failAnswer = null;
      throw fail;
    }
    return super.answer(attemptId: attemptId, itemId: itemId, value: value);
  }

  @override
  Future<PlacementResult> submitWriting({
    required String attemptId,
    required String text,
  }) async {
    writings.add(text);
    final Object? fail = failWriting;
    if (fail != null) {
      failWriting = null;
      throw fail;
    }
    return super.submitWriting(attemptId: attemptId, text: text);
  }

  @override
  Future<PlacementResult> finish(String attemptId) async {
    final Object? fail = failFinish;
    if (fail != null) {
      failFinish = null;
      throw fail;
    }
    return super.finish(attemptId);
  }
}

const String _writing =
    'I lead a small analytics team. Last month we cut the monthly report '
    'from four days to one.';

void main() {
  late _Scripted repo;
  late ProviderContainer c;

  Future<void> open({FakePlacementSeed seed = FakePlacementSeed.fresh}) async {
    repo = _Scripted(seed: seed);
    c = ProviderContainer(
      overrides: <Override>[
        placementRepositoryProvider.overrideWithValue(repo),
      ],
      // The app turns Riverpod's own retries off (bootstrap.dart); a failed
      // read must stay failed here too.
      retry: (int retryCount, Object error) => null,
    );
    addTearDown(c.dispose);
    // The page watches both.
    c.listen(placementFlowProvider, (_, _) {});
    c.listen(placementStatusProvider, (_, _) {});
    await c.read(placementStatusProvider.future);
  }

  PlacementFlow flow() => c.read(placementFlowProvider.notifier);
  PlacementFlowState state() => c.read(placementFlowProvider);

  PlacementStep questionOnScreen() {
    final PlacementScreen screen = state().screen;
    expect(screen, isA<PlacementQuestionScreen>());
    return (screen as PlacementQuestionScreen).step;
  }

  /// Answer every question with its first option until the writing stage.
  Future<void> answerToTheEnd() async {
    while (state().screen is PlacementQuestionScreen) {
      await flow().answer(questionOnScreen().item!.options.first);
    }
  }

  test('start opens the first question; nothing is sent on arrival', () async {
    await open();
    expect(state().screen, isA<PlacementIntroScreen>());
    expect(repo.answers, isEmpty);

    await flow().start();
    final PlacementStep step = questionOnScreen();
    expect(step.answered, 0);
    expect(step.item?.id, 'step-0');
    expect(step.skill, ObjectiveSkill.vocabulary);
  });

  test('an answer sends the option text and the handle as received', () async {
    await open();
    await flow().start();
    final PlacementStep first = questionOnScreen();

    await flow().answer(first.item!.options[2]);

    expect(repo.answers.single, (
      attemptId: first.attemptId,
      itemId: 'step-0',
      value: first.item!.options[2],
    ));
    expect(questionOnScreen().item?.id, 'step-1');
  });

  test('the last answer lands on writing and says the band moved', () async {
    await open();
    final int before = c.read(placementBandChangesProvider);
    await flow().start();
    await answerToTheEnd();

    expect(state().screen, isA<PlacementWritingScreen>());
    expect(c.read(placementBandChangesProvider), greaterThan(before));
    final PlacementStatus status = await c.read(placementStatusProvider.future);
    expect(status.hasPlacement, isTrue);
  });

  test('a status read that finds a different band says so; the same band '
      'does not', () async {
    await open();
    final PlacementBandChanges changes = c.read(
      placementBandChangesProvider.notifier,
    );
    final int start = c.read(placementBandChangesProvider);

    changes.observe(CefrBand.b2);
    expect(c.read(placementBandChangesProvider), start);
    changes.observe(CefrBand.b1);
    expect(c.read(placementBandChangesProvider), start + 1);
    changes.observe(CefrBand.b1);
    expect(c.read(placementBandChangesProvider), start + 1);
  });

  group('the attempt moved on under an answer', () {
    test('finished on the web: back to the intro, told it was finished, '
        'never that it was cut short', () async {
      await open();
      await flow().start();
      final String attemptId = questionOnScreen().attemptId;
      repo
        ..failAnswer = const PlacementAlreadyComplete(
          'This placement test is already finished.',
        )
        ..statusOverride = PlacementStatus(
          hasPlacement: true,
          canStart: false,
          latest: PlacementSummary(attemptId: attemptId, band: CefrBand.b1),
        );
      final int readsBefore = repo.statusReads;

      await flow().answer(questionOnScreen().item!.options.first);

      expect(state().screen, isA<PlacementIntroScreen>());
      expect(state().isBusy, isFalse);
      expect(repo.statusReads, greaterThan(readsBefore));
      expect(state().notice, '$answerNotSavedNotice $finishedElsewhereNotice');
    });

    test('closed early: told it closed, and the result is below', () async {
      await open();
      await flow().start();
      final String attemptId = questionOnScreen().attemptId;
      repo
        ..failAnswer = const PlacementAlreadyComplete('Already finished.')
        ..statusOverride = PlacementStatus(
          hasPlacement: true,
          canStart: false,
          latest: PlacementSummary(
            attemptId: attemptId,
            band: CefrBand.a2,
            closedEarly: true,
          ),
        );

      await flow().answer(questionOnScreen().item!.options.first);

      expect(state().notice, '$answerNotSavedNotice $closedNotice');
    });

    test('cleared with nothing answered: no level is claimed', () async {
      await open();
      await flow().start();
      repo
        ..failAnswer = const PlacementNotFound(
          'That placement test expired before any question was answered, '
          'so it was cleared. You can start again.',
        )
        ..statusOverride = const PlacementStatus();

      await flow().answer(questionOnScreen().item!.options.first);

      expect(state().screen, isA<PlacementIntroScreen>());
      expect(state().notice, '$answerNotSavedNotice $clearedNotice');
    });

    test(
      'anything else stays on the question with the server\'s words',
      () async {
        await open();
        await flow().start();
        final String handle = questionOnScreen().item!.id;
        repo.failAnswer = const PlacementUnavailable(
          'Could not save that answer. Try again in a moment.',
        );

        await flow().answer(questionOnScreen().item!.options.first);

        expect(questionOnScreen().item?.id, handle);
        expect(state().problem?.move, PlacementMove.answer);
        expect(
          state().problem?.message,
          'Could not save that answer. Try again in a moment.',
        );
      },
    );
  });

  test('Continue answered COOLDOWN: the offered attempt closed with answers; '
      'the intro shows what it closed with', () async {
    await open(seed: FakePlacementSeed.inProgress);
    final String offered = (await c.read(
      placementStatusProvider.future,
    )).inProgress!.attemptId;
    repo
      ..failStart = PlacementCooldown(
        'You can retake the placement test 30 days after your last one.',
        nextRetakeAt: DateTime.utc(2026, 12, 9),
      )
      ..statusOverride = PlacementStatus(
        hasPlacement: true,
        canStart: false,
        nextRetakeAt: DateTime.utc(2026, 12, 9),
        latest: PlacementSummary(
          attemptId: offered,
          band: CefrBand.b1,
          closedEarly: true,
        ),
      );

    await flow().start();

    expect(state().screen, isA<PlacementIntroScreen>());
    expect(state().notice, closedNotice);
  });

  test('Continue landed on a different attempt: its first question says it '
      'is a new one, and only the first', () async {
    await open(seed: FakePlacementSeed.inProgress);
    final _Scripted fake = repo;
    // The offered attempt was cleared server-side between the read and the
    // press; the server opened a fresh one.
    fake.statusOverride = PlacementStatus(
      inProgress: const PlacementInProgress(attemptId: 'gone', answered: 0),
    );
    c.invalidate(placementStatusProvider);
    await c.read(placementStatusProvider.future);
    fake.statusOverride = null;

    await flow().start();
    final PlacementStep first = questionOnScreen();
    expect(state().newAttemptId, first.attemptId);

    await flow().answer(first.item!.options.first);
    expect(state().newAttemptId, isNull);
  });

  group('writing', () {
    Future<void> toWriting() async {
      await open();
      await flow().start();
      await answerToTheEnd();
      expect(state().screen, isA<PlacementWritingScreen>());
    }

    test(
      'the consent is recorded first, in context, then the text goes',
      () async {
        await toWriting();
        expect(
          state().needsAgreement(c.read(placementStatusProvider).value),
          isTrue,
        );

        await flow().grade(_writing);

        expect(repo.consentCalls.single, <String, Object>{
          'purpose': 'assessment_grading',
          'granted': true,
          'source': 'in_context',
        });
        expect(repo.writings.single, _writing);
        expect(state().screen, isA<PlacementResultScreen>());
      },
    );

    test('grading unavailable keeps the screen, says the page\'s words, and '
        'does not ask for consent a second time', () async {
      await toWriting();
      repo.failWriting = const PlacementGradingUnavailable(
        'Your writing could not be graded just now, so nothing was saved.',
      );

      await flow().grade(_writing);

      expect(state().screen, isA<PlacementWritingScreen>());
      expect(state().problem?.move, PlacementMove.grade);
      expect(state().problem?.message, gradingUnavailableMessage);
      expect(state().agreed, isTrue);

      await flow().grade(_writing);

      expect(repo.consentCalls, hasLength(1));
      expect(state().screen, isA<PlacementResultScreen>());
    });

    test('consent withdrawn since the page loaded: the card asks again, with '
        'no error line', () async {
      await toWriting();
      await flow().grade('too short');
      // The fake refused the length after recording consent; now withdraw.
      repo.failWriting = const PlacementConsentRequired(
        'Grading your writing sends it to an AI provider.',
      );

      await flow().grade(_writing);

      expect(state().consentRefused, isTrue);
      expect(state().problem, isNull);
      expect(
        state().needsAgreement(c.read(placementStatusProvider).value),
        isTrue,
      );

      await flow().grade(_writing);
      expect(repo.consentCalls, hasLength(2));
      expect(state().screen, isA<PlacementResultScreen>());
    });

    test(
      'already in: a fresh read decides, then the intro says which',
      () async {
        await toWriting();
        final String attemptId =
            (state().screen as PlacementWritingScreen).attemptId;
        repo
          ..failWriting = const PlacementAlreadyComplete(
            'Your writing for this test is already in.',
          )
          ..statusOverride = PlacementStatus(
            hasPlacement: true,
            canStart: false,
            latest: PlacementSummary(attemptId: attemptId, band: CefrBand.b2),
          );

        await flow().grade(_writing);

        expect(state().screen, isA<PlacementIntroScreen>());
        expect(state().notice, writingInNotice);
      },
    );

    test(
      'already in, and the read fails: the draft stays with the words',
      () async {
        await toWriting();
        repo
          ..failWriting = const PlacementAlreadyComplete(
            'Writing can only be added to your latest placement test.',
          )
          ..failStatus = const PlacementUnavailable();

        await flow().grade(_writing);

        expect(state().screen, isA<PlacementWritingScreen>());
        expect(state().isBusy, isFalse);
        expect(
          state().problem?.message,
          'Writing can only be added to your latest placement test.',
        );
      },
    );

    test('skip reads back the stored result', () async {
      await toWriting();
      await flow().skip();
      final PlacementScreen screen = state().screen;
      expect(screen, isA<PlacementResultScreen>());
      expect(
        (screen as PlacementResultScreen).result.writingSubmitted,
        isFalse,
      );
      expect(repo.writings, isEmpty);
    });

    test('skip refused NOT_READY goes back to the intro', () async {
      await toWriting();
      repo.failFinish = const PlacementNotReady(
        'Finish the three parts of the test first.',
      );
      await flow().skip();
      expect(state().screen, isA<PlacementIntroScreen>());
    });
  });

  test('the intro\'s closing time passing re-reads and explains', () async {
    await open(seed: FakePlacementSeed.inProgress);
    final String attemptId = (await c.read(
      placementStatusProvider.future,
    )).inProgress!.attemptId;
    repo.statusOverride = PlacementStatus(
      hasPlacement: true,
      canStart: false,
      latest: PlacementSummary(
        attemptId: attemptId,
        band: CefrBand.b1,
        closedEarly: true,
      ),
    );

    await flow().recheckClosed(attemptId);

    expect(state().notice, closedNotice);
  });

  test('the latest result\'s writing opens from the intro', () async {
    await open(seed: FakePlacementSeed.placed);
    final PlacementSummary latest = (await c.read(
      placementStatusProvider.future,
    )).latest!;
    expect(latest.writingPending, isTrue);

    flow().openWriting(latest.attemptId);

    final PlacementScreen screen = state().screen;
    expect(screen, isA<PlacementWritingScreen>());
    expect((screen as PlacementWritingScreen).attemptId, latest.attemptId);
  });
}
