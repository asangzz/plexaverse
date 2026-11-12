import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/contest/application/contest_controllers.dart';
import 'package:plexaverse/features/contest/domain/contest_dates.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/domain/contest_words.dart';

/// The contest's words and its few pure decisions, held to the web's.
///
/// Most expectations here are the web's own test expectations, copied from
/// `__tests__/components/contest-path.test.tsx` and
/// `__tests__/lib/contest-lesson-parts.test.ts`, so the two platforms are
/// pinned to the same strings rather than to two readings of one spec.
void main() {
  group('numbers', () {
    test('thousands are grouped, and a penalty carries a true minus', () {
      expect(formatCount(0), '0');
      expect(formatCount(999), '999');
      expect(formatCount(1500), '1,500');
      expect(formatCount(1234567), '1,234,567');
      expect(signed(52), '+52');
      expect(signed(-2), '−2');
      expect(signed(0), '0');
      expect(contestXp(1500), '+1,500 XP');
      expect(plural(1, 'person has', 'people have'), '1 person has');
      expect(plural(1284, 'person has', 'people have'), '1,284 people have');
    });

    test(
      'exactly thirty free days is a free month; anything else is counted',
      () {
        expect(freePeriod(30), 'free month');
        expect(freePeriod(7), '7 free days');
        expect(freePeriod(1), '1 free day');
      },
    );
  });

  group('a level’s words', () {
    test('every state has the card’s word', () {
      expect(stateWord(PathNodeState.locked), 'Locked');
      expect(stateWord(PathNodeState.today), 'Open today');
      expect(stateWord(PathNodeState.done), 'Done');
      expect(stateWord(PathNodeState.missed), 'Missed');
      expect(stateWord(PathNodeState.pending), 'Waiting for review');
      expect(stateWord(PathNodeState.approved), 'Approved');
      expect(stateWord(PathNodeState.rejected), 'Rejected');
      expect(stateWord(PathNodeState.revoked), 'Removed after review');
      expect(stateWord(PathNodeState.unavailable), 'Nothing to do today');
    });

    test('every kind has its kicker', () {
      expect(kindWord(PathNodeKind.lesson), 'Lesson');
      expect(kindWord(PathNodeKind.connectLeaders), 'LinkedIn · Connect');
      expect(kindWord(PathNodeKind.comment), 'LinkedIn · Comment');
      expect(kindWord(PathNodeKind.feedComments), 'LinkedIn · Feed comments');
      expect(kindWord(PathNodeKind.weeklyInvites), 'LinkedIn · Invites');
      expect(kindWord(PathNodeKind.planWeek), 'Planner · Plan this week');
      expect(kindWord(PathNodeKind.article), 'LinkedIn · Article link');
      expect(kindWord(PathNodeKind.video), 'LinkedIn · Video link');
    });

    test('a lesson part is named for its part; anything else by its title', () {
      expect(levelName(_lesson(3, PathNodeState.locked)), 'Lesson part 3 of 3');
      expect(levelName(_task(PathNodeKind.comment)), 'Comment on a top voice');
    });

    test('the card’s button: Start or Continue with what it pays, Open for '
        'anything else that opens, Locked for a locked one', () {
      expect(actionWord(_task(PathNodeKind.comment)), 'Start +40 XP');
      expect(
        actionWord(_task(PathNodeKind.feedComments, started: true, points: 60)),
        'Continue +60 XP',
      );
      expect(actionWord(_task(PathNodeKind.planWeek, points: 0)), 'Start');
      // A rejected claim is re-sent: Start, never Continue.
      expect(
        actionWord(
          _task(
            PathNodeKind.video,
            state: PathNodeState.rejected,
            started: true,
          ),
        ),
        'Start +40 XP',
      );
      expect(
        actionWord(_task(PathNodeKind.comment, state: PathNodeState.done)),
        'Open',
      );
      expect(
        actionWord(_task(PathNodeKind.comment, state: PathNodeState.locked)),
        'Locked',
      );
      expect(
        actionWord(_task(PathNodeKind.comment, points: 1500)),
        'Start +1,500 XP',
      );
    });

    test('locked never opens, even with an href; nor does a level with no '
        'href, an unknown kind, or a claim that lost its piece', () {
      expect(canOpen(_task(PathNodeKind.comment)), isTrue);
      expect(
        canOpen(_task(PathNodeKind.comment, state: PathNodeState.locked)),
        isFalse,
      );
      expect(canOpen(_task(PathNodeKind.comment, href: null)), isFalse);
      expect(
        canOpen(
          _task(PathNodeKind.comment, state: PathNodeState.revoked, href: null),
        ),
        isFalse,
      );
      expect(canOpen(_task(PathNodeKind.unknown)), isFalse);
      expect(canOpen(_task(PathNodeKind.video)), isFalse);
      expect(canOpen(_task(PathNodeKind.video, claim: _claim)), isTrue);
    });

    test('finished means done or approved; handed in adds pending', () {
      expect(isFinished(PathNodeState.done), isTrue);
      expect(isFinished(PathNodeState.approved), isTrue);
      expect(isFinished(PathNodeState.pending), isFalse);
      expect(isHandedIn(PathNodeState.pending), isTrue);
      expect(isHandedIn(PathNodeState.rejected), isFalse);
    });
  });

  group('the path', () {
    test('START sits on today’s first level still to do', () {
      expect(currentNodeId(_week), '2026-11-11:lesson:2');
      final List<PathDay> lessonDone = <PathDay>[
        _week[0],
        _today(<PathNode>[
          _lesson(1, PathNodeState.done),
          _lesson(2, PathNodeState.done),
          _lesson(3, PathNodeState.done),
          _task(PathNodeKind.comment),
        ]),
      ];
      expect(currentNodeId(lessonDone), '2026-11-11:comment');
      // A rejected level counts as the current one: it is to be sent again.
      expect(
        currentNodeId(<PathDay>[
          _today(<PathNode>[
            _lesson(3, PathNodeState.done),
            _task(PathNodeKind.video, state: PathNodeState.rejected),
          ]),
        ]),
        '2026-11-11:video',
      );
      // Nothing left today, and no today at all.
      expect(
        currentNodeId(<PathDay>[
          _today(<PathNode>[_lesson(3, PathNodeState.done)]),
        ]),
        isNull,
      );
      expect(currentNodeId(<PathDay>[_week[0]]), isNull);
    });

    test('the day divider counts the day, never the length', () {
      expect(dayLabel(_week[1]), 'Wed · Day 17 · Today');
      expect(dayLabel(_week[0]), 'Mon · Day 15');
    });

    test('the path winds both ways and stays within the amplitude', () {
      final List<double> steps = <double>[
        for (int i = 0; i < 16; i++) windAt(i),
      ];
      expect(steps.reduce((double a, double b) => a > b ? a : b), 1);
      expect(steps.reduce((double a, double b) => a < b ? a : b), -1);
      expect(windAt(0), 0);
      expect(windAt(8), 0);
      expect(windAt(-1), -0.7);
    });

    test('the lesson is done when its LAST part is', () {
      expect(isLessonDone(_week[1]), isFalse);
      expect(
        isLessonDone(
          _today(<PathNode>[
            _lesson(1, PathNodeState.done),
            _lesson(3, PathNodeState.done),
          ]),
        ),
        isTrue,
      );
      expect(isLessonDone(null), isFalse);
      expect(lessonPartsOf(_week[1]), hasLength(3));
    });

    test('the START ring measures the part the server cut, even when the '
        'lesson read’s size has moved', () {
      // Drawn for 5 questions (1/2/2: part 2 is [1, 3)); opening the day
      // wrote five more and the read now says 10.
      final PathNode part = _lesson(2, PathNodeState.today, start: 1, end: 3);
      expect(partProgress(part, answered: 2, total: 10), 0.5);
    });

    test('a node without bounds falls back to the shared cut of the read', () {
      // 10 → 3/3/4: part 2 is [3, 6).
      final PathNode part = _lesson(2, PathNodeState.today);
      expect(partProgress(part, answered: 4, total: 10), closeTo(1 / 3, 1e-9));
      expect(partProgress(part, answered: 0, total: 0), 0);
      expect(
        partProgress(_task(PathNodeKind.comment), answered: 4, total: 10),
        0,
      );
    });
  });

  group('the week trophy', () {
    test('as the web labels it', () {
      WeekTrophy t(WeekReward? r) => weekTrophy(r);
      final WeekTrophy paid = t(
        const WeekReward(points: 500, earned: true, paid: 500),
      );
      expect(
        (paid.open, paid.label, paid.missed),
        (true, 'Week complete · +500 XP', false),
      );
      // Earned while paused: no figure that was never paid.
      expect(
        t(const WeekReward(points: 500, earned: true)).label,
        'Week complete',
      );
      expect(t(const WeekReward(points: 500)).label, 'Week trophy · +500 XP');
      expect(
        t(const WeekReward(points: 1500)).label,
        'Week trophy · +1,500 XP',
      );
      final WeekTrophy missed = t(
        const WeekReward(points: 500, missedDay: true),
      );
      expect(
        (missed.open, missed.label, missed.missed),
        (false, '−500 XP missed · incomplete week', true),
      );
      expect(
        t(const WeekReward(missedDay: true)).label,
        'Missed a day’s lesson this week',
      );
      // A 0 XP bonus never reads "+0 XP".
      expect(t(const WeekReward(earned: true, paid: 0)).label, 'Week complete');
      expect(t(const WeekReward()).label, 'Week trophy');
      // An older server says nothing: a shut, plain trophy.
      final WeekTrophy none = t(null);
      expect(
        (none.open, none.label, none.missed),
        (false, 'Week trophy', false),
      );
    });
  });

  group('the week card’s claims', () {
    test('each status has its word; a claim not ready says when it opens', () {
      PostClaim c(ClaimStatus s, {String? opens}) => PostClaim(
        kind: ClaimKind.video,
        status: s,
        opensOnKey: opens,
        points: 40,
      );
      expect(claimWord(c(ClaimStatus.approved)), 'Done');
      expect(claimWord(c(ClaimStatus.pending)), 'Pending');
      expect(claimWord(c(ClaimStatus.rejected)), 'Rejected');
      expect(claimWord(c(ClaimStatus.open)), 'Share link');
      // 13 Nov 2026 is a Friday — read as a calendar date.
      expect(
        claimWord(c(ClaimStatus.notReady, opens: '2026-11-13')),
        'Opens Fri',
      );
      expect(claimWord(c(ClaimStatus.notReady)), '+40');
    });
  });

  group('the board', () {
    test('before it opens, it names the day and the last ten days', () {
      expect(
        boardLockedLine('2027-02-20'),
        'The leaderboard opens on Saturday, 20 February — the last 10 days of the contest. Until then, it’s you against yesterday: keep your streak.',
      );
      expect(
        boardLockedLine(''),
        startsWith('The leaderboard opens in the contest’s last days'),
      );
    });

    test('says how far it is to the next place that matters', () {
      const List<BoardRow> rows = <BoardRow>[
        BoardRow(
          rank: 1,
          name: 'Aarav R',
          total: 2410,
          streak: 20,
          level: 'B2',
        ),
        BoardRow(rank: 2, total: 2165, streak: 18, level: 'B2'),
        BoardRow(rank: 3, name: 'Sana J', total: 1980, streak: 17, level: 'C1'),
        BoardRow(
          rank: 4,
          name: 'Me',
          isViewer: true,
          total: 1240,
          streak: 17,
          level: 'B2',
        ),
      ];
      final BoardRow viewer = rows.last;
      expect(
        gapLine(rows, viewer, 10),
        'You are a finalist. 741 XP to pass #3.',
      );
      expect(
        gapLine(rows, viewer.copyWith(rank: 1), 10),
        'You lead. Keep the streak going.',
      );
      expect(
        gapLine(rows, viewer.copyWith(rank: 12, total: 100), 3),
        '1,881 XP to reach the top 3.',
      );
      expect(
        gapLine(rows, null, 10),
        'Most consistent and most correct leads.',
      );
      expect(
        gapLine(const <BoardRow>[], viewer.copyWith(rank: 30), 10),
        'Most consistent and most correct leads.',
      );
    });
  });

  group('the lesson’s lines', () {
    test('never promise a lesson the server has not', () {
      expect(
        tomorrowLine(const TodayQuiz(tomorrow: true)),
        'A new lesson tomorrow.',
      );
      expect(
        tomorrowLine(const TodayQuiz(tomorrow: false)),
        'No lesson tomorrow.',
      );
      expect(tomorrowLine(const TodayQuiz()), isNull);
      expect(tomorrowLine(null), isNull);
    });

    test('only bank_ended says why there is no lesson', () {
      expect(
        noQuizLine(const TodayQuiz(reason: QuizReason.bankEnded)),
        'The lesson questions for your level have run out, so there is no lesson today.',
      );
      expect(
        noQuizLine(const TodayQuiz(reason: QuizReason.notStarted)),
        'There is no lesson at your level today.',
      );
    });

    test('paused scoring never promises the answers will count later', () {
      expect(kQuizPausedLine, contains('not now and not later'));
      expect(kQuizUnscoredLine, contains('not now and not later'));
    });
  });

  group('dates', () {
    test('a day key is a calendar date, whatever the device’s timezone', () {
      expect(dayKeyDate('2027-02-15'), DateTime.utc(2027, 2, 15));
      expect(dayKeyShort('2027-02-15'), '15 Feb 2027');
      expect(dayKeyLong('2027-02-20'), 'Saturday, 20 February');
      expect(planDate(dayKeyDate('2026-11-18')!), 'Wednesday, 18 Nov');
      expect(weekdayOfKey('2026-11-08'), 0);
      expect(weekdayOfKey('2026-11-14'), 6);
    });

    test('anything that is not a real day key is none', () {
      expect(dayKeyDate(null), isNull);
      expect(dayKeyDate(''), isNull);
      expect(dayKeyDate('2027-02-30'), isNull);
      expect(dayKeyDate('15 Feb 2027'), isNull);
      expect(dayKeyShort('nope'), '');
    });
  });

  group('routing on the KIND, never the href', () {
    test('each kind opens its own screen', () {
      final Map<PathNodeKind, String> want = <PathNodeKind, String>{
        PathNodeKind.lesson: ZaveRoutes.contestLesson,
        PathNodeKind.comment: ZaveRoutes.contestComment,
        PathNodeKind.feedComments: ZaveRoutes.contestFeedComments,
        PathNodeKind.weeklyInvites: ZaveRoutes.contestInvites,
        PathNodeKind.planWeek: ZaveRoutes.contestPlan,
        PathNodeKind.connectLeaders: '/connections?from=contest',
      };
      want.forEach((PathNodeKind kind, String route) {
        // An href the app has never registered, to prove it is not read.
        expect(
          contestLevelRoute(_task(kind, href: '/somewhere/else')),
          route,
          reason: kind.name,
        );
      });
    });

    test('a claim opens its piece, its occurrence sent back unchanged', () {
      final String route = contestLevelRoute(
        _task(PathNodeKind.video, claim: _claim, href: '/x'),
      )!;
      final Uri uri = Uri.parse(route);
      expect(uri.path, ZaveRoutes.contestClaim);
      expect(uri.queryParameters, <String, String>{
        'kind': 'video',
        'occurrence': '6:1:2',
      });
      expect(contestClaimRoute(ClaimKind.unknown, '6:1'), isNull);
      expect(contestClaimRoute(ClaimKind.article, ''), isNull);
    });

    test('a level that does not open has nowhere to go', () {
      for (final PathNodeState s in <PathNodeState>[
        PathNodeState.locked,
        PathNodeState.missed,
        PathNodeState.unavailable,
        PathNodeState.revoked,
      ]) {
        expect(
          contestLevelRoute(_task(PathNodeKind.comment, state: s, href: null)),
          isNull,
          reason: s.name,
        );
      }
      expect(contestLevelRoute(_task(PathNodeKind.unknown)), isNull);
    });

    test('the next level after a finished one, or back to the path', () {
      final ContestPath path = ContestPath(
        status: ContestPathStatus.running,
        days: <PathDay>[
          _today(<PathNode>[
            _lesson(3, PathNodeState.done),
            _task(PathNodeKind.comment),
          ]),
        ],
      );
      final NextLevel next = nextOpenLevel(path, PathNodeKind.lesson);
      expect(next.route, ZaveRoutes.contestComment);
      expect(next.label, 'Next: Comment on a top voice');
      expect(next.isBackToPath, isFalse);

      // The path still shows the level just finished: back to the path.
      expect(
        nextOpenLevel(path, PathNodeKind.comment).label,
        'Back to the path',
      );
      expect(nextOpenLevel(path, PathNodeKind.comment).isBackToPath, isTrue);
      // No path yet, or nothing left today.
      expect(
        nextOpenLevel(null, PathNodeKind.lesson).route,
        ZaveRoutes.contest,
      );
      expect(
        nextOpenLevel(
          ContestPath(
            status: ContestPathStatus.running,
            days: <PathDay>[
              _today(<PathNode>[_lesson(3, PathNodeState.done)]),
            ],
          ),
          PathNodeKind.lesson,
        ).label,
        'Back to the path',
      );
    });
  });
}

