import 'dart:typed_data';

import '../../../core/week/week_shape.dart';
import '../domain/contest_dates.dart';
import '../domain/contest_links.dart';
import '../domain/contest_repository.dart';
import '../domain/linkedin_profile_url.dart';
import '../domain/contest_words.dart';
import '../domain/lesson_parts.dart';
import '../domain/levels_words.dart';

/// Which round of levels the mock flavor shows.
///
/// [running] is the default: a learner on a Wednesday mid-path — the
/// lesson's second part half answered, the comment level locked behind it,
/// and last round's top learners to follow at the end; up on Sunday, the
/// week's open-all-week set-up levels (Monday's post done, its image's day
/// passed, Wednesday's and Friday's open, their images locked behind them).
/// The others are the states the levels page branches on, each reachable
/// without a server:
///
/// ```sh
/// flutter run -t lib/main_mock.dart --dart-define=FAKE_CONTEST=not_joined
/// ```
enum FakeContestScenario {
  running,

  /// No round running, recently ended or scheduled: the overview is null.
  noContest,

  /// A running round the user has no place in yet. Reading is joining (24
  /// Nov 2026): the first read of the overview or the path enters them, on
  /// today, with the days before it missed.
  notJoined,

  /// A round that starts in a few days; the first read enters them.
  upcoming,

  /// A round that ended last week, with no next one yet (automatic rounds
  /// switched off); the user took part.
  ended,

  /// The round's last days: the board is open and the user has a rank.
  revealed,

  /// The free days are over and there is no plan: scoring has stopped.
  paused;

  /// `--dart-define=FAKE_CONTEST=<scenario>`, spelt as the wire would
  /// (`not_joined`) or as the enum is (`notJoined`). Anything else is
  /// [running].
  static FakeContestScenario fromEnvironment() =>
      parse(const String.fromEnvironment('FAKE_CONTEST'));

  static FakeContestScenario parse(String raw) {
    final String key = raw.replaceAll('_', '').toLowerCase();
    for (final FakeContestScenario s in FakeContestScenario.values) {
      if (s.name.toLowerCase() == key) return s;
    }
    return FakeContestScenario.running;
  }
}

/// The contest the mock flavor plays against: the server's state for one
/// scenario, and the server's rules for moving it.
///
/// ## Why it is a server, not a set of canned answers
///
/// The contest's screens are thin on purpose — the path, the gate, the
/// streak and every verdict are the server's. A fake that returned fixed JSON
/// would show a lesson part that never fills, a comment level that never
/// unlocks and a gate that never moves, and the mock build is what this app
/// is tested by hand on. So this keeps state, and answers every call the way
/// `lib/services/contest-*.service.ts` would: grading answers HERE (and only
/// here — the app never grades), gating today's levels in path order,
/// refusing with the server's codes and sentences.
///
/// ## Module-level, one per scenario
///
/// The repository is rebuilt whenever its provider is; a contest that forgot
/// every answer on a rebuild would be a different bug from any real one.
/// [reset] is for tests.
class FakeContestWorld {
  FakeContestWorld._(this.scenario) {
    _seed();
  }

  final FakeContestScenario scenario;

  static final Map<FakeContestScenario, FakeContestWorld> _worlds =
      <FakeContestScenario, FakeContestWorld>{};

  static FakeContestWorld of(FakeContestScenario scenario) =>
      _worlds.putIfAbsent(scenario, () => FakeContestWorld._(scenario));

  /// Forget every scenario's progress.
  static void reset() => _worlds.clear();

  // ── The calendar ─────────────────────────────────────────────────────────
  //
  // Fixed dates, so a fixture reads the same on any day it is run. Every
  // "today" is a Wednesday: a post day of the playbook week (Mon post, Tue
  // rest, Wed post, Thu article, Fri post, the weekend off).

  late final String? _firstKey;
  late final String? _lastKey;
  late final String _todayKey;

  /// The user's planner week holding today, and its journey number. The
  /// claims' occurrences are built from these, as the server builds them.
  late final int _plannerWeek;
  static const int _journey = 1;

  bool get _hasContest => _firstKey != null;

  /// The window, for a scenario that has a contest — every caller checks
  /// [_hasContest] first.
  String get _first => _firstKey!;
  String get _last => _lastKey!;
  int get _dayNumber => _daysBetween(_first, _todayKey) + 1;
  int get _finalDay => _daysBetween(_first, _last) + 1;
  int get _revealDay => _finalDay - kLeaderboardRevealDays + 1 < 1
      ? 1
      : _finalDay - kLeaderboardRevealDays + 1;

  ContestPhase get _phase {
    if (_todayKey.compareTo(_first) < 0) return ContestPhase.upcoming;
    if (_todayKey.compareTo(_last) > 0) return ContestPhase.ended;
    return ContestPhase.running;
  }

  bool get _running => _hasContest && _phase == ContestPhase.running;
  bool get _revealed =>
      _phase == ContestPhase.ended || _dayNumber >= _revealDay;
  int get _weekday => _weekdayOf(_todayKey);

  // ── The entry ────────────────────────────────────────────────────────────

  bool _joined = false;
  DateTime? _joinedAt;

  /// Joined during this run: every earlier day of the week is missed, and
  /// today's lesson has not been opened.
  bool _fresh = false;
  int _freeDays = 30;
  int _total = 0;
  int _streak = 0;
  int _bestStreak = 0;
  int _correctCount = 0;
  int _wrongCount = 0;

  bool get _scoringPaused => scenario == FakeContestScenario.paused;

  // ── Today ────────────────────────────────────────────────────────────────

  bool _started = false;

  /// An answer reached the server before the lesson was opened: the day is
  /// the set questions alone, for good — the server's own trap, kept.
  bool _setOnly = false;
  final List<_Given> _answers = <_Given>[];
  bool _lessonCredited = false;
  bool _finishBonusPaid = false;

  bool _commentOpened = false;
  CommentFirstTry? _commentFirstTry;
  bool _commentDone = false;
  int _commentPaid = 0;

  final List<String> _feedLinks = <String>[];
  final List<int> _feedPaid = <int>[];

  bool _connectDone = false;
  int _connectPaid = 0;
  bool _invitesDone = false;
  int _invitesPaid = 0;
  bool _planDone = false;

  final Map<String, _ClaimRow> _claimRows = <String, _ClaimRow>{};

  /// Today's skipped node ids — `contest_level_skips`. Skips only ever
  /// affect their own day, and every fixture's today is fixed.
  final Set<String> _skipped = <String>{};

  void _seed() {
    switch (scenario) {
      case FakeContestScenario.noContest:
        _firstKey = null;
        _lastKey = null;
        _todayKey = '2026-11-11';
        _plannerWeek = 6;
      case FakeContestScenario.upcoming:
        _firstKey = '2026-11-15';
        _lastKey = '2027-02-22';
        _todayKey = '2026-11-11';
        _plannerWeek = 6;
      case FakeContestScenario.ended:
        _firstKey = '2026-07-26';
        _lastKey = '2026-11-02';
        _todayKey = '2026-11-11';
        _plannerWeek = 6;
      case FakeContestScenario.revealed:
        _firstKey = '2026-11-01';
        _lastKey = '2027-02-08';
        _todayKey = '2027-02-03';
        _plannerWeek = 18;
      case FakeContestScenario.running:
      case FakeContestScenario.notJoined:
      case FakeContestScenario.paused:
        _firstKey = '2026-11-01';
        _lastKey = '2027-02-08';
        _todayKey = '2026-11-11';
        _plannerWeek = 6;
    }
    if (scenario == FakeContestScenario.paused) _freeDays = 7;

    final bool seasoned = switch (scenario) {
      FakeContestScenario.running ||
      FakeContestScenario.paused ||
      FakeContestScenario.revealed ||
      FakeContestScenario.ended => true,
      _ => false,
    };
    if (!seasoned) return;

    _joined = true;
    _joinedAt = _instant(_first).add(const Duration(hours: 9));
    _total = switch (scenario) {
      FakeContestScenario.revealed => 9840,
      FakeContestScenario.ended => 6215,
      _ => 1240,
    };
    _streak = scenario == FakeContestScenario.revealed ? 14 : 10;
    _bestStreak = scenario == FakeContestScenario.revealed ? 31 : 10;
    _correctCount = scenario == FakeContestScenario.revealed ? 412 : 40;
    _wrongCount = scenario == FakeContestScenario.revealed ? 58 : 9;

    if (scenario == FakeContestScenario.ended) return;

    // Today is half done: part 1 finished, two of part 2 answered.
    _started = true;
    for (int i = 0; i < 7; i++) {
      final _Question q = _questions[i];
      // The fifth (a reading question) was missed; the rest were right.
      final String value = i == 4 ? q.options[(q.correct + 1) % 4] : q.answer;
      _answers.add(
        _Given(
          itemId: q.idFor(_dayNumber),
          value: value,
          correct: value == q.answer,
          own: q.own,
          // Given today, after the free days ran out: never paid.
          pointsApplied: _scoringPaused
              ? null
              : _answerPoints(right: value == q.answer, own: q.own),
        ),
      );
    }
    _claimRows['${_plannerWeek - 1}:$_journey:4'] = const _ClaimRow(
      status: ClaimStatus.rejected,
      postUrl:
          'https://www.linkedin.com/posts/your-name_how-i-say-no-to-a-deadline-activity-7392000000000000000-wxyz',
      rejectReason: 'The link opens a different post.',
    );
  }

  // ── The consistency meter ────────────────────────────────────────────────

