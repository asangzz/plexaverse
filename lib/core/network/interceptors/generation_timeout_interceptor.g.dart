// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generation_timeout_interceptor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(generationTimeoutInterceptor)
final generationTimeoutInterceptorProvider =
    GenerationTimeoutInterceptorProvider._();

final class GenerationTimeoutInterceptorProvider
    extends
        $FunctionalProvider<
          GenerationTimeoutInterceptor,
          GenerationTimeoutInterceptor,
          GenerationTimeoutInterceptor
        >
    with $Provider<GenerationTimeoutInterceptor> {
  GenerationTimeoutInterceptorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'generationTimeoutInterceptorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$generationTimeoutInterceptorHash();

  @$internal
  @override
  $ProviderElement<GenerationTimeoutInterceptor> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GenerationTimeoutInterceptor create(Ref ref) {
    return generationTimeoutInterceptor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GenerationTimeoutInterceptor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GenerationTimeoutInterceptor>(value),
    );
  }
}

String _$generationTimeoutInterceptorHash() =>
    r'7be840fb2fb1f43745432d684aa685fe23c087d2';
