// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_signal.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authSignalSink)
final authSignalSinkProvider = AuthSignalSinkProvider._();

final class AuthSignalSinkProvider
    extends $FunctionalProvider<AuthSignalSink, AuthSignalSink, AuthSignalSink>
    with $Provider<AuthSignalSink> {
  AuthSignalSinkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSignalSinkProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSignalSinkHash();

  @$internal
  @override
  $ProviderElement<AuthSignalSink> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthSignalSink create(Ref ref) {
    return authSignalSink(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthSignalSink value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthSignalSink>(value),
    );
  }
}

String _$authSignalSinkHash() => r'add8125ba0189e3e8f80c8da9bee67764a831fa1';
