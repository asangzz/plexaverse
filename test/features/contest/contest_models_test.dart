import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/week/week_shape.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';

/// The contest's DTOs, read from bodies shaped exactly as the web's types are
/// (`lib/contest-path-types.ts`, `lib/services/contest.service.ts`,
/// `lib/services/contest-quiz.service.ts`, `contest-tasks.service.ts`).
///
/// ## What this pins
///
/// The mobile routes answer with the web's body inside `data`, so these DTOs
/// are the web's types one to one. A field renamed on either side shows up
/// here as a fixture that no longer reads — rather than as a screen that
/// silently draws a default.
///
/// And the guard: an enum value this build has never heard of falls back to
/// the reading that opens nothing. A new level kind must not open the
/// lesson; a new state must not put START on a node.
void main() {
  group('the overview', () {
    test('reads every field the web sends', () {
      final ContestOverview o = ContestOverview.fromJson(_overview);
      expect(o.contest.id, 'c1');
      expect(o.contest.title, 'Business English Contest');
      expect(o.contest.prizeImageUrl, isNull);
      expect(o.contest.startsAt, DateTime.utc(2026, 10, 31, 18, 30));
      expect(o.contest.endsAt, DateTime.utc(2027, 2, 8, 18, 30));
      expect(o.contest.firstDayKey, '2026-11-01');
      expect(o.contest.lastDayKey, '2027-02-08');
      expect(o.contest.rewardTopN, 10);
      expect(o.contest.rewardMonths, 3);
      expect(o.contest.freeDays, 30);
      expect(o.contest.weekComplete, 500);
      expect(o.phase, ContestPhase.running);
      expect(o.dayNumber, 11);
      expect(o.lengthDays, 100);
      expect(o.board.revealed, isFalse);
      expect(o.board.revealsOn, '2027-01-30');
      expect(o.board.revealDay, 91);
      expect(o.entrants, 1284);

      final ContestEntryView e = o.entry!;
      expect(e.joinedAt, DateTime.utc(2026, 11, 1, 3, 30));
      expect(e.level, 'B1');
      expect(e.total, 1240);
      expect(e.rank, isNull);
      expect(e.streak, 10);
      expect(e.bestStreak, 12);
      expect(e.correctCount, 40);
      expect(e.wrongCount, 9);
      expect(e.freeDaysLeft, 20);
      expect(e.scoringPaused, isFalse);
      expect(o.isEntrant, isTrue);
      expect(o.isRunning, isTrue);
    });

    test('no entry is a non-entrant, and an older server without the week '
        'bonus reads as none', () {
      final Map<String, dynamic> json = _copy(_overview)
        ..['entry'] = null
        ..['contest'] = (_copy(_overview['contest'] as Map<String, dynamic>)
          ..remove('weekComplete'));
      final ContestOverview o = ContestOverview.fromJson(json);
      expect(o.entry, isNull);
      expect(o.isEntrant, isFalse);
      expect(o.contest.weekComplete, isNull);
    });

    test('an unknown phase draws no path', () {
      final ContestOverview o = ContestOverview.fromJson(
        _copy(_overview)..['phase'] = 'paused_for_review',
      );
      expect(o.phase, ContestPhase.upcoming);
      expect(o.isRunning, isFalse);
    });
  });

  group('the board', () {
    test('before the reveal: no rows, no viewer, only the viewer’s own '
        'figures — and that reads as hidden', () {
      final BoardResult b = BoardResult.fromJson(<String, dynamic>{
        'revealed': false,
        'revealsOn': '2027-01-30',
        'revealDay': 91,
        'rows': <Object>[],
        'viewer': null,
        'self': <String, dynamic>{'total': 1240, 'streak': 10, 'level': 'B1'},
      });
      expect(b.isLocked, isTrue);
      expect(b.viewer, isNull);
      expect(b.self!.total, 1240);
    });

    test('no contest is the plain empty board, not a hidden one', () {
      final BoardResult b = BoardResult.fromJson(<String, dynamic>{
        'revealed': false,
        'revealsOn': '',
        'revealDay': 1,
        'rows': <Object>[],
        'viewer': null,
        'self': null,
      });
      expect(b.isLocked, isFalse);
    });

    test('after it: rows with null names for those who did not consent, and '
        'a viewer pinned when outside them', () {
      final BoardResult b = BoardResult.fromJson(<String, dynamic>{
        'revealed': true,
        'revealsOn': '2027-01-30',
        'revealDay': 91,
        'rows': <Object>[_row(1, 'Aarav R', 2410), _row(2, null, 2165)],
        'viewer': _row(14, 'Me', 900, isViewer: true),
        'self': <String, dynamic>{'total': 900, 'streak': 3, 'level': 'B2'},
      });
      expect(b.isLocked, isFalse);
      expect(b.rows[1].name, isNull);
      expect(b.viewer!.rank, 14);
      expect(b.viewerOutsideRows, isTrue);
    });
  });

  group('the path', () {
    test('reads every node shape the server builds', () {
      final ContestPath p = ContestPath.fromJson(_path);
      expect(p.status, ContestPathStatus.running);
      expect(p.contestId, 'c1');
      expect(p.dayNumber, 11);
      expect(p.finalDay, 100);
      expect(p.weekNumber, 2);
      expect(p.days, hasLength(1));
      expect(p.hasWeek, isTrue);

      final PathDay d = p.days.single;
      expect(d.dayKey, '2026-11-11');
      expect(d.weekday, 3);
      expect(d.isToday, isTrue);
      expect(p.today, same(d));

      final PathNode part2 = d.nodes[1];
      expect(part2.kind, PathNodeKind.lesson);
      expect(part2.state, PathNodeState.today);
      expect(part2.detail, '2 of 5 answered');
      expect(part2.part, const NodePart(index: 2, total: 3, start: 5, end: 10));
      expect(part2.href, '/contest/lesson');

      final PathNode feed = d.nodes[4];
      expect(feed.kind, PathNodeKind.feedComments);
      expect(feed.started, isTrue);

      final PathNode claim = d.nodes.last;
      expect(claim.kind, PathNodeKind.video);
      expect(
        claim.claim,
        const NodeClaim(kind: ClaimKind.video, occurrence: '6:1:2'),
      );
      expect(p.todayNode(PathNodeKind.comment)!.state, PathNodeState.locked);

      final PostClaim c = p.claims.single;
      expect(c.kind, ClaimKind.video);
      expect(c.status, ClaimStatus.rejected);
      expect(c.rejectReason, 'The link opens a different post.');
      expect(p.claimFor(ClaimKind.video, '5:1:4'), same(c));
      expect(p.claimFor(ClaimKind.article, '5:1:4'), isNull);

      expect(p.feedComments, const FeedCommentsRule(points: 100, penalty: 50));
      expect(
        p.weekReward,
        const WeekReward(points: 500, earned: false, missedDay: false),
      );
    });

    test('a status other than running carries no week', () {
      for (final String status in <String>[
        'no_contest',
        'not_joined',
        'upcoming',
        'ended',
      ]) {
        final ContestPath p = ContestPath.fromJson(<String, dynamic>{
          'status': status,
        });
        expect(p.hasWeek, isFalse, reason: status);
        expect(p.days, isEmpty);
      }
      expect(
        ContestPath.fromJson(<String, dynamic>{'status': 'not_joined'}).status,
        ContestPathStatus.notJoined,
      );
    });

    test('a running path with no days is "not ready", not an empty week', () {
      expect(
        ContestPath.fromJson(<String, dynamic>{'status': 'running'}).hasWeek,
        isFalse,
      );
    });

    test('every kind and state the web names reads as itself, both ways', () {
      const Map<String, PathNodeKind> kinds = <String, PathNodeKind>{
        'lesson': PathNodeKind.lesson,
        'connect_leaders': PathNodeKind.connectLeaders,
        'comment': PathNodeKind.comment,
        'feed_comments': PathNodeKind.feedComments,
        'weekly_invites': PathNodeKind.weeklyInvites,
        'plan_week': PathNodeKind.planWeek,
        'article': PathNodeKind.article,
        'video': PathNodeKind.video,
      };
      for (final MapEntry<String, PathNodeKind> k in kinds.entries) {
        expect(PathNodeKind.parse(k.key), k.value);
        expect(k.value.wire, k.key);
        final PathNode n = PathNode.fromJson(_node(kind: k.key));
        expect(n.kind, k.value, reason: k.key);
        // The JSON spelling and the hand-written one agree.
        expect(n.toJson()['kind'], k.key);
      }
      for (final PathNodeState s in PathNodeState.values) {
        expect(PathNodeState.parse(s.wire), s);
        expect(
          PathNode.fromJson(_node(state: s.wire)).state,
          s,
          reason: s.wire,
        );
      }
    });

    test('an unknown KIND is drawn locked with nothing to open, whatever '
        'state and href the server sent', () {
      final PathNode n = PathNode.fromJson(
        _node(kind: 'voice_duel', state: 'today', href: '/contest/voice'),
      );
      expect(n.kind, PathNodeKind.unknown);
      expect(n.state, PathNodeState.locked);
      expect(n.href, isNull);
      expect(PathNodeKind.parse('voice_duel'), PathNodeKind.unknown);
    });

    test('skipped reads as skipped, never locked', () {
      final PathNode n = PathNode.fromJson(
        _node(state: 'skipped', href: '/contest/comment'),
      );
      expect(n.state, PathNodeState.skipped);
      expect(n.href, '/contest/comment');
      expect(PathNodeState.parse('skipped'), PathNodeState.skipped);
    });

    test('canSkip is read when sent, false when absent, and false for an '
        'unknown kind whatever the server said', () {
      expect(
        PathNode.fromJson(<String, dynamic>{
          ..._node(),
          'canSkip': true,
        }).canSkip,
        isTrue,
      );
      expect(PathNode.fromJson(_node()).canSkip, isFalse);
      expect(
        PathNode.fromJson(<String, dynamic>{
          ..._node(kind: 'voice_duel'),
          'canSkip': true,
        }).canSkip,
        isFalse,
      );
      expect(
        PathNode.fromJson(<String, dynamic>{
          ..._node(),
          'canSkip': 'yes',
        }).canSkip,
        isFalse,
      );
    });

    test('a level’s own page finds its node, a claim by its piece', () {
      final ContestPath p = ContestPath.fromJson(<String, dynamic>{
        'status': 'running',
        'days': <Map<String, dynamic>>[
          <String, dynamic>{
            'dayNumber': 11,
            'dayKey': '2026-11-11',
            'weekday': 3,
            'isToday': true,
            'nodes': <Map<String, dynamic>>[
              _node(),
              <String, dynamic>{
                ..._node(kind: 'video'),
                'id': '2026-11-11:video:6:1:2',
                'claim': <String, dynamic>{
                  'kind': 'video',
                  'occurrence': '6:1:2',
                },
                'canSkip': true,
              },
            ],
          },
        ],
      });
      expect(p.todayNodeFor(PathNodeKind.comment)!.id, '2026-11-11:comment');
      expect(
        p.todayNodeFor(PathNodeKind.video, occurrence: '6:1:2')!.canSkip,
        isTrue,
      );
      expect(p.todayNodeFor(PathNodeKind.video, occurrence: '5:1:4'), isNull);
    });

    test('a Sunday set-up level reads its step and openAllWeek; a missed one '
        'keeps its reason', () {
      final PathNode open = PathNode.fromJson(<String, dynamic>{
        'id': '2026-11-08:plan_week:image:2',
        'kind': 'plan_week',
        'state': 'today',
        'title': 'Add Wednesday’s image',
        'points': 0,
        'href': '/planner?week=6&setup=1&day=2&step=image',
        'detail': 'Give us a candid photo of you at your desk',
        'setup': <String, dynamic>{
          'dayIndex': 2,
          'step': 'image',
          'imageKind': 'photo',
          'photoGuide': 'a candid photo of you at your desk',
        },
        'openAllWeek': true,
      });
      expect(open.kind, PathNodeKind.planWeek);
      expect(open.openAllWeek, isTrue);
      expect(open.isSetupStep, isTrue);
      expect(open.canSkip, isFalse);
      expect(
        open.setup,
        const NodeSetup(
          dayIndex: 2,
          step: SetupStep.image,
          imageKind: 'photo',
          photoGuide: 'a candid photo of you at your desk',
        ),
      );
      // The JSON round trip keeps both.
      expect(PathNode.fromJson(jsonDecode(jsonEncode(open.toJson()))), open);

      final PathNode passed = PathNode.fromJson(<String, dynamic>{
        'id': '2026-11-08:plan_week:post:0',
        'kind': 'plan_week',
        'state': 'missed',
        'title': 'Write Monday’s post',
        'points': 0,
        'href': null,
        'detail': 'Day passed — Monday’s post was not written',
        'setup': <String, dynamic>{'dayIndex': 0, 'step': 'post'},
        'openAllWeek': true,
      });
      expect(passed.state, PathNodeState.missed);
      expect(passed.href, isNull);
      expect(passed.detail, 'Day passed — Monday’s post was not written');
      expect(passed.setup!.step, SetupStep.post);
    });

    test('openAllWeek and setup are absent on every other level, and only a '
        'true openAllWeek counts', () {
      final PathNode plan = PathNode.fromJson(_node(kind: 'plan_week'));
      expect(plan.openAllWeek, isFalse);
      expect(plan.setup, isNull);
      expect(plan.isSetupStep, isFalse);
      expect(
        PathNode.fromJson(<String, dynamic>{
          ..._node(kind: 'plan_week'),
          'openAllWeek': 'yes',
        }).openAllWeek,
        isFalse,
      );
      // A level this build cannot name is not one of them either.
      expect(
        PathNode.fromJson(<String, dynamic>{
          ..._node(kind: 'voice_duel'),
          'openAllWeek': true,
        }).openAllWeek,
        isFalse,
      );
      // A step this build cannot name reads as unknown, not as a post.
      expect(
        NodeSetup.fromJson(<String, dynamic>{
          'dayIndex': 4,
          'step': 'video',
        }).step,
        SetupStep.unknown,
      );
    });

    test('a level’s own page never finds a Sunday level: they are outside '
        'today’s order', () {
      final ContestPath p = ContestPath.fromJson(<String, dynamic>{
        'status': 'running',
        'days': <Map<String, dynamic>>[
          <String, dynamic>{
            'dayNumber': 8,
            'dayKey': '2026-11-08',
            'weekday': 0,
            'isToday': true,
            'nodes': <Map<String, dynamic>>[
              <String, dynamic>{
                ..._node(kind: 'plan_week'),
                'id': '2026-11-08:plan_week:post:0',
                'setup': <String, dynamic>{'dayIndex': 0, 'step': 'post'},
                'openAllWeek': true,
              },
            ],
          },
        ],
      });
      expect(p.todayNode(PathNodeKind.planWeek), isNull);
      expect(p.todayNodeFor(PathNodeKind.planWeek), isNull);
    });

    test('an unknown STATE is locked', () {
      final PathNode n = PathNode.fromJson(_node(state: 'frozen'));
      expect(n.state, PathNodeState.locked);
      expect(PathNodeState.parse('frozen'), PathNodeState.locked);
    });

    test(
      'an unknown claim kind or status opens nothing and promises nothing',
      () {
        final PostClaim c = PostClaim.fromJson(<String, dynamic>{
          'kind': 'podcast',
          'occurrence': '6:1',
          'title': 't',
          'postingDayKey': null,
          'opensOnKey': null,
          'status': 'escalated',
          'postUrl': null,
          'points': 70,
        });
        expect(c.kind, ClaimKind.unknown);
        expect(c.status, ClaimStatus.notReady);
        expect(ClaimKind.parse('podcast'), ClaimKind.unknown);
      },
    );

    test('an unknown path status is not a running one', () {
      expect(
        ContestPath.fromJson(<String, dynamic>{'status': 'archived'}).status,
        ContestPathStatus.noContest,
      );
    });

    test('a path survives its own round trip', () {
      final ContestPath p = ContestPath.fromJson(_path);
      expect(ContestPath.fromJson(_roundTrip(p.toJson())), p);
    });
  });

  group('the lesson', () {
    test('reads a ready lesson, answered half way', () {
      final TodayQuiz q = TodayQuiz.fromJson(_quiz);
      expect(q.status, QuizStatus.ready);
      expect(q.reason, isNull);
      expect(q.day, 11);
      expect(q.band, 'B1');
      expect(q.bandLocked, isTrue);
      expect(q.tomorrow, isTrue);
      expect(q.started, isTrue);
      expect(q.ownQuestions, 1);
      expect(q.total, 3);
      expect(q.answeredCount, 2);
      expect(q.completed, isFalse);
      expect(q.score, const QuizScore(correct: 1, wrong: 1, points: 8));
      expect(q.finishBonus, const FinishBonus(points: 20, minCorrect: 9));
      expect(q.scoringPaused, isFalse);

      expect(q.questions[0].skill, QuizSkill.vocabulary);
      expect(q.questions[2].skill, QuizSkill.reading);
      expect(q.questions[2].passage, isNotNull);
      expect(q.questions[1].isOwn, isTrue);
      expect(q.questions[0].isOwn, isFalse);

      // Paused when given: null, which is "Not scored" — not 0.
      expect(q.answerFor('ai-11-1')!.pointsApplied, isNull);
      expect(q.answerFor('qz-b1-0051')!.pointsApplied, 12);
      expect(q.answerFor('qz-b1-0054'), isNull);
      expect(q.firstUnansweredIndex, 2);
    });

    test('the answered list is matched by id, so answers given out of order '
        'still find the first gap in lesson order', () {
      final TodayQuiz q = TodayQuiz.fromJson(
        _copy(_quiz)
          ..['answered'] = <Object>[
            _answer('qz-b1-0054', points: 12),
            _answer('qz-b1-0051', points: 12),
          ],
      );
      expect(q.firstUnansweredIndex, 1);
    });

    test('tomorrow stays unknown when the server does not say', () {
      final TodayQuiz q = TodayQuiz.fromJson(<String, dynamic>{
        'status': 'no_quiz_today',
        'reason': 'bank_ended',
        'contestId': 'c1',
        'day': 51,
        'band': 'B1',
      });
      expect(q.tomorrow, isNull);
      expect(q.reason, QuizReason.bankEnded);
      expect(q.questions, isEmpty);
      expect(q.firstUnansweredIndex, isNull);
    });

    test('unknown status, reason and skill fall back to nothing to answer', () {
      final TodayQuiz q = TodayQuiz.fromJson(<String, dynamic>{
        'status': 'maintenance',
        'reason': 'scheduled_downtime',
      });
      expect(q.status, QuizStatus.noQuizToday);
      expect(q.isReady, isFalse);
      expect(q.reason, isNull);
      expect(
        PublicQuizItem.fromJson(<String, dynamic>{
          'id': 'qz-1',
          'skill': 'listening',
          'prompt': 'p',
          'options': <String>['a', 'b', 'c', 'd'],
        }).skill,
        QuizSkill.other,
      );
    });

    test('each status the web sends is itself', () {
      const Map<String, QuizStatus> statuses = <String, QuizStatus>{
        'no_contest': QuizStatus.noContest,
        'not_joined': QuizStatus.notJoined,
        'upcoming': QuizStatus.upcoming,
        'ended': QuizStatus.ended,
        'no_quiz_today': QuizStatus.noQuizToday,
        'ready': QuizStatus.ready,
      };
      statuses.forEach((String wire, QuizStatus status) {
        expect(
          TodayQuiz.fromJson(<String, dynamic>{'status': wire}).status,
          status,
        );
      });
    });

    test('the skill labels are the web’s', () {
      expect(QuizSkill.vocabulary.label, 'Vocabulary');
      expect(QuizSkill.grammar.label, 'Grammar');
      expect(QuizSkill.usage.label, 'Saying it at work');
      expect(QuizSkill.reading.label, 'Reading');
    });

    test('an answer reads its week bonus and replay', () {
      final QuizAnswerResult r = QuizAnswerResult.fromJson(<String, dynamic>{
        'value': 'postpone',
        'correct': true,
        'correctOption': 'postpone',
        'explain': 'Later.',
        'completed': true,
        'pointsApplied': 692,
        'scored': true,
        'weekBonus': 500,
        'replay': false,
      });
      expect(r.weekBonus, 500);
      expect(r.pointsApplied, 692);
      expect(r.replay, isFalse);
      final QuizAnswerResult replay =
          QuizAnswerResult.fromJson(<String, dynamic>{
            'value': 'prepone',
            'correct': false,
            'correctOption': 'postpone',
            'explain': 'Later.',
            'completed': false,
            'pointsApplied': 0,
            'scored': false,
            'weekBonus': null,
            'replay': true,
          });
      expect(replay.weekBonus, isNull);
      expect(replay.scored, isFalse);
      expect(replay.replay, isTrue);
    });
  });

  group('skip', () {
    test('the lesson read carries its day key and skipped parts when ready, '
        'and defaults without them', () {
      final TodayQuiz q = TodayQuiz.fromJson(<String, dynamic>{
        'status': 'ready',
        'dayKey': '2026-11-18',
        'skippedParts': <int>[1, 3],
      });
      expect(q.dayKey, '2026-11-18');
      expect(q.skippedParts, <int>[1, 3]);
      final TodayQuiz old = TodayQuiz.fromJson(<String, dynamic>{
        'status': 'ready',
      });
      expect(old.dayKey, isNull);
      expect(old.skippedParts, isEmpty);
    });

    test('a skip’s result', () {
      final SkipResult r = SkipResult.fromJson(<String, dynamic>{
        'nodeId': '2026-11-18:lesson:2',
        'alreadySkipped': true,
      });
      expect(r.nodeId, '2026-11-18:lesson:2');
      expect(r.alreadySkipped, isTrue);
      expect(SkipResult.fromJson(<String, dynamic>{}).alreadySkipped, isFalse);
    });
  });

  group('the tasks', () {
    test(
      'the comment level, open: the bank and the blanks, never the answers',
      () {
        final CommentLevelView v = CommentLevelView.fromJson(<String, dynamic>{
          'status': 'open',
          'post': <String, dynamic>{'author': 'Meera', 'firstLine': 'Most…'},
          'template': 'This is the {{1}} I needed.',
          'blankCount': 1,
          'bank': <String>['reminder', 'remainder'],
          'firstTry': 'none',
          'pointsApplied': 0,
        });
        expect(v.status, CommentLevelStatus.open);
        expect(v.post!.postUrl, isNull);
        expect(v.answers, isEmpty);
        expect(v.comment, isNull);
        expect(v.firstTry, CommentFirstTry.none);
      },
    );

    test('unavailable with no reason is "not written"; writing is its own', () {
      expect(
        CommentLevelView.fromJson(<String, dynamic>{
          'status': 'unavailable',
        }).notWritten,
        isTrue,
      );
      final CommentLevelView writing = CommentLevelView.fromJson(
        <String, dynamic>{'status': 'unavailable', 'reason': 'writing'},
      );
      expect(writing.isWriting, isTrue);
      expect(writing.notWritten, isFalse);
      for (final String reason in <String>[
        'not_today',
        'no_post',
        'not_running',
        'not_joined',
      ]) {
        expect(
          CommentLevelView.fromJson(<String, dynamic>{
            'status': 'unavailable',
            'reason': reason,
          }).reason,
          isNotNull,
          reason: reason,
        );
      }
    });

    test('a comment submission reads every blank and the level after it', () {
      final CommentSubmitResult r = CommentSubmitResult.fromJson(
        <String, dynamic>{
          'correct': false,
          'blanks': <Object>[
            <String, dynamic>{
              'value': 'remainder',
              'correct': false,
              'answer': 'reminder',
            },
          ],
          'firstTry': true,
          'pointsApplied': 0,
          'level': <String, dynamic>{'status': 'open', 'firstTry': 'wrong'},
        },
      );
      expect(r.blanks.single.answer, 'reminder');
      expect(r.level.firstTry, CommentFirstTry.wrong);
    });

    test(
      'feed comments: a legacy day has no per-link points — null, not empty',
      () {
        final FeedCommentsView legacy = FeedCommentsView.fromJson(
          <String, dynamic>{
            'status': 'done',
            'perDay': 5,
            'points': 100,
            'shares': <int>[20, 20, 20, 20, 20],
            'penalty': 50,
            'links': <String>[
              'https://www.linkedin.com/feed/update/urn:li:activity:1',
            ],
            'pointsApplied': 100,
          },
        );
        expect(legacy.linkPoints, isNull);
        final FeedCommentsView open = FeedCommentsView.fromJson(
          <String, dynamic>{
            'status': 'open',
            'perDay': 5,
            'points': 101,
            'shares': <int>[20, 20, 20, 20, 21],
            'penalty': 0,
            'links': <String>['a', 'b', 'c', 'd'],
            'linkPoints': <int>[20, 20, 20, 20],
            'pointsApplied': 80,
          },
        );
        expect(open.nextNumber, 5);
        expect(open.nextShare, 21);
        final FeedCommentsView revoked = FeedCommentsView.fromJson(
          <String, dynamic>{
            'status': 'revoked',
            'perDay': 5,
            'points': 100,
            'shares': <int>[20, 20, 20, 20, 20],
            'penalty': 50,
            'links': <String>[],
            'pointsApplied': 0,
            'revokeReason': 'Not your comment.',
            'pointsDeducted': 150,
          },
        );
        expect(revoked.status, FeedCommentsStatus.revoked);
        expect(revoked.pointsDeducted, 150);
      },
    );

    test('the plan week reads its days in calendar order with their kinds', () {
      final PlanWeekView v = PlanWeekView.fromJson(<String, dynamic>{
        'status': 'locked',
        'lockedDetail': 'Unlocks after Post 5 valuable comments',
        'weekNumber': 6,
        'season': 1,
        'planned': false,
        'topic': null,
        'plannerHref': '/planner?week=6',
        'days': <Object>[
          _planDay(6, 'Sunday', 'rest'),
          // A week planned before 25 Nov 2026 keeps its video day.
          _planDay(2, 'Wednesday', 'video_script'),
          _planDay(3, 'Thursday', 'article'),
          <String, dynamic>{
            ..._planDay(0, 'Monday', 'post'),
            'role': 'teach',
            'formatName': 'Numbered steps',
            'imageReady': true,
          },
        ],
      });
      expect(v.status, PlanWeekStatus.locked);
      expect(v.lockedDetail, startsWith('Unlocks after'));
      expect(v.days.map((PlanWeekDay d) => d.kind), <DayKind>[
        DayKind.rest,
        DayKind.videoScript,
        DayKind.article,
        DayKind.post,
      ]);
      expect(v.days.first.index, 6);
      final PlanWeekDay monday = v.days.last;
      expect(monday.role, 'teach');
      expect(monday.formatName, 'Numbered steps');
      expect(monday.imageReady, isTrue);
      // Absent on a day that is not a post, and from an older server.
      expect(v.days[1].role, isNull);
      expect(v.days[1].formatName, isNull);
      expect(v.days[1].imageReady, isFalse);
    });

    test('the write results read as the web returns them', () {
      expect(
        ConnectTaskResult.fromJson(<String, dynamic>{
          'taskId': 't',
          'status': 'done',
          'pointsApplied': 60,
          'alreadyDone': true,
        }).alreadyDone,
        isTrue,
      );
      expect(
        InvitesSubmitResult.fromJson(<String, dynamic>{
          'taskId': 't',
          'status': 'done',
          'pointsApplied': 0,
          'replaced': true,
        }).replaced,
        isTrue,
      );
      expect(
        PlanWeekResult.fromJson(<String, dynamic>{
          'taskId': 't',
          'status': 'done',
          'alreadyDone': false,
        }).taskId,
        't',
      );
      final FeedCommentSubmitResult f = FeedCommentSubmitResult.fromJson(
        <String, dynamic>{
          'taskId': 't',
          'status': 'done',
          'n': 5,
          'pointsApplied': 20,
          'dayPoints': 100,
          'links': <String>['a', 'b', 'c', 'd', 'e'],
        },
      );
      expect(f.status, FeedCommentSubmitStatus.done);
      final ClaimResult c = ClaimResult.fromJson(<String, dynamic>{
        'taskId': 't',
        'claim': <String, dynamic>{
          'kind': 'article',
          'occurrence': '6:1',
          'title': 'Why your status update should start with the decision',
          'postingDayKey': '2026-11-12',
          'opensOnKey': '2026-11-12',
          'status': 'pending',
          'postUrl': 'https://www.linkedin.com/pulse/x',
          'points': 70,
        },
      });
      expect(c.claim.status, ClaimStatus.pending);
      expect(c.claim.kind, ClaimKind.article);
    });

    test('the connect level reuses the /connections batch', () {
      final ConnectionBatch b = ConnectionBatch.fromJson(<String, dynamic>{
        'connections': <Object>[
          <String, dynamic>{
            'role': 'Head of Product',
            'company': 'Acme',
            'searchQuery': 'Head of Product Acme',
            'linkedinSearchUrl': '',
            'note': 'Hi',
            'isDirectMessage': false,
          },
        ],
        'profession': 'Product manager',
        'cached': true,
      });
      expect(b.connections.single.role, 'Head of Product');
      expect(b.cached, isTrue);
    });
  });
}

