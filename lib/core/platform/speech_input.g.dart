// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_input.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(speechInput)
final speechInputProvider = SpeechInputProvider._();

final class SpeechInputProvider
    extends
        $FunctionalProvider<
          SpeechInputService,
          SpeechInputService,
          SpeechInputService
        >
    with $Provider<SpeechInputService> {
  SpeechInputProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speechInputProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speechInputHash();

  @$internal
  @override
  $ProviderElement<SpeechInputService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SpeechInputService create(Ref ref) {
    return speechInput(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpeechInputService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpeechInputService>(value),
    );
  }
}

String _$speechInputHash() => r'7ac4b95f0f45e30cf0776cdadd90e724448246cc';
