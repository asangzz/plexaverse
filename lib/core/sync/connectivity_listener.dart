// ignore_for_file: prefer_initializing_formals
// Named-parameter constructor reads cleaner than `this._debounce`, and the
// private fields remain private.

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_listener.g.dart';

/// Emits `true` when the device gains real reachability, `false` when it
/// loses it (ProHealth §7.3). `connectivity_plus` only tells us the radio is
/// up; a DNS-level probe filters out captive portals and
/// WiFi-without-internet.
class ConnectivityListener {
  ConnectivityListener({
    Connectivity? connectivity,
    Duration debounce = const Duration(milliseconds: 500),
    Future<bool> Function() reachabilityProbe = _defaultReachabilityProbe,
  })  : _connectivity = connectivity ?? Connectivity(),
        _debounce = debounce,
        _probe = reachabilityProbe;

  final Connectivity _connectivity;
  final Duration _debounce;
  final Future<bool> Function() _probe;

  /// Debounced + reachability-filtered. Use this for sync-drain triggers.
  Stream<bool> get online {
    return _connectivity.onConnectivityChanged
        .map(_anyOnline)
        .transform(_debouncer(_debounce))
        .asyncMap((up) async => up && await _probe())
        .distinct();
  }

  /// One-shot reachability check. Cheap enough to call on every drain pass to
  /// confirm the WiFi/SIM still actually has internet.
  Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    if (!_anyOnline(results)) return false;
    return _probe();
  }

  bool _anyOnline(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }

  static Future<bool> _defaultReachabilityProbe() async {
    // DNS-only probe: no payload, no third-party endpoint, completes in
    // ~50 ms on a live network. A failed lookup means no real internet even
    // if the WiFi indicator says otherwise.
    try {
      final result = await InternetAddress.lookup('one.one.one.one')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on Object {
      return false;
    }
  }

  /// Coalesces back-to-back interface flaps into a single emission.
  static StreamTransformer<bool, bool> _debouncer(Duration window) {
    return StreamTransformer<bool, bool>.fromBind(
      (stream) => _DebouncedStream(stream, window).stream,
    );
  }
}

class _DebouncedStream {
  _DebouncedStream(this._source, this._window) {
    _controller = StreamController<bool>(
      onListen: _attach,
      onCancel: _detach,
    );
  }

  final Stream<bool> _source;
  final Duration _window;
  late final StreamController<bool> _controller;
  Timer? _timer;
  bool? _lastValue;
  StreamSubscription<bool>? _sub;

  Stream<bool> get stream => _controller.stream;

  void _attach() {
    _sub =
        _source.listen(_onData, onError: _controller.addError, onDone: _onDone);
  }

  Future<void> _detach() async {
    _timer?.cancel();
    await _sub?.cancel();
  }

  void _onData(bool value) {
    _lastValue = value;
    _timer?.cancel();
    _timer = Timer(_window, _emit);
  }

  void _onDone() {
    _timer?.cancel();
    _emit();
    _controller.close();
  }

  void _emit() {
    final value = _lastValue;
    if (value != null) _controller.add(value);
  }
}

@Riverpod(keepAlive: true)
ConnectivityListener connectivityListener(Ref ref) {
  return ConnectivityListener();
}

@Riverpod(keepAlive: true)
Stream<bool> connectivityStream(Ref ref) {
  return ref.watch(connectivityListenerProvider).online;
}
