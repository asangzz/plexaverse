// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Dictation)
final dictationProvider = DictationProvider._();

final class DictationProvider
    extends $NotifierProvider<Dictation, DictationState> {
  DictationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dictationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dictationHash();

  @$internal
  @override
  Dictation create() => Dictation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DictationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DictationState>(value),
    );
  }
}

String _$dictationHash() => r'39515826244cb0b5dcbe6b5dc8764ca17820c948';

abstract class _$Dictation extends $Notifier<DictationState> {
  DictationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DictationState, DictationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DictationState, DictationState>,
              DictationState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
