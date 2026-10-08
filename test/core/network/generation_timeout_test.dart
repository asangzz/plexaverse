import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/network/failure.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';
import 'package:plexaverse/core/network/interceptors/generation_timeout_interceptor.dart';
import 'package:plexaverse/core/network/network_config.dart';

/// A generation request must outlive the server's own budget for it, and a
/// timeout must not be reported as being offline.
///
/// ## The bug
///
/// `BaseOptions.receiveTimeout` was 30 seconds for every request in the app,
/// and nothing overrode it anywhere. In Dio that bounds the wait for response
/// HEADERS, so on a generation endpoint it is a deadline for the entire
/// server-side pipeline — and it was shorter than what the backend allows
/// itself: `OPENAI_IMAGE_TIMEOUT_MS` is 90s, and `/ai/headshot` and
/// `/ai/carousel` both declare `maxDuration = 60` with a note that image
/// generation "can hit 30-45s on cold start".
///
/// So the phone hung up on its own server. The web has no client-side timeout
/// at all — a plain `fetch`, no AbortSignal — which is exactly why the same
/// account generated posters on the web and not on the phone.
///
/// It was invisible because of the second half: `DioExceptionType.
/// receiveTimeout` mapped to [NetworkFailure], whose copy is "No connection.
/// Check your network and try again." The connection was fine, the server
/// finished the poster, and the XP was charged. The one piece of advice shown
/// was the one thing that could not help.
void main() {
  group('generation endpoints get the longer budget', () {
    /// Runs the interceptor the way Dio would and returns the options it
    /// saw. The interceptor mutates `options` in place, so the handler only
    /// has to not blow up.
    RequestOptions through(String path) {
      final RequestOptions options = RequestOptions(
        path: path,
        receiveTimeout: NetworkConfig.receiveTimeout,
      );
      const GenerationTimeoutInterceptor()
          .onRequest(options, _NoopRequestHandler());
      return options;
    }

    test('the poster route outlives the server it is waiting on', () {
      // The number that matters: the server may spend 90s inside the image
      // model alone (OPENAI_IMAGE_TIMEOUT_MS), so anything at or below that is
      // still a coin toss.
      expect(
        through('/ai/poster').receiveTimeout,
        NetworkConfig.generationReceiveTimeout,
      );
      expect(
        NetworkConfig.generationReceiveTimeout,
        greaterThan(const Duration(seconds: 90)),
        reason:
            'the client would still hang up before the server gives up on its '
            'own image call',
      );
    });

    test('every AI path qualifies, not just the ones we remembered', () {
      for (final String path in <String>[
        '/ai/generate',
        '/ai/image',
        '/ai/carousel',
        '/ai/headshot',
        '/ai/comments',
        '/planner/generate-post',
        '/planner/article/body',
        '/festive/generate',
        '/persona/chat',
      ]) {
        expect(
          through(path).receiveTimeout,
          NetworkConfig.generationReceiveTimeout,
          reason: '$path runs a model and would be cut off at 30s',
        );
      }
    });

    test('an ordinary read keeps the short budget', () {
      // The long budget is not a free upgrade: a dashboard fetch that hangs
      // for two minutes is a worse experience than one that fails in thirty.
      for (final String path in <String>[
        '/dashboard',
        '/posts',
        '/user/preferences',
        '/linkedin/accounts',
      ]) {
        expect(
          through(path).receiveTimeout,
          NetworkConfig.receiveTimeout,
          reason: '$path is a plain read and should fail fast',
        );
      }
    });

    test('a full URL is matched too', () {
      // Dio hands over an absolute path when a call site passes one.
      expect(
        through('https://www.plexaverse.com/api/mobile/v1/ai/poster')
            .receiveTimeout,
        NetworkConfig.generationReceiveTimeout,
      );
    });
  });

  group('a timeout is not an outage', () {
    /// The [Failure] the interceptor attaches for a given transport error.
    ///
    /// `onError` hands the rewrapped exception to a handler rather than
    /// returning it, so the mapping is read off a handler that records it.
    Failure map(DioExceptionType type) {
      Failure? seen;
      ErrorInterceptor().onError(
        DioException(
          requestOptions: RequestOptions(path: '/ai/poster'),
          type: type,
        ),
        _CapturingHandler((DioException e) => seen = e.error as Failure),
      );
      return seen!;
    }

    test('the server taking too long is a TimeoutFailure', () {
      expect(map(DioExceptionType.receiveTimeout), isA<TimeoutFailure>());
      expect(map(DioExceptionType.sendTimeout), isA<TimeoutFailure>());
    });

    test('genuinely not reaching the server is still a NetworkFailure', () {
      // The distinction is the whole point — do not collapse these back
      // together. One means retry or check your connection; the other means
      // the work is probably still happening.
      expect(map(DioExceptionType.connectionTimeout), isA<NetworkFailure>());
      expect(map(DioExceptionType.connectionError), isA<NetworkFailure>());
      expect(map(DioExceptionType.badCertificate), isA<NetworkFailure>());
    });
  });
}

class _NoopRequestHandler extends RequestInterceptorHandler {
  @override
  void next(RequestOptions requestOptions) {}
}

class _CapturingHandler extends ErrorInterceptorHandler {
  _CapturingHandler(this.onNext);
  final void Function(DioException) onNext;

  @override
  void next(DioException err) => onNext(err);
}
