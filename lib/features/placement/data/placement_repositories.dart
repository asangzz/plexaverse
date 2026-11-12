import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure.dart';
import '../domain/placement_repository.dart';

/// Dio-backed [PlacementRepository].
///
/// [DioClient] unwraps the `{data, error, meta}` envelope, so on success
/// `response.data` is the inner object — `{status}`, `{step}` or `{result}`,
/// the web route's own body.
///
/// ## The code is read before the class
///
/// The mobile routes answer with the web's statuses, unchanged: 403
/// CONSENT_REQUIRED, 429 COOLDOWN, 503 GRADING_UNAVAILABLE. The interceptor
/// files those as [AuthFailure] and [NetworkFailure] — by class, a cooldown
/// is "check your connection". So every failure is mapped on its
/// [Failure.errorCode] first, and only a failure with no code the page knows
/// falls to [PlacementUnavailable].
class ApiPlacementRepository implements PlacementRepository {
  const ApiPlacementRepository(this._client);

  final DioClient _client;

  @override
  Future<PlacementStatus> fetchStatus() => _guard(() async {
    final Response<Map<String, dynamic>> r = await _client
        .get<Map<String, dynamic>>(ApiPaths.placement);
    return PlacementStatus.fromJson(_inner(r.data, 'status'));
  });

  @override
  Future<PlacementStep> start() => _guard(() async {
    final Response<Map<String, dynamic>> r = await _client
        .post<Map<String, dynamic>>(ApiPaths.placementStart);
    return PlacementStep.fromJson(_inner(r.data, 'step'));
  });

  @override
  Future<PlacementStep> answer({
    required String attemptId,
    required String itemId,
    required String value,
  }) => _guard(() async {
    final Response<Map<String, dynamic>> r = await _client
        .post<Map<String, dynamic>>(
          ApiPaths.placementAnswer,
          data: <String, dynamic>{
            'attemptId': attemptId,
            'itemId': itemId,
            'value': value,
          },
        );
    return PlacementStep.fromJson(_inner(r.data, 'step'));
  });

  @override
  Future<PlacementResult> finish(String attemptId) => _guard(() async {
    final Response<Map<String, dynamic>> r = await _client
        .post<Map<String, dynamic>>(
          ApiPaths.placementFinish,
          data: <String, dynamic>{'attemptId': attemptId},
        );
    return PlacementResult.fromJson(_inner(r.data, 'result'));
  });

  @override
  Future<PlacementResult> submitWriting({
    required String attemptId,
    required String text,
  }) => _guard(() async {
    final Response<Map<String, dynamic>> r = await _client
        .post<Map<String, dynamic>>(
          ApiPaths.placementWriting,
          data: <String, dynamic>{'attemptId': attemptId, 'text': text},
        );
    return PlacementResult.fromJson(_inner(r.data, 'result'));
  });

  @override
  Future<void> grantWritingConsent() => _guard(() async {
    await _client.patch<Map<String, dynamic>>(
      ApiPaths.userConsent,
      data: <String, dynamic>{
        'purpose': 'assessment_grading',
        'granted': true,
        // The card on the writing step IS where the learner agreed. The
        // ledger is the evidence of how consent was given, and a row naming
        // Settings would be a record of something that did not happen.
        'source': 'in_context',
      },
    );
  });

  /// One boundary for every call: a refusal becomes its [PlacementFailure],
  /// and a body that does not parse becomes [PlacementUnavailable] rather
  /// than a TypeError on the screen.
  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw _mapped(e);
    } on PlacementFailure {
      rethrow;
    } on Object {
      throw const PlacementUnavailable();
    }
  }

  static Map<String, dynamic> _inner(Map<String, dynamic>? data, String key) {
    final Object? inner = data?[key];
    if (inner is! Map) throw const PlacementUnavailable();
    return Map<String, dynamic>.from(inner);
  }

  static PlacementFailure _mapped(DioException e) {
    final Object? err = e.error;
    final Failure? failure = err is Failure ? err : null;
    final String message = failure?.message?.trim() ?? '';
    return switch (failure?.errorCode) {
      'COOLDOWN' => PlacementCooldown(
        message,
        nextRetakeAt: _nextRetakeAt(e.response?.data),
      ),
      'CONSENT_REQUIRED' => PlacementConsentRequired(message),
      'GRADING_UNAVAILABLE' => PlacementGradingUnavailable(message),
      'ALREADY_COMPLETE' => PlacementAlreadyComplete(message),
      'NOT_FOUND' => PlacementNotFound(message),
      'NOT_READY' => PlacementNotReady(message),
      'VALIDATION_FAILED' => PlacementRejected(message),
      // The server's 401 sentence is written for a log, not a person.
      'UNAUTHORIZED' => const PlacementUnavailable('You have been signed out.'),
      _ => PlacementUnavailable(
        message.isEmpty ? placementFallbackMessage : message,
      ),
    };
  }

  /// `error.details.nextRetakeAt`, read off the raw envelope.
  ///
  /// The interceptor keeps the code and the message and drops `details` —
  /// `PlanRefusal` reaches past it for the same reason.
  static DateTime? _nextRetakeAt(Object? body) {
    if (body is! Map) return null;
    final Object? error = body['error'];
    final Object? details = error is Map ? error['details'] : null;
    final Object? at = details is Map ? details['nextRetakeAt'] : null;
    return at is String ? DateTime.tryParse(at) : null;
  }
}