  /// `GET /contest/consistency` — the meter over an IST calendar month.
  ///
  /// The days before today are a fixed history (the server rebuilds them
  /// from rows this fake does not keep); today is read off this world's own
  /// path, so finishing or skipping a level moves the figure as the server's
  /// would. The states follow `getConsistency`: anything on offer is
  /// measuring; a running contest the learner has not joined is not_joined;
  /// no counted day and no contest running is no_contest; else no_tasks.
  ConsistencyView consistency() {
    final String monthStart = '${_todayKey.substring(0, 8)}01';
    final DateTime month = _utc(monthStart);
    final ConsistencyWindow window = ConsistencyWindow(
      from: _instant(monthStart),
      to: _instant(_keyOf(DateTime.utc(month.year, month.month + 1))),
      basis: 'calendar',
    );
    if (!_hasContest) {
      return ConsistencyView(
        state: ConsistencyState.noContest,
        window: window,
        noContestRunning: true,
      );
    }
    if (_running && !_joined) {
      return ConsistencyView(
        state: ConsistencyState.notJoined,
        window: window,
        joined: false,
      );
    }
    if (_phase == ContestPhase.upcoming) {
      return ConsistencyView(
        state: ConsistencyState.noContest,
        window: window,
        noContestRunning: true,
      );
    }

    final List<ConsistencyDay> days = <ConsistencyDay>[];
    // A fresh joiner has no history; the ended scenario's is all there is.
    if (!_fresh) {
      final (int earned, int available) = switch (scenario) {
        FakeContestScenario.revealed => (2880, 3200),
        _ => (1820, 2600),
      };
      final String yesterday = _addDays(_todayKey, -1);
      days.add(
        ConsistencyDay(dayKey: yesterday, available: available, earned: earned),
      );
    }

    ConsistencyToday? today;
    if (_running) {
      int available = 0;
      int earned = 0;
      int pending = 0;
      for (final PathNode n in path().today?.nodes ?? const <PathNode>[]) {
        if (n.state == PathNodeState.unavailable) continue;
        // The follow level counts on neither side (FOLLOW_WINNER_KIND in
        // the web's lib/consistency.ts).
        if (n.kind == PathNodeKind.followWinners) continue;
        final int offer = n.isLesson ? n.points : (_rulePoints[n.kind] ?? 0);
        available += offer;
        switch (n.state) {
          case PathNodeState.done || PathNodeState.approved:
            earned += n.kind == PathNodeKind.feedComments
                ? _feedPaid.fold(0, (int a, int b) => a + b)
                : n.points;
          case PathNodeState.pending:
            pending += offer;
          // Each feed comment is paid as it lands and stays earned, so a
          // part-done level keeps its paid shares when it is skipped too.
          case PathNodeState.today || PathNodeState.skipped
              when n.kind == PathNodeKind.feedComments:
            earned += _feedPaid.fold(0, (int a, int b) => a + b);
          default:
            break;
        }
      }
      // Paused days count on neither side.
      final bool paused = _scoringPaused;
      days.add(
        ConsistencyDay(
          dayKey: _todayKey,
          available: paused ? 0 : available,
          earned: paused ? 0 : earned,
          pending: paused ? 0 : pending,
          paused: paused,
          today: true,
        ),
      );
      today = ConsistencyToday(
        dayKey: _todayKey,
        earned: paused ? 0 : earned,
        available: paused ? 0 : available,
      );
    }

    const int threshold = 75;
    final int earned = days.fold(0, (int a, ConsistencyDay d) => a + d.earned);
    final int available = days.fold(
      0,
      (int a, ConsistencyDay d) => a + d.available,
    );
    final int pending = days.fold(
      0,
      (int a, ConsistencyDay d) => a + d.pending,
    );
    final bool measuring = available > 0;
    final int line = (threshold * available + 99) ~/ 100;
    return ConsistencyView(
      state: measuring
          ? ConsistencyState.measuring
          : days.isEmpty && !_running
          ? ConsistencyState.noContest
          : ConsistencyState.noTasks,
      threshold: threshold,
      percent: measuring ? (100 * earned) ~/ available : null,
      atOrAbove: measuring ? earned * 100 >= threshold * available : null,
      earned: earned,
      available: available,
      pending: pending,
      toLine: measuring ? (line - earned < 0 ? 0 : line - earned) : 0,
      countedDays: days.where((ConsistencyDay d) => !d.paused).length,
      window: window,
      today: today,
      joined: _running ? _joined : null,
      scoringPaused: days.any((ConsistencyDay d) => d.paused),
      noContestRunning: !_running,
      days: days,
    );
  }

  // ── The shoutout ─────────────────────────────────────────────────────────

  /// The viewer's `contest_shoutout` consent, and the profile link given for
  /// it. Off until they agree, as the server's ledger starts.
  bool _shoutoutOn = false;
  String? _shoutoutLink;

  /// "I am 18 or older" on record — the app's own sign-up never asks, so the
  /// "Feature me" card does, and records it with the yes.
  bool _adultDeclared = false;

  /// `GET /contest/featured` — the server's `getContestFeatured`.
  ///
  /// The week's learners only for an entrant of a running contest whose
  /// lesson for today is finished, and only for a week that ended after the
  /// contest began; in this fixture, six fixed learners who agreed to be
  /// featured, in an order that is not their XP's. The Hall of Fame holds a
  /// contest finalised in the last 30 days where this scenario has one: the
  /// ended contest, and — between contests — the last one.
  ///
  /// The viewer is never one of this fixture's winners (`viewerPlaced`
  /// false), so outside a contest they joined the card is not offered.
  ContestFeatured featured() =>
      ContestFeatured(week: _learnersOfWeek(), hallOfFame: _hallOfFame());

  LearnersOfWeek _learnersOfWeek() {
    if (!_running || !_joined) return const LearnersOfWeek();
    if (!_lessonComplete) {
      return const LearnersOfWeek(state: LearnersOfWeekState.afterLesson);
    }
    final String thisWeek = _weekSunday(_todayKey);
    // A week that ended before the contest began holds no contest XP.
    if (thisWeek.compareTo(_first) <= 0) {
      return const LearnersOfWeek(state: LearnersOfWeekState.noWeek);
    }
    return LearnersOfWeek(
      state: LearnersOfWeekState.ready,
      weekStart: _addDays(thisWeek, -7),
      weekEnd: _addDays(thisWeek, -1),
      learners: _weekLearners,
    );
  }

  static const List<FeaturedPerson> _weekLearners = <FeaturedPerson>[
    FeaturedPerson(
      key: '3f9a1c27b0d4e815',
      name: 'Meera Iyer',
      headline: 'Product designer · Bengaluru',
      linkedinUrl: 'https://www.linkedin.com/in/plexaverse-demo-learner-1',
    ),
    FeaturedPerson(
      key: '41c07e9d2a6b3f58',
      name: 'Kabir Mehta',
      headline: 'Data analyst learning to present to leadership',
      linkedinUrl: 'https://www.linkedin.com/in/plexaverse-demo-learner-2',
    ),
    FeaturedPerson(
      key: '5b2e8f0a91c7d643',
      name: 'Ananya Ghosh',
      linkedinUrl: 'https://www.linkedin.com/in/plexaverse-demo-learner-3',
    ),
    FeaturedPerson(
      key: '6d71a3e5c0f2b984',
      name: 'Rohan Pillai',
      headline: 'Site reliability engineer',
      linkedinUrl: 'https://www.linkedin.com/in/plexaverse-demo-learner-4',
    ),
    FeaturedPerson(
      key: '7e04c9b2d8a15f36',
      name: 'Sana Jain',
      headline: 'HR business partner',
    ),
    FeaturedPerson(
      key: '8a63f1d07b2ec594',
      name: 'Arjun Nair',
      headline: 'Founder, a two-person design studio',
      linkedinUrl: 'https://www.linkedin.com/in/plexaverse-demo-learner-5',
    ),
  ];

  List<HallOfFameEntry> _hallOfFame() {
    final String? finalisedOn = switch (scenario) {
      FakeContestScenario.ended => _addDays(_last, 2),
      FakeContestScenario.noContest => _addDays(_todayKey, -9),
      _ => null,
    };
    if (finalisedOn == null) return const <HallOfFameEntry>[];
    final DateTime finalisedAt = _instant(
      finalisedOn,
    ).add(const Duration(hours: 11));
    return <HallOfFameEntry>[
      HallOfFameEntry(
        contestId: 'fake-contest-finalised-$finalisedOn',
        title: 'Levels · Aug–Nov 2026',
        lastDayKey: _addDays(finalisedOn, -2),
        prizeTitle: 'a profile shoutout',
        rewardTopN: 10,
        finalisedAt: finalisedAt,
        featuredUntil: finalisedAt.add(const Duration(days: 30)),
        // Only the winners who agreed to be featured: places 3, 6 and 9
        // said no, and are simply not here.
        winners: const <HallOfFameWinner>[
          HallOfFameWinner(
            rank: 1,
            key: 'c41d0a9e7f3b2685',
            name: 'Aarav Rao',
            headline: 'Engineering manager · Pune',
            linkedinUrl:
                'https://www.linkedin.com/in/plexaverse-demo-learner-6',
          ),
          HallOfFameWinner(
            rank: 2,
            key: 'd52e1b0f8a4c3796',
            name: 'Ishita Bose',
            headline: 'Consultant, supply chain',
            linkedinUrl:
                'https://www.linkedin.com/in/plexaverse-demo-learner-7',
          ),
          HallOfFameWinner(
            rank: 4,
            key: 'e63f2c1a9b5d48a7',
            name: 'Neha Kulkarni',
            linkedinUrl:
                'https://www.linkedin.com/in/plexaverse-demo-learner-8',
          ),
          HallOfFameWinner(
            rank: 5,
            key: 'f7403d2b0c6e59b8',
            name: 'Dev Malhotra',
            headline: 'Sales lead, B2B software',
          ),
          HallOfFameWinner(
            rank: 7,
            key: '08514e3c1d7f6ac9',
            name: 'Tara Sen',
            headline: 'Teacher turned learning designer',
            linkedinUrl:
                'https://www.linkedin.com/in/plexaverse-demo-learner-9',
          ),
        ],
      ),
    ];
  }

  /// `GET /contest/shoutout`.
  ShoutoutSettings shoutout() => ShoutoutSettings(
    featured: _shoutoutOn,
    linkedinUrl: _shoutoutLink,
    adultDeclared: _adultDeclared,
  );

  /// `PUT /contest/shoutout` — the server's `setShoutout`. On needs a public
  /// profile link: the one sent, or the one on record; it is kept in its
  /// canonical form. Off is a withdrawal, which erases the link and never
  /// fails on one.
  ShoutoutSettings setShoutout({
    required bool featured,
    String? linkedinUrl,
    bool adult = false,
  }) {
    if (!featured) {
      _shoutoutOn = false;
      _shoutoutLink = null;
      return shoutout();
    }
    final String? sent = linkedinUrl != null && linkedinUrl.trim().isNotEmpty
        ? linkedinUrl
        : null;
    final String? url = sent != null
        ? normaliseLinkedInProfileUrl(sent)
        : profileHref(_shoutoutLink);
    if (url == null) {
      throw const ContestBadProfileLink(
        'Paste the link to your public LinkedIn profile, like '
        'https://www.linkedin.com/in/your-name.',
      );
    }
    // As the server: the 18+ declaration on record, or the card's tick.
    if (!_adultDeclared && !adult) throw const ContestAdultRequired();
    _adultDeclared = true;
    _shoutoutOn = true;
    _shoutoutLink = url;
    return shoutout();
  }

  // ── The overview and the board ───────────────────────────────────────────

  ContestOverview? overview() {
    if (!_hasContest) return null;
    _enterOnRead();
    return ContestOverview(
      contest: _contestInfo(),
      phase: _phase,
      dayNumber: _dayNumber,
      lengthDays: _finalDay,
      board: BoardReveal(
        revealed: _revealed,
        revealsOn: _addDays(_first, _revealDay - 1),
        revealDay: _revealDay,
      ),
      entry: _joined
          ? ContestEntryView(
              joinedAt: _joinedAt!,
              level: 'B1',
              total: _total,
              rank: _revealed ? _viewerRank : null,
              streak: _streak,
              bestStreak: _bestStreak,
              correctCount: _correctCount,
              wrongCount: _wrongCount,
              freeDaysLeft: _freeDaysLeft,
              scoringPaused: _scoringPaused,
            )
          : null,
      entrants: _entrants,
    );
  }

  int get _entrants => _joined ? 1284 : 1283;

  int get _freeDaysLeft {
    final int used = _daysBetween(_participationStartKey, _todayKey);
    final int left = _freeDays - used;
    return left < 0 ? 0 : left;
  }

  String get _participationStartKey {
    final String joinKey = _dayKeyOf(_joinedAt!);
    return joinKey.compareTo(_first) > 0 ? joinKey : _first;
  }

  ContestInfo _contestInfo() => ContestInfo(
    id: 'fake-contest-$_first',
    // The admin's name for the round. Never shown to a learner.
    title: 'Levels · Nov 2026–Feb 2027',
    // The owner's rule (22 Nov 2026): every prize is a profile shoutout —
    // never goods, never plan time, not even in a demo build.
    prizeTitle: 'a profile shoutout',
    startsAt: _instant(_first),
    endsAt: _instant(_addDays(_last, 1)),
    firstDayKey: _first,
    lastDayKey: _last,
    rewardTopN: 10,
    rewardMonths: 0,
    freeDays: _freeDays,
    weekComplete: 500,
  );

