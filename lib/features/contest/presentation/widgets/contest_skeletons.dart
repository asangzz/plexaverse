import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/contest_words.dart';
import 'path/path_node.dart';
import 'path/path_view.dart';

/// The contest page's loading skeletons — ports of the web's
/// `components/contest/skeletons.tsx`.
///
/// ## Why skeletons
///
/// The owner asked for them (11 Nov 2026): a page opens in the shape it is
/// about to take, and nothing jumps when the data lands. Each draws the frame
/// of the screen it stands in for, and the path's winds with the path's own
/// [windAt] and [pathAmplitude] — one copy of the numbers.
///
/// ## Said once
///
/// One labelled region per skeleton ("Loading the contest"); every shape is
/// hidden from a screen reader, which hears what loads, not forty empty
/// boxes. The sweep is [ZaveShimmer]'s, which stands still under reduced
/// motion.
class _Busy extends StatelessWidget {
  const _Busy({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      label: label,
      child: ExcludeSemantics(child: ZaveShimmer(child: child)),
    );
  }
}

/// The whole running page while the overview loads: the stats row, the
/// path, and the rail's cards. Most visitors are running entrants, so this
/// is the shape the page usually takes.
class ContestDashboardSkeleton extends StatelessWidget {
  const ContestDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _Busy(
      label: 'Loading your levels',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ZaveSkeleton.bar(width: 56, height: 22),
              ZaveSkeleton.bar(width: 48),
              ZaveSkeleton.bar(width: 84),
            ],
          ),
          const SizedBox(height: 20),
          const _PathShapes(rows: 9),
          const SizedBox(height: 32),
          for (final double h in <double>[92, 168, 196, 220]) ...<Widget>[
            ZaveSkeleton.block(height: h),
            const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}

/// The path alone, while the week loads.
class PathSkeleton extends StatelessWidget {
  const PathSkeleton({super.key});

  @override
  Widget build(BuildContext context) =>
      const _Busy(label: 'Loading this week', child: _PathShapes(rows: 6));
}

/// The banner, two day dividers and [rows] winding nodes with a chest.
class _PathShapes extends StatelessWidget {
  const _PathShapes({required this.rows});

  final int rows;

  @override
  Widget build(BuildContext context) {
    final double amp = pathAmplitude(context);
    final int half = rows ~/ 2;
    int step = 0;
    Widget node() => SizedBox(
      height: kPathRowHeight,
      child: Center(
        child: Transform.translate(
          offset: Offset(amp * windAt(step++), 0),
          child: ClipOval(
            child: ZaveSkeleton.block(
              width: kPathNodeWidth,
              height: kPathNodeHeight,
            ),
          ),
        ),
      ),
    );
    Widget divider() => Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 14),
      child: Center(child: ZaveSkeleton.bar(width: 120, height: 13)),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ZaveSkeleton.block(height: 74),
        const SizedBox(height: 24),
        divider(),
        for (int i = 0; i < half; i++) node(),
        divider(),
        for (int i = half; i < rows; i++) node(),
        SizedBox(
          height: kPathRowHeight,
          child: Center(
            child: Transform.translate(
              offset: Offset(amp * windAt(step++), 0),
              child: ZaveSkeleton.block(width: 80, height: 66),
            ),
          ),
        ),
      ],
    );
  }
}

/// A board's rows in outline: rank, avatar, name, XP.
class BoardRowsSkeleton extends StatelessWidget {
  const BoardRowsSkeleton({required this.rows, required this.label, super.key});

  final int rows;
  final String label;

  @override
  Widget build(BuildContext context) {
    return _Busy(
      label: label,
      child: Column(
        children: <Widget>[
          for (int i = 0; i < rows; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: <Widget>[
                  ZaveSkeleton.bar(width: 20),
                  const SizedBox(width: 12),
                  const ZaveSkeleton.circle(width: 34),
                  const SizedBox(width: 12),
                  Expanded(child: ZaveSkeleton.bar(widthFactor: 0.7)),
                  const SizedBox(width: 12),
                  ZaveSkeleton.bar(width: 56),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// A rail card's rows in outline: a tile, a line and a bar.
class RailRowsSkeleton extends StatelessWidget {
  const RailRowsSkeleton({required this.label, this.rows = 3, super.key});

  final String label;
  final int rows;

  @override
  Widget build(BuildContext context) {
    return _Busy(
      label: label,
      child: Column(
        children: <Widget>[
          for (int i = 0; i < rows; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  const ZaveSkeleton.block(width: 38, height: 38),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        ZaveSkeleton.bar(widthFactor: 0.6),
                        const SizedBox(height: 8),
                        const ZaveSkeleton.bar(height: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
