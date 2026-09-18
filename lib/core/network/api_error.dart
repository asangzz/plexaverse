/// Compatibility alias for the sealed error model.
///
/// The SHARED MANIFEST names this file `api_error.dart`, while the ProHealth
/// reference architecture (ground truth) names the sealed error hierarchy
/// `Failure` in `failure.dart`. Every feature slice in the ProHealth port
/// imports `core/network/failure.dart` and branches on `Failure` subtypes
/// carried on `DioException.error`. To satisfy both without duplicating the
/// hierarchy, this file simply re-exports it — import either path.
library;

export 'failure.dart';
