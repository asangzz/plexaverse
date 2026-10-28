import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/network/failure.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';

/// `Failure.errorCode` has to survive the mobile envelope.
///
/// ## The bug this pins
///
/// Every rejection from the mobile API is
/// `{data: null, error: {code, message}, meta}`, and the interceptor used to
/// look for the code at the TOP level of the body only — while the MESSAGE
/// extractor already handled the nesting. So a failure arrived carrying the
/// server's sentence and no code, and every `switch (failure.errorCode)` in
/// the app fell through to its generic branch.
///
/// That is not cosmetic. `OUT_OF_HEARTS` is a screen with a retry button,
/// `IMAGE_MISSING` means "your poster is not made yet", `NOT_A_POST_DAY`
/// means a retry can never work — all of them showed as "something went
/// wrong". Two slices had already reached past [Failure] into the raw body
/// to work around it.
class _CannedAdapter implements HttpClientAdapter {
  _CannedAdapter(this.body, this.statusCode);

  final Object? body;
  final int statusCode;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

Future<Failure> _failureFor(Object? body, int status) async {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = _CannedAdapter(body, status)
    ..interceptors.add(ErrorInterceptor());
  try {
    await dio.get<dynamic>('/learn/level');
    fail('a $status should not resolve');
  } on DioException catch (e) {
    final Object? failure = e.error;
    expect(failure, isA<Failure>());
    return failure! as Failure;
  }
}

void main() {
  test('the envelope\'s nested code reaches Failure.errorCode', () async {
    final Failure failure = await _failureFor(<String, dynamic>{
      'data': null,
      'error': <String, dynamic>{
        'code': 'OUT_OF_HEARTS',
        'message': 'That is 5 wrong in one level. Run it again.',
      },
      'meta': <String, dynamic>{'version': 'v1'},
    }, 422);

    expect(failure.errorCode, 'OUT_OF_HEARTS');
    expect(failure.message, 'That is 5 wrong in one level. Run it again.');
    expect(failure, isA<ValidationFailure>());
  });

  test('a 409 keeps its code too — not-yet is not a failure', () async {
    // IMAGE_MISSING is the poster level asking the user to come back when
    // they have one. Without the code it is indistinguishable from a 409
    // that means the level is locked.
    final Failure failure = await _failureFor(<String, dynamic>{
      'data': null,
      'error': <String, dynamic>{
        'code': 'IMAGE_MISSING',
        'message': 'No poster on this post yet.',
      },
    }, 409);

    expect(failure.errorCode, 'IMAGE_MISSING');
  });

  test('a top-level code still wins, for anything not enveloped', () async {
    final Failure failure = await _failureFor(<String, dynamic>{
      'code': 'LEGACY_SHAPE',
      'message': 'from a flat body',
      'error': <String, dynamic>{'code': 'IGNORED'},
    }, 400);

    expect(failure.errorCode, 'LEGACY_SHAPE');
  });

  test('a string error body yields no code rather than a wrong one', () async {
    final Failure failure = await _failureFor(<String, dynamic>{
      'error': 'Bad Request',
    }, 400);

    expect(failure.errorCode, isNull);
    expect(failure.message, 'Bad Request');
  });
}