  int get _viewerRank => scenario == FakeContestScenario.ended ? 14 : 7;

  BoardResult board({int? limit}) {
    if (!_hasContest) return const BoardResult();
    final String revealsOn = _addDays(_first, _revealDay - 1);
    if (!_revealed) {
      return BoardResult(
        revealsOn: revealsOn,
        revealDay: _revealDay,
        self: _joined
            ? BoardSelf(total: _total, streak: _streak, level: 'B1')
            : null,
      );
    }
    final int n = (limit ?? 50).clamp(1, 200);
    final List<BoardRow> all = _rankedRows();
    final BoardRow? viewer = _joined
        ? all.firstWhere((BoardRow r) => r.isViewer)
        : null;
    return BoardResult(
      revealed: true,
      revealsOn: revealsOn,
      revealDay: _revealDay,
      rows: all.take(n).toList(),
      viewer: viewer,
      self: viewer == null
          ? null
          : BoardSelf(
              total: viewer.total,
              streak: viewer.streak,
              level: viewer.level,
            ),
    );
  }

  /// Thirty places. Names only where an entrant agreed to be named — and for
  /// a viewer who has not joined, none at all, as the server does.
  List<BoardRow> _rankedRows() {
    const List<String?> names = <String?>[
      'Aarav Rao',
      null,
      'Sana Jain',
      'Kabir Mehta',
      null,
      'Ishita Bose',
      null,
      'Rohan Pillai',
      'Neha Kulkarni',
      null,
      'Dev Malhotra',
      'Tara Sen',
      null,
      null,
      'Vikram Shah',
    ];
    const List<String> levels = <String>['B2', 'C1', 'B1', 'B2', 'A2'];
    final List<BoardRow> rows = <BoardRow>[];
    int total = _total + 4100;
    for (int rank = 1; rank <= 30; rank++) {
      final bool isViewer = _joined && rank == _viewerRank;
      if (isViewer) {
        total = _total;
      } else if (rank > 1) {
        total -= 120 + (rank * 37) % 90;
      }
      final String? name = isViewer
          ? 'Riya Kapoor'
          : (_joined ? names[(rank - 1) % names.length] : null);
      rows.add(
        BoardRow(
          rank: rank,
          name: name,
          isViewer: isViewer,
          total: total < 0 ? 0 : total,
          streak: rank % 6 == 0 ? 0 : 24 - (rank % 19),
          level: isViewer ? 'B1' : levels[rank % levels.length],
        ),
      );
    }
    return rows;
  }

  // ── Entering ─────────────────────────────────────────────────────────────

  /// Reading is joining (owner, 24 Nov 2026) — the server's
  /// `ensureLevelsEntry`, which runs before the overview and the path answer:
  /// a learner with no place in the running (or next) round is entered,
  /// anonymously, and never refused for an 18+ declaration in the app. An
  /// ended round enters nobody.
  void _enterOnRead() {
    if (!_hasContest || _joined) return;
    if (_phase == ContestPhase.ended) return;
    _joined = true;
    _fresh = true;
    _joinedAt = DateTime.now().toUtc();
  }

  // ── The path ─────────────────────────────────────────────────────────────

  ContestPath path() {
    if (!_hasContest) return const ContestPath();
    _enterOnRead();
    final String id = 'fake-contest-$_first';
    if (_phase == ContestPhase.ended) {
      return ContestPath(status: ContestPathStatus.ended, contestId: id);
    }
    if (!_joined) {
      return ContestPath(status: ContestPathStatus.notJoined, contestId: id);
    }
    if (_phase == ContestPhase.upcoming) {
      return ContestPath(status: ContestPathStatus.upcoming, contestId: id);
    }

    final String sunday = _addDays(_todayKey, -_weekday);
    final List<PathDay> days = <PathDay>[];
    // The Sunday levels sit on the week's Sunday — or, when the round starts
    // mid-week, on its first day — after that day's own levels.
    final String setupDay = sunday.compareTo(_first) < 0 ? _first : sunday;
    for (int wd = 0; wd < 7; wd++) {
      final String key = _addDays(sunday, wd);
      if (key.compareTo(_first) < 0 || key.compareTo(_last) > 0) {
        continue;
      }
      final List<PathNode> nodes = <PathNode>[
        ..._lessonNodes(key),
        for (final PathNodeKind kind in _tasksOn(wd))
          // A planned week's Sunday sets it up step by step instead of
          // "Plan this week", in its place.
          if (kind == PathNodeKind.planWeek && _weekPlanned)
            ..._weekSetupNodes(sunday)
          else
            _taskNode(kind, key),
        for (final _Piece piece in _piecesOn(key)) _claimNode(piece, key),
        // No Sunday this week (a round that started mid-week): on the
        // round's first day, after its own levels and claims.
        if (key == setupDay && key != sunday) ..._weekSetupNodes(sunday),
      ];
      days.add(
        PathDay(
          dayNumber: _daysBetween(_first, key) + 1,
          dayKey: key,
          weekday: wd,
          isToday: key == _todayKey,
          // The follow level goes after the gate: it is outside the
          // one-at-a-time order, never locked and never skipped.
          nodes: key == _todayKey
              ? <PathNode>[..._gate(nodes), ?_followNode()]
              : nodes,
        ),
      );
    }
    return ContestPath(
      status: ContestPathStatus.running,
      contestId: id,
      dayNumber: _dayNumber,
      finalDay: _finalDay,
      weekNumber: _daysBetween(_weekSunday(_first), sunday) ~/ 7 + 1,
      days: days,
      claims: _claims(),
      feedComments: const FeedCommentsRule(points: 100, penalty: 50),
      // Every fixture's today is a Wednesday, so the week cannot be earned
      // yet; and no day it asks for was missed — a late joiner's days before
      // they joined are not asked for.
      weekReward: const WeekReward(points: 500),
    );
  }

  /// This fake's planner week exists: Sunday carries the set-up levels, not
  /// "Plan this week".
  static const bool _weekPlanned = true;

  /// The planner week's post days as the fake's Planner holds them: Monday's
  /// post written (and published) without its image, Wednesday's and
  /// Friday's not written yet. `(dayIndex, weekday, role, format, image
  /// kind, photo guide, title, post written, image added)`.
  static const List<
    (int, String, String, String, String, String?, String, bool, bool)
  >
  _postDays =
      <(int, String, String, String, String, String?, String, bool, bool)>[
        (
          0,
          'Monday',
          'teach',
          'Numbered steps',
          'ai_poster',
          null,
          'The status update nobody has to chase',
          true,
          false,
        ),
        (
          2,
          'Wednesday',
          'story',
          'Mistake → lesson',
          'photo',
          'a candid photo of you at your desk with your laptop and coffee',
          'The deadline I said yes to, and what it cost',
          false,
          false,
        ),
        (
          4,
          'Friday',
          'opinion',
          'Industry take',
          'ai_poster',
          null,
          'Status meetings are a symptom, not a habit',
          false,
          false,
        ),
      ];

  /// `weekSetupNodes`: the SUNDAY LEVELS, open all week and outside the
  /// gate. Done from the Planner's state, whatever the day; missed once the
  /// post day has gone; an image locked until its post exists; else open.
  /// Ids carry the week's Sunday, wherever they are drawn.
  List<PathNode> _weekSetupNodes(String sunday) {
    if (!_weekPlanned) return const <PathNode>[];
    final List<PathNode> out = <PathNode>[];
    for (final (
          int day,
          String weekday,
          _,
          String format,
          String imageKind,
          String? photoGuide,
          String title,
          bool postDone,
          bool imageDone,
        )
        in _postDays) {
      // Planner day 0 is Monday, the day after the week's Sunday.
      final bool passed = _addDays(sunday, day + 1).compareTo(_todayKey) < 0;
      String href(String step) =>
          '/planner?week=$_plannerWeek&setup=1&day=$day&step=$step';
      final String postTitle = 'Write $weekday’s post';
      final PathNodeState post = postDone
          ? PathNodeState.done
          : (passed ? PathNodeState.missed : PathNodeState.today);
      out.add(
        PathNode(
          id: '$sunday:plan_week:post:$day',
          kind: PathNodeKind.planWeek,
          state: post,
          title: postTitle,
          href: post == PathNodeState.missed ? null : href('post'),
          detail: postDone
              ? 'Written'
              : (passed
                    ? sundayLevelPassedLine(weekday, image: false)
                    : '$format · $title'),
          setup: NodeSetup(dayIndex: day, step: SetupStep.post),
          openAllWeek: true,
        ),
      );
      final PathNodeState image = imageDone
          ? PathNodeState.done
          : (passed
                ? PathNodeState.missed
                : (postDone ? PathNodeState.today : PathNodeState.locked));
      final String? guide = photoGuide;
      out.add(
        PathNode(
          id: '$sunday:plan_week:image:$day',
          kind: PathNodeKind.planWeek,
          state: image,
          title: 'Add $weekday’s image',
          href: image == PathNodeState.today || image == PathNodeState.done
              ? href('image')
              : null,
          detail: switch (image) {
            PathNodeState.done => 'Image added',
            PathNodeState.missed => sundayLevelPassedLine(weekday, image: true),
            PathNodeState.locked => 'Unlocks after $postTitle',
            _ =>
              guide == null
                  ? 'We draw a poster for this post'
                  : 'Give us $guide',
          },
          setup: NodeSetup(
            dayIndex: day,
            step: SetupStep.image,
            imageKind: imageKind,
            photoGuide: photoGuide,
          ),
          openAllWeek: true,
        ),
      );
    }
    return out;
  }

  /// `CONTEST_WEEK` in the web's `lib/contest-week.ts`: what follows the
  /// lesson on each weekday, Sunday first.
  static List<PathNodeKind> _tasksOn(int weekday) => <PathNodeKind>[
    PathNodeKind.comment,
    PathNodeKind.feedComments,
    ...switch (weekday) {
      0 => <PathNodeKind>[PathNodeKind.planWeek],
      1 || 4 => <PathNodeKind>[PathNodeKind.connectLeaders],
      6 => <PathNodeKind>[PathNodeKind.weeklyInvites],
      _ => const <PathNodeKind>[],
    },
  ];

  static const Map<PathNodeKind, String> _titles = <PathNodeKind, String>{
    PathNodeKind.connectLeaders: 'Connect with leaders',
    PathNodeKind.comment: 'Comment on a top voice',
    PathNodeKind.feedComments: 'Post 5 valuable comments',
    PathNodeKind.weeklyInvites: 'Weekly invites',
    PathNodeKind.planWeek: 'Plan this week',
    PathNodeKind.article: 'Share your article’s link',
    PathNodeKind.video: 'Share your video’s link',
  };

  static const Map<PathNodeKind, String> _hrefs = <PathNodeKind, String>{
    PathNodeKind.lesson: '/levels/lesson',
    PathNodeKind.connectLeaders: '/connections?from=levels',
    PathNodeKind.comment: '/levels/comment',
    PathNodeKind.feedComments: '/levels/feed-comments',
    PathNodeKind.weeklyInvites: '/levels/invites',
    PathNodeKind.planWeek: '/levels/plan',
    PathNodeKind.followWinners: '/levels/follow',
  };

  static const Map<PathNodeKind, int> _rulePoints = <PathNodeKind, int>{
    PathNodeKind.connectLeaders: 60,
    PathNodeKind.comment: 40,
    PathNodeKind.feedComments: 100,
    PathNodeKind.weeklyInvites: 80,
    PathNodeKind.planWeek: 0,
  };

