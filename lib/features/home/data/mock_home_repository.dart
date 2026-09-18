import '../../../core/mock/mock_api.dart';
import '../domain/home_repository.dart';

const String _kDashboardAsset = 'assets/mock/home/dashboard.json';

/// In-memory [HomeRepository] used when `useFakeBackend` is true. Loads the
/// bundled dashboard JSON (with simulated latency so the loading state is
/// observable) through the real [DashboardSummary.fromJson], and honours
/// connectivity (online-first): offline throws exactly like the gated Dio
/// path would, so the UI shows the same network-error state.
class MockHomeRepository implements HomeRepository {
  const MockHomeRepository({this.isOffline});

  final bool Function()? isOffline;

  @override
  Future<DashboardSummary> fetchDashboard() async {
    if (isOffline?.call() ?? false) throw const DashboardUnavailable();
    try {
      final json = await MockApi.loadObject(_kDashboardAsset);
      return DashboardSummary.fromJson(json);
    } on Object {
      throw const DashboardUnavailable();
    }
  }
}
