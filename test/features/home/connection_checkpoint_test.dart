import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/ui/zave/zave_kit.dart';
import 'package:plexaverse/features/home/application/connections_controller.dart';
import 'package:plexaverse/features/home/data/connections_repositories.dart';
import 'package:plexaverse/features/home/domain/connections_repository.dart';
import 'package:plexaverse/features/home/presentation/widgets/connection_checkpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The roadmap's weekly connections check-in, held to the web's
/// `ConnectionCheckpoint` (`__tests__/components/connection-checkpoint.test.tsx`
/// pins the same behaviour there): when it asks, what it says, what it sends,
/// and what an answer turns into.
void main() {
  const String why =
      'Connection growth is how your connect and invite levels show up over '
      'time.';

  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  Future<void> pump(WidgetTester tester, ConnectionsRepository repo) async {
    tester.view.physicalSize = const Size(375, 667) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [connectionsRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ConnectionCheckpoint()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Every string on screen, rich text included.
  String allText(WidgetTester tester) => tester
      .widgetList<RichText>(find.byType(RichText))
      .map((RichText t) => t.text.toPlainText())
      .join('\n');

  group('asking', () {
    testWidgets('asks when there is no reading, and says where and why', (
      WidgetTester tester,
    ) async {
      await pump(tester, _Repo(const ConnectionSummary()));

      expect(
        find.text('How many connections do you have now?'),
        findsOneWidget,
      );
      expect(find.text('$why One number a week is enough.'), findsOneWidget);
      expect(
        find.text(
          'Find it on your LinkedIn profile under your name, or in My '
          'Network → Connections.',
        ),
        findsOneWidget,
      );
      expect(find.text('Not now'), findsOneWidget);
      expect(find.text('e.g. 480'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('asks again once the reading is over a week old', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        _Repo(_summaryOf(<ConnectionReading>[_reading(1240, daysAgo: 8)])),
      );

      expect(
        find.text('How many connections do you have now?'),
        findsOneWidget,
      );
      // The last answer is the placeholder, grouped as LinkedIn prints it.
      expect(find.text('1,240'), findsOneWidget);
    });

    testWidgets('a reading from this week shows the figure, not the question', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        _Repo(_summaryOf(<ConnectionReading>[_reading(1240, daysAgo: 2)])),
      );

      expect(find.text('How many connections do you have now?'), findsNothing);
      expect(allText(tester), contains('1,240 connections'));
    });

    testWidgets('renders nothing while the first read is in flight', (
      WidgetTester tester,
    ) async {
      final _Repo repo = _Repo(const ConnectionSummary())
        ..pending = Completer<ConnectionSummary>();
      await pump(tester, repo);

      expect(find.byType(ZaveCard), findsNothing);
      repo.pending!.complete(const ConnectionSummary());
      await tester.pumpAndSettle();
      expect(
        find.text('How many connections do you have now?'),
        findsOneWidget,
      );
    });

    testWidgets('a read that failed still asks rather than leaving a hole', (
      WidgetTester tester,
    ) async {
      await pump(tester, _Repo(const ConnectionSummary())..readFails = true);
      expect(
        find.text('How many connections do you have now?'),
        findsOneWidget,
      );
    });
  });

  group('saving', () {
    testWidgets('saves a typed number, commas and all', (
      WidgetTester tester,
    ) async {
      final _Repo repo = _Repo(const ConnectionSummary());
      await pump(tester, repo);

      await tester.enterText(find.byType(TextField), '1,240');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(repo.recorded, <int>[1240]);
      // The answer turns into the figure.
      expect(find.text('How many connections do you have now?'), findsNothing);
      expect(allText(tester), contains('1,240 connections'));
      expect(
        find.text('First reading — growth shows from next week.'),
        findsOneWidget,
      );
    });

    testWidgets("refuses a number past LinkedIn's 30,000 cap without sending", (
      WidgetTester tester,
    ) async {
      final _Repo repo = _Repo(const ConnectionSummary());
      await pump(tester, repo);

      await tester.enterText(find.byType(TextField), '30001');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(repo.recorded, isEmpty);
      expect(
        find.text('Enter a whole number between 0 and 30,000.'),
        findsOneWidget,
      );

      // Typing again clears the sentence: it described the last attempt.
      await tester.enterText(find.byType(TextField), '300');
      await tester.pumpAndSettle();
      expect(
        find.text('Enter a whole number between 0 and 30,000.'),
        findsNothing,
      );
    });

    testWidgets('an empty answer cannot be saved, and Done says why', (
      WidgetTester tester,
    ) async {
      final _Repo repo = _Repo(const ConnectionSummary());
      await pump(tester, repo);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(repo.recorded, isEmpty);
      expect(
        find.text('Enter a whole number between 0 and 30,000.'),
        findsNothing,
      );

      await tester.showKeyboard(find.byType(TextField));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(repo.recorded, isEmpty);
      expect(
        find.text('Enter a whole number between 0 and 30,000.'),
        findsOneWidget,
      );
    });

    testWidgets("the server's refusal is said in its words", (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        _Repo(const ConnectionSummary())
          ..refusal = const ConnectionsInvalid(
            'That number is not one we keep.',
          ),
      );

      await tester.enterText(find.byType(TextField), '480');
      await tester.pump();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('That number is not one we keep.'), findsOneWidget);
    });

    testWidgets('any other failure is one plain sentence, never an exception', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        _Repo(const ConnectionSummary())..refusal = StateError('socket closed'),
      );

      await tester.enterText(find.byType(TextField), '480');
      await tester.pump();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Could not save that number.'), findsOneWidget);
      expect(allText(tester), isNot(contains('socket closed')));
    });
  });

  group('not now', () {
    testWidgets('puts it away, and the snooze outlives the screen', (
      WidgetTester tester,
    ) async {
      await pump(tester, _Repo(const ConnectionSummary()));

      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();

      // Snoozed before ever answering: one line to add it, never an empty
      // card.
      expect(find.text('How many connections do you have now?'), findsNothing);
      expect(find.text('Add your connection count'), findsOneWidget);
      expect(find.text(why), findsOneWidget);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? until = prefs.getInt(ConnectionPromptSnooze.storageKey);
      expect(until, isNotNull);
      final Duration held = DateTime.fromMillisecondsSinceEpoch(
        until!,
      ).difference(DateTime.now());
      expect(held.inHours, inInclusiveRange(71, 72));

      // A fresh app: a new container reads the snooze back from the device.
      await tester.pumpWidget(const SizedBox.shrink());
      await pump(tester, _Repo(const ConnectionSummary()));
      expect(find.text('How many connections do you have now?'), findsNothing);
      expect(find.text('Add your connection count'), findsOneWidget);
    });

    testWidgets('a snooze that has run out asks again', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        ConnectionPromptSnooze.storageKey: DateTime.now()
            .subtract(const Duration(minutes: 1))
            .millisecondsSinceEpoch,
      });
      await pump(tester, _Repo(const ConnectionSummary()));
      expect(
        find.text('How many connections do you have now?'),
        findsOneWidget,
      );
    });

    testWidgets('snoozed with a stale reading shows when it was last updated', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        ConnectionPromptSnooze.storageKey: DateTime.now()
            .add(const Duration(days: 2))
            .millisecondsSinceEpoch,
      });
      await pump(
        tester,
        _Repo(
          _summaryOf(<ConnectionReading>[
            _fixed(400, '2026-10-01T12:00:00.000Z'),
            _reading(450, daysAgo: 9),
          ], week: null),
        ),
      );

      expect(find.text('How many connections do you have now?'), findsNothing);
      final String text = allText(tester);
      // Not "this week" — nothing was measured this week.
      expect(text, contains('Last updated '));
      expect(text, isNot(contains('this week')));
      expect(text, contains('+50 since 1 Oct'));
    });

    testWidgets('Update reopens the question, and Cancel does not snooze', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        _Repo(_summaryOf(<ConnectionReading>[_reading(480, daysAgo: 1)])),
      );

      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();
      expect(
        find.text('How many connections do you have now?'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Not now'), findsNothing);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('How many connections do you have now?'), findsNothing);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt(ConnectionPromptSnooze.storageKey), isNull);
    });
  });

  group('the figure', () {
    Future<String> lineFor(
      WidgetTester tester, {
      required int week,
      required int sinceFirst,
    }) async {
      await pump(
        tester,
        _Repo(
          ConnectionSummary(
            reading: _reading(530, daysAgo: 0),
            growth: ConnectionGrowth(
              week: week,
              sinceFirst: sinceFirst,
              firstMeasuredAt: '2026-10-01T12:00:00.000Z',
              daysCovered: 42,
              readings: 4,
            ),
            history: <ConnectionReading>[
              _fixed(480, '2026-10-01T12:00:00.000Z'),
              _reading(530, daysAgo: 0),
            ],
          ),
        ),
      );
      return allText(tester);
    }

    testWidgets('shows the week, the change since the first, and a line', (
      WidgetTester tester,
    ) async {
      final String text = await lineFor(tester, week: 25, sinceFirst: 50);
      expect(text, contains('530 connections'));
      expect(text, contains('+25 this week · +50 since 1 Oct'));
      expect(find.byType(ZaveSparkline), findsOneWidget);
      expect(find.text(why), findsOneWidget);
    });

    testWidgets('says a drop plainly, with a real minus sign', (
      WidgetTester tester,
    ) async {
      final String text = await lineFor(tester, week: -12, sinceFirst: -12);
      expect(text, contains('−12 this week · −12 since 1 Oct'));
    });

    testWidgets('calls no movement "No change"', (WidgetTester tester) async {
      final String text = await lineFor(tester, week: 0, sinceFirst: 0);
      expect(text, contains('No change this week · no change since 1 Oct'));
    });

    testWidgets('does not invent growth from a single reading', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        _Repo(_summaryOf(<ConnectionReading>[_reading(480, daysAgo: 1)])),
      );
      expect(
        find.text('First reading — growth shows from next week.'),
        findsOneWidget,
      );
      expect(allText(tester), isNot(contains('this week')));
      expect(find.byType(ZaveSparkline), findsNothing);
    });
  });
}