  /// `lessonNodes`: one node per part, by `lessonPartStates` — which
  /// questions are answered, and today's skipped parts. The open part is
  /// `today`, a skipped one `skipped` (opening on itself, `?part=k`), the
  /// parts after the open one locked, a past day's unfinished parts missed.
  List<PathNode> _lessonNodes(String key) {
    final bool isToday = key == _todayKey;
    final bool past = key.compareTo(_todayKey) < 0;
    final int total = isToday ? _pathQuestionCount : 15;
    final bool complete = isToday ? _lessonComplete : (past && !_fresh);
    final List<LessonPartView> views = lessonPartStates(
      total: total,
      answered: isToday ? _answeredIndexes : const <int>{},
      skipped: isToday ? skippedPartsOf(_skipped, key) : const <int>{},
      when: isToday
          ? LessonWhen.today
          : (past ? LessonWhen.past : LessonWhen.future),
      complete: complete,
    );
    final List<PathNode> nodes = <PathNode>[];
    for (final LessonPartView p in views) {
      final int k = p.index + 1;
      final String sizeLine =
          '${p.size} ${p.size == 1 ? 'question' : 'questions'}';
      final String progress = '${p.answeredInPart} of ${p.size} answered';
      String detail = sizeLine;
      if (p.state == LessonPartState.today && p.answeredInPart > 0) {
        detail = progress;
      }
      if (p.state == LessonPartState.skipped) {
        detail = p.answeredInPart > 0
            ? 'You skipped this · $progress'
            : 'You skipped this';
      }
      final PathNodeState state = switch (p.state) {
        LessonPartState.done => PathNodeState.done,
        LessonPartState.today => PathNodeState.today,
        LessonPartState.skipped => PathNodeState.skipped,
        LessonPartState.locked => PathNodeState.locked,
        LessonPartState.missed => PathNodeState.missed,
      };
      final String lesson = _hrefs[PathNodeKind.lesson]!;
      nodes.add(
        PathNode(
          id: lessonNodeId(key, k),
          kind: PathNodeKind.lesson,
          state: state,
          title: 'Lesson · part $k of ${views.length}',
          // Only the last part pays: finishing the day is the day credit.
          points: p.index == views.length - 1 ? 50 : 0,
          // A skipped part opens on itself.
          href: switch (state) {
            PathNodeState.today || PathNodeState.done => lesson,
            PathNodeState.skipped => '$lesson?part=$k',
            _ => null,
          },
          detail: detail,
          part: NodePart(
            index: k,
            total: views.length,
            start: p.start,
            end: p.end,
          ),
        ),
      );
    }
    return nodes;
  }

  /// Today's answered questions by their index in today's lesson — which
  /// ones, never how many.
  Set<int> get _answeredIndexes {
    final List<_Question> qs = _todayQuestions;
    final Set<String> ids = <String>{for (final _Given a in _answers) a.itemId};
    return <int>{
      for (int i = 0; i < qs.length; i++)
        if (ids.contains(qs[i].idFor(_dayNumber))) i,
    };
  }

  /// Today's lesson parts as the answer endpoint reckons them.
  List<LessonPartView> get _todayParts => lessonPartStates(
    total: _todayQuestionCount,
    answered: _answeredIndexes,
    skipped: skippedPartsOf(_skipped, _todayKey),
    when: LessonWhen.today,
    complete: false,
  );

  /// `taskNode`, for today from the state above and for the past from a
  /// fixed history: a week mostly done, with a missed feed task on Monday
  /// (revoked, in the last days) and a first try missed on Tuesday.
  PathNode _taskNode(PathNodeKind kind, String key) {
    final bool isToday = key == _todayKey;
    final bool past = key.compareTo(_todayKey) < 0;
    final int weekday = _weekdayOf(key);
    PathNodeState state;
    String? detail;
    bool started = false;
    int points = _rulePoints[kind] ?? 0;

    if (isToday) {
      switch (kind) {
        case PathNodeKind.comment:
          if (_commentDone) {
            state = PathNodeState.done;
            points = _commentPaid;
          } else {
            state = PathNodeState.today;
            final bool missedFirst = _commentFirstTry == CommentFirstTry.wrong;
            detail = missedFirst
                ? 'First try missed — finish it to post your comment'
                : 'Fill the blanks, then comment on LinkedIn';
            if (missedFirst) points = 0;
          }
        case PathNodeKind.feedComments:
          if (_feedLinks.length >= 5) {
            state = PathNodeState.done;
            detail = '5 of 5 posted';
            points = _feedPaid.fold(0, (int a, int b) => a + b);
          } else if (_feedLinks.isNotEmpty) {
            state = PathNodeState.today;
            detail = '${_feedLinks.length} of 5 posted';
            started = true;
            points = 20 * (5 - _feedLinks.length);
          } else {
            state = PathNodeState.today;
            detail = 'Comment on 5 posts in your feed, then share the links';
          }
        case PathNodeKind.connectLeaders:
          state = _connectDone ? PathNodeState.done : PathNodeState.today;
          if (_connectDone) points = _connectPaid;
        case PathNodeKind.weeklyInvites:
          if (_invitesDone) {
            state = PathNodeState.done;
            detail = 'XP in — our team checks every screenshot';
            points = _invitesPaid;
          } else {
            state = PathNodeState.today;
            detail = 'Send this week’s invitations, then upload a screenshot';
          }
        case PathNodeKind.planWeek:
          state = _planDone ? PathNodeState.done : PathNodeState.today;
          detail = _planDone
              ? 'This week is planned'
              : 'Get this week’s posts and article ready in the Planner';
        default:
          state = PathNodeState.today;
      }
    } else if (!past || _fresh) {
      state = past ? PathNodeState.missed : PathNodeState.locked;
    } else {
      // The fixed history of the days before today.
      switch (kind) {
        case PathNodeKind.comment:
          state = PathNodeState.done;
          // Tuesday's first try missed: done, and paid nothing.
          points = weekday == 2 ? 0 : 40;
        case PathNodeKind.feedComments when weekday == 1:
          if (scenario == FakeContestScenario.revealed) {
            state = PathNodeState.revoked;
            detail =
                'Removed: Two of the links were the same comment — −110 XP';
            points = 0;
          } else {
            state = PathNodeState.missed;
            detail = '3 of 5 posted';
            points = 60;
          }
        case PathNodeKind.feedComments:
          state = PathNodeState.done;
          detail = '5 of 5 posted';
          points = 100;
        case PathNodeKind.planWeek:
          state = PathNodeState.done;
          detail = 'This week is planned';
        default:
          state = PathNodeState.done;
      }
    }

    // A level already handed in still opens, read-only — not connect, whose
    // page is the whole flow, and never a revoked one.
    final bool viewable =
        (state == PathNodeState.done ||
            state == PathNodeState.approved ||
            state == PathNodeState.pending) &&
        kind != PathNodeKind.connectLeaders;
    final bool opens =
        state == PathNodeState.today ||
        state == PathNodeState.rejected ||
        viewable;
    return PathNode(
      id: '$key:${kind.wire}',
      kind: kind,
      state: state,
      title: _titles[kind]!,
      points: state == PathNodeState.revoked ? 0 : points,
      href: opens ? _hrefs[kind] : null,
      detail: detail,
      started: started,
    );
  }

  /// `claimNode`: a level of the piece's posting day.
  PathNode _claimNode(_Piece piece, String key) {
    final _ClaimRow? row = _claimRows[piece.occurrence];
    PathNodeState state;
    String detail = piece.title;
    switch (row?.status) {
      case ClaimStatus.approved:
        state = PathNodeState.approved;
      case ClaimStatus.pending:
        state = PathNodeState.pending;
        detail = 'Waiting for review';
      case ClaimStatus.rejected:
        state = PathNodeState.rejected;
        final String? why = row!.rejectReason;
        detail = why == null ? 'Rejected — send it again' : 'Rejected: $why';
      default:
        state = key == _todayKey
            ? PathNodeState.today
            : (key.compareTo(_todayKey) < 0
                  ? PathNodeState.missed
                  : PathNodeState.locked);
    }
    final bool opens =
        state == PathNodeState.today ||
        state == PathNodeState.rejected ||
        state == PathNodeState.pending;
    final String kind = piece.kind.wire;
    return PathNode(
      id: '$key:$kind:${piece.occurrence}',
      kind: piece.kind == ClaimKind.article
          ? PathNodeKind.article
          : PathNodeKind.video,
      state: state,
      title:
          _titles[piece.kind == ClaimKind.article
              ? PathNodeKind.article
              : PathNodeKind.video]!,
      points: piece.points,
      href: opens
          ? '/contest/claim?kind=$kind&occurrence=${Uri.encodeComponent(piece.occurrence)}'
          : null,
      detail: detail,
      claim: NodeClaim(kind: piece.kind, occurrence: piece.occurrence),
    );
  }

  /// `gateDay(markSkipped(nodes))`: today's skipped task and claim levels
  /// drawn as `skipped`; then the first level that is not passable keeps its
  /// state and, when it is open, is the one marked `canSkip`; every open
  /// level after it is locked behind the nearest earlier level still holding
  /// the chain.
  List<PathNode> _gate(List<PathNode> nodes) {
    final List<PathNode> marked = <PathNode>[
      for (final PathNode n in nodes) _markSkipped(n),
    ];
    PathNode? holder;
    bool canSkipMarked = false;
    final List<PathNode> out = <PathNode>[];
    for (final PathNode node in marked) {
      // Outside the order: never locked, never a holder, never skipped.
      if (node.openAllWeek) {
        out.add(node);
        continue;
      }
      PathNode next = node;
      final bool open =
          node.state == PathNodeState.today ||
          node.state == PathNodeState.rejected;
      final PathNode? h = holder;
      if (h != null && open) {
        next = node.copyWith(
          state: PathNodeState.locked,
          href: null,
          started: false,
          canSkip: false,
          detail: 'Unlocks after ${levelName(h)}',
        );
      } else if (h == null && !canSkipMarked && open) {
        next = node.copyWith(canSkip: true);
        canSkipMarked = true;
      }
      if (!_passable(next.state)) holder = next;
      out.add(next);
    }
    return out;
  }

  /// `markSkipped`: a task or claim node whose id was skipped today and whose
  /// rows leave it open (today) or sent back (rejected). A state read off the
  /// level's own rows beats the skip. Lesson parts arrive skip-aware.
  PathNode _markSkipped(PathNode n) {
    if (n.isLesson || !_skipped.contains(n.id)) return n;
    if (n.state != PathNodeState.today && n.state != PathNodeState.rejected) {
      return n;
    }
    final String? keep = n.state == PathNodeState.rejected || n.started
        ? n.detail
        : null;
    return n.copyWith(
      state: PathNodeState.skipped,
      detail: keep == null ? 'You skipped this' : 'You skipped this · $keep',
    );
  }

  /// `PASSABLE_STATES` in the web's `lib/contest-gate.ts`.
  static bool _passable(PathNodeState s) => switch (s) {
    PathNodeState.done ||
    PathNodeState.approved ||
    PathNodeState.pending ||
    PathNodeState.revoked ||
    PathNodeState.unavailable ||
    PathNodeState.missed ||
    PathNodeState.skipped => true,
    _ => false,
  };

  /// `holderOf`: the nearest node before [i] that is not passable — never
  /// an open-all-week Sunday level, which holds nothing back.
  static PathNode? _holderOf(List<PathNode> nodes, int i) {
    for (int j = i - 1; j >= 0; j--) {
      if (nodes[j].openAllWeek) continue;
      if (!_passable(nodes[j].state)) return nodes[j];
    }
    return null;
  }

