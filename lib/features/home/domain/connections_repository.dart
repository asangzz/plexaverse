import 'connection_summary.dart';

export 'connection_summary.dart';

/// The count was refused. [message] is the server's sentence — today always
/// [connectionRangeMessage], but read off the reply so the two cannot drift.
class ConnectionsInvalid implements Exception {
  const ConnectionsInvalid(this.message);

  final String message;
}

/// The check-in could not be read. One sentinel, as `HomeUnavailable` is for
/// the roadmap: the card has a single answer to it.
class ConnectionsUnavailable implements Exception {
  const ConnectionsUnavailable();
}

/// Seam between the roadmap's connections check-in and the backend.
///
/// Its own repository rather than a second method on the home one, because
/// the home repository is deliberately read-only (see its doc) and this one
/// writes. The number is free to record: there is no plan gate on either verb.
abstract class ConnectionsRepository {
  /// `GET /reach/connections` → `{reading, growth, history}`.
  ///
  /// The server swallows its own read errors and answers an empty summary, so
  /// a failure here is the network's, not the database's.
  Future<ConnectionSummary> fetchSummary();

  /// `POST /reach/connections {count}` → `{id}`.
  ///
  /// Merges into today's reading when there already is one, so a typo fixed a
  /// minute later does not leave two readings a minute apart. Throws
  /// [ConnectionsInvalid] for a number the server will not store.
  Future<void> record(int count);
}
