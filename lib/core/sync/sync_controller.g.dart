// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App-lifetime projection of the SyncQueue (ProHealth §11.5). Watches the
/// drift stream and emits a [SyncStatusSummary] per change — that's what the
/// global sync banner consumes via Riverpod.
///
/// `core/sync` may legitimately depend on `core/storage` — both are
/// infrastructure adapters. Feature presentation never imports either;
/// presentation reads only [SyncStatusSummary].

@ProviderFor(SyncController)
final syncControllerProvider = SyncControllerProvider._();

/// App-lifetime projection of the SyncQueue (ProHealth §11.5). Watches the
/// drift stream and emits a [SyncStatusSummary] per change — that's what the
/// global sync banner consumes via Riverpod.
///
/// `core/sync` may legitimately depend on `core/storage` — both are
/// infrastructure adapters. Feature presentation never imports either;
/// presentation reads only [SyncStatusSummary].
final class SyncControllerProvider
    extends $StreamNotifierProvider<SyncController, SyncStatusSummary> {
  /// App-lifetime projection of the SyncQueue (ProHealth §11.5). Watches the
  /// drift stream and emits a [SyncStatusSummary] per change — that's what the
  /// global sync banner consumes via Riverpod.
  ///
  /// `core/sync` may legitimately depend on `core/storage` — both are
  /// infrastructure adapters. Feature presentation never imports either;
  /// presentation reads only [SyncStatusSummary].
  SyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncControllerHash();

  @$internal
  @override
  SyncController create() => SyncController();
}

String _$syncControllerHash() => r'21cd79fec5e9af71e59e00aeaca55140d9c39c82';

/// App-lifetime projection of the SyncQueue (ProHealth §11.5). Watches the
/// drift stream and emits a [SyncStatusSummary] per change — that's what the
/// global sync banner consumes via Riverpod.
///
/// `core/sync` may legitimately depend on `core/storage` — both are
/// infrastructure adapters. Feature presentation never imports either;
/// presentation reads only [SyncStatusSummary].

abstract class _$SyncController extends $StreamNotifier<SyncStatusSummary> {
  Stream<SyncStatusSummary> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SyncStatusSummary>, SyncStatusSummary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SyncStatusSummary>, SyncStatusSummary>,
              AsyncValue<SyncStatusSummary>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
