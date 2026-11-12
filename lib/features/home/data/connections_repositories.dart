import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kReleaseMode, visibleForTesting;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure.dart';
import '../domain/connections_repository.dart';

/// Dio-backed [ConnectionsRepository].
///
/// [DioClient] already unwraps the envelope, so on success `response.data` is
/// the summary itself.
class ApiConnectionsRepository implements ConnectionsRepository {
  const ApiConnectionsRepository(this._client);

  final DioClient _client;

  @override
  Future<ConnectionSummary> fetchSummary() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.reachConnections,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const ConnectionsUnavailable();
      return ConnectionSummary.fromJson(data);
    } on ConnectionsUnavailable {
      rethrow;
    } on Object {
      throw const ConnectionsUnavailable();
    }
  }

  @override
  Future<void> record(int count) async {
    try {
      await _client.post<Map<String, dynamic>>(
        ApiPaths.reachConnections,
        data: <String, dynamic>{'count': count},
      );
    } on DioException catch (e) {
      throw _refusal(e) ?? e;
    }
  }

  /// A refused number, by the server's code.
  ///
  /// It arrives as 400 `VALIDATION_FAILED` with `fields.count`, which the
  /// interceptor reads as a [ValidationFailure] — branched on the code rather
  /// than the class so a change in how the interceptor buckets a 400 cannot
  /// turn the server's sentence into "Could not save that number."
  static ConnectionsInvalid? _refusal(DioException e) {
    final Failure? failure = e.error is Failure ? e.error as Failure : null;
    if (failure?.errorCode != 'VALIDATION_FAILED') return null;
    final String message = failure?.message ?? '';
    return ConnectionsInvalid(
      message.isEmpty ? connectionRangeMessage : message,
    );
  }
}

/// In-memory [ConnectionsRepository] for the `mock` flavor.
///
/// Seeded as someone who answered twice and then let it lapse: the latest
/// count is eight days old, so the card opens on its question with last
/// week's figure as the placeholder — and one Save later it shows a real
/// week's growth, because the fake computes the summary with the server's
/// own arithmetic ([connectionGrowthOf]) instead of asserting one.
///
/// Module-level, like `FakeDaySession`: it stands in for rows in a table, so
/// a fresh repository (every provider rebuild makes one) must see what the
/// last one wrote.
class FakeConnectionsRepository implements ConnectionsRepository {
  FakeConnectionsRepository();

  static const Duration _latency = Duration(milliseconds: 350);

  static List<ConnectionReading>? _rows;

  /// Oldest first, as the server keeps them.
  static List<ConnectionReading> get _history => _rows ??= _seed();

  static List<ConnectionReading> _seed() {
    final DateTime now = DateTime.now();
    String daysAgo(int n) =>
        now.subtract(Duration(days: n)).toUtc().toIso8601String();
    return <ConnectionReading>[
      ConnectionReading(count: 468, measuredAt: daysAgo(15)),
      ConnectionReading(count: 480, measuredAt: daysAgo(8)),
    ];
  }

  /// Back to the seeded rows. Tests only.
  @visibleForTesting
  static void reset() => _rows = null;

  @override
  Future<ConnectionSummary> fetchSummary() async {
    await Future<void>.delayed(_latency);
    final List<ConnectionReading> history =
        List<ConnectionReading>.unmodifiable(_history);
    return ConnectionSummary(
      reading: history.isEmpty ? null : history.last,
      growth: connectionGrowthOf(history, now: DateTime.now()),
      history: history,
    );
  }

  @override
  Future<void> record(int count) async {
    await Future<void>.delayed(_latency);
    // The server's check, in the server's words.
    if (count < 0 || count > maxConnections) {
      throw const ConnectionsInvalid(connectionRangeMessage);
    }
    final DateTime now = DateTime.now();
    final ConnectionReading reading = ConnectionReading(
      count: count,
      measuredAt: now.toUtc().toIso8601String(),
    );
    // One reading per calendar day: today's is replaced, not added to.
    final List<ConnectionReading> rows = _history;
    final DateTime? last = rows.isEmpty
        ? null
        : DateTime.tryParse(rows.last.measuredAt)?.toLocal();
    if (last != null && _sameDay(last, now)) {
      rows[rows.length - 1] = reading;
    } else {
      rows.add(reading);
    }
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors every other slice.
final Provider<ConnectionsRepository> connectionsRepositoryProvider =
    Provider<ConnectionsRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakeConnectionsRepository();
      return ApiConnectionsRepository(ref.watch(dioClientProvider));
    });
