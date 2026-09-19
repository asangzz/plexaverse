// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Starting Season 2.
///
/// Day 66 used to be a dead end in the app: the Season Complete recap showed
/// the user's real numbers and then described three paths they could only
/// take on the web. `POST /season/advance` did not exist on the mobile API
/// until now.

@ProviderFor(SeasonAdvanceController)
final seasonAdvanceControllerProvider = SeasonAdvanceControllerProvider._();

/// Starting Season 2.
///
/// Day 66 used to be a dead end in the app: the Season Complete recap showed
/// the user's real numbers and then described three paths they could only
/// take on the web. `POST /season/advance` did not exist on the mobile API
/// until now.
final class SeasonAdvanceControllerProvider
    extends $NotifierProvider<SeasonAdvanceController, void> {
  /// Starting Season 2.
  ///
  /// Day 66 used to be a dead end in the app: the Season Complete recap showed
  /// the user's real numbers and then described three paths they could only
  /// take on the web. `POST /season/advance` did not exist on the mobile API
  /// until now.
  SeasonAdvanceControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seasonAdvanceControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seasonAdvanceControllerHash();

  @$internal
  @override
  SeasonAdvanceController create() => SeasonAdvanceController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$seasonAdvanceControllerHash() =>
    r'54f6fec4f874dab1f96056c058f68fa506c41d08';

/// Starting Season 2.
///
/// Day 66 used to be a dead end in the app: the Season Complete recap showed
/// the user's real numbers and then described three paths they could only
/// take on the web. `POST /season/advance` did not exist on the mobile API
/// until now.

abstract class _$SeasonAdvanceController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