// ── Fixtures, shaped as the web sends them ─────────────────────────────────

Map<String, dynamic> _copy(Map<String, dynamic> m) =>
    Map<String, dynamic>.of(m);

/// Through the wire and back, as the server's JSON would carry it.
Map<String, dynamic> _roundTrip(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

final Map<String, dynamic> _overview = <String, dynamic>{
  'contest': <String, dynamic>{
    'id': 'c1',
    'title': 'Business English Contest',
    'prizeTitle': 'Noise-cancelling headphones',
    'prizeImageUrl': null,
    'startsAt': '2026-10-31T18:30:00.000Z',
    'endsAt': '2027-02-08T18:30:00.000Z',
    'firstDayKey': '2026-11-01',
    'lastDayKey': '2027-02-08',
    'rewardTopN': 10,
    'rewardMonths': 3,
    'freeDays': 30,
    'weekComplete': 500,
  },
  'phase': 'running',
  'dayNumber': 11,
  'lengthDays': 100,
  'board': <String, dynamic>{
    'revealed': false,
    'revealsOn': '2027-01-30',
    'revealDay': 91,
  },
  'entry': <String, dynamic>{
    'joinedAt': '2026-11-01T03:30:00.000Z',
    'level': 'B1',
    'total': 1240,
    'rank': null,
    'streak': 10,
    'bestStreak': 12,
    'correctCount': 40,
    'wrongCount': 9,
    'freeDaysLeft': 20,
    'scoringPaused': false,
  },
  'entrants': 1284,
};

Map<String, dynamic> _row(
  int rank,
  String? name,
  int total, {
  bool isViewer = false,
}) => <String, dynamic>{
  'rank': rank,
  'name': name,
  'image': null,
  'isViewer': isViewer,
  'total': total,
  'streak': 4,
  'level': 'B2',
};

Map<String, dynamic> _node({
  String kind = 'comment',
  String state = 'today',
  String? href = '/contest/comment',
}) => <String, dynamic>{
  'id': '2026-11-11:$kind',
  'kind': kind,
  'state': state,
  'title': 'A level',
  'points': 40,
  'href': href,
};

final Map<String, dynamic> _path = <String, dynamic>{
  'status': 'running',
  'contestId': 'c1',
  'dayNumber': 11,
  'finalDay': 100,
  'weekNumber': 2,
  'days': <Object>[
    <String, dynamic>{
      'dayNumber': 11,
      'dayKey': '2026-11-11',
      'weekday': 3,
      'isToday': true,
      'nodes': <Object>[
        <String, dynamic>{
          'id': '2026-11-11:lesson:1',
          'kind': 'lesson',
          'state': 'done',
          'title': 'Lesson · part 1 of 3',
          'points': 0,
          'href': '/contest/lesson',
          'detail': '5 questions',
          'part': <String, dynamic>{
            'index': 1,
            'total': 3,
            'start': 0,
            'end': 5,
          },
        },
        <String, dynamic>{
          'id': '2026-11-11:lesson:2',
          'kind': 'lesson',
          'state': 'today',
          'title': 'Lesson · part 2 of 3',
          'points': 0,
          'href': '/contest/lesson',
          'detail': '2 of 5 answered',
          'part': <String, dynamic>{
            'index': 2,
            'total': 3,
            'start': 5,
            'end': 10,
          },
        },
        <String, dynamic>{
          'id': '2026-11-11:lesson:3',
          'kind': 'lesson',
          'state': 'locked',
          'title': 'Lesson · part 3 of 3',
          'points': 50,
          'href': null,
          'detail': '5 questions',
          'part': <String, dynamic>{
            'index': 3,
            'total': 3,
            'start': 10,
            'end': 15,
          },
        },
        <String, dynamic>{
          'id': '2026-11-11:comment',
          'kind': 'comment',
          'state': 'locked',
          'title': 'Comment on a top voice',
          'points': 40,
          'href': null,
          'detail': 'Unlocks after Lesson part 3 of 3',
        },
        <String, dynamic>{
          'id': '2026-11-11:feed_comments',
          'kind': 'feed_comments',
          'state': 'today',
          'title': 'Post 5 valuable comments',
          'points': 60,
          'href': '/contest/feed-comments',
          'detail': '2 of 5 posted',
          'started': true,
        },
        <String, dynamic>{
          'id': '2026-11-11:video:6:1:2',
          'kind': 'video',
          'state': 'locked',
          'title': 'Share your video’s link',
          'points': 40,
          'href': null,
          'detail': 'Unlocks after Post 5 valuable comments',
          'claim': <String, dynamic>{'kind': 'video', 'occurrence': '6:1:2'},
        },
      ],
    },
  ],
  'claims': <Object>[
    <String, dynamic>{
      'kind': 'video',
      'occurrence': '5:1:4',
      'title': 'How I say no to a deadline without saying no',
      'postingDayKey': '2026-11-06',
      'opensOnKey': '2026-11-06',
      'status': 'rejected',
      'postUrl': 'https://www.linkedin.com/posts/x',
      'points': 40,
      'rejectReason': 'The link opens a different post.',
    },
  ],
  'feedComments': <String, dynamic>{'perDay': 5, 'points': 100, 'penalty': 50},
  'weekReward': <String, dynamic>{
    'points': 500,
    'earned': false,
    'paid': null,
    'missedDay': false,
  },
};

Map<String, dynamic> _answer(String itemId, {int? points}) => <String, dynamic>{
  'itemId': itemId,
  'value': 'a',
  'correct': true,
  'correctOption': 'a',
  'explain': 'Because.',
  'pointsApplied': points,
};

final Map<String, dynamic> _quiz = <String, dynamic>{
  'status': 'ready',
  'contestId': 'c1',
  'day': 11,
  'band': 'B1',
  'bandLocked': true,
  'tomorrow': true,
  'started': true,
  'ownQuestions': 1,
  'questions': <Object>[
    <String, dynamic>{
      'id': 'qz-b1-0051',
      'skill': 'vocabulary',
      'prompt': 'The client is travelling, so ___ the meeting.',
      'options': <String>['prepone', 'postpone', 'cancel out', 'delay off'],
    },
    <String, dynamic>{
      'id': 'ai-11-1',
      'skill': 'usage',
      'prompt': 'Which reply is the most professional?',
      'options': <String>['a', 'b', 'c', 'd'],
    },
    <String, dynamic>{
      'id': 'qz-b1-0054',
      'skill': 'reading',
      'passage': 'Team — the vendor has moved delivery to 14 March.',
      'prompt': 'What must the team do by Friday?',
      'options': <String>['a', 'b', 'c', 'd'],
    },
  ],
  'answered': <Object>[
    _answer('qz-b1-0051', points: 12),
    <String, dynamic>{
      'itemId': 'ai-11-1',
      'value': 'c',
      'correct': false,
      'correctOption': 'b',
      'explain': 'It names the disagreement.',
      'pointsApplied': null,
    },
  ],
  'completed': false,
  'score': <String, dynamic>{'correct': 1, 'wrong': 1, 'points': 8},
  'finishBonus': <String, dynamic>{'points': 20, 'minCorrect': 9},
  'scoringPaused': false,
};

Map<String, dynamic> _planDay(int index, String weekday, String kind) =>
    <String, dynamic>{
      'index': index,
      'weekday': weekday,
      'dayKey': '2026-11-08',
      'kind': kind,
      'title': null,
      'status': 'Rest',
      'ready': true,
      'instruction': 'Rest.',
    };
