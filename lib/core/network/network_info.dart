/// Compatibility alias for the online-first reachability monitor.
///
/// The SHARED MANIFEST names this file `network_info.dart`, while the
/// ProHealth reference architecture (ground truth) names the reachability
/// notifier `InternetMonitor` in `internet_monitor.dart`. Every feature
/// slice in the ProHealth port reads `internetMonitorProvider` /
/// `InternetStatus` from `core/network/internet_monitor.dart`. To satisfy
/// both without duplicating the notifier, this file re-exports it — import
/// either path.
///
/// The old `NetworkInfo` / `NetworkInfoImpl` (a bare `connectivity_plus`
/// wrapper with no DNS reachability probe) is retired: it counted captive
/// portals and dead WiFi as online. Use `internetMonitorProvider` instead.
library;

export 'internet_monitor.dart';
