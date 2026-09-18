import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/mock/mock_api.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/internet_monitor.dart';
import '../domain/analytics_repository.dart';

const String _kAnalyticsAsset = 'assets/mock/analytics/analytics.json';

/// Bundled-JSON fake (offline-aware, parses through the real `fromJson`).
///
/// The Analytics tab returns a single aggregate object, so this loads a JSON
/// object (not an array) via [MockApi.loadObject] and deserialises it with
/// [AnalyticsEntity.fromJson]. Any failure collapses to the single feature
/// sentinel [AnalyticsUnavailable].
class FakeAnalyticsRepository implements AnalyticsRepository {
  const FakeAnalyticsRepository({this.isOffline});

  final bool Function()? isOffline;

  @override
  Future<AnalyticsEntity> fetchAnalytics() async {
    if (isOffline?.call() ?? false) throw const AnalyticsUnavailable();
    try {
      final json = await MockApi.loadObject(_kAnalyticsAsset);
      return AnalyticsEntity.fromJson(json);
    } on Object {
      throw const AnalyticsUnavailable();
    }
  }
}

/// Real Dio impl — `GET /analytics`. The mobile API envelope is unwrapped at
/// the [DioClient] parse seam, so `response.data` is already the inner
/// analytics object.
class ApiAnalyticsRepository implements AnalyticsRepository {
  const ApiAnalyticsRepository(this._client);

  final DioClient _client;

  @override
  Future<AnalyticsEntity> fetchAnalytics() async {
    try {
      final response =
          await _client.get<Map<String, dynamic>>(ApiPaths.linkedInAnalytics);
      final data = response.data;
      if (data == null) throw const AnalyticsUnavailable();
      return AnalyticsEntity.fromJson(data);
    } on AnalyticsUnavailable {
      rethrow;
    } on Object {
      throw const AnalyticsUnavailable();
    }
  }
}

/// Fake ↔ real switch on `useFakeBackend`; release builds can never get the
/// fake. Override in tests with `overrideWithValue`.
final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  final useFake = ref.watch(useFakeBackendProvider);
  assert(
    !(kReleaseMode && useFake),
    'useFakeBackend must be false in release builds.',
  );
  if (useFake && !kReleaseMode) {
    return FakeAnalyticsRepository(
      isOffline: () => ref.read(internetMonitorProvider).isOffline,
    );
  }
  return ApiAnalyticsRepository(ref.watch(dioClientProvider));
});
