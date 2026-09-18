// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'title_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Profile Title Creator wizard — the web's `/title-creator`.
///
/// Roadmap level 1, step 4. Three steps: type your current headline, pick who
/// the new one is FOR, read the result.

@ProviderFor(TitleCreatorController)
final titleCreatorControllerProvider = TitleCreatorControllerProvider._();

/// The Profile Title Creator wizard — the web's `/title-creator`.
///
/// Roadmap level 1, step 4. Three steps: type your current headline, pick who
/// the new one is FOR, read the result.
final class TitleCreatorControllerProvider
    extends $NotifierProvider<TitleCreatorController, TitleCreatorState> {
  /// The Profile Title Creator wizard — the web's `/title-creator`.
  ///
  /// Roadmap level 1, step 4. Three steps: type your current headline, pick who
  /// the new one is FOR, read the result.
  TitleCreatorControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'titleCreatorControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$titleCreatorControllerHash();

  @$internal
  @override
  TitleCreatorController create() => TitleCreatorController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TitleCreatorState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TitleCreatorState>(value),
    );
  }
}

String _$titleCreatorControllerHash() =>
    r'eeb80856aafead2ee09b7f6a43d2ab3dde513970';

/// The Profile Title Creator wizard — the web's `/title-creator`.
///
/// Roadmap level 1, step 4. Three steps: type your current headline, pick who
/// the new one is FOR, read the result.

abstract class _$TitleCreatorController extends $Notifier<TitleCreatorState> {
  TitleCreatorState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TitleCreatorState, TitleCreatorState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TitleCreatorState, TitleCreatorState>,
              TitleCreatorState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
