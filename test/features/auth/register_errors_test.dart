import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/consent/notice.dart';
import 'package:plexaverse/core/network/dio_client.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';
import 'package:plexaverse/core/platform/web_auth.dart';
import 'package:plexaverse/features/auth/data/api_auth_repository.dart';
import 'package:plexaverse/features/auth/domain/auth_repository.dart';

/// A sign-up the server refuses says why.
///
/// Every 4xx the register route sends carries a sentence written for the user
/// — an email that already has an account, a privacy notice this build is too
/// old to show. They used to be filed as network failures and rendered as
/// "Something went wrong. Please try again.", so a stale build could not sign
/// anyone up and told them to retry a request that could never succeed.
///
/// The bodies below are the server's real envelope: `fail()` in
/// lib/mobile/envelope.ts nests `{ code, message }` under `error`.
class _Canned implements HttpClientAdapter {
  _Canned(this.status, this.body);

  final int status;
  final Object body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

Future<RegisterResult> _register(int status, String code, String message) {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = _Canned(status, <String, dynamic>{
      'data': null,
      'error': <String, dynamic>{'code': code, 'message': message},
    })
    ..interceptors.add(ErrorInterceptor());
  return ApiAuthRepository(DioClient(dio), const WebAuthService()).register(
    name: 'Asha',
    email: 'asha@example.com',
    password: 'correct-horse',
    acceptedNotice: true,
    noticeVersion: kNoticeVersion,
  );
}

void main() {
  test('a stale privacy notice says to update the app', () async {
    final RegisterResult r = await _register(
      400,
      'NOTICE_VERSION_STALE',
      'The privacy notice has changed. Update the app to continue.',
    );
    expect(r, isA<RegisterInvalid>());
    expect(
      (r as RegisterInvalid).message,
      'The privacy notice has changed. Update the app to continue.',
    );
  });

  test('an existing email says so, on the email field too', () async {
    final RegisterResult r = await _register(
      409,
      'CONFLICT',
      'An account with this email already exists',
    );
    expect(r, isA<RegisterInvalid>());
    expect(
      (r as RegisterInvalid).message,
      'An account with this email already exists',
    );
    expect(r.fieldErrors['email'], isNotNull);
  });

  test('paused sign-ups keep the server\'s words', () async {
    final RegisterResult r = await _register(
      503,
      'SERVICE_UNAVAILABLE',
      'New sign-ups are temporarily paused. Please check back soon.',
    );
    expect(r, isA<RegisterNetworkFailure>());
    expect(
      (r as RegisterNetworkFailure).message,
      'New sign-ups are temporarily paused. Please check back soon.',
    );
  });
}
