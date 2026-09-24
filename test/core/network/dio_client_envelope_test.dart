import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/network/dio_client.dart';
import 'package:plexaverse/core/network/failure.dart';

/// Serves one canned JSON body, whatever is asked of it.
class _CannedAdapter implements HttpClientAdapter {
  _CannedAdapter(this.body, {this.statusCode = 200});

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

DioClient _clientServing(Object? body, {int statusCode = 200}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = _CannedAdapter(body, statusCode: statusCode);
  return DioClient(dio);
}

void main() {
  group('envelope unwrapping', () {
    test('an object payload is handed back as the response data', () async {
      final client = _clientServing(<String, dynamic>{
        'data': <String, dynamic>{'balance': 1440},
        'error': null,
        'meta': <String, dynamic>{'version': 'v1'},
      });

      final response = await client.get<Map<String, dynamic>>('/user/xp');

      expect(response.data, <String, dynamic>{'balance': 1440});
      expect(DioClient.envelopeMeta(response)?['version'], 'v1');
    });

    test('a LIST payload survives a List-typed call', () async {
      // The regression this pins. Dio casts the body to `T` on the way out of
      // `_dio.get<T>`, which happens BEFORE the envelope is unwrapped — so a
      // caller asking for the payload's type got a TypeError on the ENVELOPE
      // (a Map) instead of their list. Every list endpoint returns its array
      // as `data`, so the only way to read one used to be `get<dynamic>` plus
      // a manual `is List` check; the one repository that typed the call
      // honestly (the Season 1 recap's published-post count) failed on every
      // load and blamed the server for it.
      final client = _clientServing(<String, dynamic>{
        'data': <dynamic>[
          <String, dynamic>{'id': 'p1'},
          <String, dynamic>{'id': 'p2'},
        ],
        'error': null,
        'meta': <String, dynamic>{
          'pagination': <String, dynamic>{'hasMore': true, 'limit': 100},
        },
      });

      final response = await client.get<List<dynamic>>('/posts');

      expect(response.data, hasLength(2));
      expect(
        DioClient.envelopeMeta(response)?['pagination'],
        <String, dynamic>{'hasMore': true, 'limit': 100},
      );
    });

    test('a null payload is null, not a cast failure', () async {
      final client = _clientServing(<String, dynamic>{
        'data': null,
        'error': null,
      });

      final response = await client.get<Map<String, dynamic>>('/user/whatever');

      expect(response.data, isNull);
    });

    test('an envelope error becomes a DioException carrying a Failure',
        () async {
      final client = _clientServing(<String, dynamic>{
        'data': null,
        'error': <String, dynamic>{
          'code': 'UNAUTHORIZED',
          'message': 'Sign in again.',
          'statusCode': 401,
        },
      });

      await expectLater(
        client.get<Map<String, dynamic>>('/user/xp'),
        throwsA(
          isA<DioException>().having(
            (DioException e) => e.error,
            'error',
            isA<AuthFailure>(),
          ),
        ),
      );
    });

    test('a bare, un-enveloped body is passed straight through', () async {
      final client = _clientServing(<String, dynamic>{'id': 'raw'});

      final response = await client.get<Map<String, dynamic>>('/legacy');

      expect(response.data, <String, dynamic>{'id': 'raw'});
    });
  });
}
