import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../domain/home_repository.dart';

/// Real, Dio-backed [HomeRepository] — `GET /home/dashboard`. Any
/// transport/server failure (including the `{data, error, meta}` envelope
/// error the DioClient parse seam maps to a `Failure`) surfaces as the
/// single [DashboardUnavailable] sentinel; the UI maps it to the shared
/// network-error state with retry.
class ApiHomeRepository implements HomeRepository {
  const ApiHomeRepository(this._client);

  final DioClient _client;

  @override
  Future<DashboardSummary> fetchDashboard() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.homeDashboard,
      );
      final data = response.data;
      if (data == null) throw const DashboardUnavailable();
      return DashboardSummary.fromJson(data);
    } on DashboardUnavailable {
      rethrow;
    } on Object {
      throw const DashboardUnavailable();
    }
  }
}
