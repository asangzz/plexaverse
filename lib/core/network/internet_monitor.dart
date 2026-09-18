import 'dart:async';
import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../sync/connectivity_listener.dart';

part 'internet_monitor.g.dart';

/// App-wide internet reachability as seen by the UI and the data layer.
enum InternetStatus {
  /// Boot state, before the first reachability check resolves. Treated as
  /// online by consumers (no offline banner flash on cold start; requests
  /// pass through and fail naturally if the network truly is down).
  checking,

  online,
  offline,
}

extension InternetStatusX on InternetStatus {
  /// Definite, probe-confirmed offline. [InternetStatus.checking] is *not*
  /// offline — only a failed probe is.
  bool get isOffline => this == InternetStatus.offline;
}

/// The app is **online-first**: every feature assumes a live backend, so
/// reachability must be observable everywhere, at all times.
///
/// This keepAlive notifier turns [ConnectivityListener] (radio events +
/// DNS reachability probe, so captive portals and dead WiFi don't count as
/// online) into a single app-wide [InternetStatus]:
///
///   - **UI**: the global offline banner (`OfflineOverlay`, mounted in
///     `PlexaverseApp` above every route) watches it.
///   - **Data**: `OfflineGateInterceptor` reads it to fast-fail API calls
///     while offline instead of burning the connect timeout.
///
/// While offline it re-probes on an exponential backoff (5s → 60s cap) —
/// necessary because recovery without an interface change (e.g. completing
/// a captive-portal login) fires no connectivity event, so events alone
/// would never notice the network coming back. Any consumer can also force
/// an immediate probe via [recheck] (the "Try again" button does).
@Riverpod(keepAlive: true)
class InternetMonitor extends _$InternetMonitor {
  StreamSubscription<bool>? _events;
  Timer? _reprobe;
  int _backoffStep = 0;

  static const List<Duration> _backoff = <Duration>[
    Duration(seconds: 5),
    Duration(seconds: 10),
    Duration(seconds: 20),
    Duration(seconds: 40),
    Duration(seconds: 60),
  ];

  @override
  InternetStatus build() {
    final listener = ref.watch(connectivityListenerProvider);
    // Defensive: never stack subscriptions if build ever re-runs.
    unawaited(_events?.cancel());
    _events = listener.online.listen(_apply);
    ref.onDispose(() {
      unawaited(_events?.cancel());
      _reprobe?.cancel();
    });
    // Resolve the boot state promptly — connectivity events only fire on
    // *changes*, so without this the state could sit on `checking` forever.
    unawaited(_probeNow(listener));
    return InternetStatus.checking;
  }

  /// Immediate one-shot reachability probe (e.g. from a retry button).
  Future<void> recheck() => _probeNow(ref.read(connectivityListenerProvider));

  Future<void> _probeNow(ConnectivityListener listener) async {
    final online = await listener.isOnline();
    if (!ref.mounted) return;
    _apply(online);
  }

  void _apply(bool online) {
    state = online ? InternetStatus.online : InternetStatus.offline;
    if (online) {
      _backoffStep = 0;
      _reprobe?.cancel();
      _reprobe = null;
    } else {
      _scheduleReprobe();
    }
  }

  void _scheduleReprobe() {
    _reprobe?.cancel();
    final delay = _backoff[math.min(_backoffStep, _backoff.length - 1)];
    _backoffStep++;
    _reprobe = Timer(delay, () {
      if (!ref.mounted) return;
      unawaited(recheck());
    });
  }
}
