// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_gate.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Overridden by the auth feature once it lands (after sign-in / sign-out the
/// pages `ref.invalidate(authGateProvider)` then `await
/// ref.read(authGateProvider.future)` to drive the recompute so the go_router
/// redirect fires). The fallback here consults [SessionStore] directly so the
/// rest of the router works today.

@ProviderFor(authGate)
final authGateProvider = AuthGateProvider._();

/// Overridden by the auth feature once it lands (after sign-in / sign-out the
/// pages `ref.invalidate(authGateProvider)` then `await
/// ref.read(authGateProvider.future)` to drive the recompute so the go_router
/// redirect fires). The fallback here consults [SessionStore] directly so the
/// rest of the router works today.

final class AuthGateProvider
    extends
        $FunctionalProvider<AsyncValue<AuthGate>, AuthGate, FutureOr<AuthGate>>
    with $FutureModifier<AuthGate>, $FutureProvider<AuthGate> {
  /// Overridden by the auth feature once it lands (after sign-in / sign-out the
  /// pages `ref.invalidate(authGateProvider)` then `await
  /// ref.read(authGateProvider.future)` to drive the recompute so the go_router
  /// redirect fires). The fallback here consults [SessionStore] directly so the
  /// rest of the router works today.
  AuthGateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authGateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authGateHash();

  @$internal
  @override
  $FutureProviderElement<AuthGate> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AuthGate> create(Ref ref) {
    return authGate(ref);
  }
}

String _$authGateHash() => r'd90064b6a0ded4676eed2041feb6e45cc21a07c3';
