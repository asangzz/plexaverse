import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure.dart';
import '../domain/learn_repository.dart';
import '../domain/learn_unit.dart';

/// Dio-backed [LearnRepository].
///
/// [DioClient] already unwraps the `{data, error, meta}` envelope, so on
/// success `response.data` is the inner payload.
///
/// ## The three response shapes are not the same, and that is the server's
///
/// `/learn/answer` answers a bare verdict; `/learn/level` answers
/// `{ unit, results }`; `/learn/action` answers the bare unit. Normalising
/// them into one shape here would hide a real difference — the answer route
/// has a verdict and no unit, the level route has both, the action route has
/// no verdict to report — so each is parsed as it arrives.
class ApiLearnRepository implements LearnRepository {
  const ApiLearnRepository(this._client);

  final DioClient _client;

  @override
  Future<LearnPath> fetchPath({int? week}) async {
    try {
      final Response<Map<String, dynamic>> response = await _client
          .get<Map<String, dynamic>>(
            ApiPaths.learn,
            queryParameters: <String, dynamic>{'week': ?week},
          );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const LearnNoPlan();
      return LearnPath.fromJson(data);
    } on DioException catch (e) {
      throw _mapped(e) ?? e;
    }
  }

  @override
  Future<LearnUnit> fetchUnit({required int week, required int day}) async {
    try {
      final Response<Map<String, dynamic>> response = await _client
          .get<Map<String, dynamic>>(
            ApiPaths.learnUnit,
            queryParameters: <String, dynamic>{'week': week, 'day': day},
          );
      return _unit(response.data);
    } on DioException catch (e) {
      throw _mapped(e) ?? e;
    }
  }

  @override
  Future<AnswerVerdict> gradeAnswer({
    required String unitId,
    required int levelIndex,
    required String exerciseId,
    required String value,
  }) async {
    try {
      final Response<Map<String, dynamic>> response = await _client
          .post<Map<String, dynamic>>(
            ApiPaths.learnAnswer,
            data: <String, dynamic>{
              'unitId': unitId,
              'levelIndex': levelIndex,
              'exerciseId': exerciseId,
              'value': value,
            },
          );
      final Map<String, dynamic>? data = response.data;
      if (data == null) {
        throw const LearnGenerationFailed('No verdict came back.');
      }
      return AnswerVerdict.fromJson(data);
    } on DioException catch (e) {
      throw _mapped(e) ?? e;
    }
  }

  @override
  Future<SubmitResult> submitLevel({
    required String unitId,
    required int levelIndex,
    required List<LevelAnswer> answers,
  }) async {
    try {
      final Response<Map<String, dynamic>> response = await _client
          .post<Map<String, dynamic>>(
            ApiPaths.learnLevel,
            data: <String, dynamic>{
              'unitId': unitId,
              'levelIndex': levelIndex,
              // Only what the user gave. `correct` is the server's to decide
              // and is deliberately not sent back to it.
              'answers': answers
                  .map(
                    (LevelAnswer a) => <String, dynamic>{
                      'exerciseId': a.exerciseId,
                      'value': a.value,
                    },
                  )
                  .toList(),
            },
          );
      final Map<String, dynamic>? data = response.data;
      if (data == null) {
        throw const LearnGenerationFailed('No answer came back.');
      }
      return SubmitResult.fromJson(data);
    } on DioException catch (e) {
      throw _mapped(e) ?? e;
    }
  }

  @override
  Future<LearnUnit> runDraft(String unitId) => _action(unitId, 'draft');

  @override
  Future<LearnUnit> checkVisual(String unitId) => _action(unitId, 'visual');

  @override
  Future<LearnUnit> completeReview(String unitId) => _action(unitId, 'review');

  Future<LearnUnit> _action(String unitId, String action) async {
    try {
      final Response<Map<String, dynamic>> response = await _client
          .post<Map<String, dynamic>>(
            ApiPaths.learnAction,
            data: <String, dynamic>{'unitId': unitId, 'action': action},
          );
      return _unit(response.data);
    } on DioException catch (e) {
      throw _mapped(e) ?? e;
    }
  }

  static LearnUnit _unit(Map<String, dynamic>? data) {
    if (data == null) throw const LearnGenerationFailed('No unit came back.');
    return LearnUnit.fromJson(data);
  }