  /// Sunday's gated "Plan this week" — never a set-up step, which is outside
  /// the order (`?setupLevels=1`'s layout).
  static bool _isPlanThisWeek(PathNode n) =>
      n.kind == PathNodeKind.planWeek && !n.openAllWeek;

  /// The level an action on [kind] waits on today, by the same gate the path
  /// draws with — `lockedLevel`.
  String? _lockedBehind(bool Function(PathNode) match) {
    final PathDay? today = path().today;
    if (today == null) return null;
    final List<PathNode> nodes = today.nodes;
    final int i = nodes.indexWhere(match);
    if (i <= 0) return null;
    final PathNode node = nodes[i];
    if (node.state != PathNodeState.locked || node.isLesson) return null;
    final PathNode? holder = _holderOf(nodes, i);
    return holder == null ? null : levelName(holder);
  }

  void _assertUnlocked(bool Function(PathNode) match) {
    final String? behind = _lockedBehind(match);
    if (behind != null) throw ContestLocked('Finish or skip $behind first.');
  }

  // ── Skip ─────────────────────────────────────────────────────────────────

  /// `skipLevel`, in the server's order: the node id's shape and day, today's
  /// gated nodes, then the node's state. A repeat is not an error.
  SkipResult skip(String nodeId) {
    if (nodeId.isEmpty || nodeId.length > 200) {
      throw const ContestInvalid('Missing nodeId.');
    }
    // The Sunday levels are outside the order on every day of the week.
    if (RegExp(r':plan_week:(post|image):\d+$').hasMatch(nodeId)) {
      throw const ContestNotOpen(
        'This level is open all week and never holds the others back, so it '
        'needs no skip.',
      );
    }
    _assertEntrant();
    if (!nodeId.startsWith('$_todayKey:')) {
      throw const ContestWrongDay(
        'That day is over. Reload the path for today’s.',
      );
    }
    final List<PathNode> nodes = path().today?.nodes ?? const <PathNode>[];
    final int i = nodes.indexWhere((PathNode n) => n.id == nodeId);
    if (i < 0) {
      throw const ContestInvalid('That level is not on today’s path.');
    }
    final PathNode node = nodes[i];
    switch (node.state) {
      case PathNodeState.skipped:
        return SkipResult(nodeId: nodeId, alreadySkipped: true);
      case PathNodeState.done ||
          PathNodeState.approved ||
          PathNodeState.pending ||
          PathNodeState.revoked:
        throw const ContestAlreadyDone('That level is already done.');
      case PathNodeState.unavailable:
        throw const ContestNotOpen(
          'There is nothing to do on that level today.',
        );
      case PathNodeState.locked:
        final PathNode? holder = _holderOf(nodes, i);
        throw ContestLocked(
          holder == null
              ? 'Finish or skip today’s earlier levels first.'
              : 'Finish or skip ${levelName(holder)} first.',
        );
      default:
        break;
    }
    if (!node.canSkip) {
      throw const ContestNotOpen('Only the level you are on can be skipped.');
    }
    if (!_skipped.add(nodeId)) {
      return SkipResult(nodeId: nodeId, alreadySkipped: true);
    }
    return SkipResult(nodeId: nodeId);
  }

  // ── The planner's pieces, and their claims ───────────────────────────────

  List<_Piece> get _pieces {
    final String sunday = _addDays(_todayKey, -_weekday);
    return <_Piece>[
      // Last week's Friday video, sent before the video levels were retired
      // (25 Nov 2026) and sent back: it still shows, and can be sent again.
      _Piece(
        kind: ClaimKind.video,
        occurrence: '${_plannerWeek - 1}:$_journey:4',
        title: 'How I say no to a deadline without saying no',
        dayKey: _addDays(sunday, -2),
      ),
      // This week has no videos: the article is its one claim.
      _Piece(
        kind: ClaimKind.article,
        occurrence: '$_plannerWeek:$_journey',
        title: 'Why your status update should start with the decision',
        dayKey: _addDays(sunday, 4),
      ),
    ];
  }

  Iterable<_Piece> _piecesOn(String key) =>
      _pieces.where((_Piece p) => p.dayKey == key && _isThisWeek(p.dayKey));

  bool _isThisWeek(String key) =>
      key.compareTo(_addDays(_todayKey, -_weekday)) >= 0;

  /// `buildClaims`: this week's pieces, and last week's still unpaid — an
  /// approved one of last week has nothing left to claim.
  List<PostClaim> _claims() => <PostClaim>[
    for (final _Piece p in _pieces)
      if (_isThisWeek(p.dayKey) ||
          _claimRows[p.occurrence]?.status != ClaimStatus.approved)
        _claimOf(p),
  ];

  PostClaim _claimOf(_Piece p) {
    final _ClaimRow? row = _claimRows[p.occurrence];
    final ClaimStatus status = switch (row?.status) {
      ClaimStatus.approved => ClaimStatus.approved,
      ClaimStatus.rejected => ClaimStatus.rejected,
      null =>
        _todayKey.compareTo(p.dayKey) < 0
            ? ClaimStatus.notReady
            : ClaimStatus.open,
      _ => ClaimStatus.pending,
    };
    return PostClaim(
      kind: p.kind,
      occurrence: p.occurrence,
      title: p.title,
      postingDayKey: p.dayKey,
      opensOnKey: p.dayKey,
      status: status,
      postUrl: row?.postUrl,
      points: p.points,
      rejectReason: row?.rejectReason,
    );
  }

  ClaimResult claim({
    required ClaimKind kind,
    required String occurrence,
    required String postUrl,
  }) {
    if (kind == ClaimKind.unknown) {
      throw const ContestInvalid(
        'Only the article (and a video already sent) is claimed by link.',
      );
    }
    if (occurrence.isEmpty || occurrence.length > 40) {
      throw const ContestInvalid('Missing occurrence.');
    }
    final String raw = postUrl.trim();
    if (!isLinkedInPostUrl(raw)) {
      throw const ContestBadUrl(
        'Paste the link to your LinkedIn post (linkedin.com/posts/… or /feed/update/…).',
      );
    }
    _assertEntrant();
    // The video levels were retired on 25 Nov 2026: only a video claim
    // already sent stays decidable and correctable.
    if (kind == ClaimKind.video && !_claimRows.containsKey(occurrence)) {
      throw const ContestNotOpen('Video levels were retired on 25 Nov 2026.');
    }
    final List<PostClaim> claims = _claims();
    PostClaim? target;
    for (final PostClaim c in claims) {
      if (c.kind == kind && c.occurrence == occurrence) target = c;
    }
    if (target == null) {
      throw const ContestInvalid('That is not one of this week’s pieces.');
    }
    if (target.status == ClaimStatus.approved) {
      throw const ContestAlreadyDone('That one is already approved.');
    }
    if (target.status == ClaimStatus.notReady) {
      throw ContestTooEarly(
        'You can share it from ${planDate(dayKeyDate(target.opensOnKey)!)}, the day it goes out.',
      );
    }
    _assertUnlocked(
      (PathNode n) =>
          n.claim?.kind == kind && n.claim?.occurrence == occurrence,
    );
    final String url = _normalisePostUrl(raw);
    for (final MapEntry<String, _ClaimRow> e in _claimRows.entries) {
      if (e.key != occurrence &&
          e.value.postUrl == url &&
          e.value.status != ClaimStatus.rejected) {
        throw const ContestDuplicateUrl('That link has already been claimed.');
      }
    }
    _claimRows[occurrence] = _ClaimRow(
      status: ClaimStatus.pending,
      postUrl: url,
    );
    return ClaimResult(
      taskId: 'fake-claim-$occurrence',
      claim: _claimOf(
        _pieces.firstWhere((_Piece p) => p.occurrence == occurrence),
      ),
    );
  }

  /// `normalisePostUrl`: https, a lower-case host with the bare domain made
  /// `www`, the path decoded, no query, no fragment, no trailing slash.
  static String _normalisePostUrl(String raw) {
    final Uri u = Uri.parse(raw.trim());
    final String host = u.host == 'linkedin.com' ? 'www.linkedin.com' : u.host;
    String path;
    try {
      path = Uri.decodeComponent(u.path);
    } on ArgumentError {
      path = u.path;
    }
    return 'https://$host${path.replaceAll(RegExp(r'/+$'), '')}';
  }

  // ── The lesson ───────────────────────────────────────────────────────────

  /// The day's size as the path counts it: the stored lesson's once the day
  /// has a row, else the size opening it is expected to give — the set
  /// questions plus five — as the server's `lessonQuestionCount` assumes.
  int get _pathQuestionCount =>
      _started || _answers.isNotEmpty ? _todayQuestionCount : _questions.length;

  int get _todayQuestionCount =>
      _started && !_setOnly ? _questions.length : _setQuestions.length;

  /// Today's questions as the server holds them: the set ones alone until
  /// the lesson is opened, then interleaved with the five written for the
  /// learner — two set, then one of theirs.
  List<_Question> get _todayQuestions =>
      _started && !_setOnly ? _questions : _setQuestions;

  bool get _lessonComplete =>
      _answers.length >= _todayQuestionCount && _todayQuestionCount > 0;

  TodayQuiz quiz() {
    if (!_hasContest) {
      return const TodayQuiz(
        status: QuizStatus.noContest,
        reason: QuizReason.noContest,
      );
    }
    final String id = 'fake-contest-$_first';
    if (_phase == ContestPhase.ended) {
      return TodayQuiz(
        status: QuizStatus.ended,
        reason: QuizReason.contestEnded,
        contestId: id,
      );
    }
    if (!_joined) {
      return TodayQuiz(
        status: QuizStatus.notJoined,
        reason: QuizReason.notJoined,
        contestId: id,
      );
    }
    if (_phase == ContestPhase.upcoming) {
      return TodayQuiz(
        status: QuizStatus.upcoming,
        reason: QuizReason.notStarted,
        contestId: id,
      );
    }
    final int correct = _answers.where((_Given a) => a.correct).length;
    final int paid = _answers.fold(
      0,
      (int sum, _Given a) => sum + (a.pointsApplied ?? 0),
    );
    return TodayQuiz(
      status: QuizStatus.ready,
      contestId: id,
      day: _dayNumber,
      band: 'B1',
      bandLocked: _started || _answers.isNotEmpty,
      tomorrow: _todayKey.compareTo(_last) < 0,
      started: _started,
      ownQuestions: _started && !_setOnly ? 5 : 0,
      questions: <PublicQuizItem>[
        for (final _Question q in _todayQuestions) q.public(_dayNumber),
      ],
      answered: <QuizAnswerView>[
        for (final _Given a in _answers)
          QuizAnswerView(
            itemId: a.itemId,
            value: a.value,
            correct: a.correct,
            correctOption: _byId(a.itemId)!.answer,
            explain: _byId(a.itemId)!.explain,
            pointsApplied: a.pointsApplied,
          ),
      ],
      completed: _lessonComplete,
      score: QuizScore(
        correct: correct,
        wrong: _answers.length - correct,
        points: paid + (_finishBonusPaid ? 20 : 0),
      ),
      finishBonus: const FinishBonus(points: 20, minCorrect: 9),
      scoringPaused: _scoringPaused,
      dayKey: _todayKey,
      skippedParts: skippedPartsOf(_skipped, _todayKey).toList()..sort(),
    );
  }