ConnectionReading _reading(int count, {required int daysAgo}) =>
    ConnectionReading(
      count: count,
      measuredAt: DateTime.now()
          .subtract(Duration(days: daysAgo))
          .toUtc()
          .toIso8601String(),
    );

ConnectionReading _fixed(int count, String at) =>
    ConnectionReading(count: count, measuredAt: at);

/// A summary shaped as the server would send it for [history], with the week
/// figure given rather than computed (the arithmetic has its own test).
ConnectionSummary _summaryOf(List<ConnectionReading> history, {int? week = 0}) {
  final ConnectionReading first = history.first;
  final ConnectionReading last = history.last;
  return ConnectionSummary(
    reading: last,
    growth: ConnectionGrowth(
      week: history.length > 1 ? week : 0,
      sinceFirst: last.count - first.count,
      firstMeasuredAt: first.measuredAt,
      readings: history.length,
    ),
    history: history,
  );
}

/// Answers [summary], records every save, and refuses when told to.
class _Repo implements ConnectionsRepository {
  _Repo(this.summary);

  ConnectionSummary summary;
  final List<int> recorded = <int>[];

  /// Holds the read open until completed, when set.
  Completer<ConnectionSummary>? pending;
  bool readFails = false;
  Object? refusal;

  @override
  Future<ConnectionSummary> fetchSummary() async {
    if (pending case final Completer<ConnectionSummary> c) return c.future;
    if (readFails) throw const ConnectionsUnavailable();
    return summary;
  }

  @override
  Future<void> record(int count) async {
    if (refusal case final Object e) throw e;
    recorded.add(count);
    summary = _summaryOf(<ConnectionReading>[_reading(count, daysAgo: 0)]);
  }
}
