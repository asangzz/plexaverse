import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/network/dio_client.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';

/// Every contest refusal, through the real network stack, to the type a
/// screen branches on.
///
/// ## The bug this exists to stop
///
/// The mobile routes keep the web's statuses, and the interceptor files
/// three of them under the wrong class: a 403 is an `AuthFailure` (the
/// app's "your session expired"), a 429 or 503 a `NetworkFailure` ("check
/// your connection"). So a repository that branched on the class told a
/// non-entrant to sign in again and a full proof store to check their wifi.
/// [ApiContestRepository] reads the CODE first. These tests send each code
/// at every status it can arrive with — and at the ones it cannot, since a
/// status is the one thing about a refusal the web may change — and expect
/// the same refusal every time.
class _Canned implements HttpClientAdapter {
  _Canned(this.status, this.body, {this.offline = false});

  final int status;
  final Object? body;
  final bool offline;
  final List<RequestOptions> seen = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    if (offline) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      );
    }
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiContestRepository, _Canned) _stack(
  int status,
  Object? body, {
  bool offline = false,
}) {
  final _Canned adapter = _Canned(status, body, offline: offline);
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = adapter
    ..interceptors.add(ErrorInterceptor());
  return (ApiContestRepository(DioClient(dio)), adapter);
}

Map<String, dynamic> _refusal(String code, String message) => <String, dynamic>{
  'data': null,
  'error': <String, dynamic>{'code': code, 'message': message},
  'meta': <String, dynamic>{'version': 'v1'},
};

Map<String, dynamic> _ok(Object? data) => <String, dynamic>{
  'data': data,
  'error': null,
  'meta': <String, dynamic>{'version': 'v1'},
};

Future<Object> _thrown(Future<Object?> Function() call) async {
  try {
    await call();
  } on Object catch (e) {
    return e;
  }
  fail('expected a refusal');
}