  /// Turns the server's own `code` into something the UI can branch on.
  ///
  /// The codes matter more here than usual because three of them are not
  /// failures: `IMAGE_MISSING` means the poster is not made YET, `REST_DAY`
  /// means there is deliberately nothing to do, and `OUT_OF_HEARTS` means the
  /// level was attempted and not passed. Rendering any of them as "something
  /// went wrong" would be a lie about the product.
  ///
  /// Returns null for anything unrecognised, so the original DioException
  /// reaches the controller with its mapped [Failure] intact.
  static Exception? _mapped(DioException e) {
    final Object? err = e.error;
    final String? code = err is Failure ? err.errorCode : null;
    final String? message = err is Failure && (err.message?.isNotEmpty ?? false)
        ? err.message
        : null;

    return switch (code) {
      'NO_PLAN' => message == null ? const LearnNoPlan() : LearnNoPlan(message),
      'IMAGE_MISSING' =>
        message == null
            ? const LearnImageMissing()
            : LearnImageMissing(message),
      'REST_DAY' =>
        message == null ? const LearnRestDay() : LearnRestDay(message),
      'OUT_OF_HEARTS' =>
        message == null
            ? const LearnOutOfHearts()
            : LearnOutOfHearts(message),
      'GENERATION_FAILED' =>
        message == null
            ? const LearnGenerationFailed()
            : LearnGenerationFailed(message),
      _ => null,
    };
  }
}

/// A walkable week, with no server.
///
/// Not decoration. The mock flavor is how this app is demonstrated and how
/// its screens are checked, and without a fake the Learn path sits on its
/// skeleton for ever — which is exactly what it did the first time it was
/// opened in mock.
///
/// It grades, because in this flavor it IS the server. That is also why it
/// lives here in `data/` and not in a widget: the rule the presentation layer
/// is held to — never decide whether an answer is right — is about the
/// CLIENT not grading, and a stand-in backend is not the client.
///
/// Its fixtures carry all seven exercise types in the shapes
/// `LADDER_TEMPLATE` actually emits (`meaning, gap, pair` for vocabulary,
/// `dialogue` for the close), because a mock that only exercises the three
/// easy ones is a mock that cannot show whether the hard three render.
class FakeLearnRepository implements LearnRepository {
  final Map<int, LearnUnit> _units = <int, LearnUnit>{};

