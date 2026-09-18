import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/app_database.dart';
import 'pending_mutation.dart';
import 'sync_failure.dart';

part 'mutation_dispatcher.g.dart';

/// Per-kind dispatcher (ProHealth §11.5). Features register handlers; the
/// sync engine never reaches into feature repositories directly — it only
/// knows about `MutationKind` + this registry. A missing handler is a
/// permanent failure (the mutation can never succeed until the feature that
/// owns that kind is wired in).
class MutationDispatcher {
  MutationDispatcher();

  final Map<MutationKind, MutationHandler> _handlers =
      <MutationKind, MutationHandler>{};

  void register(MutationKind kind, MutationHandler handler) {
    _handlers[kind] = handler;
  }

  Future<MutationOutcome> dispatch(SyncQueueData row) async {
    final handler = _handlers[row.kind];
    if (handler == null) {
      return MutationOutcome.permanent(
        SyncUnknownFailure(message: 'No handler registered for ${row.kind}'),
      );
    }
    final payload = SyncPayloadCodec.decode(row.payloadJson);
    return handler(row.id, payload);
  }
}

typedef MutationHandler = Future<MutationOutcome> Function(
  String mutationId,
  Map<String, dynamic> payload,
);

/// Result of dispatching a single mutation. Sealed so the engine's `switch`
/// stays exhaustive when new outcomes are added.
sealed class MutationOutcome {
  const MutationOutcome();
  static const MutationOutcome succeeded = MutationOutcomeSucceeded();
  // ignore: prefer_constructors_over_static_methods
  static MutationOutcome transient(SyncFailure failure) =>
      MutationOutcomeTransient(failure);
  // ignore: prefer_constructors_over_static_methods
  static MutationOutcome permanent(SyncFailure failure) =>
      MutationOutcomePermanent(failure);
}

final class MutationOutcomeSucceeded extends MutationOutcome {
  const MutationOutcomeSucceeded();
}

final class MutationOutcomeTransient extends MutationOutcome {
  const MutationOutcomeTransient(this.failure);
  final SyncFailure failure;
}

final class MutationOutcomePermanent extends MutationOutcome {
  const MutationOutcomePermanent(this.failure);
  final SyncFailure failure;
}

@Riverpod(keepAlive: true)
MutationDispatcher mutationDispatcher(Ref ref) {
  return MutationDispatcher();
}
