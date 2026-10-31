import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/learn/data/learn_repositories.dart';
import 'package:plexaverse/features/learn/domain/learn_repository.dart';
import 'package:plexaverse/features/learn/domain/learn_unit.dart';
import 'package:plexaverse/features/learn/presentation/widgets/lesson_player.dart';

/// The draft level names what the day actually makes.
///
/// Only two of the five climbable days become a Post. Wednesday and Friday
/// write a script and Thursday a newsletter, and the player used to offer
/// "Write my post" on all of them — which the web fixed in
/// `fix(learn): the draft level was a dead end on three days out of five`
/// after a user hit it on a Wednesday.
///
/// Copy, so cheap to get wrong again and invisible in a diff. Pinned per kind.
class _Repo implements LearnRepository {
  _Repo(this.unit);

  final LearnUnit unit;

  @override
  Future<LearnUnit> fetchUnit({required int week, required int day}) async =>
      unit;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not used here');
}

/// A unit sitting on its draft level, unwritten.
LearnUnit _draftUnit(DayKind kind, {String? written}) => LearnUnit(
  id: 'unit-1',
  season: 1,
  weekNumber: 4,
  dayIndex: 0,
  kind: kind,
  title: 'Why most onboarding docs go unread',
  nextLevelIndex: 0,
  postContent: written,
  levels: <LearnLevel>[
    LearnLevel(
      index: 0,
      kind: LevelKind.draft,
      title: 'Write the ${kind.madeThing}',
      // `isComplete` reads the STATUS, not completedAt — a level carrying a
      // timestamp but still marked available is not done.
      status: written == null ? LevelStatus.available : LevelStatus.complete,
      completedAt: written == null ? null : '2026-10-30T00:00:00.000Z',
    ),
  ],
);

Future<void> _pump(WidgetTester tester, LearnUnit unit) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        learnRepositoryProvider.overrideWithValue(_Repo(unit)),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: LessonPlayer(unit: unit, week: 4, day: 0, onClose: () {}),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('what the day makes', () {
    test('each kind has its own word', () {
      expect(DayKind.post.madeThing, 'post');
      expect(DayKind.videoScript.madeThing, 'script');
      expect(DayKind.article.madeThing, 'newsletter');
    });

    test('a rest day never reaches it, and still answers', () {
      // Nothing is written on a rest day, so the string is unreachable — but
      // an exhaustive switch has to answer and a throw here would turn a copy
      // lookup into a crash.
      expect(DayKind.rest.madeThing, isNotEmpty);
    });
  });

  group('the draft button', () {
    testWidgets('says post on a post day', (WidgetTester tester) async {
      await _pump(tester, _draftUnit(DayKind.post));
      expect(find.text('Write my post'), findsOneWidget);
      expect(find.textContaining('together into the post'), findsOneWidget);
    });

    testWidgets('says script on a video day', (WidgetTester tester) async {
      // The reported case: four levels climbed on a Wednesday, then a button
      // offering to write a post that the server could never write.
      await _pump(tester, _draftUnit(DayKind.videoScript));
      expect(find.text('Write my script'), findsOneWidget);
      expect(find.text('Write my post'), findsNothing);
      expect(find.textContaining('together into the script'), findsOneWidget);
    });

    testWidgets('says newsletter on the article day', (
      WidgetTester tester,
    ) async {
      await _pump(tester, _draftUnit(DayKind.article));
      expect(find.text('Write my newsletter'), findsOneWidget);
      expect(find.text('Write my post'), findsNothing);
      expect(
        find.textContaining('together into the newsletter'),
        findsOneWidget,
      );
    });
  });

  group('once it is written', () {
    testWidgets('the finished script is labelled a script', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        _draftUnit(DayKind.videoScript, written: 'Hook. Then the beats.'),
      );
      expect(find.text('YOUR SCRIPT'), findsOneWidget);
      expect(find.text('YOUR POST'), findsNothing);
    });

    testWidgets('the finished post is still labelled a post', (
      WidgetTester tester,
    ) async {
      await _pump(tester, _draftUnit(DayKind.post, written: 'The post body.'));
      expect(find.text('YOUR POST'), findsOneWidget);
    });
  });
}