void main() {
  // The code, the web's sentence for it, the statuses it is sent with, and
  // the refusal it must become.
  final List<(String, String, List<int>, TypeMatcher<ContestRefusal>)>
  table = <(String, String, List<int>, TypeMatcher<ContestRefusal>)>[
    (
      'NOT_ENTERED',
      'Join the contest to take its daily quiz.',
      // 403 on the lesson routes, 404 on the task routes.
      <int>[403, 404],
      isA<ContestNotEntered>(),
    ),
    (
      'NOT_RUNNING',
      'There is no contest running right now.',
      <int>[409],
      isA<ContestNotRunning>(),
    ),
    (
      'LOCKED',
      'Finish Lesson part 3 of 3 first.',
      // 409 from the tasks; 423 in the join route's table.
      <int>[409, 423],
      isA<ContestLocked>(),
    ),
    (
      'STALE_QUIZ',
      'Today’s quiz changed since this page loaded. Reload for today’s questions.',
      <int>[409],
      isA<ContestStale>(),
    ),
    (
      'NOT_TODAY',
      'That quiz has closed. Reload for today’s.',
      <int>[409],
      isA<ContestNotToday>(),
    ),
    ('NO_QUIZ', 'There is no quiz today.', <int>[404], isA<ContestNoQuiz>()),
    (
      'WRONG_DAY',
      'Connecting with leaders is a Monday and Thursday task.',
      <int>[409],
      isA<ContestWrongDay>(),
    ),
    (
      'TOO_EARLY',
      'You can share it from Thursday, 12 Nov, the day it goes out.',
      <int>[409],
      isA<ContestTooEarly>(),
    ),
    (
      'NOT_READY',
      'Generate this week in the Planner first.',
      <int>[409],
      isA<ContestNotReady>(),
    ),
    (
      'NOT_OPEN',
      'Open today’s comment level first.',
      <int>[409],
      isA<ContestNotOpen>(),
    ),
    (
      'ALREADY_DONE',
      'This week’s screenshot is already in.',
      <int>[409],
      isA<ContestAlreadyDone>(),
    ),
    (
      'DUPLICATE_URL',
      'That link has already been claimed.',
      <int>[409],
      isA<ContestDuplicateUrl>(),
    ),
    (
      'BAD_URL',
      'Paste the link to your LinkedIn post (linkedin.com/posts/… or /feed/update/…).',
      <int>[400],
      isA<ContestBadUrl>(),
    ),
    (
      'REVOKED',
      'Today’s comments were removed after review, so no more count today.',
      <int>[409],
      isA<ContestRevoked>(),
    ),
    (
      'CONFLICT',
      'That answer collided with another. Reload and try again.',
      <int>[409],
      isA<ContestConflict>(),
    ),
    (
      'TOO_LARGE',
      'That screenshot is over 8 MB.',
      <int>[413],
      isA<ContestTooLarge>(),
    ),
    (
      'INVALID_IMAGE',
      'The screenshot must be an image.',
      <int>[400],
      isA<ContestInvalidImage>(),
    ),
    (
      'STORAGE_UNAVAILABLE',
      'The proof store is not configured.',
      // A 503: the interceptor's "network" bucket.
      <int>[503],
      isA<ContestStorageUnavailable>(),
    ),
    (
      'VALIDATION_FAILED',
      'Pick one of the options.',
      <int>[400, 422],
      isA<ContestInvalid>(),
    ),
    (
      'PROFILE_INCOMPLETE',
      'Add your profession first.',
      <int>[400],
      isA<ContestProfileIncomplete>(),
    ),
  ];

  // Every status a refusal could plausibly ride on, including the three the
  // interceptor misfiles (403, 429, 503).
  const List<int> anyStatus = <int>[
    400,
    403,
    404,
    409,
    413,
    422,
    423,
    429,
    503,
  ];

  group('each code becomes its refusal', () {
    for (final (
          String code,
          String message,
          List<int> statuses,
          TypeMatcher<ContestRefusal> want,
        )
        in table) {
      test('$code at the statuses the server sends it with', () async {
        for (final int status in statuses) {
          final (ApiContestRepository repo, _) = _stack(
            status,
            _refusal(code, message),
          );
          final Object e = await _thrown(repo.fetchTodayQuiz);
          expect(e, want, reason: '$code at $status');
          // The server's own sentence, untouched.
          expect((e as ContestRefusal).message, message);
          expect(contestMessage(e), message);
        }
      });

      test('$code at ANY status — the code decides, never the class', () async {
        for (final int status in anyStatus) {
          final (ApiContestRepository repo, _) = _stack(
            status,
            _refusal(code, message),
          );
          expect(
            await _thrown(repo.completeConnect),
            want,
            reason: '$code at $status',
          );
        }
      });
    }

    test(
      'a 403 NOT_ENTERED is "join first", never "your session expired"',
      () async {
        final (ApiContestRepository repo, _) = _stack(
          403,
          _refusal('NOT_ENTERED', 'Join the contest to take its daily lesson.'),
        );
        final Object e = await _thrown(repo.startLesson);
        expect(e, isA<ContestNotEntered>());
        expect(contestMessage(e), isNot(contains('session')));
      },
    );

    test(
      'a code arriving inside a 2xx envelope is still the refusal',
      () async {
        final (ApiContestRepository repo, _) = _stack(
          200,
          _refusal('LOCKED', 'Finish Comment on a top voice first.'),
        );
        expect(await _thrown(repo.fetchPath), isA<ContestLocked>());
      },
    );

    test('a refusal with no sentence falls back to the web’s', () async {
      final (ApiContestRepository repo, _) = _stack(
        409,
        _refusal('NOT_RUNNING', ''),
      );
      expect(
        contestMessage(await _thrown(repo.fetchOverview)),
        'There is no contest running right now.',
      );
    });
  });

  group('the plan gate on the connect level', () {
    test('402 LIMIT_REACHED is the plan, with when it comes back', () async {
      final (ApiContestRepository repo, _) = _stack(402, <String, dynamic>{
        'data': null,
        'error': <String, dynamic>{
          'code': 'LIMIT_REACHED',
          'message': "You've used today's connection batches.",
          'details': <String, dynamic>{
            'key': 'ai_connections',
            'limit': 1,
            'period': 'day',
            'used': 1,
            'resetsAt': '2026-11-12T18:30:00.000Z',
          },
        },
      });
      final Object e = await _thrown(repo.fetchConnectTargets);
      expect(e, isA<ContestPlanRefused>());
      final ContestPlanRefused r = e as ContestPlanRefused;
      expect(r.refusal.isLimit, isTrue);
      expect(r.refusal.key, 'ai_connections');
      expect(r.refusal.resetsAt, DateTime.utc(2026, 11, 12, 18, 30));
    });

    test('402 INSUFFICIENT_XP is "needs a plan", never "needs XP"', () async {
      final (ApiContestRepository repo, _) = _stack(402, <String, dynamic>{
        'data': null,
        'error': <String, dynamic>{
          'code': 'INSUFFICIENT_XP',
          'message': 'This needs a Plexaverse plan.',
          'details': <String, dynamic>{
            'reason': 'NOT_ENTITLED',
            'upgradeUrl': '/pricing',
          },
        },
      });
      final Object e = await _thrown(repo.fetchConnectTargets);
      expect((e as ContestPlanRefused).refusal.needsPlan, isTrue);
      expect(contestMessage(e), isNot(contains('XP')));
    });
  });

  group('what is not a contest refusal', () {
    test(
      'the rate limiter’s bare 429 says what it said, not "join first"',
      () async {
        final (ApiContestRepository repo, _) = _stack(429, <String, dynamic>{
          'error': 'Too many requests. Please try again later.',
        });
        final Object e = await _thrown(repo.fetchPath);
        expect(e, isA<ContestUnavailable>());
        expect(contestMessage(e), 'Too many requests. Please try again later.');
      },
    );

    test('no connection is said as one', () async {
      final (ApiContestRepository repo, _) = _stack(0, null, offline: true);
      final Object e = await _thrown(repo.fetchOverview);
      expect(e, isA<ContestUnavailable>());
      expect(contestMessage(e), contains('No connection'));
    });

    test('a 401 with nothing to say is the session', () async {
      final (ApiContestRepository repo, _) = _stack(401, null);
      expect(
        contestMessage(await _thrown(repo.fetchOverview)),
        'Your session expired. Sign in again.',
      );
    });

    test('a 500 keeps the route’s sentence', () async {
      final (ApiContestRepository repo, _) = _stack(500, <String, dynamic>{
        'data': null,
        'error': <String, dynamic>{
          'code': 'INTERNAL',
          'message': 'Could not load your path.',
        },
      });
      final Object e = await _thrown(repo.fetchPath);
      expect(e, isA<ContestUnavailable>());
      expect(contestMessage(e), 'Could not load your path.');
    });

    test('anything else a screen catches still reads as one sentence', () {
      expect(
        contestMessage(StateError('boom')),
        'That did not come through. Try again.',
      );
    });
  });

  group('the wire', () {
    test('no contest is an answer; a missing body is not', () async {
      final (ApiContestRepository none, _) = _stack(
        200,
        _ok(<String, dynamic>{'overview': null}),
      );
      expect(await none.fetchOverview(), isNull);

      final (ApiContestRepository empty, _) = _stack(200, _ok(null));
      expect(await _thrown(empty.fetchOverview), isA<ContestUnavailable>());
    });

    test('join sends the ticked box as a literal bool', () async {
      final (ApiContestRepository repo, _Canned wire) = _stack(
        200,
        _ok(<String, dynamic>{'ok': true}),
      );
      await repo.join(showName: false);
      expect(wire.seen.single.method, 'POST');
      expect(wire.seen.single.path, '/contest/join');
      expect(wire.seen.single.data, <String, dynamic>{'showName': false});
    });

    test('the board asks for a limit only when one is given', () async {
      final (ApiContestRepository repo, _Canned wire) = _stack(
        200,
        _ok(<String, dynamic>{
          'revealed': false,
          'revealsOn': '2027-01-30',
          'revealDay': 91,
          'rows': <Object>[],
          'viewer': null,
          'self': null,
        }),
      );
      await repo.fetchBoard(limit: 10);
      await repo.fetchBoard();
      expect(wire.seen[0].queryParameters, <String, dynamic>{'limit': 10});
      expect(wire.seen[1].queryParameters, isEmpty);
    });

    test('an answer sends the day, the item and the option’s TEXT', () async {
      final (ApiContestRepository repo, _Canned wire) = _stack(
        200,
        _ok(<String, dynamic>{
          'result': <String, dynamic>{
            'value': 'postpone',
            'correct': true,
            'correctOption': 'postpone',
            'explain': 'Later.',
            'completed': false,
            'pointsApplied': 12,
            'scored': true,
            'weekBonus': null,
            'replay': false,
          },
        }),
      );
      final QuizAnswerResult r = await repo.answerQuiz(
        day: 11,
        itemId: 'qz-b1-0051',
        value: 'postpone',
      );
      expect(r.pointsApplied, 12);
      expect(wire.seen.single.path, '/contest/quiz/answer');
      expect(wire.seen.single.data, <String, dynamic>{
        'day': 11,
        'itemId': 'qz-b1-0051',
        'value': 'postpone',
      });
    });

    test('opening the lesson is a POST to the lesson', () async {
      final (ApiContestRepository repo, _Canned wire) = _stack(
        200,
        _ok(<String, dynamic>{
          'quiz': <String, dynamic>{'status': 'ready', 'started': true},
        }),
      );
      expect((await repo.startLesson()).started, isTrue);
      expect(wire.seen.single.method, 'POST');
      expect(wire.seen.single.path, '/contest/lesson');
    });

    test('a claim sends the piece as the path named it', () async {
      final (ApiContestRepository repo, _Canned wire) = _stack(
        200,
        _ok(<String, dynamic>{
          'result': <String, dynamic>{
            'taskId': 't',
            'claim': <String, dynamic>{
              'kind': 'video',
              'occurrence': '6:1:2',
              'title': 'x',
              'status': 'pending',
              'points': 40,
            },
          },
        }),
      );
      await repo.claimPostLink(
        kind: ClaimKind.video,
        occurrence: '6:1:2',
        postUrl: 'https://www.linkedin.com/posts/x',
      );
      expect(wire.seen.single.data, <String, dynamic>{
        'kind': 'video',
        'occurrence': '6:1:2',
        'postUrl': 'https://www.linkedin.com/posts/x',
      });
    });

    test('a piece this build cannot name is never sent', () async {
      final (ApiContestRepository repo, _Canned wire) = _stack(200, _ok(null));
      expect(
        await _thrown(
          () => repo.claimPostLink(
            kind: ClaimKind.unknown,
            occurrence: '6:1',
            postUrl: 'https://www.linkedin.com/posts/x',
          ),
        ),
        isA<ContestInvalid>(),
      );
      expect(wire.seen, isEmpty);
    });

    test(
      'the screenshot goes as `screenshot`, with an image content type',
      () async {
        final (ApiContestRepository repo, _Canned wire) = _stack(
          200,
          _ok(<String, dynamic>{
            'result': <String, dynamic>{
              'taskId': 't',
              'status': 'done',
              'pointsApplied': 80,
              'replaced': false,
            },
          }),
        );
        final InvitesSubmitResult r = await repo.submitInvites(
          Uint8List.fromList(<int>[1, 2, 3]),
          'sent.png',
        );
        expect(r.pointsApplied, 80);
        final FormData form = wire.seen.single.data as FormData;
        expect(form.files.single.key, 'screenshot');
        expect(form.files.single.value.contentType.toString(), 'image/png');

        // A name that says nothing is a JPEG, never octet-stream.
        expect(
          ApiContestRepository.imageTypeOf('IMG_0042').toString(),
          'image/jpeg',
        );
        expect(
          ApiContestRepository.imageTypeOf('a.HEIC').toString(),
          'image/heic',
        );
      },
    );

    test('a skip sends the node id as the path gave it', () async {
      final (ApiContestRepository repo, _Canned wire) = _stack(
        200,
        _ok(<String, dynamic>{
          'result': <String, dynamic>{
            'nodeId': '2026-11-18:lesson:2',
            'alreadySkipped': false,
          },
        }),
      );
      final SkipResult r = await repo.skipLevel('2026-11-18:lesson:2');
      expect(r.nodeId, '2026-11-18:lesson:2');
      expect(r.alreadySkipped, isFalse);
      expect(wire.seen.single.method, 'POST');
      expect(wire.seen.single.path, '/contest/skip');
      expect(wire.seen.single.data, <String, dynamic>{
        'nodeId': '2026-11-18:lesson:2',
      });
    });

    test('a skip’s refusals map by code, the server’s sentence kept', () async {
      final List<(String, String, int, TypeMatcher<ContestRefusal>)> cases =
          <(String, String, int, TypeMatcher<ContestRefusal>)>[
            (
              'WRONG_DAY',
              'That day is over. Reload the path for today’s.',
              409,
              isA<ContestWrongDay>(),
            ),
            (
              'ALREADY_DONE',
              'That level is already done.',
              409,
              isA<ContestAlreadyDone>(),
            ),
            (
              'NOT_OPEN',
              'Only the level you are on can be skipped.',
              409,
              isA<ContestNotOpen>(),
            ),
            (
              'LOCKED',
              'Finish or skip Lesson part 2 of 3 first.',
              409,
              isA<ContestLocked>(),
            ),
            (
              'NOT_ENTERED',
              'Join the contest to take part in its tasks.',
              404,
              isA<ContestNotEntered>(),
            ),
            (
              'VALIDATION_FAILED',
              'That level is not on today’s path.',
              400,
              isA<ContestInvalid>(),
            ),
          ];
      for (final (
            String code,
            String message,
            int status,
            TypeMatcher<ContestRefusal> want,
          )
          in cases) {
        final (ApiContestRepository repo, _) = _stack(
          status,
          _refusal(code, message),
        );
        final Object e = await _thrown(() => repo.skipLevel('x'));
        expect(e, want, reason: code);
        expect(contestMessage(e), message, reason: code);
      }
      final (ApiContestRepository repo, _) = _stack(
        500,
        _refusal('INTERNAL', 'Could not skip that level. Try again.'),
      );
      final Object e = await _thrown(() => repo.skipLevel('x'));
      expect(e, isA<ContestUnavailable>());
      expect(contestMessage(e), 'Could not skip that level. Try again.');
    });

    test('the consistency meter is read from {consistency}', () async {
      final (ApiContestRepository repo, _Canned wire) = _stack(
        200,
        _ok(<String, dynamic>{
          'consistency': <String, dynamic>{
            'state': 'measuring',
            'mode': 'shadow',
            'threshold': 75,
            'percent': 68,
            'atOrAbove': false,
            'earned': 1820,
            'available': 2680,
            'pending': 80,
            'unaudited': 100,
            'toLine': 190,
            'countedDays': 12,
            'window': <String, dynamic>{
              'from': '2026-10-31T18:30:00.000Z',
              'to': '2026-11-30T18:30:00.000Z',
              'basis': 'calendar',
              'estimated': false,
            },
            'today': <String, dynamic>{
              'dayKey': '2026-11-18',
              'earned': 60,
              'available': 340,
            },
            'joined': true,
            'scoringPaused': false,
            'noContestRunning': false,
            'days': <Map<String, dynamic>>[
              <String, dynamic>{
                'dayKey': '2026-11-18',
                'available': 340,
                'earned': 60,
                'pending': 0,
                'paused': false,
                'today': true,
              },
            ],
          },
        }),
      );
      final ConsistencyView v = await repo.fetchConsistency();
      expect(wire.seen.single.method, 'GET');
      expect(wire.seen.single.path, '/contest/consistency');
      expect(v.state, ConsistencyState.measuring);
      expect(v.percent, 68);
      expect(v.atOrAbove, isFalse);
      expect(v.toLine, 190);
      expect(v.window?.from, DateTime.utc(2026, 10, 31, 18, 30));
      expect(v.today?.available, 340);
      expect(v.days.single.today, isTrue);
    });

    test('a consistency read with no body, or a 500, is unavailable', () async {
      final (ApiContestRepository empty, _) = _stack(
        200,
        _ok(<String, dynamic>{}),
      );
      expect(await _thrown(empty.fetchConsistency), isA<ContestUnavailable>());
      final (ApiContestRepository failed, _) = _stack(
        500,
        _refusal('INTERNAL', 'Could not load your consistency.'),
      );
      final Object e = await _thrown(failed.fetchConsistency);
      expect(e, isA<ContestUnavailable>());
      expect(contestMessage(e), 'Could not load your consistency.');
    });

    test('a screenshot over 8 MB is refused before a byte is sent', () async {
      final (ApiContestRepository repo, _Canned wire) = _stack(200, _ok(null));
      final Object e = await _thrown(
        () => repo.submitInvites(
          Uint8List(kMaxInvitesScreenshotBytes + 1),
          'big.jpg',
        ),
      );
      expect(e, isA<ContestTooLarge>());
      expect(wire.seen, isEmpty);
    });
  });
}
