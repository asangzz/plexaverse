import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_summary.freezed.dart';
part 'connection_summary.g.dart';

/// LinkedIn's cap on first-degree connections. Mirrors `MAX_CONNECTIONS` in
/// the web's `lib/services/connections.service.ts`, which refuses anything
/// past it.
const int maxConnections = 30000;

/// The server's own sentence for a number it will not store, so a typed count
/// is refused in the same words before and after the round trip.
const String connectionRangeMessage =
    'Enter a whole number between 0 and 30,000.';

/// A typed connection count, or null when the server would refuse it.
///
/// The web's rule exactly: commas and whitespace are stripped (people type
/// "1,240" because that is how LinkedIn prints it), and what is left must be a
/// whole number from 0 to [maxConnections]. Checked here first so a number
/// that can only be refused never costs a request.
int? parseConnectionCount(String raw) {
  final String digits = raw.replaceAll(RegExp(r'[,\s]'), '');
  if (digits.isEmpty || !RegExp(r'^\d+$').hasMatch(digits)) return null;
  final int? count = int.tryParse(digits);
  if (count == null || count > maxConnections) return null;
  return count;
}

/// One connection count the user typed, and when it was true.
@freezed
abstract class ConnectionReading with _$ConnectionReading {
  const ConnectionReading._();

  const factory ConnectionReading({
    @Default(0) int count,

    /// ISO 8601, as the server stored it.
    @Default('') String measuredAt,
  }) = _ConnectionReading;

  factory ConnectionReading.fromJson(Map<String, dynamic> json) =>
      _$ConnectionReadingFromJson(json);

  /// A week, not the follower card's month: connections are what the
  /// contest's connect and invite tasks move, and a week is the grain those
  /// tasks run on. Mirrors the web's `CONNECTION_STALE_DAYS`.
  static const Duration staleAfter = Duration(days: 7);

  /// Over a week old, or unparseable — both mean "ask again".
  bool isStale({DateTime? now}) {
    final DateTime? at = DateTime.tryParse(measuredAt);
    if (at == null) return true;
    return (now ?? DateTime.now()).difference(at) > staleAfter;
  }
}

/// How the count has moved, as the SERVER computed it.
@freezed
abstract class ConnectionGrowth with _$ConnectionGrowth {
  const factory ConnectionGrowth({
    /// Latest minus the latest reading at or before seven days ago — or minus
    /// the first reading when none is that old yet.
    ///
    /// Null when the latest reading is itself a week old or more: nothing was
    /// measured this week, so any figure here would be older movement (or a
    /// false "no change") labelled as this week's.
    int? week,

    /// Latest minus the first reading ever recorded.
    @Default(0) int sinceFirst,

    /// When the first reading was true, ISO 8601.
    @Default('') String firstMeasuredAt,

    /// Whole days between the first and the latest reading.
    @Default(0) int daysCovered,

    /// How many readings the figures come from. One means there is no growth
    /// to speak of yet.
    @Default(0) int readings,
  }) = _ConnectionGrowth;

  factory ConnectionGrowth.fromJson(Map<String, dynamic> json) =>
      _$ConnectionGrowthFromJson(json);
}

/// The roadmap's weekly connections check-in, as `GET /reach/connections`
/// sends it: the latest count, its growth and the dated series.
///
/// LinkedIn gives no app a member's connection count, so every figure here
/// exists only because the user typed it.
@freezed
abstract class ConnectionSummary with _$ConnectionSummary {
  const factory ConnectionSummary({
    /// Null until the first count is saved.
    ConnectionReading? reading,

    /// Null with no readings.
    ConnectionGrowth? growth,

    /// Oldest first.
    @Default(<ConnectionReading>[]) List<ConnectionReading> history,
  }) = _ConnectionSummary;

  factory ConnectionSummary.fromJson(Map<String, dynamic> json) =>
      _$ConnectionSummaryFromJson(json);
}

/// Growth figures from a dated series in any order — a port of the server's
/// `connectionGrowth`, so the mock flavour's fake computes what the server
/// would rather than asserting it. Null for an empty series.
///
/// Readings whose date does not parse are dropped, as the server drops them.
ConnectionGrowth? connectionGrowthOf(
  List<ConnectionReading> history, {
  required DateTime now,
}) {
  final List<({int count, DateTime at})> series =
      <({int count, DateTime at})>[
        for (final ConnectionReading r in history)
          if (DateTime.tryParse(r.measuredAt) case final DateTime at)
            (count: r.count, at: at),
      ]..sort(
        (({int count, DateTime at}) a, ({int count, DateTime at}) b) =>
            a.at.compareTo(b.at),
      );
  if (series.isEmpty) return null;

  final ({int count, DateTime at}) first = series.first;
  final ({int count, DateTime at}) latest = series.last;
  final DateTime weekAgo = now.subtract(const Duration(days: 7));

  // The latest reading at or before a week ago; the first one until a reading
  // is that old.
  ({int count, DateTime at}) baseline = first;
  for (final ({int count, DateTime at}) r in series) {
    if (r.at.isAfter(weekAgo)) break;
    baseline = r;
  }

  return ConnectionGrowth(
    week: latest.at.isAfter(weekAgo) ? latest.count - baseline.count : null,
    sinceFirst: latest.count - first.count,
    firstMeasuredAt: first.at.toUtc().toIso8601String(),
    daysCovered: latest.at.difference(first.at).inDays,
    readings: series.length,
  );
}