  TodayQuiz startLesson() {
    if (!_running) {
      throw const ContestNotRunning();
    }
    if (!_joined) {
      throw const ContestNotEntered(
        'Open your levels page first: today’s lesson opens there.',
      );
    }
    // The learner's own questions are written only while nothing is
    // answered; an answer that came first fixed the day to the set ones.
    if (!_started && _answers.isNotEmpty) _setOnly = true;
    _started = true;
    return quiz();
  }

  QuizAnswerResult answer({
    required int day,
    required String itemId,
    required String value,
  }) {
    if (!_running) {
      throw const ContestNotRunning();
    }
    if (!_joined) {
      throw const ContestNotEntered(
        'Open your levels page first: today’s quiz opens there.',
      );
    }
    if (day != _dayNumber) {
      throw const ContestNotToday('That quiz has closed. Reload for today’s.');
    }
    final _Question? q = _byId(itemId);
    final bool inToday = _todayQuestions.any(
      (_Question t) => t.idFor(_dayNumber) == itemId,
    );
    if (q == null || !inToday) {
      if (q != null && q.own) {
        throw const ContestStale(
          'Today’s quiz changed since this page loaded. Reload for today’s questions.',
        );
      }
      throw const ContestInvalid('That question is not in today’s quiz.');
    }
    if (!q.options.contains(value)) {
      throw const ContestInvalid('Pick one of the options.');
    }
    for (final _Given a in _answers) {
      if (a.itemId != itemId) continue;
      return QuizAnswerResult(
        value: a.value,
        correct: a.correct,
        correctOption: q.answer,
        explain: q.explain,
        completed: _lessonComplete,
        pointsApplied: a.pointsApplied ?? 0,
        scored: a.pointsApplied != null,
        replay: true,
      );
    }
    // Within a part in order; a part neither finished nor skipped holds the
    // parts after it — the server's 409 LOCKED.
    if (!_lessonComplete) {
      final int idx = _todayQuestions.indexWhere(
        (_Question t) => t.idFor(_dayNumber) == itemId,
      );
      final List<LessonPartView> parts = _todayParts;
      for (final LessonPartView p in parts) {
        if (!p.contains(idx) || p.state != LessonPartState.locked) continue;
        int open = 0;
        for (final LessonPartView o in parts) {
          if (o.state == LessonPartState.today) {
            open = o.index;
            break;
          }
        }
        throw ContestLocked(
          'Finish or skip Lesson part ${open + 1} of ${parts.length} first.',
        );
      }
    }

    final bool right = value == q.answer;
    final int? own = _scoringPaused
        ? null
        : _clamped(_answerPoints(right: right, own: q.own));
    _answers.add(
      _Given(
        itemId: itemId,
        value: value,
        correct: right,
        own: q.own,
        pointsApplied: own,
      ),
    );
    // Only the questions written for the learner feed the tie-break's
    // accuracy.
    if (q.own && right) _correctCount++;
    if (q.own && !right) _wrongCount++;
    int applied = own ?? 0;
    _total += applied;

    if (_lessonComplete && !_lessonCredited && !_scoringPaused) {
      // The day credit, and with it the streak — on its own day only, and
      // never while scoring is paused (the server's rule, R7).
      _lessonCredited = true;
      _streak += 1;
      if (_streak > _bestStreak) _bestStreak = _streak;
      final int credit = 50 + (_streak > 20 ? 20 : _streak) * 10;
      final int rights = _answers.where((_Given a) => a.correct).length;
      final int bonus = rights >= 9 ? 20 : 0;
      _finishBonusPaid = bonus > 0;
      applied += credit + bonus;
      _total += credit + bonus;
    }
    return QuizAnswerResult(
      value: value,
      correct: right,
      correctOption: q.answer,
      explain: q.explain,
      completed: _lessonComplete,
      pointsApplied: applied,
      scored: !_scoringPaused,
    );
  }

  /// What an answer's own event pays at B1: ten for a right one, times the
  /// band's 1.2; −4 for a set question missed, −2 for one of theirs.
  static int _answerPoints({required bool right, required bool own}) =>
      right ? 12 : (own ? -2 : -4);

  /// A penalty never takes the total below zero.
  int _clamped(int points) => _total + points < 0 ? -_total : points;

  _Question? _byId(String itemId) {
    for (final _Question q in _questions) {
      if (q.idFor(_dayNumber) == itemId) return q;
    }
    return null;
  }

  // ── The comment level ────────────────────────────────────────────────────

  static const List<String> _commentAnswers = <String>[
    'reminder',
    'decision',
    'approvals',
  ];

  /// The answers and three near misses, shuffled once for the day.
  static const List<String> _commentBank = <String>[
    'decision',
    'remainder',
    'approvals',
    'reminder',
    'approves',
    'decisive',
  ];

  CommentLevelView commentLevel() {
    if (!_running) {
      return const CommentLevelView(reason: CommentLevelReason.notRunning);
    }
    if (!_joined) {
      return const CommentLevelView(reason: CommentLevelReason.notJoined);
    }
    // The server's GET does not check the gate: it opens the day's row
    // whatever the path says. Kept, so a screen that forgets to read the
    // lock first is caught here too.
    _commentOpened = true;
    const CommentPost post = CommentPost(
      author: 'Meera Iyer',
      firstLine:
          'Most status updates bury the one decision the reader actually needs.',
    );
    const String template =
        'This is the {{1}} I needed this week. Leading with the {{2}} has cut our follow-up questions in half — and the {{3}} land faster too.';
    if (_commentDone) {
      return CommentLevelView(
        status: CommentLevelStatus.done,
        post: post.copyWith(
          postUrl:
              'https://www.linkedin.com/posts/meera-iyer_status-updates-activity-7394000000000000000-abcd',
        ),
        template: template,
        blankCount: 3,
        bank: _commentBank,
        firstTry: _commentFirstTry,
        answers: _commentAnswers,
        comment:
            'This is the reminder I needed this week. Leading with the decision has cut our follow-up questions in half — and the approvals land faster too.',
        pointsApplied: _commentPaid,
      );
    }
    return CommentLevelView(
      status: CommentLevelStatus.open,
      post: post,
      template: template,
      blankCount: 3,
      bank: _commentBank,
      firstTry: _commentFirstTry ?? CommentFirstTry.none,
      pointsApplied: _commentPaid,
    );
  }

  CommentSubmitResult submitComment(List<String> words) {
    final List<String> picked = <String>[
      for (final String w in words) w.trim().replaceAll(RegExp(r'\s+'), ' '),
    ];
    if (picked.isEmpty ||
        picked.length > 5 ||
        picked.any((String w) => w.isEmpty || w.length > 60)) {
      throw const ContestInvalid('Send one word from the bank for each blank.');
    }
    _assertEntrant();
    _assertUnlocked((PathNode n) => n.kind == PathNodeKind.comment);
    if (!_commentOpened) {
      throw const ContestNotOpen('Open today’s comment level first.');
    }
    if (picked.length != _commentAnswers.length) {
      throw ContestInvalid('Fill all ${_commentAnswers.length} blanks.');
    }
    final Set<String> bank = _commentBank
        .map((String w) => w.toLowerCase())
        .toSet();
    final Set<String> seen = <String>{};
    for (final String w in picked) {
      if (!bank.contains(w.toLowerCase()) || !seen.add(w.toLowerCase())) {
        throw const ContestInvalid('Use each word from the bank at most once.');
      }
    }
    final List<CommentBlank> blanks = <CommentBlank>[
      for (int i = 0; i < picked.length; i++)
        CommentBlank(
          value: picked[i],
          correct: picked[i].toLowerCase() == _commentAnswers[i],
          answer: _commentAnswers[i],
        ),
    ];
    final bool correct = blanks.every((CommentBlank b) => b.correct);
    final bool first = _commentFirstTry == null && !_commentDone;
    int paid = 0;
    if (first) {
      _commentFirstTry = correct
          ? CommentFirstTry.right
          : CommentFirstTry.wrong;
      if (correct && !_scoringPaused) {
        paid = 40;
        _commentPaid = 40;
        _total += 40;
      }
    }
    if (correct) _commentDone = true;
    return CommentSubmitResult(
      correct: correct,
      blanks: blanks,
      firstTry: first,
      pointsApplied: paid,
      level: commentLevel(),
    );
  }

  // ── Post 5 valuable comments ─────────────────────────────────────────────

  FeedCommentsView feedComments() {
    if (!_running || !_joined) {
      return FeedCommentsView(
        reason: _running
            ? FeedCommentsReason.notJoined
            : FeedCommentsReason.notRunning,
        shares: const <int>[0, 0, 0, 0, 0],
      );
    }
    final int paid = _feedPaid.fold(0, (int a, int b) => a + b);
    return FeedCommentsView(
      status: _feedLinks.length >= 5
          ? FeedCommentsStatus.done
          : FeedCommentsStatus.open,
      points: 100,
      shares: const <int>[20, 20, 20, 20, 20],
      penalty: 50,
      links: List<String>.of(_feedLinks),
      linkPoints: List<int>.of(_feedPaid),
      pointsApplied: paid,
    );
  }

  FeedCommentSubmitResult submitFeedComment(String link) {
    final String raw = link.trim();
    if (raw.isEmpty) {
      throw const ContestInvalid('Paste the link to your comment.');
    }
    if (!isLinkedInCommentUrl(raw)) {
      throw const ContestBadUrl(
        'That is not a link to a comment on a LinkedIn post. Use Copy link to comment (linkedin.com/feed/update/…, /posts/… or an lnkd.in link).',
      );
    }
    _assertEntrant();
    _assertUnlocked((PathNode n) => n.kind == PathNodeKind.feedComments);
    if (_feedLinks.length >= 5) {
      throw const ContestAlreadyDone('Today’s 5 comments are already in.');
    }
    final String id = commentIdentity(raw);
    for (int i = 0; i < _feedLinks.length; i++) {
      if (commentIdentity(_feedLinks[i]) == id) {
        throw ContestDuplicateUrl(
          'You already sent this comment today, as comment ${i + 1}. Each comment counts once.',
        );
      }
    }
    final int share = _scoringPaused ? 0 : 20;
    _feedLinks.add(normaliseCommentUrl(raw));
    _feedPaid.add(share);
    _total += share;
    return FeedCommentSubmitResult(
      taskId: 'fake-feed-$_todayKey',
      status: _feedLinks.length >= 5
          ? FeedCommentSubmitStatus.done
          : FeedCommentSubmitStatus.open,
      n: _feedLinks.length,
      pointsApplied: share,
      dayPoints: _feedPaid.fold(0, (int a, int b) => a + b),
      links: List<String>.of(_feedLinks),
    );
  }

  // ── Connect with leaders ─────────────────────────────────────────────────

  ConnectionBatch connectTargets() => const ConnectionBatch(
    profession: 'Product manager',
    cached: true,
    connections: <ConnectionTarget>[
      ConnectionTarget(
        role: 'Head of Product',
        company: 'a B2B payments company',
        searchQuery: 'Head of Product payments',
        note:
            'Hi — I read your post on writing specs people actually finish. I run product for a smaller team and would value following your work.',
      ),
      ConnectionTarget(
        role: 'Director of Customer Success',
        company: 'a SaaS scale-up',
        searchQuery: 'Director Customer Success SaaS',
        note:
            'Hello — your thread on onboarding calls changed how we run ours. I would be glad to connect and keep learning from it.',
      ),
      ConnectionTarget(
        role: 'Engineering Manager',
        company: 'a fintech in Bengaluru',
        searchQuery: 'Engineering Manager fintech Bengaluru',
        note:
            'Hi — I work closely with engineering on roadmap trade-offs and found your view on estimates useful. Happy to connect.',
      ),
      ConnectionTarget(
        role: 'Product Marketing Lead',
        company: 'an HR-tech company',
        searchQuery: 'Product Marketing Lead HR tech',
        note:
            'Hello — your launch checklist is now pinned in our team channel. I would like to connect and follow what you share next.',
      ),
      ConnectionTarget(
        role: 'VP Product',
        company: 'a logistics platform',
        searchQuery: 'VP Product logistics',
        note:
            'Hi — I lead a product team and keep coming back to your posts on saying no to good ideas. Could I ask you one question about how you run quarterly planning?',
        isDirectMessage: true,
      ),
    ],
  );