/// Which life the fake's learner is in when it starts.
enum FakePlacementSeed {
  /// Never placed: lessons at B2, the contest's "Set your level first" shows.
  fresh,

  /// A test open with three answers in it.
  inProgress,

  /// Placed three days ago, writing never added — inside the cooldown.
  placed,

  /// Placed forty days ago on a test that closed on a walk-away before its
  /// reading part was scored — the cooldown is over.
  retake,
}

/// In-memory [PlacementRepository] for the mock flavour and tests.
///
/// A small staircase: four questions a part, three parts, then the band.
/// The answers are marked HERE and nowhere else — exactly as on the server,
/// nothing a step returns says whether the last answer was right.
class FakePlacementRepository implements PlacementRepository {
  FakePlacementRepository({
    FakePlacementSeed seed = FakePlacementSeed.fresh,
    DateTime Function()? clock,
    this.latency = const Duration(milliseconds: 350),
  }) : _clock = clock ?? _utcNow {
    _seed(seed);
  }

  /// UTC, as every instant arrives off the wire — a local one would read
  /// as a different value from the same moment parsed back.
  final DateTime Function() _clock;
  final Duration latency;

  static DateTime _utcNow() => DateTime.now().toUtc();

  CefrBand _band = defaultBand;
  _FakeResult? _latest;
  _FakeAttempt? _open;
  bool _consent = false;
  int _attempts = 0;

  /// Every `PATCH /user/consent` body sent, for tests.
  final List<Map<String, Object>> consentCalls = <Map<String, Object>>[];

  void _seed(FakePlacementSeed seed) {
    final DateTime now = _clock();
    switch (seed) {
      case FakePlacementSeed.fresh:
        break;
      case FakePlacementSeed.inProgress:
        _open = _FakeAttempt(
          id: 'fake-attempt-${++_attempts}',
          startedAt: now.subtract(const Duration(hours: 3)),
        );
        for (final _FakeItem item in _bank.take(3)) {
          _open!.answers.add(_FakeAnswer(item.skill, correct: true));
        }
        _open!.lastActivity = now.subtract(const Duration(hours: 2));
      case FakePlacementSeed.placed:
        _latest = _FakeResult(
          attemptId: 'fake-attempt-${++_attempts}',
          completedAt: now.subtract(const Duration(days: 3)),
          bands: const <ObjectiveSkill, CefrBand>{
            ObjectiveSkill.vocabulary: CefrBand.b2,
            ObjectiveSkill.grammar: CefrBand.b1,
            ObjectiveSkill.reading: CefrBand.b2,
          },
        );
        _band = CefrBand.b2;
      case FakePlacementSeed.retake:
        _latest = _FakeResult(
          attemptId: 'fake-attempt-${++_attempts}',
          completedAt: now.subtract(const Duration(days: 40)),
          bands: const <ObjectiveSkill, CefrBand>{
            ObjectiveSkill.vocabulary: CefrBand.b1,
            ObjectiveSkill.grammar: CefrBand.b1,
            ObjectiveSkill.reading: CefrBand.b1,
          },
          closedEarly: true,
          unmeasured: <ObjectiveSkill>{ObjectiveSkill.reading},
        );
        _band = CefrBand.b1;
    }
  }

  Future<void> _wait() => Future<void>.delayed(latency);

