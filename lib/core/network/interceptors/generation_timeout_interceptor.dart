import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network_config.dart';

part 'generation_timeout_interceptor.g.dart';

/// Gives endpoints that run a model the longer receive budget.
///
/// ## Why this is an interceptor and not an `Options` at each call site
///
/// Because the call sites kept forgetting, and the symptom did not look like
/// a timeout. `BaseOptions.receiveTimeout` is 30 seconds for every request in
/// the app, and nothing overrode it anywhere — so `/ai/poster`, whose server
/// side may spend up to 90 seconds in the image model alone, was hung up on
/// by its own client. Dio reports that as `DioExceptionType.receiveTimeout`,
/// which mapped to `NetworkFailure`, which reads "No connection. Check your
/// network and try again." The user sees a network error, the server finishes
/// the poster and charges the XP, and nobody connects the two.
///
/// Doing it here means a new AI route gets the right budget by being named
/// `/ai/…`, rather than by whoever adds it remembering. The rule itself lives
/// in [NetworkConfig.isGenerationPath] next to the durations, which is this
/// codebase's convention for transport tunables.
class GenerationTimeoutInterceptor extends Interceptor {
  const GenerationTimeoutInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (NetworkConfig.isGenerationPath(options.path)) {
      options.receiveTimeout = NetworkConfig.generationReceiveTimeout;
    }
    handler.next(options);
  }
}

@Riverpod(keepAlive: true)
GenerationTimeoutInterceptor generationTimeoutInterceptor(Ref ref) =>
    const GenerationTimeoutInterceptor();