  ConnectTaskResult completeConnect() {
    _assertEntrant();
    if (!_tasksOn(_weekday).contains(PathNodeKind.connectLeaders)) {
      throw const ContestWrongDay(
        'Connecting with leaders is a Monday and Thursday task.',
      );
    }
    if (_connectDone) {
      return ConnectTaskResult(
        taskId: 'fake-connect-$_todayKey',
        pointsApplied: _connectPaid,
        alreadyDone: true,
      );
    }
    _assertUnlocked((PathNode n) => n.kind == PathNodeKind.connectLeaders);
    _connectDone = true;
    _connectPaid = _scoringPaused ? 0 : 60;
    _total += _connectPaid;
    return ConnectTaskResult(
      taskId: 'fake-connect-$_todayKey',
      pointsApplied: _connectPaid,
    );
  }

  // ── Weekly invites ───────────────────────────────────────────────────────

  InvitesSubmitResult submitInvites(Uint8List bytes) {
    if (bytes.isEmpty) throw const ContestInvalid('Attach a screenshot.');
    if (bytes.length > kMaxInvitesScreenshotBytes) {
      throw const ContestTooLarge('That screenshot is over 8 MB.');
    }
    _assertEntrant();
    if (_invitesDone) {
      throw const ContestAlreadyDone('This week’s screenshot is already in.');
    }
    if (!_tasksOn(_weekday).contains(PathNodeKind.weeklyInvites)) {
      throw const ContestWrongDay('The invites screenshot is a Saturday task.');
    }
    _assertUnlocked((PathNode n) => n.kind == PathNodeKind.weeklyInvites);
    _invitesDone = true;
    _invitesPaid = _scoringPaused ? 0 : 80;
    _total += _invitesPaid;
    return InvitesSubmitResult(
      taskId: 'fake-invites-$_todayKey',
      pointsApplied: _invitesPaid,
    );
  }

  // ── Plan this week ───────────────────────────────────────────────────────

  PlanWeekView planWeek() {
    final PlanWeekReason? reason = !_running
        ? PlanWeekReason.notRunning
        : (!_joined
              ? PlanWeekReason.notJoined
              : (_weekday != 0 ? PlanWeekReason.notToday : null));
    final String? locked = reason == null
        ? _lockedBehind(_isPlanThisWeek)
        : null;
    final String sunday = _addDays(_todayKey, -_weekday);
    // `planDayInstruction`: a post day by its role; a past one says so.
    String instruction(DayKind kind, String key, String? role) {
      final String when = planDate(dayKeyDate(key)!);
      return switch (kind) {
        DayKind.post when key.compareTo(_todayKey) < 0 =>
          'This day has passed. If its post isn’t written yet, you can still '
              'write it in the Planner and publish it now.',
        DayKind.post =>
          '${_roleLine[role] ?? ''}Write it and add its image in the Planner '
              'today, then approve it — we publish it for you on its day.',
        DayKind.videoScript =>
          'Record and post this video if you like. The video levels were '
              'retired on 25 Nov 2026, so no link is asked for it.',
        DayKind.article =>
          'Get the article ready to paste into LinkedIn’s newsletter. On '
              '$when, this level will ask for the article’s link.',
        DayKind.rest => 'Rest.',
      };
    }

    // The playbook week (25 Nov 2026), in calendar order from its Sunday:
    // `(index, weekday, kind, title, status)`; a post day's role, format
    // and image come from [_postDays].
    const List<(int, String, DayKind, String?, String)> week =
        <(int, String, DayKind, String?, String)>[
          (6, 'Sunday', DayKind.rest, null, 'Rest'),
          (
            0,
            'Monday',
            DayKind.post,
            'The status update nobody has to chase',
            'Published',
          ),
          (1, 'Tuesday', DayKind.rest, null, 'Rest'),
          (
            2,
            'Wednesday',
            DayKind.post,
            'The deadline I said yes to, and what it cost',
            'Planned — not written yet',
          ),
          (
            3,
            'Thursday',
            DayKind.article,
            'Why your status update should start with the decision',
            'Article ready',
          ),
          (
            4,
            'Friday',
            DayKind.post,
            'Status meetings are a symptom, not a habit',
            'Planned — not written yet',
          ),
          (5, 'Saturday', DayKind.rest, null, 'Rest'),
        ];
    PlanWeekDay dayOf(int i) {
      final (
        int index,
        String weekday,
        DayKind kind,
        String? title,
        String status,
      ) = week[i];
      final String key = _addDays(sunday, i);
      String? role;
      String? format;
      bool imageReady = false;
      for (final (int d, _, String r, String f, _, _, _, _, bool img)
          in _postDays) {
        if (d != index || kind != DayKind.post) continue;
        role = r;
        format = f;
        imageReady = img;
      }
      return PlanWeekDay(
        index: index,
        weekday: weekday,
        dayKey: key,
        kind: kind,
        role: role,
        formatName: format,
        imageReady: imageReady,
        title: title,
        status: status,
        ready: kind != DayKind.post || status == 'Published',
        instruction: i == 0
            ? 'Set up the week — write each post and add its image. Nothing '
                  'to post today.'
            : instruction(kind, key, role),
      );
    }

    return PlanWeekView(
      status: reason != null
          ? PlanWeekStatus.unavailable
          : (_planDone
                ? PlanWeekStatus.done
                : (locked != null
                      ? PlanWeekStatus.locked
                      : PlanWeekStatus.open)),
      reason: reason,
      lockedDetail: locked == null ? null : 'Unlocks after $locked',
      weekNumber: _plannerWeek,
      season: _journey,
      planned: _weekPlanned,
      topic: 'Writing updates people act on',
      plannerHref: '/planner?week=$_plannerWeek',
      days: <PlanWeekDay>[for (int i = 0; i < week.length; i++) dayOf(i)],
    );
  }

  /// `ROLE_LINE` in the web's `lib/contest-plan-copy.ts`, with its space.
  static const Map<String, String> _roleLine = <String, String>{
    'teach': 'This post teaches something worth saving. ',
    'story': 'This post tells a real story of yours, with the evidence. ',
    'opinion': 'This post takes a position you really hold. ',
  };

  PlanWeekResult completePlanWeek() {
    _assertEntrant();
    if (!_tasksOn(_weekday).contains(PathNodeKind.planWeek)) {
      throw const ContestWrongDay('Planning this week is a Sunday level.');
    }
    if (_planDone) {
      return PlanWeekResult(taskId: 'fake-plan-$_todayKey', alreadyDone: true);
    }
    _assertUnlocked(_isPlanThisWeek);
    _planDone = true;
    return PlanWeekResult(taskId: 'fake-plan-$_todayKey');
  }

  // ── "Follow last round's top learners" ───────────────────────────────────
  //
  // The server's follow-winners.service: the top learners of the round that
  // ended before this one, who agreed to be featured AND published a
  // Plexaverse profile — never the viewer. Step 1 (Follow on LinkedIn) is
  // recorded on the learner's word; step 2 is the follow itself, which the
  // real server reads off the follow row. This fake cannot see the profile
  // fake's follows, so it takes step 2's re-check as the follow having been
  // made — the controller only sends it after the follow succeeded.

  static const int _followWinnerPoints = 20;

  /// The round the top learners come from: the one that ended before this.
  static const String _fromRoundLastDayKey = '2026-10-31';

  static const List<FollowWinnerView> _winners = <FollowWinnerView>[
    FollowWinnerView(
      handle: 'asha-rao',
      name: 'Asha Rao',
      headline: 'Product lead · Hyderabad',
      linkedinUrl: 'https://www.linkedin.com/in/plexaverse-demo-learner-10',
    ),
    FollowWinnerView(
      handle: 'vikram-shah',
      name: 'Vikram Shah',
      headline: 'Founder, a B2B analytics studio',
      linkedinUrl: 'https://www.linkedin.com/in/plexaverse-demo-learner-11',
    ),
  ];

  final Set<String> _linkedinTapped = <String>{};
  final Set<String> _plexaverseFollowed = <String>{};
  final Map<String, int> _followPaid = <String, int>{};

  /// The scenarios whose running round has a last round to follow.
  bool get _hasFollowLevel => _running && _joined;

  FollowWinnerView _winnerView(FollowWinnerView w) {
    final bool done = _followPaid.containsKey(w.handle);
    return w.copyWith(
      linkedinDone: done || _linkedinTapped.contains(w.handle),
      plexaverseDone: done || _plexaverseFollowed.contains(w.handle),
      done: done,
      paid: done ? _followPaid[w.handle] : null,
    );
  }

  FollowWinnersView _followView() {
    if (!_running) {
      return const FollowWinnersView(reason: FollowWinnersReason.notRunning);
    }
    if (!_joined) {
      return const FollowWinnersView(reason: FollowWinnersReason.notJoined);
    }
    final List<FollowWinnerView> winners = <FollowWinnerView>[
      for (final FollowWinnerView w in _winners) _winnerView(w),
    ];
    return FollowWinnersView(
      status: winners.every((FollowWinnerView w) => w.done)
          ? FollowWinnersStatus.done
          : FollowWinnersStatus.open,
      pointsEach: _followWinnerPoints,
      fromRoundLastDayKey: _fromRoundLastDayKey,
      winners: winners,
    );
  }

  /// `GET /contest/tasks/follow-winners`.
  FollowWinnersView followWinners() => _followView();

  /// `POST /contest/tasks/follow-winners` — the server's
  /// `recordFollowWinnerStep`: step 1 recorded once, step 2 re-checked; both
  /// done → paid once, whichever lands second.
  FollowWinnerStepResult followWinnerStep({
    required String handle,
    required FollowWinnerStep step,
  }) {
    if (handle.trim().isEmpty) {
      throw const ContestInvalid('Say whose profile: their handle.');
    }
    _assertEntrant();
    final String h = handle.trim().toLowerCase();
    if (!_winners.any((FollowWinnerView w) => w.handle == h)) {
      throw const ContestNotInLevel();
    }
    switch (step) {
      case FollowWinnerStep.linkedin:
        _linkedinTapped.add(h);
      case FollowWinnerStep.plexaverse:
        _plexaverseFollowed.add(h);
    }
    int paid = 0;
    if (!_followPaid.containsKey(h) &&
        _linkedinTapped.contains(h) &&
        _plexaverseFollowed.contains(h)) {
      paid = _scoringPaused ? 0 : _followWinnerPoints;
      _followPaid[h] = paid;
      _total += paid;
    }
    return FollowWinnerStepResult(view: _followView(), pointsApplied: paid);
  }