  @override
  Future<PlacementStatus> fetchStatus() async {
    await _wait();
    return _status();
  }

  @override
  Future<PlacementStep> start() async {
    await _wait();
    final _FakeAttempt? open = _open;
    if (open != null) return _stepOf(open);
    final DateTime? retake = _nextRetakeAt();
    if (retake != null) {
      throw PlacementCooldown(
        'You can retake the placement test 30 days after your last one.',
        nextRetakeAt: retake,
      );
    }
    final DateTime now = _clock();
    final _FakeAttempt fresh = _FakeAttempt(
      id: 'fake-attempt-${++_attempts}',
      startedAt: now,
    );
    _open = fresh;
    return _stepOf(fresh);
  }

  @override
  Future<PlacementStep> answer({
    required String attemptId,
    required String itemId,
    required String value,
  }) async {
    await _wait();
    final _FakeAttempt? open = _open;
    if (open == null || open.id != attemptId) {
      if (_latest?.attemptId == attemptId) {
        throw const PlacementAlreadyComplete(
          'This placement test is already finished.',
        );
      }
      throw const PlacementNotFound('That placement test was not found.');
    }
    final int asked = open.answers.length;
    final int? handle = int.tryParse(itemId.replaceFirst('step-', ''));
    if (handle != null && handle < asked) return _stepOf(open);
    if (handle != asked) {
      throw const PlacementRejected(
        'That is not the question being asked. Reload to continue.',
      );
    }
    final _FakeItem item = _bank[asked];
    if (!item.options.contains(value)) {
      throw const PlacementRejected('Pick one of the options.');
    }
    open.answers.add(
      _FakeAnswer(item.skill, correct: value == item.options[item.key]),
    );
    open.lastActivity = _clock();
    if (open.answers.length < _bank.length) return _stepOf(open);

    // The answer that finishes the third part completes the attempt and sets
    // the band in the same write, as the server does.
    final _FakeResult done = _FakeResult(
      attemptId: open.id,
      completedAt: _clock(),
      bands: <ObjectiveSkill, CefrBand>{
        for (final ObjectiveSkill skill in ObjectiveSkill.values)
          skill: _bandFor(open.rightIn(skill)),
      },
    );
    _latest = done;
    _band = done.band;
    _open = null;
    return PlacementStep(
      attemptId: done.attemptId,
      stage: PlacementStage.writing,
      answered: open.answers.length,
      estimatedTotal: open.answers.length,
      writingTask: standardWritingTask,
    );
  }

  @override
  Future<PlacementResult> finish(String attemptId) async {
    await _wait();
    return _resultFor(attemptId).toResult();
  }

  @override
  Future<PlacementResult> submitWriting({
    required String attemptId,
    required String text,
  }) async {
    await _wait();
    // Consent first, before the text is even looked at — the server's order.
    if (!_consent) {
      throw const PlacementConsentRequired(
        'Grading your writing sends it to an AI provider. Agree to that '
        'first, or skip the writing step.',
      );
    }
    final int length = text.trim().length;
    if (length < standardWritingTask.minChars) {
      throw const PlacementRejected(
        'Write at least 30 characters — a sentence or two.',
      );
    }
    if (length > standardWritingTask.maxChars) {
      throw const PlacementRejected(
        'Keep it under 1200 characters — 3 to 6 sentences is plenty.',
      );
    }
    final _FakeResult result = _resultFor(attemptId);
    if (result.writingSubmitted) {
      throw const PlacementAlreadyComplete(
        'Your writing for this test is already in.',
      );
    }
    result
      ..writingSubmitted = true
      ..writingBand = result.band
      ..feedback = const WritingFeedback(
        strengths: <String>[
          'You open with what you do, so a reader knows who is talking.',
          'The result you describe is specific and easy to picture.',
        ],
        improvements: <String>[
          'Give the result a number, even a rough one.',
          'Cut the last sentence; the one before it is a stronger close.',
        ],
      );
    return result.toResult();
  }

  @override
  Future<void> grantWritingConsent() async {
    await _wait();
    consentCalls.add(<String, Object>{
      'purpose': 'assessment_grading',
      'granted': true,
      'source': 'in_context',
    });
    _consent = true;
  }

