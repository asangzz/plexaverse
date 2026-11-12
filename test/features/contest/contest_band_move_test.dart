import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/contest/application/contest_controllers.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/placement/application/placement_controllers.dart';
import 'package:plexaverse/features/placement/domain/cefr_band.dart';

/// A placement band move re-reads what shows the band: the contest overview
/// (the entry's level) and the board (every row's). The web's
/// `invalidateBand` and `noticeBandMove`.
///
/// The placement slice cannot name the contest's providers — it counts the
/// moves instead, and these two watch the count. Drop either watch and the
/// stats bar or the board keeps the old band until something unrelated
/// refetches it; nothing else would notice.
void main() {
  test('a band move re-reads the overview and every board', () async {
    final _CountingContest repo = _CountingContest();
    final ProviderContainer c = ProviderContainer(
      overrides: [contestRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    c.listen(contestOverviewProvider, (_, _) {});
    c.listen(contestBoardProvider(50), (_, _) {});
    c.listen(contestBoardProvider(3), (_, _) {});

    await c.read(contestOverviewProvider.future);
    await c.read(contestBoardProvider(50).future);
    await c.read(contestBoardProvider(3).future);
    expect((repo.overviews, repo.boards), (1, 2));

    c.read(placementBandChangesProvider.notifier).moved();

    await c.read(contestOverviewProvider.future);
    await c.read(contestBoardProvider(50).future);
    await c.read(contestBoardProvider(3).future);
    expect((repo.overviews, repo.boards), (2, 4));
  });

  test('a status read that finds the same band re-reads nothing', () async {
    final _CountingContest repo = _CountingContest();
    final ProviderContainer c = ProviderContainer(
      overrides: [contestRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    c.listen(contestOverviewProvider, (_, _) {});
    await c.read(contestOverviewProvider.future);

    final PlacementBandChanges band = c.read(
      placementBandChangesProvider.notifier,
    );
    band.observe(CefrBand.b1);
    band.observe(CefrBand.b1);

    await c.read(contestOverviewProvider.future);
    expect(repo.overviews, 1);
  });
}

class _CountingContest extends FakeContestRepository {
  _CountingContest() : super(latency: Duration.zero);

  int overviews = 0;
  int boards = 0;

  @override
  Future<ContestOverview?> fetchOverview() {
    overviews++;
    return super.fetchOverview();
  }

  @override
  Future<BoardResult> fetchBoard({int? limit}) {
    boards++;
    return super.fetchBoard(limit: limit);
  }
}
