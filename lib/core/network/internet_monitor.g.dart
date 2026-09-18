// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'internet_monitor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(InternetMonitor)
final internetMonitorProvider = InternetMonitorProvider._();

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
final class InternetMonitorProvider
    extends $NotifierProvider<InternetMonitor, InternetStatus> {
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
  InternetMonitorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'internetMonitorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$internetMonitorHash();

  @$internal
  @override
  InternetMonitor create() => InternetMonitor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InternetStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InternetStatus>(value),
    );
  }
}

String _$internetMonitorHash() => r'e75e240756098f34032982b021252fde2934a108';

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

abstract class _$InternetMonitor extends $Notifier<InternetStatus> {
  InternetStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<InternetStatus, InternetStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InternetStatus, InternetStatus>,
              InternetStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
