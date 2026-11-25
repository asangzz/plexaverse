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
      expect(stateWord(PathNodeState.skipped), 'Skipped, still open today');
    });

    test('Skip’s words are the web’s', () {
      expect(kSkipLabel, 'Skip this level');
      expect(kSkipPartLabel, 'Skip this part');
      expect(
        kSkipNote,
        'It stays open until the day ends. Its XP counts only if you come '
        'back to it.',
      );
    });

    test('every kind has its kicker', () {
      expect(kindWord(PathNodeKind.lesson), 'Lesson');
      expect(kindWord(PathNodeKind.connectLeaders), 'LinkedIn · Connect');
      expect(kindWord(PathNodeKind.comment), 'LinkedIn · Comment');
      expect(kindWord(PathNodeKind.feedComments), 'LinkedIn · Feed comments');
      expect(kindWord(PathNodeKind.weeklyInvites), 'LinkedIn · Invites');
      expect(kindWord(PathNodeKind.planWeek), 'Planner · Set up the week');
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
      // A skipped level is still open: Start, or Continue once part done.
      expect(
        actionWord(_task(PathNodeKind.comment, state: PathNodeState.skipped)),
        'Start +40 XP',
      );
      expect(
        actionWord(
          _task(
            PathNodeKind.feedComments,
            state: PathNodeState.skipped,
            started: true,
            points: 60,
          ),
        ),
        'Continue +60 XP',
      );
      expect(
        canOpen(_task(PathNodeKind.comment, state: PathNodeState.skipped)),
        isTrue,
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

    test('START falls back to the first skipped level once nothing else is '
        'open', () {
      // An open level beats a skipped one before it.
      final List<PathDay> withOpen = <PathDay>[
        _today(<PathNode>[
          _lesson(1, PathNodeState.done),
          _lesson(2, PathNodeState.skipped),
          _lesson(3, PathNodeState.today),
        ]),
      ];
      expect(currentNodeId(withOpen), '2026-11-11:lesson:3');
      expect(openLevelOf(withOpen)!.id, '2026-11-11:lesson:3');
      // Nothing open: START goes back to the first skipped — but the open
      // level a skip leads to is none.
      final List<PathDay> allSkipped = <PathDay>[
        _today(<PathNode>[
          _lesson(1, PathNodeState.done),
          _lesson(2, PathNodeState.skipped),
          _lesson(3, PathNodeState.done),
          _task(PathNodeKind.comment, state: PathNodeState.skipped),
        ]),
      ];
      expect(currentNodeId(allSkipped), '2026-11-11:lesson:2');
      expect(openLevelOf(allSkipped), isNull);
      // Sunday's late node, open after skipped levels, wins over them.
      final List<PathDay> late = <PathDay>[
        _today(<PathNode>[
          _task(PathNodeKind.comment, state: PathNodeState.skipped),
          _task(PathNodeKind.planWeek, state: PathNodeState.done, points: 0),
          _task(PathNodeKind.video),
        ]),
      ];
      expect(currentNodeId(late), '2026-11-11:video');
      expect(openLevelOf(late)!.id, '2026-11-11:video');
      expect(openLevelOf(<PathDay>[_week[0]]), isNull);
    });

    test('START never lands on an open-all-week Sunday level while a gated '
        'level of today is open, nor while one is skipped', () {
      // Sunday with its own comment open and the set-up steps open after it.
      final List<PathDay> sunday = <PathDay>[
        _sunday(<PathNode>[
          _task(PathNodeKind.comment, id: '2026-11-08:comment'),
          _setup(0, SetupStep.post),
          _setup(0, SetupStep.image, state: PathNodeState.locked),
        ]),
      ];
      expect(currentNodeId(sunday), '2026-11-08:comment');
      expect(openLevelOf(sunday)!.id, '2026-11-08:comment');
      // A Sunday level listed FIRST still waits behind today's own level.
      expect(
        currentNodeId(<PathDay>[
          _sunday(<PathNode>[
            _setup(0, SetupStep.post),
            _task(PathNodeKind.comment, id: '2026-11-08:comment'),
          ]),
        ]),
        '2026-11-08:comment',
      );
      // A skipped level is something that can only be done today: it beats
      // a Sunday level too.
      final List<PathDay> skipped = <PathDay>[
        _sunday(<PathNode>[
          _task(
            PathNodeKind.comment,
            id: '2026-11-08:comment',
            state: PathNodeState.skipped,
          ),
          _setup(0, SetupStep.post),
        ]),
      ];
      expect(currentNodeId(skipped), '2026-11-08:comment');
      // Nothing else left today: the first open Sunday level, never a
      // locked one.
      final List<PathDay> rest = <PathDay>[
        _sunday(<PathNode>[
          _task(
            PathNodeKind.comment,
            id: '2026-11-08:comment',
            state: PathNodeState.done,
          ),
          _setup(0, SetupStep.post, state: PathNodeState.done),
          _setup(0, SetupStep.image, state: PathNodeState.locked),
          _setup(2, SetupStep.post),
        ]),
      ];
      expect(currentNodeId(rest), '2026-11-08:plan_week:post:2');
      expect(openLevelOf(rest)!.id, '2026-11-08:plan_week:post:2');
    });

    test('a Sunday level shown open on a past Sunday is never START', () {
      final List<PathDay> week = <PathDay>[
        PathDay(
          dayNumber: 15,
          dayKey: '2026-11-08',
          nodes: <PathNode>[_setup(2, SetupStep.post)],
        ),
        _today(<PathNode>[_lesson(3, PathNodeState.done)]),
      ];
      expect(currentNodeId(week), isNull);
      expect(openLevelOf(week), isNull);
    });

    test('a Sunday level says "Open all week", and "Day passed" with its '
        'reason once its day has gone', () {
      expect(nodeStateWord(_setup(2, SetupStep.post)), 'Open all week');
      final PathNode passed = _setup(
        0,
        SetupStep.image,
        state: PathNodeState.missed,
        detail: 'Day passed — Monday’s image was not added',
      );
      expect(isDayPassed(passed), isTrue);
      expect(nodeStateWord(passed), 'Day passed');
      expect(dayPassedReason(passed), 'Monday’s image was not added');
      expect(isOrange(passed), isFalse);
      expect(isOrange(_setup(2, SetupStep.post)), isTrue);
      expect(
        isOrange(_setup(0, SetupStep.post, state: PathNodeState.done)),
        isTrue,
      );
      expect(
        isOrange(_setup(2, SetupStep.image, state: PathNodeState.locked)),
        isFalse,
      );
      // Any other level keeps its own words: a missed past level is missed.
      final PathNode missed = _task(
        PathNodeKind.comment,
        state: PathNodeState.missed,
      );
      expect(isDayPassed(missed), isFalse);
      expect(nodeStateWord(missed), 'Missed');
      expect(nodeStateWord(_task(PathNodeKind.comment)), 'Open today');
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

    // Was "the lesson is done when its LAST part is": a part can be skipped
    // now (17 Nov 2026), so the last can be done before an earlier one.
    test('the lesson is done when EVERY part is', () {
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
      // The old rule called this done.
      expect(
        isLessonDone(
          _today(<PathNode>[
            _lesson(1, PathNodeState.done),
            _lesson(2, PathNodeState.skipped),
            _lesson(3, PathNodeState.done),
          ]),
        ),
        isFalse,
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

    test('with WHICH questions are answered, a part counts its own', () {
      // 15 → 5/5/5. Part 2 skipped with two answered, part 3 one answered:
      // a count of 3 would read part 2 as nothing and part 3 as nothing.
      final PathNode two = _lesson(2, PathNodeState.skipped, start: 5, end: 10);
      final PathNode three = _lesson(
        3,
        PathNodeState.today,
        start: 10,
        end: 15,
      );
      final Set<int> which = <int>{0, 1, 2, 3, 4, 5, 6, 10};
      expect(
        partProgress(two, answered: 8, total: 15, answeredIndexes: which),
        0.4,
      );
      expect(
        partProgress(three, answered: 8, total: 15, answeredIndexes: which),
        0.2,
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
        'The top learners show on Saturday, 20 February — the last 10 days of the round. Until then, it’s you against yesterday: keep your streak.',
      );
      expect(
        boardLockedLine(''),
        startsWith('The top learners show in the round’s last days'),
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
        // "Follow last round's top learners" (24 Nov 2026).
        PathNodeKind.followWinners: ZaveRoutes.contestFollow,
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

    test('a Sunday set-up level opens the Planner tab; "Plan this week" its '
        'own page', () {
      // Its day's sheet of this week: post and image steps alike.
      final String? route = contestLevelRoute(_setup(2, SetupStep.post));
      final Uri uri = Uri.parse(route!);
      expect(uri.path, ZaveRoutes.planner);
      expect(uri.queryParameters['day'], '2');
      // The week the server's link names — counted on the round's day, not
      // the planner's own "this week" (which can differ around midnight).
      expect(uri.queryParameters['week'], '6');
      expect(
        Uri.parse(
          contestLevelRoute(_setup(2, SetupStep.post, href: '/planner?setup=1'))!,
        ).queryParameters.containsKey('week'),
        isFalse,
        reason: 'no week in the link: the planner opens its own week',
      );
      // A per-tap token, so tapping the same level again reopens its day.
      expect(uri.queryParameters['at'], isNotEmpty);
      expect(isContestTabRoute(route), isTrue);
      expect(
        Uri.parse(
          contestLevelRoute(_setup(4, SetupStep.image))!,
        ).queryParameters['day'],
        '4',
      );
      expect(isContestTabRoute(ZaveRoutes.planner), isTrue);
      expect(
        contestLevelRoute(_task(PathNodeKind.planWeek)),
        ZaveRoutes.contestPlan,
      );
      expect(isContestTabRoute(ZaveRoutes.contestPlan), isFalse);
      // A passed one opens nothing.
      expect(
        contestLevelRoute(
          _setup(0, SetupStep.post, state: PathNodeState.missed, href: null),
        ),
        isNull,
      );
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

    test('a skipped lesson part opens on itself', () {
      final PathNode two = _lesson(
        2,
        PathNodeState.skipped,
      ).copyWith(href: '/contest/lesson?part=2');
      expect(contestLevelRoute(two), '${ZaveRoutes.contestLesson}?part=2');
      expect(
        contestLevelRoute(_lesson(3, PathNodeState.today)),
        ZaveRoutes.contestLesson,
      );
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

      // After "I've planned this week" the next level is Sunday's first
      // set-up step — the same kind, plan_week, but a level of its own.
      final ContestPath planned = ContestPath(
        status: ContestPathStatus.running,
        days: <PathDay>[
          _sunday(<PathNode>[
            _lesson(3, PathNodeState.done),
            _setup(0, SetupStep.post),
          ]),
        ],
      );
      final NextLevel afterPlan = nextOpenLevel(
        planned,
        PathNodeKind.planWeek,
      );
      expect(afterPlan.isBackToPath, isFalse);
      expect(Uri.parse(afterPlan.route).path, ZaveRoutes.planner);

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
  String? id,
}) => PathNode(
  id: id ?? '2026-11-11:${kind.wire}',
  kind: kind,
  state: state,
  title: _titles[kind] ?? kind.name,
  points: points,
  href: href,
  started: started,
  claim: claim,
);

/// One of the open-all-week Sunday levels, on the week's Sunday.
PathNode _setup(
  int day,
  SetupStep step, {
  PathNodeState state = PathNodeState.today,
  String? href = '/planner?week=6&setup=1',
  String? detail,
}) => PathNode(
  id: '2026-11-08:plan_week:${step.wire}:$day',
  kind: PathNodeKind.planWeek,
  state: state,
  title: step == SetupStep.post ? 'Write a post' : 'Add an image',
  href: href,
  detail: detail,
  setup: NodeSetup(dayIndex: day, step: step),
  openAllWeek: true,
);

/// Today, a Sunday.
PathDay _sunday(List<PathNode> nodes) =>
    PathDay(dayNumber: 15, dayKey: '2026-11-08', isToday: true, nodes: nodes);

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
