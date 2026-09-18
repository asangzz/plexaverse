// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jailbreak_detector.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(jailbreakDetector)
final jailbreakDetectorProvider = JailbreakDetectorProvider._();

final class JailbreakDetectorProvider
    extends
        $FunctionalProvider<
          JailbreakDetector,
          JailbreakDetector,
          JailbreakDetector
        >
    with $Provider<JailbreakDetector> {
  JailbreakDetectorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jailbreakDetectorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jailbreakDetectorHash();

  @$internal
  @override
  $ProviderElement<JailbreakDetector> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  JailbreakDetector create(Ref ref) {
    return jailbreakDetector(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JailbreakDetector value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JailbreakDetector>(value),
    );
  }
}

String _$jailbreakDetectorHash() => r'b7a807bf0305ca83fce29b0220f5a0cf5d9d1196';
