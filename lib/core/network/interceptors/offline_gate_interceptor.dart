import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../internet_monitor.dart';

part 'offline_gate_interceptor.g.dart';

/// Online-first fast-fail: when [InternetMonitor] says the device is
/// definitively offline, reject the request immediately as a connection
/// error instead of letting it burn the 15s connect timeout. The rejection
/// flows through [ErrorInterceptor], which maps `connectionError` to a
/// [NetworkFailure] — so repositories and the UI see exactly the same
/// failure shape as a real transport failure, just instantly.
///
/// `checking` (boot) passes through: only a probe-confirmed offline gates.
class OfflineGateInterceptor extends Interceptor {
  OfflineGateInterceptor({required bool Function() isOffline})
      : _isOffline = isOffline;

  final bool Function() _isOffline;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_isOffline()) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'Offline — request fast-failed by OfflineGateInterceptor.',
        ),
        true, // run the error interceptors so the Failure mapping applies
      );
      return;
    }
    handler.next(options);
  }
}

@Riverpod(keepAlive: true)
OfflineGateInterceptor offlineGateInterceptor(Ref ref) {
  return OfflineGateInterceptor(
    isOffline: () => ref.read(internetMonitorProvider).isOffline,
  );
}
