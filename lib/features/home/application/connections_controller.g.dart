// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connections_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The roadmap's weekly connections check-in. The read half.
///
/// The web reads this on every roadmap open; so does this — a reading is a
/// few rows, and a stale one is exactly the case the card exists to catch.

@ProviderFor(connectionSummary)
final connectionSummaryProvider = ConnectionSummaryProvider._();

/// The roadmap's weekly connections check-in. The read half.
///
/// The web reads this on every roadmap open; so does this — a reading is a
/// few rows, and a stale one is exactly the case the card exists to catch.

final class ConnectionSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<ConnectionSummary>,
          ConnectionSummary,
          FutureOr<ConnectionSummary>
        >
    with
        $FutureModifier<ConnectionSummary>,
        $FutureProvider<ConnectionSummary> {
  /// The roadmap's weekly connections check-in. The read half.
  ///
  /// The web reads this on every roadmap open; so does this — a reading is a
  /// few rows, and a stale one is exactly the case the card exists to catch.
  ConnectionSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionSummaryHash();

  @$internal
  @override
  $FutureProviderElement<ConnectionSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ConnectionSummary> create(Ref ref) {
    return connectionSummary(ref);
  }
}

String _$connectionSummaryHash() => r'4759bb3ad8ea009b98a25376f78b2a0d23cb26e0';

/// Saves a typed count.

@ProviderFor(ConnectionActions)
final connectionActionsProvider = ConnectionActionsProvider._();

/// Saves a typed count.
final class ConnectionActionsProvider
    extends $NotifierProvider<ConnectionActions, ConnectionSave> {
  /// Saves a typed count.
  ConnectionActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionActionsHash();

  @$internal
  @override
  ConnectionActions create() => ConnectionActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectionSave value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectionSave>(value),
    );
  }
}

String _$connectionActionsHash() => r'f96bd788d4b4c76ee9720fa5d308cd90fbdaec9a';

/// Saves a typed count.

abstract class _$ConnectionActions extends $Notifier<ConnectionSave> {
  ConnectionSave build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ConnectionSave, ConnectionSave>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConnectionSave, ConnectionSave>,
              ConnectionSave,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Until when "Not now" holds on this device.
///
/// Three days — shorter than the follower card's month, because the question
/// is weekly. A per-device convenience exactly as the web's localStorage key
/// is per browser, under the same name: a snooze that cannot be read or
/// written just means the card asks again, so every failure here is "not
/// snoozed" and nothing waits on it.

@ProviderFor(ConnectionPromptSnooze)
final connectionPromptSnoozeProvider = ConnectionPromptSnoozeProvider._();

/// Until when "Not now" holds on this device.
///
/// Three days — shorter than the follower card's month, because the question
/// is weekly. A per-device convenience exactly as the web's localStorage key
/// is per browser, under the same name: a snooze that cannot be read or
/// written just means the card asks again, so every failure here is "not
/// snoozed" and nothing waits on it.
final class ConnectionPromptSnoozeProvider
    extends $AsyncNotifierProvider<ConnectionPromptSnooze, DateTime?> {
  /// Until when "Not now" holds on this device.
  ///
  /// Three days — shorter than the follower card's month, because the question
  /// is weekly. A per-device convenience exactly as the web's localStorage key
  /// is per browser, under the same name: a snooze that cannot be read or
  /// written just means the card asks again, so every failure here is "not
  /// snoozed" and nothing waits on it.
  ConnectionPromptSnoozeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionPromptSnoozeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionPromptSnoozeHash();

  @$internal
  @override
  ConnectionPromptSnooze create() => ConnectionPromptSnooze();
}

String _$connectionPromptSnoozeHash() =>
    r'0dace5273309c590409e31c6f744f1b79422b1d0';

/// Until when "Not now" holds on this device.
///
/// Three days — shorter than the follower card's month, because the question
/// is weekly. A per-device convenience exactly as the web's localStorage key
/// is per browser, under the same name: a snooze that cannot be read or
/// written just means the card asks again, so every failure here is "not
/// snoozed" and nothing waits on it.

abstract class _$ConnectionPromptSnooze extends $AsyncNotifier<DateTime?> {
  FutureOr<DateTime?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DateTime?>, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DateTime?>, DateTime?>,
              AsyncValue<DateTime?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
