import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/connection_summary.dart';
import 'follower_series_chart.dart';

/// The connection series, spaced by TIME — the roadmap's connections graph.
///
/// The web's `ConnectionSeriesChart` is a port of [FollowerSeriesChart]; this
/// is that chart again, fed the connection readings with no checkpoint line
/// (connections have no target). Its rules are the follower chart's: points
/// placed by when they were measured, straight segments between real
/// readings, the readings drawn, the latest emphasised, nothing with fewer
/// than two. One accessible name for the whole chart.
class ConnectionSeriesChart extends StatelessWidget {
  const ConnectionSeriesChart({
    required this.readings,
    this.height = 88,
    super.key,
  });

  /// Any order; the readings the user typed.
  final List<ConnectionReading> readings;

  /// The web's 88.
  final double height;

  @override
  Widget build(BuildContext context) {
    final List<({DateTime at, double value})> points = connectionSeries(
      readings,
    );
    if (points.length < 2) return const SizedBox.shrink();
    return Semantics(
      container: true,
      label: connectionSeriesLabel(points),
      child: ExcludeSemantics(
        child: FollowerSeriesChart(points: points, height: height),
      ),
    );
  }
}

/// The readings as dated points, oldest first. A reading whose date does not
/// parse is dropped, as the server drops it.
List<({DateTime at, double value})> connectionSeries(
  List<ConnectionReading> readings,
) =>
    <({DateTime at, double value})>[
      for (final ConnectionReading r in readings)
        if (DateTime.tryParse(r.measuredAt) case final DateTime at)
          (at: at, value: r.count.toDouble()),
    ]..sort(
      (({DateTime at, double value}) a, ({DateTime at, double value}) b) =>
          a.at.compareTo(b.at),
    );

/// "Connections over time: 3,900 to 4,103" — the first and the latest.
String connectionSeriesLabel(List<({DateTime at, double value})> points) {
  final NumberFormat grouped = NumberFormat.decimalPattern('en_US');
  return 'Connections over time: ${grouped.format(points.first.value.round())} '
      'to ${grouped.format(points.last.value.round())}';
}