  /// Today's follow node — the server's `followNodeFor`: open while any top
  /// learner is left, done on the day the last is followed, gone after.
  PathNode? _followNode() {
    if (!_hasFollowLevel) return null;
    final List<FollowWinnerView> views = <FollowWinnerView>[
      for (final FollowWinnerView w in _winners) _winnerView(w),
    ];
    final int total = views.length;
    final int done = views.where((FollowWinnerView w) => w.done).length;
    final String id = '$_todayKey:${PathNodeKind.followWinners.wire}';
    final FollowProgress follow = FollowProgress(done: done, total: total);
    if (done == total) {
      return PathNode(
        id: id,
        kind: PathNodeKind.followWinners,
        state: PathNodeState.done,
        title: kFollowWinnersTitle,
        href: _hrefs[PathNodeKind.followWinners],
        points: _followPaid.values.fold(0, (int a, int b) => a + b),
        detail: total == 1 ? 'Followed' : 'All $total followed',
        follow: follow,
      );
    }
    final bool started =
        done > 0 ||
        views.any((FollowWinnerView w) => w.linkedinDone || w.plexaverseDone);
    return PathNode(
      id: id,
      kind: PathNodeKind.followWinners,
      state: PathNodeState.today,
      title: kFollowWinnersTitle,
      href: _hrefs[PathNodeKind.followWinners],
      points: _followWinnerPoints * (total - done),
      detail: done > 0
          ? '$done of $total followed'
          : 'Follow them on LinkedIn and on Plexaverse',
      started: started,
      follow: follow,
    );
  }

  // ── Shared refusals ──────────────────────────────────────────────────────

  /// The task routes' order: no contest running, then not a participant.
  /// NOT_ENTERED is 404 on these routes; the code is what matters.
  void _assertEntrant() {
    if (!_running) {
      throw const ContestNotRunning();
    }
    if (!_joined) {
      throw const ContestNotEntered(
        'Open your levels page first: today’s levels open there.',
      );
    }
  }
}

// ── Day keys ───────────────────────────────────────────────────────────────
//
// The fake plays the server, so it does the server's calendar arithmetic on
// its own fixed dates. Nothing outside data/ does this.

DateTime _utc(String key) => dayKeyDate(key)!;

String _keyOf(DateTime utc) =>
    '${utc.year.toString().padLeft(4, '0')}-${utc.month.toString().padLeft(2, '0')}-${utc.day.toString().padLeft(2, '0')}';

String _addDays(String key, int n) => _keyOf(_utc(key).add(Duration(days: n)));

int _daysBetween(String a, String b) =>
    (_utc(b).difference(_utc(a)).inHours / 24).round();

int _weekdayOf(String key) => weekdayOfKey(key)!;

String _weekSunday(String key) => _addDays(key, -_weekdayOf(key));

/// Midnight of a day key in India, the contest's timezone, as an instant.
DateTime _instant(String key) =>
    _utc(key).subtract(const Duration(hours: 5, minutes: 30));

/// The day key in India of an instant.
String _dayKeyOf(DateTime instant) =>
    _keyOf(instant.toUtc().add(const Duration(hours: 5, minutes: 30)));

// ── Fixtures ───────────────────────────────────────────────────────────────

class _Given {
  const _Given({
    required this.itemId,
    required this.value,
    required this.correct,
    required this.own,
    required this.pointsApplied,
  });

  final String itemId;
  final String value;
  final bool correct;
  final bool own;
  final int? pointsApplied;
}

class _ClaimRow {
  const _ClaimRow({required this.status, this.postUrl, this.rejectReason});

  final ClaimStatus status;
  final String? postUrl;
  final String? rejectReason;
}

class _Piece {
  const _Piece({
    required this.kind,
    required this.occurrence,
    required this.title,
    required this.dayKey,
  });

  final ClaimKind kind;
  final String occurrence;
  final String title;
  final String dayKey;

  int get points => kind == ClaimKind.article ? 70 : 40;
}

/// One question, with its answer — which never leaves this file except in a
/// verdict, after the learner has answered.
class _Question {
  const _Question({
    required this.ref,
    required this.skill,
    required this.prompt,
    required this.options,
    required this.correct,
    required this.explain,
    this.passage,
  });

  /// A set question's bank id (`qz-b1-0051`), or `ai-<n>` for one of the
  /// five written for the learner — whose id carries the day.
  final String ref;
  final QuizSkill skill;
  final String prompt;
  final List<String> options;
  final int correct;
  final String explain;
  final String? passage;

  bool get own => ref.startsWith('ai-');

  String get answer => options[correct];

  String idFor(int day) => own ? 'ai-$day-${ref.substring(3)}' : ref;

  PublicQuizItem public(int day) => PublicQuizItem(
    id: idFor(day),
    skill: skill,
    passage: passage,
    prompt: prompt,
    options: options,
  );
}

/// The set questions, in bank order: two bank days of five — a word, a
/// structure, a phrasing, a short text, and one more word or structure.
const List<_Question> _setQuestions = <_Question>[
  _q51,
  _q52,
  _q53,
  _q54,
  _q55,
  _q56,
  _q57,
  _q58,
  _q59,
  _q60,
];

/// The opened lesson: ten set and five of the learner's own, interleaved two
/// set to one of theirs — the server's `interleave` for 10 + 5.
const List<_Question> _questions = <_Question>[
  _q51,
  _q52,
  _ai1,
  _q53,
  _q54,
  _ai2,
  _q55,
  _q56,
  _ai3,
  _q57,
  _q58,
  _ai4,
  _q59,
  _q60,
  _ai5,
];

const _Question _q51 = _Question(
  ref: 'qz-b1-0051',
  skill: QuizSkill.vocabulary,
  prompt:
      'The client is travelling, so your manager asks you to ___ the meeting to Thursday.',
  options: <String>['prepone', 'postpone', 'cancel out', 'delay off'],
  correct: 1,
  explain:
      '“Postpone” means move to a later time. The other three are not standard ways to say it.',
);

const _Question _q52 = _Question(
  ref: 'qz-b1-0052',
  skill: QuizSkill.grammar,
  prompt:
      'By the time the report reached the client, we ___ the figures twice.',
  options: <String>['have checked', 'were checking', 'had checked', 'check'],
  correct: 2,
  explain:
      'The past perfect shows one past action finished before another one.',
);

const _Question _q53 = _Question(
  ref: 'qz-b1-0053',
  skill: QuizSkill.usage,
  prompt: 'Which closing suits an email to a client you have not met yet?',
  options: <String>['Cheers mate,', 'Love,', 'Kind regards,', 'Bye for now!!'],
  correct: 2,
  explain:
      '“Kind regards” is polite and neutral — right for someone you do not know well.',
);

const _Question _q54 = _Question(
  ref: 'qz-b1-0054',
  skill: QuizSkill.reading,
  passage:
      'Team — the vendor has moved delivery to 14 March. Design sign-off stays on 1 March, so we keep two weeks for testing. Please flag any risk to the new date by Friday.',
  prompt: 'What must the team do by Friday?',
  options: <String>[
    'Flag risks to the new delivery date',
    'Sign off the design',
    'Start testing',
    'Call the vendor',
  ],
  correct: 0,
  explain:
      'The last sentence asks the team to flag risks to the new date by Friday.',
);

const _Question _q55 = _Question(
  ref: 'qz-b1-0055',
  skill: QuizSkill.vocabulary,
  prompt: 'The deadline is tight, so we need to ___ the most important tasks.',
  options: <String>['priority', 'prioritise', 'prior', 'prioritising'],
  correct: 1,
  explain: 'After “need to” you need the base form of a verb: “prioritise”.',
);

const _Question _q56 = _Question(
  ref: 'qz-b1-0056',
  skill: QuizSkill.vocabulary,
  prompt: 'A “stakeholder” is someone who ___.',
  options: <String>[
    'holds the company’s cash',
    'writes the project plan',
    'works only in sales',
    'has an interest in how a project turns out',
  ],
  correct: 3,
  explain:
      'A stakeholder is anyone affected by, or interested in, the outcome.',
);

const _Question _q57 = _Question(
  ref: 'qz-b1-0057',
  skill: QuizSkill.grammar,
  prompt: 'If the client ___ the proposal, we will start in April.',
  options: <String>['approved', 'approves', 'will approve', 'approving'],
  correct: 1,
  explain:
      'In the first conditional, “if” takes the present simple and the result takes “will”.',
);

const _Question _q58 = _Question(
  ref: 'qz-b1-0058',
  skill: QuizSkill.usage,
  prompt:
      'You need a colleague to review a document today. Which request is polite and clear?',
  options: <String>[
    'Review this now.',
    'Maybe look at this sometime?',
    'Could you review this by 5 pm today?',
    'You must review this.',
  ],
  correct: 2,
  explain: '“Could you” keeps it polite, and the time makes the request clear.',
);

const _Question _q59 = _Question(
  ref: 'qz-b1-0059',
  skill: QuizSkill.reading,
  passage:
      'Please note the office closes at 3 pm on Friday for maintenance. Remote work is encouraged for the afternoon, and meetings booked after 3 pm should move online.',
  prompt: 'What should happen to a meeting booked for 4 pm on Friday?',
  options: <String>[
    'It should be cancelled',
    'It should start at 3 pm',
    'It should move to Monday',
    'It should move online',
  ],
  correct: 3,
  explain: 'Meetings after 3 pm should move online.',
);

const _Question _q60 = _Question(
  ref: 'qz-b1-0060',
  skill: QuizSkill.grammar,
  prompt: 'Neither the manager nor the team members ___ aware of the change.',
  options: <String>['was', 'were', 'is', 'be'],
  correct: 1,
  explain:
      'With “neither … nor”, the verb agrees with the nearer subject: “team members were”.',
);

const _Question _ai1 = _Question(
  ref: 'ai-1',
  skill: QuizSkill.usage,
  prompt:
      'In a planning meeting you disagree with a senior colleague’s timeline. Which is the most professional reply?',
  options: <String>[
    'That plan is wrong.',
    'I see it a little differently — could we walk through the timeline first?',
    'No way this works.',
    'You are mistaken about the timeline.',
  ],
  correct: 1,
  explain:
      'It names the disagreement and moves to a next step without making it personal.',
);

const _Question _ai2 = _Question(
  ref: 'ai-2',
  skill: QuizSkill.vocabulary,
  prompt:
      'In your roadmap update, the launch is “on track”. What does that mean?',
  options: <String>[
    'It is going as planned',
    'It has been cancelled',
    'It is over budget',
    'It is under review',
  ],
  correct: 0,
  explain: '“On track” means progressing as planned.',
);

const _Question _ai3 = _Question(
  ref: 'ai-3',
  skill: QuizSkill.grammar,
  prompt: 'Which sentence is right for your weekly product update?',
  options: <String>[
    'We have shipped the first version last week.',
    'We has shipped the first version last week.',
    'We shipped the first version last week.',
    'We shipping the first version last week.',
  ],
  correct: 2,
  explain:
      'A finished time like “last week” takes the simple past, not the present perfect.',
);

const _Question _ai4 = _Question(
  ref: 'ai-4',
  skill: QuizSkill.reading,
  passage:
      'Quick update on onboarding: three of the five new hires have finished their product training. The other two start on Monday and should be ready by the end of next week.',
  prompt: 'How many new hires have not finished their training?',
  options: <String>['Three', 'Five', 'Two', 'None'],
  correct: 2,
  explain: 'Three of five have finished, so two have not.',
);

const _Question _ai5 = _Question(
  ref: 'ai-5',
  skill: QuizSkill.usage,
  prompt: 'Which line best ends a LinkedIn post about a launch you led?',
  options: <String>[
    'Thoughts???',
    'What would you have done differently?',
    'Like and share if you agree!!!',
    'The end.',
  ],
  correct: 1,
  explain:
      'A real question invites comments; the others read as filler or as begging for reach.',
);
