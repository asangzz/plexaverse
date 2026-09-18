import '../../../core/mock/mock_api.dart';
import '../domain/avatars_repository.dart';

const String _kProfileAsset = 'assets/mock/avatars/profile.json';
const String _kLooksAsset = 'assets/mock/avatars/looks.json';

/// Bundled-JSON [AvatarsRepository] for the `mock` flavor. Loads
/// `assets/mock/avatars/{profile,looks}.json` (with simulated latency so
/// the loading state is observable) through the real `fromJson`s, and
/// honours connectivity (online-first): offline throws exactly like the
/// gated Dio path would, so the UI shows the same network-error state.
class MockAvatarsRepository implements AvatarsRepository {
  const MockAvatarsRepository({this.isOffline});

  final bool Function()? isOffline;

  @override
  Future<AvatarProfile> fetchProfile() async {
    if (isOffline?.call() ?? false) throw const AvatarsUnavailable();
    try {
      final json = await MockApi.loadObject(_kProfileAsset);
      return AvatarProfile.fromJson(json);
    } on Object {
      throw const AvatarsUnavailable();
    }
  }

  @override
  Future<List<AvatarLook>> fetchLooks() async {
    if (isOffline?.call() ?? false) throw const AvatarsUnavailable();
    try {
      final list = await MockApi.loadArray(_kLooksAsset);
      return list
          .map((e) => AvatarLook.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Object {
      throw const AvatarsUnavailable();
    }
  }
}
