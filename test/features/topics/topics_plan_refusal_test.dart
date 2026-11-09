import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/network/dio_client.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';
import 'package:plexaverse/features/topics/data/topics_repositories.dart';
import 'package:plexaverse/features/topics/domain/topics_repository.dart';

/// Suggesting topics is paid for by the plan, and the two plan refusals must
/// survive the repository: the interceptor drops `details`, so without the
/// plan parser a used-up limit lost `resetsAt` and the user was never told
/// when suggestions come back.
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

Future<TopicsUnavailable> _suggestRefused(Map<String, dynamic> error) async {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = _Canned(402, <String, dynamic>{
      'data': null,
      'error': error,
    })
    ..interceptors.add(ErrorInterceptor());
  try {
    await ApiTopicsRepository(DioClient(dio)).suggestTopics();
  } on TopicsUnavailable catch (e) {
    return e;
  }
  fail('suggestTopics should have thrown');
}

void main() {
  test('a used-up daily limit says when suggestions come back', () async {
    final TopicsUnavailable e = await _suggestRefused(<String, dynamic>{
      'code': 'LIMIT_REACHED',
      'message': "You've used today's topic suggestions.",
      'details': <String, dynamic>{
        'key': 'ai_suggest_topics',
        'limit': 3,
        'period': 'day',
        'used': 3,
        'resetsAt': DateTime.now()
            .add(const Duration(hours: 2))
            .toUtc()
            .toIso8601String(),
      },
    });
    expect(e.reason, TopicsFailure.limitReached);
    expect(e.message, contains("You've used today's topic suggestions."));
    expect(e.message, contains('Back'));
    expect(e.message, isNot(contains('XP')));
  });

  test('INSUFFICIENT_XP means no plan, not an XP shortfall', () async {
    final TopicsUnavailable e = await _suggestRefused(<String, dynamic>{
      'code': 'INSUFFICIENT_XP',
      'message': 'Topic suggestions need a Plexaverse plan.',
      'details': <String, dynamic>{
        'reason': 'NOT_ENTITLED',
        'upgradeUrl': '/pricing',
      },
    });
    expect(e.reason, TopicsFailure.needsPlan);
    expect(e.message, 'Topic suggestions need a Plexaverse plan.');
  });

  test('other codes still map as before', () async {
    final TopicsUnavailable e = await _suggestRefused(<String, dynamic>{
      'code': 'PROFILE_INCOMPLETE',
      'message': 'Add your profession first.',
    });
    expect(e.reason, TopicsFailure.profileIncomplete);
    expect(e.message, 'Add your profession first.');
  });
}
