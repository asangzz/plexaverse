import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/network/dio_client.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';
import 'package:plexaverse/features/placement/data/placement_repositories.dart';
import 'package:plexaverse/features/placement/domain/placement_repository.dart';

/// Every placement refusal reaches the page as its own type, at the status
/// the server really sends it with.
///
/// The mobile routes keep the web's statuses: 403 CONSENT_REQUIRED, 429
/// COOLDOWN, 503 GRADING_UNAVAILABLE. The interceptor files those as an
/// [AuthFailure] and two [NetworkFailure]s — by class, a cooldown reads as
/// "check your connection". These go through the real [DioClient] and the
/// real interceptor, so a repository that switched on the class instead of
/// the code fails here.
class _Canned implements HttpClientAdapter {
  _Canned(this.status, this.body);

  final int status;
  final Object? body;

  /// What each request carried, for the body checks.
  final List<RequestOptions> requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
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

(ApiPlacementRepository, _Canned) _repo(int status, Object? body) {
  final _Canned canned = _Canned(status, body);
  final DioClient client = DioClient(
    Dio(BaseOptions(baseUrl: 'https://example.test/api/mobile/v1'))
      ..httpClientAdapter = canned
      ..interceptors.add(ErrorInterceptor()),
  );
  return (ApiPlacementRepository(client), canned);
}

Map<String, dynamic> _refusal(
  String code,
  String message, {
  Map<String, dynamic>? details,
}) => <String, dynamic>{
  'data': null,
  'error': <String, dynamic>{
    'code': code,
    'message': message,
    'details': ?details,
  },
  'meta': <String, dynamic>{'version': 'v1'},
};

Map<String, dynamic> _ok(Map<String, dynamic> data) => <String, dynamic>{
  'data': data,
  'error': null,
  'meta': <String, dynamic>{'version': 'v1'},
};

const String _cooldownWords =
    'You can retake the placement test 30 days after your last one.';

void main() {
  group('the code decides, not the status', () {
    test(
      '429 COOLDOWN is a cooldown with its date, not a network blip',
      () async {
        final (ApiPlacementRepository repo, _) = _repo(
          429,
          _refusal(
            'COOLDOWN',
            _cooldownWords,
            details: <String, dynamic>{
              'nextRetakeAt': '2026-12-09T10:00:00.000Z',
            },
          ),
        );

        final Object error = await _thrown(repo.start);
        expect(error, isA<PlacementCooldown>());
        final PlacementCooldown cooldown = error as PlacementCooldown;
        expect(cooldown.message, _cooldownWords);
        // `details` never reaches the Failure; it is read off the raw body.
        expect(cooldown.nextRetakeAt, DateTime.utc(2026, 12, 9, 10));
      },
    );

    test('a COOLDOWN with no date still says when, in words', () async {
      final (ApiPlacementRepository repo, _) = _repo(
        429,
        _refusal('COOLDOWN', _cooldownWords),
      );
      final Object error = await _thrown(repo.start);
      expect((error as PlacementCooldown).nextRetakeAt, isNull);
      expect(placementMessage(error), _cooldownWords);
    });

    test('the limiter\'s own 429 has no code, and is not a cooldown', () async {
      final (ApiPlacementRepository repo, _) = _repo(429, <String, dynamic>{
        'error': 'Too many requests. Please try again later.',
      });
      final Object error = await _thrown(repo.start);
      expect(error, isA<PlacementUnavailable>());
      expect(
        placementMessage(error),
        'Too many requests. Please try again later.',
      );
    });

    test('403 CONSENT_REQUIRED is the consent card, not a sign-out', () async {
      final (ApiPlacementRepository repo, _) = _repo(
        403,
        _refusal(
          'CONSENT_REQUIRED',
          'Grading your writing sends it to an AI provider. Agree to that '
              'first, or skip the writing step.',
        ),
      );
      final Object error = await _thrown(
        () => repo.submitWriting(attemptId: 'att_1', text: 'x' * 40),
      );
      expect(error, isA<PlacementConsentRequired>());
    });

    test('503 GRADING_UNAVAILABLE says the page\'s own words', () async {
      final (ApiPlacementRepository repo, _) = _repo(
        503,
        _refusal(
          'GRADING_UNAVAILABLE',
          'Your writing could not be graded just now, so nothing was saved.',
        ),
      );
      final Object error = await _thrown(
        () => repo.submitWriting(attemptId: 'att_1', text: 'x' * 40),
      );
      expect(error, isA<PlacementGradingUnavailable>());
      expect(placementMessage(error), gradingUnavailableMessage);
    });

    final Map<String, (int, String, Type)> moves =
        <String, (int, String, Type)>{
          'ALREADY_COMPLETE': (
            409,
            'This placement test is already finished.',
            PlacementAlreadyComplete,
          ),
          'NOT_FOUND': (
            404,
            'That placement test was not found.',
            PlacementNotFound,
          ),
          'NOT_READY': (
            409,
            'Finish the three parts of the test first.',
            PlacementNotReady,
          ),
          'VALIDATION_FAILED': (
            400,
            'Pick one of the options.',
            PlacementRejected,
          ),
        };
    for (final MapEntry<String, (int, String, Type)> m in moves.entries) {
      test('${m.value.$1} ${m.key} keeps the server\'s sentence', () async {
        final (ApiPlacementRepository repo, _) = _repo(
          m.value.$1,
          _refusal(m.key, m.value.$2),
        );
        final Object error = await _thrown(
          () => repo.answer(attemptId: 'att_1', itemId: 'step-3', value: 'a'),
        );
        expect(error.runtimeType, m.value.$3);
        expect(placementMessage(error), m.value.$2);
      });
    }

    test('a 500 shows the route\'s sentence', () async {
      final (ApiPlacementRepository repo, _) = _repo(
        500,
        _refusal('INTERNAL', 'Could not load your placement.'),
      );
      final Object error = await _thrown(repo.fetchStatus);
      expect(error, isA<PlacementUnavailable>());
      expect(placementMessage(error), 'Could not load your placement.');
    });

    test('a 401 never shows the server\'s log line', () async {
      final (ApiPlacementRepository repo, _) = _repo(
        401,
        _refusal('UNAUTHORIZED', 'Authentication required'),
      );
      final Object error = await _thrown(repo.fetchStatus);
      expect(placementMessage(error), 'You have been signed out.');
    });

    test(
      'a body that does not parse is unavailable, not a TypeError',
      () async {
        final (ApiPlacementRepository repo, _) = _repo(
          200,
          _ok(<String, dynamic>{'status': 'not a map'}),
        );
        final Object error = await _thrown(repo.fetchStatus);
        expect(error, isA<PlacementUnavailable>());
        expect(placementMessage(error), placementFallbackMessage);
      },
    );
  });

  group('what goes out', () {
    test('an answer sends the option TEXT and the handle untouched', () async {
      final (ApiPlacementRepository repo, _Canned canned) = _repo(
        200,
        _ok(<String, dynamic>{
          'step': <String, dynamic>{
            'attemptId': 'att_1',
            'stage': 'objective',
            'answered': 4,
          },
        }),
      );
      await repo.answer(
        attemptId: 'att_1',
        itemId: 'step-3',
        value: 'take over',
      );
      final RequestOptions sent = canned.requests.single;
      expect(sent.path, '/placement/answer');
      expect(sent.method, 'POST');
      expect(sent.data, <String, dynamic>{
        'attemptId': 'att_1',
        'itemId': 'step-3',
        'value': 'take over',
      });
    });

    test('the writing consent is recorded as given in context', () async {
      final (ApiPlacementRepository repo, _Canned canned) = _repo(
        200,
        _ok(<String, dynamic>{'noticeVersion': 'x', 'consents': <Object>[]}),
      );
      await repo.grantWritingConsent();
      final RequestOptions sent = canned.requests.single;
      expect(sent.path, '/user/consent');
      expect(sent.method, 'PATCH');
      expect(sent.data, <String, dynamic>{
        'purpose': 'assessment_grading',
        'granted': true,
        'source': 'in_context',
      });
    });

    test('skip asks for the stored result of that attempt', () async {
      final (ApiPlacementRepository repo, _Canned canned) = _repo(
        200,
        _ok(<String, dynamic>{
          'result': <String, dynamic>{
            'band': 'B2',
            'vocabularyBand': 'B2',
            'grammarBand': 'B1',
            'readingBand': 'B2',
            'writingSubmitted': false,
            'completedAt': '2026-11-12T08:00:00.000Z',
          },
        }),
      );
      final PlacementResult result = await repo.finish('att_1');
      expect(result.band, CefrBand.b2);
      expect(canned.requests.single.path, '/placement/finish');
      expect(canned.requests.single.data, <String, dynamic>{
        'attemptId': 'att_1',
      });
    });
  });
}

Future<Object> _thrown(Future<Object?> Function() call) async {
  try {
    await call();
  } on Object catch (e) {
    return e;
  }
  fail('expected a refusal');
}
