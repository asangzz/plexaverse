import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/network/api_paths.dart';
import 'package:plexaverse/core/network/dio_client.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';
import 'package:plexaverse/features/home/data/connections_repositories.dart';
import 'package:plexaverse/features/home/domain/connections_repository.dart';

/// `GET/POST /reach/connections` as the mobile route answers them
/// (`app/api/mobile/v1/reach/connections/route.ts` on the web): the summary
/// inside `data`, and a refused count as 400 `VALIDATION_FAILED` carrying the
/// server's sentence and `fields.count`.
class _Canned implements HttpClientAdapter {
  _Canned(this.status, this.body);

  final int status;
  final Object body;
  final List<RequestOptions> seen = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
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

(ApiConnectionsRepository, _Canned) _repo(int status, Object body) {
  final _Canned adapter = _Canned(status, body);
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = adapter
    ..interceptors.add(ErrorInterceptor());
  return (ApiConnectionsRepository(DioClient(dio)), adapter);
}

void main() {
  test('reads a summary with a week figure and the series', () async {
    final (ApiConnectionsRepository repo, _) = _repo(200, <String, dynamic>{
      'data': <String, dynamic>{
        'reading': <String, dynamic>{
          'count': 520,
          'measuredAt': '2026-11-12T10:00:00.000Z',
        },
        'growth': <String, dynamic>{
          'week': 40,
          'sinceFirst': 40,
          'firstMeasuredAt': '2026-11-01T10:00:00.000Z',
          'daysCovered': 11,
          'readings': 2,
        },
        'history': <Map<String, dynamic>>[
          <String, dynamic>{
            'count': 480,
            'measuredAt': '2026-11-01T10:00:00.000Z',
          },
          <String, dynamic>{
            'count': 520,
            'measuredAt': '2026-11-12T10:00:00.000Z',
          },
        ],
      },
      'error': null,
    });

    final ConnectionSummary s = await repo.fetchSummary();
    expect(s.reading!.count, 520);
    expect(s.growth!.week, 40);
    expect(s.growth!.readings, 2);
    expect(s.history.map((ConnectionReading h) => h.count), <int>[480, 520]);
  });

  test('a lapsed week arrives as null, not as zero', () async {
    final (ApiConnectionsRepository repo, _) = _repo(200, <String, dynamic>{
      'data': <String, dynamic>{
        'reading': <String, dynamic>{
          'count': 450,
          'measuredAt': '2026-10-20T10:00:00.000Z',
        },
        'growth': <String, dynamic>{
          'week': null,
          'sinceFirst': 50,
          'firstMeasuredAt': '2026-10-01T10:00:00.000Z',
          'daysCovered': 19,
          'readings': 2,
        },
        'history': <Map<String, dynamic>>[],
      },
    });
    expect((await repo.fetchSummary()).growth!.week, isNull);
  });

  test('an account with no count is the empty shape', () async {
    final (ApiConnectionsRepository repo, _) = _repo(200, <String, dynamic>{
      'data': <String, dynamic>{
        'reading': null,
        'growth': null,
        'history': <Map<String, dynamic>>[],
      },
    });
    final ConnectionSummary s = await repo.fetchSummary();
    expect(s.reading, isNull);
    expect(s.growth, isNull);
    expect(s.history, isEmpty);
  });

  test('a failed read is the one sentinel', () async {
    final (ApiConnectionsRepository repo, _) = _repo(500, <String, dynamic>{
      'data': null,
      'error': <String, dynamic>{'code': 'INTERNAL', 'message': 'boom'},
    });
    await expectLater(
      repo.fetchSummary(),
      throwsA(isA<ConnectionsUnavailable>()),
    );
  });

  test('a save posts the count alone, to the mobile twin', () async {
    final (ApiConnectionsRepository repo, _Canned adapter) = _repo(
      200,
      <String, dynamic>{
        'data': <String, dynamic>{'id': 'row-1'},
      },
    );
    await repo.record(1240);

    final RequestOptions sent = adapter.seen.single;
    expect(sent.method, 'POST');
    expect(sent.path, ApiPaths.reachConnections);
    // The server's schema is strict: any other key is a 400.
    expect(sent.data, <String, dynamic>{'count': 1240});
  });

  test("a refused count carries the server's sentence", () async {
    final (ApiConnectionsRepository repo, _) = _repo(400, <String, dynamic>{
      'data': null,
      'error': <String, dynamic>{
        'code': 'VALIDATION_FAILED',
        'message': 'Enter a whole number between 0 and 30,000.',
        'fields': <String, dynamic>{
          'count': <String>['Enter a whole number between 0 and 30,000.'],
        },
      },
    });
    await expectLater(
      repo.record(30001),
      throwsA(
        isA<ConnectionsInvalid>().having(
          (ConnectionsInvalid e) => e.message,
          'message',
          'Enter a whole number between 0 and 30,000.',
        ),
      ),
    );
  });

  test('any other failure is left for the caller to word', () async {
    final (ApiConnectionsRepository repo, _) = _repo(500, <String, dynamic>{
      'data': null,
      'error': <String, dynamic>{
        'code': 'INTERNAL',
        'message': 'Could not save that number.',
      },
    });
    await expectLater(repo.record(480), throwsA(isA<DioException>()));
  });
}