  PlacementStatus _status() {
    final _FakeResult? latest = _latest;
    final _FakeAttempt? open = _open;
    final DateTime? retake = _nextRetakeAt();
    return PlacementStatus(
      band: _band,
      hasPlacement: latest != null,
      latest: latest?.toSummary(),
      inProgress: open == null
          ? null
          : PlacementInProgress(
              attemptId: open.id,
              answered: open.answers.length,
              closesAt: open.closesAt,
            ),
      // An open attempt can always be continued; only a fresh one waits out
      // the cooldown — the server's rule, word for word.
      canStart: open != null || retake == null,
      nextRetakeAt: retake,
      writingConsent: _consent,
    );
  }

  DateTime? _nextRetakeAt() {
    final DateTime? done = _latest?.completedAt;
    if (done == null) return null;
    final DateTime at = done.add(const Duration(days: 30));
    return at.isAfter(_clock()) ? at : null;
  }

  _FakeResult _resultFor(String attemptId) {
    if (_open?.id == attemptId) {
      throw const PlacementNotReady(
        'Finish the three parts of the test first.',
      );
    }
    final _FakeResult? latest = _latest;
    if (latest == null || latest.attemptId != attemptId) {
      throw const PlacementNotFound('That placement test was not found.');
    }
    return latest;
  }

  PlacementStep _stepOf(_FakeAttempt open) {
    final int asked = open.answers.length;
    final _FakeItem item = _bank[asked];
    return PlacementStep(
      attemptId: open.id,
      skill: item.skill,
      item: PublicPlacementItem(
        // A handle that counts answers and nothing else — never the bank's
        // index into the right answer.
        id: 'step-$asked',
        skill: item.skill,
        passage: item.passage,
        prompt: item.prompt,
        options: item.options,
      ),
      answered: asked,
      estimatedTotal: _bank.length,
      closesAt: open.closesAt,
    );
  }

  static CefrBand _bandFor(int right) => switch (right) {
    0 || 1 => CefrBand.a2,
    2 => CefrBand.b1,
    3 => CefrBand.b2,
    _ => CefrBand.c1,
  };
}

class _FakeAnswer {
  const _FakeAnswer(this.skill, {required this.correct});

  final ObjectiveSkill skill;
  final bool correct;
}

class _FakeAttempt {
  _FakeAttempt({required this.id, required this.startedAt})
    : lastActivity = startedAt;

  final String id;
  final DateTime startedAt;
  DateTime lastActivity;
  final List<_FakeAnswer> answers = <_FakeAnswer>[];

  /// 24 hours after the last answer, never later than 48 after the start.
  DateTime get closesAt {
    final DateTime idle = lastActivity.add(const Duration(hours: 24));
    final DateTime cap = startedAt.add(const Duration(hours: 48));
    return idle.isBefore(cap) ? idle : cap;
  }

  int rightIn(ObjectiveSkill skill) =>
      answers.where((_FakeAnswer a) => a.skill == skill && a.correct).length;
}

class _FakeResult {
  _FakeResult({
    required this.attemptId,
    required this.completedAt,
    required this.bands,
    this.closedEarly = false,
    this.unmeasured = const <ObjectiveSkill>{},
  });

  final String attemptId;
  final DateTime completedAt;
  final Map<ObjectiveSkill, CefrBand> bands;
  final bool closedEarly;
  final Set<ObjectiveSkill> unmeasured;
  bool writingSubmitted = false;
  CefrBand? writingBand;
  WritingFeedback? feedback;

  /// The median of the three, as the engine reports it.
  CefrBand get band {
    final List<CefrBand> sorted = bands.values.toList()
      ..sort((CefrBand a, CefrBand b) => a.index.compareTo(b.index));
    return sorted[sorted.length ~/ 2];
  }

  PlacementMeasured get _measured => PlacementMeasured(
    vocabulary: !unmeasured.contains(ObjectiveSkill.vocabulary),
    grammar: !unmeasured.contains(ObjectiveSkill.grammar),
    reading: !unmeasured.contains(ObjectiveSkill.reading),
  );

  PlacementSummary toSummary() => PlacementSummary(
    attemptId: attemptId,
    completedAt: completedAt,
    band: band,
    vocabularyBand: bands[ObjectiveSkill.vocabulary],
    grammarBand: bands[ObjectiveSkill.grammar],
    readingBand: bands[ObjectiveSkill.reading],
    writingBand: writingBand,
    writingFeedback: feedback,
    writingPending: !writingSubmitted,
    closedEarly: closedEarly,
    measured: _measured,
  );

