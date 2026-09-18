// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_interceptor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(errorInterceptor)
final errorInterceptorProvider = ErrorInterceptorProvider._();

final class ErrorInterceptorProvider
    extends
        $FunctionalProvider<
          ErrorInterceptor,
          ErrorInterceptor,
          ErrorInterceptor
        >
    with $Provider<ErrorInterceptor> {
  ErrorInterceptorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'errorInterceptorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$errorInterceptorHash();

  @$internal
  @override
  $ProviderElement<ErrorInterceptor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ErrorInterceptor create(Ref ref) {
    return errorInterceptor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ErrorInterceptor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ErrorInterceptor>(value),
    );
  }
}

String _$errorInterceptorHash() => r'84767a1482bc9dd5b3646150f24fa287bc4467fb';
