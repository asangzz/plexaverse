import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/learn/data/learn_repositories.dart';
import 'package:plexaverse/features/learn/domain/ladder_template.dart';
import 'package:plexaverse/features/learn/domain/learn_repository.dart';
import 'package:plexaverse/features/learn/domain/learn_unit.dart';
import 'package:plexaverse/features/learn/presentation/pages/learn_page.dart';
import 'package:plexaverse/features/learn/presentation/widgets/level_node.dart';

/// The week is a path, and it does not go away while a day is being built.
///
/// Both halves are ports of decisions the web already made and wrote down.
/// The nodes come from the TEMPLATE so the whole week draws without a single
/// model call; and opening a day dims that day in place rather than
/// replacing the screen, because the wait belongs where the user asked for
/// it.
class _Repo implements LearnRepository {
  _Repo(this.path);

  final LearnPath path;

  /// Held open so a test can look at the screen mid-build.
  Completer<void>? gate;

  @override
  Future<LearnPath> fetchPath({int? week}) async => path;

  @override
  Future<LearnUnit> fetchUnit({required int week, required int day}) async {
    await gate?.future;
    return LearnUnit(
      id: 'unit-$day',
      season: 1,
      weekNumber: week,
      dayIndex: day,
      kind: DayKind.post,
      title: 'Why most onboarding docs go unread',
      nextLevelIndex: 0,
      levels: const <LearnLevel>[
        LearnLevel(
          index: 0,
          kind: LevelKind.vocabulary,
          title: 'Words that carry',
          status: LevelStatus.available,
          teach: TeachBlock(
            rule: 'Name the thing, then say what changed.',
            why: 'A reader gives you one line.',
            before: 'We improved our processes.',
            after: 'We cut handover to three hours.',
          ),
          exercises: <Exercise>[
            Exercise(
              id: 'v1',
              type: 'choice',
              prompt: 'Which line does more work?',
              options: <ExerciseOption>[
                ExerciseOption(label: 'the weak one'),
                ExerciseOption(label: 'the strong one'),
              ],
              correctIndex: 1,
            ),
          ],
        ),
      ],
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not used here');
}

LearnPathDay _day(
  int index,
  String name, {
  UnitStatus status = UnitStatus.available,
  int completed = 0,
  int levels = 7,
}) => LearnPathDay(
  dayIndex: index,
  day: name,
  kind: DayKind.post,
  title: '$name the title',
  status: status,
  levelCount: levels,
  completedCount: completed,
  started: completed > 0,
);

final LearnPath _path = LearnPath(
  season: 1,
  weekNumber: 4,
  unitTitle: 'Writing so people act',
  phase: 'getting_seen',
  nextDayIndex: 0,
  days: <LearnPathDay>[
    _day(0, 'Monday'),
    _day(1, 'Tuesday', status: UnitStatus.locked),
  ],
);

Future<_Repo> _pump(WidgetTester tester) async {
  final _Repo repo = _Repo(_path);
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        learnRepositoryProvider.overrideWithValue(repo),
      ],
      child: const MaterialApp(home: LearnPage()),
    ),
  );
  await tester.pumpAndSettle();
  return repo;
}

void main() {
  group('levelsForDay', () {
    test('a locked day is locked all the way down', () {
      final List<PathNode> nodes = _day(
        1,
        'Tuesday',
        status: UnitStatus.locked,
      ).let(levelsForDay);

      expect(nodes, hasLength(7));
      expect(
        nodes.every((PathNode n) => n.status == LevelStatus.locked),
        isTrue,
      );
    });

    test('the next level after the finished ones is the open one', () {
      final List<PathNode> nodes = levelsForDay(_day(0, 'Monday', completed: 2));

      expect(nodes[0].status, LevelStatus.complete);
      expect(nodes[1].status, LevelStatus.complete);
      expect(nodes[2].status, LevelStatus.available);
      expect(nodes[3].status, LevelStatus.locked);
    });

    test("the server's count wins over the template's", () {
      // A server that grows an eighth level should draw eight nodes, not
      // seven and a silent mismatch.
      expect(levelsForDay(_day(0, 'Monday', levels: 8)), hasLength(8));
      expect(levelsForDay(_day(0, 'Monday', levels: 3)), hasLength(3));
    });

    test('the titles are the web ladder template, in its order', () {
      final List<PathNode> nodes = levelsForDay(_day(0, 'Monday'));
      expect(
        nodes.map((PathNode n) => n.title).toList(),
        <String>[
          'Words that carry',
          'The first line',
          'What you actually did',
          'The ask',
          'Write the post',
          'Make the poster',
          'Read it back',
        ],
      );
    });
  });

  testWidgets('the week draws without fetching a single ladder', (
    WidgetTester tester,
  ) async {
    // The first read of a day BUILDS it — a model call. A path that had to
    // fetch five ladders before it could render would spend five of those
    // just to be looked at.
    await _pump(tester);

    expect(find.text('Writing so people act'), findsOneWidget);
    expect(find.text('MONDAY'), findsOneWidget);
    // Seven nodes for a post day. The list is lazy, so the rest of the week
    // is below the fold — scrolled to below.
    expect(find.byType(LevelNode), findsNWidgets(7));
    // Only the live one wears its title.
    expect(find.text('WORDS THAT CARRY'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('TUESDAY'), 300);
    expect(find.text('TUESDAY'), findsOneWidget);
  });

  testWidgets('opening a day keeps the path on screen', (
    WidgetTester tester,
  ) async {
    final _Repo repo = await _pump(tester);
    repo.gate = Completer<void>();

    await tester.tap(find.byType(LevelNode).first);
    await tester.pump();

    expect(find.text("Writing today's lessons…"), findsOneWidget);
    // The path is still there — the day dims in place, it is not replaced.
    expect(find.text('MONDAY'), findsOneWidget);
    expect(find.text('Writing so people act'), findsOneWidget);
    expect(find.byType(LevelNode), findsNWidgets(7));
    expect(
      tester
          .widget<Opacity>(
            find
                .ancestor(
                  of: find.byType(LevelNode).first,
                  matching: find.byType(Opacity),
                )
                .first,
          )
          .opacity,
      0.4,
    );

    repo.gate!.complete();
    await tester.pumpAndSettle();

    // And then the player takes over.
    expect(find.text("Writing today's lessons…"), findsNothing);
    expect(find.text('Got it'), findsOneWidget);
  });

  testWidgets('a locked day cannot be opened', (WidgetTester tester) async {
    final _Repo repo = await _pump(tester);
    repo.gate = Completer<void>();

    // Tuesday's first node — locked, because Monday is not finished.
    await tester.scrollUntilVisible(find.text('TUESDAY'), 300);
    final Finder tuesdayNode = find
        .descendant(
          of: find.ancestor(
            of: find.text('TUESDAY'),
            matching: find.byType(Column),
          ),
          matching: find.byType(LevelNode),
        )
        .first;
    await tester.tap(tuesdayNode, warnIfMissed: false);
    await tester.pump();

    expect(find.text("Writing today's lessons…"), findsNothing);
    expect(find.text('Got it'), findsNothing);
  });
}

extension<T> on T {
  R let<R>(R Function(T) f) => f(this);
}
