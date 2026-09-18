import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_signal.g.dart';

/// Signal channel from the auth pipeline to the router. The router
/// watches [stream] and redirects to /login on `signedOut` (§8).
class AuthSignalSink {
  AuthSignalSink();

  final _controller = StreamController<AuthSignal>.broadcast();

  Stream<AuthSignal> get stream => _controller.stream;

  void emitSignedOut({required String reason}) {
    _controller.add(AuthSignal.signedOut(reason));
  }

  void dispose() => _controller.close();
}

class AuthSignal {
  const AuthSignal._(this.kind, this.reason);
  factory AuthSignal.signedOut(String reason) =>
      AuthSignal._(AuthSignalKind.signedOut, reason);

  final AuthSignalKind kind;
  final String reason;
}

enum AuthSignalKind { signedOut }

@Riverpod(keepAlive: true)
AuthSignalSink authSignalSink(Ref ref) {
  final sink = AuthSignalSink();
  ref.onDispose(sink.dispose);
  return sink;
}