  PlacementResult toResult() => PlacementResult(
    band: band,
    vocabularyBand: bands[ObjectiveSkill.vocabulary],
    grammarBand: bands[ObjectiveSkill.grammar],
    readingBand: bands[ObjectiveSkill.reading],
    writingBand: writingBand,
    writingFeedback: feedback,
    writingSubmitted: writingSubmitted,
    completedAt: completedAt,
    closedEarly: closedEarly,
    measured: _measured,
  );
}

/// One fake question. [key] is the index of the right option and never leaves
/// this file: [FakePlacementRepository._stepOf] builds the public item field
/// by field, as the server's `toPublicItem` does.
class _FakeItem {
  const _FakeItem(
    this.skill,
    this.prompt,
    this.options,
    this.key, {
    this.passage,
  });

  final ObjectiveSkill skill;
  final String prompt;
  final List<String> options;
  final int key;
  final String? passage;
}

const String _passageLaunch =
    'Our team moved the product launch from March to May. The extra eight '
    'weeks let us run a pilot with three clients, and their feedback changed '
    'the onboarding flow completely.';

const String _passageHiring =
    'We used to hire for experience alone. Last year we started giving every '
    'candidate a short paid task instead. Two of our best engineers would not '
    'have passed the old screen.';

const List<_FakeItem> _bank = <_FakeItem>[
  _FakeItem(
    ObjectiveSkill.vocabulary,
    'We need to ___ the budget before the board meeting on Friday.',
    <String>['finish up to', 'finalise', 'end over', 'close down'],
    1,
  ),
  _FakeItem(
    ObjectiveSkill.vocabulary,
    'The new process should ___ the time it takes to approve an invoice.',
    <String>['lower down', 'decline', 'drop off', 'reduce'],
    3,
  ),
  _FakeItem(
    ObjectiveSkill.vocabulary,
    'She was asked to ___ the project after the manager left.',
    <String>['take up with', 'take in', 'take over', 'take after'],
    2,
  ),
  _FakeItem(
    ObjectiveSkill.vocabulary,
    'Their proposal was ___, so we approved it without changes.',
    <String>['compulsive', 'compelling', 'competitive', 'complacent'],
    1,
  ),
  _FakeItem(
    ObjectiveSkill.grammar,
    'If we ___ the report earlier, the client would have signed.',
    <String>['sent', 'have sent', 'would send', 'had sent'],
    3,
  ),
  _FakeItem(ObjectiveSkill.grammar, 'I have worked here ___ 2019.', <String>[
    'for',
    'since',
    'from',
    'during',
  ], 1),
  _FakeItem(
    ObjectiveSkill.grammar,
    'Neither the manager nor the analysts ___ aware of the change.',
    <String>['was', 'is', 'were', 'be'],
    2,
  ),
  _FakeItem(
    ObjectiveSkill.grammar,
    'The figures, ___ were published yesterday, show steady growth.',
    <String>['what', 'that', 'whose', 'which'],
    3,
  ),
  _FakeItem(
    ObjectiveSkill.reading,
    'Why did the team move the launch?',
    <String>[
      'Because the product was finished early',
      'Because three clients cancelled',
      'To run a pilot with clients first',
      'To save money on onboarding',
    ],
    2,
    passage: _passageLaunch,
  ),
  _FakeItem(
    ObjectiveSkill.reading,
    'What changed because of the pilot?',
    <String>[
      'The onboarding flow',
      'The launch month, again',
      'The number of clients',
      'The pricing',
    ],
    0,
    passage: _passageLaunch,
  ),
  _FakeItem(
    ObjectiveSkill.reading,
    'What does the company do now when it hires?',
    <String>[
      'Hires for experience alone',
      'Gives candidates a short paid task',
      'Hires only engineers',
      'Asks for two references',
    ],
    1,
    passage: _passageHiring,
  ),
  _FakeItem(
    ObjectiveSkill.reading,
    'What does the writer suggest about the old screen?',
    <String>[
      'It was too expensive',
      'It was faster than the task',
      'It found the best engineers',
      'It missed good people',
    ],
    3,
    passage: _passageHiring,
  ),
];

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors every other slice.
final Provider<PlacementRepository> placementRepositoryProvider =
    Provider<PlacementRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakePlacementRepository();
      return ApiPlacementRepository(ref.watch(dioClientProvider));
    });