const NodeClaim _claim = NodeClaim(kind: ClaimKind.video, occurrence: '6:1:2');

PathNode _lesson(int index, PathNodeState state, {int? start, int? end}) =>
    PathNode(
      id: '2026-11-11:lesson:$index',
      kind: PathNodeKind.lesson,
      state: state,
      title: 'Lesson · part $index of 3',
      points: index == 3 ? 50 : 0,
      href: state == PathNodeState.today || state == PathNodeState.done
          ? '/contest/lesson'
          : null,
      part: NodePart(index: index, total: 3, start: start, end: end),
    );

const Map<PathNodeKind, String> _titles = <PathNodeKind, String>{
  PathNodeKind.comment: 'Comment on a top voice',
  PathNodeKind.feedComments: 'Post 5 valuable comments',
  PathNodeKind.planWeek: 'Plan this week',
  PathNodeKind.video: 'Share your video’s link',
};

PathNode _task(
  PathNodeKind kind, {
  PathNodeState state = PathNodeState.today,
  int points = 40,
  bool started = false,
  String? href = '/contest/x',
  NodeClaim? claim,
}) => PathNode(
  id: '2026-11-11:${kind.wire}',
  kind: kind,
  state: state,
  title: _titles[kind] ?? kind.name,
  points: points,
  href: href,
  started: started,
  claim: claim,
);

PathDay _today(List<PathNode> nodes) => PathDay(
  dayNumber: 17,
  dayKey: '2026-11-11',
  weekday: 3,
  isToday: true,
  nodes: nodes,
);

final List<PathDay> _week = <PathDay>[
  PathDay(
    dayNumber: 15,
    dayKey: '2026-11-09',
    weekday: 1,
    nodes: <PathNode>[_lesson(1, PathNodeState.done)],
  ),
  _today(<PathNode>[
    _lesson(1, PathNodeState.done),
    _lesson(2, PathNodeState.today),
    _lesson(3, PathNodeState.locked),
    _task(PathNodeKind.comment, state: PathNodeState.locked, href: null),
  ]),
];
