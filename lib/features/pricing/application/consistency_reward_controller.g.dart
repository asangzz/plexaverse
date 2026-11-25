// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consistency_reward_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `GET /billing/consistency-reward` — the switch as the server has it and the
/// words to show beside it, verbatim (the words the consent is recorded
/// under). Read when the section is shown, never polled (the route's bucket is
/// AUTH, 5 a minute). An error of any kind — a 404 from a server older than
/// the route included — means the section is not shown.

@ProviderFor(ConsistencyRewardConsentController)
final consistencyRewardConsentControllerProvider =
    ConsistencyRewardConsentControllerProvider._();

/// `GET /billing/consistency-reward` — the switch as the server has it and the
/// words to show beside it, verbatim (the words the consent is recorded
/// under). Read when the section is shown, never polled (the route's bucket is
/// AUTH, 5 a minute). An error of any kind — a 404 from a server older than
/// the route included — means the section is not shown.
final class ConsistencyRewardConsentControllerProvider
    extends
        $AsyncNotifierProvider<
          ConsistencyRewardConsentController,
          ConsistencyRewardConsent
        > {
  /// `GET /billing/consistency-reward` — the switch as the server has it and the
  /// words to show beside it, verbatim (the words the consent is recorded
  /// under). Read when the section is shown, never polled (the route's bucket is
  /// AUTH, 5 a minute). An error of any kind — a 404 from a server older than
  /// the route included — means the section is not shown.
  ConsistencyRewardConsentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consistencyRewardConsentControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$consistencyRewardConsentControllerHash();

  @$internal
  @override
  ConsistencyRewardConsentController create() =>
      ConsistencyRewardConsentController();
}

String _$consistencyRewardConsentControllerHash() =>
    r'6aba6a1fbed230602c6d63c789761df49880180f';

/// `GET /billing/consistency-reward` — the switch as the server has it and the
/// words to show beside it, verbatim (the words the consent is recorded
/// under). Read when the section is shown, never polled (the route's bucket is
/// AUTH, 5 a minute). An error of any kind — a 404 from a server older than
/// the route included — means the section is not shown.

abstract class _$ConsistencyRewardConsentController
    extends $AsyncNotifier<ConsistencyRewardConsent> {
  FutureOr<ConsistencyRewardConsent> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<ConsistencyRewardConsent>,
              ConsistencyRewardConsent
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ConsistencyRewardConsent>,
                ConsistencyRewardConsent
              >,
              AsyncValue<ConsistencyRewardConsent>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The switch's save: `PUT /billing/consistency-reward`.
///
/// Kept alive: a save that lands after the section is gone must still refresh
/// the billing status, the card and the consent list, or they would show the
/// switch as it was.

@ProviderFor(ConsistencyRewardSaveController)
final consistencyRewardSaveControllerProvider =
    ConsistencyRewardSaveControllerProvider._();

/// The switch's save: `PUT /billing/consistency-reward`.
///
/// Kept alive: a save that lands after the section is gone must still refresh
/// the billing status, the card and the consent list, or they would show the
/// switch as it was.
final class ConsistencyRewardSaveControllerProvider
    extends $NotifierProvider<ConsistencyRewardSaveController, RewardSave> {
  /// The switch's save: `PUT /billing/consistency-reward`.
  ///
  /// Kept alive: a save that lands after the section is gone must still refresh
  /// the billing status, the card and the consent list, or they would show the
  /// switch as it was.
  ConsistencyRewardSaveControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consistencyRewardSaveControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consistencyRewardSaveControllerHash();

  @$internal
  @override
  ConsistencyRewardSaveController create() => ConsistencyRewardSaveController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RewardSave value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RewardSave>(value),
    );
  }
}

String _$consistencyRewardSaveControllerHash() =>
    r'59658753f4dc7aa9cf45f32a8a0eb5a39fda67e4';

/// The switch's save: `PUT /billing/consistency-reward`.
///
/// Kept alive: a save that lands after the section is gone must still refresh
/// the billing status, the card and the consent list, or they would show the
/// switch as it was.

abstract class _$ConsistencyRewardSaveController extends $Notifier<RewardSave> {
  RewardSave build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RewardSave, RewardSave>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RewardSave, RewardSave>,
              RewardSave,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
