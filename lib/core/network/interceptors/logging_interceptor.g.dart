// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logging_interceptor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(loggingInterceptor)
final loggingInterceptorProvider = LoggingInterceptorProvider._();

final class LoggingInterceptorProvider
    extends
        $FunctionalProvider<
          LoggingInterceptor,
          LoggingInterceptor,
          LoggingInterceptor
        >
    with $Provider<LoggingInterceptor> {
  LoggingInterceptorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loggingInterceptorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loggingInterceptorHash();

  @$internal
  @override
  $ProviderElement<LoggingInterceptor> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoggingInterceptor create(Ref ref) {
    return loggingInterceptor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoggingInterceptor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoggingInterceptor>(value),
    );
  }
}

String _$loggingInterceptorHash() =>
    r'3bb1ec81d404e2285d86f63f26d6f6a1890c37bd';
