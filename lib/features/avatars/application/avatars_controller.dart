import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/avatars_repository_providers.dart';
import '../domain/avatars_repository.dart';

part 'avatars_controller.g.dart';

/// Everything the Avatars tab renders in one shot: the identity for the
/// header pill + voice bar, and the look cards for the grid.
typedef AvatarsOverview = ({AvatarProfile profile, List<AvatarLook> looks});

/// Loads the Avatars tab (screenshot 2369). Profile and looks are fetched
/// in parallel and land together so the header, grid and voice bar appear
/// as one unit. `AsyncValue` drives the page states: loading → skeleton,
/// error → shared network-error view (with retry), data → the tab. Retry
/// re-runs it via `ref.invalidate`.
@riverpod
class AvatarsController extends _$AvatarsController {
  @override
  Future<AvatarsOverview> build() async {
    final repository = ref.watch(avatarsRepositoryProvider);
    final (profile, looks) = await (
      repository.fetchProfile(),
      repository.fetchLooks(),
    ).wait;
    return (profile: profile, looks: looks);
  }
}
