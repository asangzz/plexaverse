import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/network/failure.dart';
import 'package:plexaverse/core/plan/plan_refusal.dart';

/// The one parser every AI feature reads the plan gate through. Pinned
/// because each slice used to read `INSUFFICIENT_XP` as "out of XP"; wallet XP
/// is retired, and the same code now means "no plan".
void main() {
  Map<String, dynamic> envelope(Map<String, dynamic> error) =>
      <String, dynamic>{'data': null, 'error': error};

  group('fromEnvelope', () {
    test('INSUFFICIENT_XP with NOT_ENTITLED is a needs-plan refusal', () {
      final PlanRefusal? r = PlanRefusal.fromEnvelope(
        envelope(<String, dynamic>{
          'code': 'INSUFFICIENT_XP',
          'message': 'Posts need a Plexaverse plan.',
          'details': <String, dynamic>{
            'reason': 'NOT_ENTITLED',
            'upgradeUrl': '/pricing',
          },
        }),
      );
      expect(r, isNotNull);
      expect(r!.needsPlan, isTrue);
      expect(r.isLimit, isFalse);
      expect(r.message, 'Posts need a Plexaverse plan.');
      expect(r.upgradeUrl, '/pricing');
    });

    test('a bare INSUFFICIENT_XP from an older server still means a plan', () {
      final PlanRefusal? r = PlanRefusal.fromEnvelope(
        envelope(<String, dynamic>{'code': 'INSUFFICIENT_XP'}),
      );
      expect(r?.needsPlan, isTrue);
      expect(r!.message, isNot(contains('XP')));
    });

    test('LIMIT_REACHED carries the limit and when it resets', () {
      final PlanRefusal? r = PlanRefusal.fromEnvelope(
        envelope(<String, dynamic>{
          'code': 'LIMIT_REACHED',
          'message': "You've used today's posts.",
          'details': <String, dynamic>{
            'key': 'ai_generate_post',
            'limit': 3,
            'period': 'day',
            'used': 3,
            'resetsAt': '2026-11-10T18:30:00.000Z',
          },
        }),
      );
      expect(r, isNotNull);
      expect(r!.isLimit, isTrue);
      expect(r.key, 'ai_generate_post');
      expect(r.limit, 3);
      expect(r.used, 3);
      expect(r.period, 'day');
      expect(r.resetsAt, DateTime.utc(2026, 11, 10, 18, 30));
    });

    test('any other code is not a plan refusal', () {
      expect(
        PlanRefusal.fromEnvelope(
          envelope(<String, dynamic>{'code': 'PROFILE_INCOMPLETE'}),
        ),
        isNull,
      );
      expect(PlanRefusal.fromEnvelope('nope'), isNull);
      expect(PlanRefusal.fromEnvelope(null), isNull);
    });
  });

  group('fromDioException', () {
    DioException refused(Object? body, {Object? error}) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      response: Response<Object?>(
        requestOptions: RequestOptions(path: '/x'),
        statusCode: 402,
        data: body,
      ),
      type: DioExceptionType.badResponse,
      error: error,
    );

    test('reads details off the raw body the interceptor keeps', () {
      final PlanRefusal? r = PlanRefusal.fromError(
        refused(
          envelope(<String, dynamic>{
            'code': 'LIMIT_REACHED',
            'message': 'Monthly carousels used.',
            'details': <String, dynamic>{
              'period': 'month',
              'resetsAt': '2026-12-01T00:00:00Z',
            },
          }),
          error: const ClientFailure(
            errorCode: 'LIMIT_REACHED',
            statusCode: 402,
          ),
        ),
      );
      expect(r?.isLimit, isTrue);
      expect(r!.resetsAt, isNotNull);
    });

    test('falls back to the Failure code when the body is gone', () {
      final PlanRefusal? r = PlanRefusal.fromError(
        refused(
          null,
          error: const ClientFailure(
            errorCode: 'INSUFFICIENT_XP',
            message: 'Needs a plan.',
            statusCode: 402,
          ),
        ),
      );
      expect(r?.needsPlan, isTrue);
      expect(r!.message, 'Needs a plan.');
    });

    test('anything else is null', () {
      expect(PlanRefusal.fromError(StateError('x')), isNull);
      expect(
        PlanRefusal.fromError(
          refused(null, error: const ServerFailure(statusCode: 500)),
        ),
        isNull,
      );
    });
  });

  group('when it comes back', () {
    // Everything is built in local time, so the labels do not depend on the
    // zone the test machine runs in.
    final DateTime now = DateTime(2026, 11, 10, 15);

    PlanRefusal limitAt(DateTime at) => PlanRefusal(
      kind: PlanRefusalKind.limitReached,
      message: "You've used today's posts.",
      resetsAt: at.toUtc(),
    );

    test('later today', () {
      expect(
        limitAt(DateTime(2026, 11, 10, 23, 30)).backAtLabel(now: now),
        'Back at 11:30 PM',
      );
    });

    test('tomorrow', () {
      expect(
        limitAt(DateTime(2026, 11, 11, 0, 0)).backAtLabel(now: now),
        'Back tomorrow at 12:00 AM',
      );
    });

    test('further out names the date', () {
      expect(
        limitAt(DateTime(2026, 12, 1, 0, 0)).backAtLabel(now: now),
        'Back on 1 Dec',
      );
    });

    test('displayMessage appends it to the server message', () {
      expect(
        limitAt(DateTime(2026, 11, 10, 23, 30)).displayMessage(now: now),
        "You've used today's posts. Back at 11:30 PM.",
      );
    });

    test('a needs-plan refusal is just the message', () {
      const PlanRefusal r = PlanRefusal(
        kind: PlanRefusalKind.needsPlan,
        message: 'Needs a plan.',
      );
      expect(r.backAtLabel(), isNull);
      expect(r.displayMessage(), 'Needs a plan.');
    });
  });
}