  static const List<String> _dayNames = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];
  static const List<DayKind> _kinds = <DayKind>[
    DayKind.post,
    DayKind.post,
    DayKind.videoScript,
    DayKind.article,
    DayKind.videoScript,
  ];
  static const List<String> _titles = <String>[
    'Why most onboarding docs go unread',
    'The handover note that saved us a week',
    'Three things I check before any launch',
    'What a good runbook actually contains',
    'The question I ask in every retro',
  ];

  @override
  Future<LearnPath> fetchPath({int? week}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final int w = week ?? 4;
    return LearnPath(
      season: 1,
      weekNumber: w,
      unitTitle: 'Writing so people act',
      phase: 'Getting seen',
      nextDayIndex: _firstOpen(),
      days: <LearnPathDay>[
        for (int i = 0; i < _dayNames.length; i++)
          LearnPathDay(
            dayIndex: i,
            day: _dayNames[i],
            kind: _kinds[i],
            title: _titles[i],
            status: _statusFor(i),
            levelCount: _kinds[i] == DayKind.post ? 7 : 6,
            completedCount: _units[i]?.completedCount ?? 0,
            started: _units.containsKey(i),
          ),
      ],
    );
  }

  /// A day opens only when the one before it is done — the server's rule, and
  /// the reason the fake has to model it: without it the mock would let you
  /// walk a week the real app would not.
  UnitStatus _statusFor(int day) {
    final LearnUnit? unit = _units[day];
    if (unit != null && unit.isComplete) return UnitStatus.complete;
    if (day == 0 || (_units[day - 1]?.isComplete ?? false)) {
      return unit == null ? UnitStatus.available : UnitStatus.inProgress;
    }
    return UnitStatus.locked;
  }

  int? _firstOpen() {
    for (int i = 0; i < _dayNames.length; i++) {
      if (_statusFor(i) != UnitStatus.complete &&
          _statusFor(i) != UnitStatus.locked) {
        return i;
      }
    }
    return null;
  }

  @override
  Future<LearnUnit> fetchUnit({required int week, required int day}) async {
    // Slow on purpose. The real one builds the ladder with a model call, and
    // a fake that answers instantly hides the one state most worth looking
    // at.
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    return _units.putIfAbsent(day, () => _build(week, day));
  }

  LearnUnit _build(int week, int day) {
    final DayKind kind = _kinds[day % _kinds.length];
    final List<LearnLevel> levels = <LearnLevel>[
      _vocabulary(0),
      _hook(1),
      _substance(2),
      _close(3),
      _action(4, LevelKind.draft, 'Write the post'),
      if (kind == DayKind.post) _action(5, LevelKind.visual, 'Make the poster'),
      _action(kind == DayKind.post ? 6 : 5, LevelKind.review, 'Read it back'),
    ];
    return LearnUnit(
      id: 'fake-unit-$week-$day',
      season: 1,
      weekNumber: week,
      dayIndex: day,
      kind: kind,
      title: _titles[day % _titles.length],
      unitTitle: 'Writing so people act',
      levels: _progress(levels),
      status: UnitStatus.inProgress,
      nextLevelIndex: 0,
    );
  }

  static List<ExerciseOption> _words(List<String> labels) => <ExerciseOption>[
    for (final String l in labels) ExerciseOption(label: l),
  ];

  LearnLevel _vocabulary(int i) => LearnLevel(
    index: i,
    kind: LevelKind.vocabulary,
    title: 'Words that carry',
    teach: const TeachBlock(
      rule: 'Name the thing, then say what changed.',
      why: 'A reader scanning LinkedIn gives you one line to be specific in.',
      before: 'We improved our processes significantly.',
      after: 'We cut handover time from two days to three hours.',
      kind: 'specificity',
    ),
    exercises: <Exercise>[
      Exercise(
        id: 'v1',
        type: 'meaning',
        prompt: 'What does it mean here?',
        teaches: 'specificity',
        sentence:
            'We cut the handover time by writing one runbook everybody could '
            'follow.',
        term: 'handover time',
        options: _words(<String>[
          'How long it takes to pass work to the next person',
          'The length of a meeting',
          'The notice period before someone leaves',
        ]),
        correctIndex: 0,
        explain:
            'A handover is the pass, not the exit. Naming the thing you '
            'measured is what makes the number mean something.',
      ),
      Exercise(
        id: 'v2',
        type: 'gap',
        prompt: 'Finish the sentence so it carries a fact.',
        teaches: 'specificity',
        sentence: 'The new runbook cut our incident response to ___.',
        options: _words(<String>[
          'much faster',
          'under 20 minutes',
          'a good level',
        ]),
        correctIndex: 1,
        explain: 'A number is checkable. "Much faster" is a feeling.',
      ),
      Exercise(
        id: 'v3',
        type: 'pair',
        prompt: 'Both halves, so the sentence holds together.',
        teaches: 'specificity',
        sentence: 'We ___ the onboarding doc and new hires ___ on day three.',
        options: const <ExerciseOption>[
          ExerciseOption(
            label: 'rewrote … shipped',
            fills: <String>['rewrote', 'shipped'],
          ),
          ExerciseOption(
            label: 'improved … performed',
            fills: <String>['improved', 'performed'],
          ),
          ExerciseOption(
            label: 'looked at … felt better',
            fills: <String>['looked at', 'felt better'],
          ),
        ],
        correctIndex: 0,
        explain:
            'Two concrete verbs. The other pairs each have one half doing no '
            'work, which is how a sentence ends up sounding busy and saying '
            'nothing.',
      ),
    ],
  );

  LearnLevel _hook(int i) => LearnLevel(
    index: i,
    kind: LevelKind.hook,
    title: 'The first line',
    teach: const TeachBlock(
      rule: 'Open on the moment, not the topic.',
      why: 'The first line is all most people read before deciding.',
      before: 'Some thoughts on documentation culture.',
      after: 'Nobody had read the runbook. We found out at 2am.',
      kind: 'opening',
    ),
    exercises: <Exercise>[
      Exercise(
        id: 'h1',
        type: 'choice',
        prompt: 'Which opening makes you read line two?',
        teaches: 'opening',
        options: _words(<String>[
          'Today I want to talk about onboarding.',
          'Our new hire shipped on day three. Here is what we changed.',
        ]),
        correctIndex: 1,
        explain: 'It starts after something has already happened.',
      ),
      const Exercise(
        id: 'h2',
        type: 'compose',
        prompt: 'Write your own opening line for today.',
        teaches: 'opening',
        placeholder: 'Start with the moment it happened…',
        minChars: 40,
      ),
    ],
  );

  LearnLevel _substance(int i) => LearnLevel(
    index: i,
    kind: LevelKind.substance,
    title: 'What you actually did',
    teach: const TeachBlock(
      rule: 'Say who did it.',
      why: 'The passive hides the actor, and the actor is the story.',
      before: 'The process was improved and timelines were met.',
      after: 'Priya rewrote the checklist and we hit the date.',
      kind: 'active_voice',
    ),
    exercises: const <Exercise>[
      Exercise(
        id: 's1',
        type: 'rewrite',
        prompt: 'Rewrite this so a person does the verb.',
        teaches: 'active_voice',
        starter: 'A decision was made to basically restructure the workflow.',
        modelAnswer: 'We restructured the workflow in one afternoon.',
      ),
      Exercise(
        id: 's2',
        type: 'compose',
        prompt: 'What did you actually do this week?',
        teaches: 'specificity',
        placeholder: 'One thing that really happened…',
        minChars: 60,
      ),
    ],
  );

  LearnLevel _close(int i) => LearnLevel(
    index: i,
    kind: LevelKind.close,
    title: 'The ask',
    teach: const TeachBlock(
      rule: 'Ask one question you want answered.',
      why: 'A post that asks nothing gets read and scrolled past.',
      before: 'Thoughts?',
      after: 'What is the one doc your team actually reads?',
      kind: 'call_to_action',
    ),
    exercises: <Exercise>[
      Exercise(
        id: 'c1',
        type: 'dialogue',
        prompt: 'Pick the reply.',
        teaches: 'call_to_action',
        speaker: 'A founder in your audience',
        opener: "We tried runbooks. Nobody kept them up to date.",
        options: _words(<String>[
          'Thanks for reading!',
          'That was us too — what finally worked was owning it in the '
              'on-call rota. Who owns yours?',
          'Totally agree, documentation is hard.',
        ]),
        correctIndex: 1,
        explain:
            'It answers them, adds the one thing you know, and hands the '
            'conversation back. The other two end it.',
      ),
      const Exercise(
        id: 'c2',
        type: 'compose',
        prompt: 'Write your closing question.',
        teaches: 'call_to_action',
        placeholder: 'One question, answerable in a line…',
        minChars: 25,
      ),
    ],
  );

  LearnLevel _action(int i, LevelKind kind, String title) =>
      LearnLevel(index: i, kind: kind, title: title);

  /// The server's progression: the first unfinished level is open, the rest
  /// are locked.
  List<LearnLevel> _progress(List<LearnLevel> levels) {
    bool openGiven = false;
    return <LearnLevel>[
      for (final LearnLevel l in levels)
        if (l.isComplete)
          l
        else if (!openGiven) ...<LearnLevel>[
          () {
            openGiven = true;
            return l.copyWith(status: LevelStatus.available);
          }(),
        ] else
          l.copyWith(status: LevelStatus.locked),
    ];
  }

  @override
  Future<AnswerVerdict> gradeAnswer({
    required String unitId,
    required int levelIndex,
    required String exerciseId,
    required String value,
  }) async {
    // Short, but not instant. The result bar has a checking state and a fake
    // that returns synchronously is a fake that never shows it.
    await Future<void>.delayed(const Duration(milliseconds: 280));
    final LearnUnit unit = _unitFor(unitId);
    final Exercise exercise = unit.levels[levelIndex].exercises.firstWhere(
      (Exercise e) => e.id == exerciseId,
    );
    final ExerciseResult result = _grade(exercise, value);
    return AnswerVerdict(
      correct: result.correct,
      message: result.message,
      // Only on a miss, like the server. A correct answer does not need the
      // answer printed back at it.
      solution: result.correct ? null : _solutionOf(exercise),
    );
  }

  /// The whole corrected line, not the missing word. Mirrors
  /// `correctAnswerOf` in the web's ladder.
  String? _solutionOf(Exercise e) {
    if (e.isCompose) return null;
    if (e.isRewrite) return e.modelAnswer;
    final int at = e.correctIndex ?? -1;
    if (at < 0 || at >= e.options.length) return null;
    final ExerciseOption option = e.options[at];
    if (e.isGap || e.isPair) return e.filled(option);
    return option.label;
  }

  @override
  Future<SubmitResult> submitLevel({
    required String unitId,
    required int levelIndex,
    required List<LevelAnswer> answers,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final LearnUnit unit = _unitFor(unitId);
    final int day = unit.dayIndex;
    final LearnLevel level = unit.levels[levelIndex];

    final List<ExerciseResult> results = <ExerciseResult>[
      for (final Exercise e in level.exercises)
        _grade(
          e,
          answers
              .firstWhere(
                (LevelAnswer a) => a.exerciseId == e.id,
                orElse: () => LevelAnswer(exerciseId: e.id, value: ''),
              )
              .value,
        ),
    ];

    // The server's two ways to fail, and the second is not redundant: a
    // three-question level skipped end to end is three wrong, under the
    // budget of five, and would otherwise bank having taught nothing.
    final int wrong = results.where((ExerciseResult r) => !r.correct).length;
    final bool nothingRight = results.isNotEmpty && wrong == results.length;
    if (wrong >= kMistakeBudget || nothingRight) {
      throw LearnOutOfHearts(
        nothingRight
            ? 'Nothing came back right on that one. Run it again.'
            : 'That is $wrong wrong in one level. Run it again.',
      );
    }

    final List<LearnLevel> next = _progress(<LearnLevel>[
      for (final LearnLevel l in unit.levels)
        if (l.index == levelIndex)
          l.copyWith(
            status: LevelStatus.complete,
            completedAt: DateTime.now().toIso8601String(),
          )
        else
          l,
    ]);
    final LearnUnit updated = unit.copyWith(
      levels: next,
      nextLevelIndex: next.indexWhere((LearnLevel l) => !l.isComplete),
      status: next.every((LearnLevel l) => l.isComplete)
          ? UnitStatus.complete
          : UnitStatus.inProgress,
    );
    _units[day] = updated;
    return SubmitResult(unit: updated, results: results);
  }

  ExerciseResult _grade(Exercise e, String answer) {
    final String trimmed = answer.trim();
    if (e.isCompose) {
      return ExerciseResult(
        exerciseId: e.id,
        correct: trimmed.length >= e.minChars,
        message: trimmed.length >= e.minChars
            ? 'Got it.'
            : 'A sentence or two more — about ${e.minChars} characters.',
      );
    }
    if (e.isRewrite) {
      final bool changed =
          trimmed.toLowerCase() != (e.starter ?? '').toLowerCase();
      final bool longEnough = trimmed.split(RegExp(r'\s+')).length >= 5;
      return ExerciseResult(
        exerciseId: e.id,
        correct: trimmed.isNotEmpty && changed && longEnough,
        message: trimmed.isEmpty
            ? 'Write your version first.'
            : !changed
            ? 'That is the original sentence — change it.'
            : !longEnough
            ? 'A little more — aim for at least 5 words.'
            : 'That reads much stronger.',
      );
    }
    final bool right =
        trimmed.isNotEmpty && e.optionAt(e.correctIndex ?? -1) == trimmed;
    return ExerciseResult(
      exerciseId: e.id,
      correct: right,
      message: e.explain ?? (right ? 'Correct.' : 'Not quite.'),
    );
  }

  @override
  Future<LearnUnit> runDraft(String unitId) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return _completeAction(unitId, LevelKind.draft, postContent: _fakePost);
  }

  @override
  Future<LearnUnit> checkVisual(String unitId) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    // The honest mock answer. Nobody has been to ChatGPT, so there is no
    // poster — and seeing this state is the point of walking it.
    throw const LearnImageMissing();
  }

  @override
  Future<LearnUnit> completeReview(String unitId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _completeAction(unitId, LevelKind.review);
  }

  LearnUnit _unitFor(String unitId) {
    final LearnUnit? unit = _units[int.parse(unitId.split('-').last)];
    if (unit == null) throw const LearnGenerationFailed('No such unit.');
    return unit;
  }

  LearnUnit _completeAction(
    String unitId,
    LevelKind kind, {
    String? postContent,
  }) {
    final LearnUnit unit = _unitFor(unitId);
    final int day = unit.dayIndex;
    final List<LearnLevel> next = _progress(<LearnLevel>[
      for (final LearnLevel l in unit.levels)
        if (l.kind == kind)
          l.copyWith(
            status: LevelStatus.complete,
            completedAt: DateTime.now().toIso8601String(),
          )
        else
          l,
    ]);
    final LearnUnit updated = unit.copyWith(
      levels: next,
      nextLevelIndex: next.indexWhere((LearnLevel l) => !l.isComplete),
      status: next.every((LearnLevel l) => l.isComplete)
          ? UnitStatus.complete
          : UnitStatus.inProgress,
      postContent: postContent ?? unit.postContent,
      postId: postContent != null ? 'fake-post-$day' : unit.postId,
    );
    _units[day] = updated;
    return updated;
  }

  static const String _fakePost =
      "Nobody had read the runbook. We found out at 2am.\n\n"
      "Priya rewrote it the next morning — not longer, shorter. One page, "
      "six steps, the phone number at the top. The next incident took "
      "nineteen minutes end to end.\n\n"
      "What is the one doc your team actually reads?";
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors the other slices.
final Provider<LearnRepository> learnRepositoryProvider =
    Provider<LearnRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakeLearnRepository();
      return ApiLearnRepository(ref.watch(dioClientProvider));
    });
