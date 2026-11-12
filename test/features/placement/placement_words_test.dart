import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/placement/domain/placement_repository.dart';
import 'package:plexaverse/features/placement/domain/placement_words.dart';

/// The placement test's sentences that move with the numbers, in the web's
/// words (`components/placement/*`).
void main() {
  final DateTime now = DateTime.utc(2026, 11, 12, 9);

  test('spans read as the engine\'s numbers do', () {
    expect(spanWords(inactivityCloseHours), '24 hours');
    expect(spanWords(maxAttemptHours), '2 days');
    expect(spanWords(36), '36 hours');
  });

  group('the leave line under Next', () {
    test('far from the close: both rules', () {
      expect(
        leaveLine(
          closesAt: now.add(const Duration(hours: 20)),
          answered: 4,
          now: now,
        ),
        'Your answers save as you go. Leave it for 24 hours, or take more '
        'than 2 days in all, and it closes with what you have answered.',
      );
    });

    test('nothing answered yet: the test is cleared, not closed', () {
      expect(
        leaveLine(
          closesAt: now.add(const Duration(hours: 20)),
          answered: 0,
          now: now,
        ),
        'Leave it for 24 hours and this test is cleared.',
      );
    });

    test('within two hours: the time to answer by', () {
      final String line = leaveLine(
        closesAt: now.add(const Duration(minutes: 90)),
        answered: 4,
        now: now,
      );
      expect(line, startsWith('Answer by '));
      expect(
        line,
        endsWith(', or the test closes with what you have answered.'),
      );
    });

    test('past the close by this clock: advice only, the server decides', () {
      expect(
        leaveLine(closesAt: now, answered: 4, now: now),
        'The time for this test may have run out. Press Next and we will '
        'check.',
      );
    });

    test('it wakes at each change of wording, and only ahead of now', () {
      final DateTime closes = now.add(const Duration(hours: 5));
      expect(leaveLineTurns(closes, now), <DateTime>[
        now.add(const Duration(hours: 3)),
        closes,
      ]);
      expect(leaveLineTurns(now.add(const Duration(hours: 1)), now), <DateTime>[
        now.add(const Duration(hours: 1)),
      ]);
      expect(leaveLineTurns(null, now), isEmpty);
    });
  });

  group('the intro\'s closing line', () {
    test('with answers: closes on what it holds, and can lower a level', () {
      final String line = closesLine(
        closesAt: now.add(const Duration(hours: 20)),
        answered: 3,
      );
      expect(line, startsWith('Continue by '));
      expect(
        line,
        endsWith(
          'After that, the test closes with what you have answered. '
          '$unfinishedRule',
        ),
      );
    });

    test('nothing answered: it is cleared', () {
      expect(
        closesLine(closesAt: now, answered: 0),
        endsWith('After that, this test is cleared and you can start again.'),
      );
    });

    test('no closing time: the rules instead', () {
      expect(
        closesLine(closesAt: null, answered: 3),
        'Leave it for 24 hours, or take more than 2 days in all, and the test '
        'closes with what you have answered. $unfinishedRule',
      );
    });
  });

  group('the retake line counts from when the result was set', () {
    test('inside the 30 days: the date', () {
      expect(
        retakeLine(now.subtract(const Duration(days: 3)), now: now),
        startsWith('You can retake the test on '),
      );
    });

    test('past them: now', () {
      expect(
        retakeLine(now.subtract(const Duration(days: 31)), now: now),
        'You can retake the test now.',
      );
    });

    test('no date: the rule', () {
      expect(
        retakeLine(null, now: now),
        'You can retake the test 30 days after you took it.',
      );
    });
  });

  test('the bar never fills while questions may still come', () {
    expect(progressOf(0, 24), 0);
    expect(progressOf(12, 24), 0.5);
    expect(progressOf(30, 24), 0.95);
    expect(progressOf(3, 0), 0);
  });

  test('the count says "about" until it passes the estimate', () {
    expect(questionCount(6, 24), 'Question 7 of about 24');
    expect(questionCount(24, 24), 'Question 25');
  });

  test('answered counts read as the web\'s', () {
    expect(answeredLine(0), 'No questions answered yet.');
    expect(answeredLine(1), '1 question answered. Your answers are saved.');
    expect(answeredLine(3), '3 questions answered. Your answers are saved.');
  });

  group('the notice after an attempt moved on is decided by the re-read', () {
    PlacementStatus withLatest(String id, {bool closedEarly = false}) =>
        PlacementStatus(
          hasPlacement: true,
          latest: PlacementSummary(attemptId: id, closedEarly: closedEarly),
        );

    test('closed early', () {
      expect(
        endedNotice('a', withLatest('a', closedEarly: true)),
        closedNotice,
      );
    });

    test('finished elsewhere — never told it was cut short', () {
      expect(endedNotice('a', withLatest('a')), finishedElsewhereNotice);
    });

    test('not the latest result, or no read: no level is claimed', () {
      expect(endedNotice('a', withLatest('b')), isNull);
      expect(endedNotice('a', null), isNull);
      expect(endedNotice(null, withLatest('a')), isNull);
    });
  });

  test('a band names what new lessons are written at, and no more', () {
    expect(
      newLessonsLine(CefrBand.b1),
      'New lessons are written at B1. A lesson you have already opened keeps '
      'its level.',
    );
  });
}
