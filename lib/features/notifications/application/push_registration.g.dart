// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_registration.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the FCM device-token lifecycle and notification-tap routing.
///
/// Called from the auth lifecycle:
///   - [register] after a successful sign-in (and at boot when a session is
///     already present) — requests permission, registers the current token
///     with the backend, and starts listening for token rotation + taps.
///   - [unregister] at the *start* of sign-out, before the session is
///     cleared (the DELETE needs the access token).
///
/// Everything here is best-effort: when Firebase isn't configured the token
/// is null and each step no-ops, so the rest of the app is unaffected. The
/// foreground push → banner → inbox path lives in [NotificationIngestor]
/// (bridged off the repository's `incoming` stream); this class only adds
/// token registration and background/terminated tap handling. Tapped pushes
/// are routed to `data['route']` (RULINGS #15).

@ProviderFor(PushRegistration)
final pushRegistrationProvider = PushRegistrationProvider._();

/// Owns the FCM device-token lifecycle and notification-tap routing.
///
/// Called from the auth lifecycle:
///   - [register] after a successful sign-in (and at boot when a session is
///     already present) — requests permission, registers the current token
///     with the backend, and starts listening for token rotation + taps.
///   - [unregister] at the *start* of sign-out, before the session is
///     cleared (the DELETE needs the access token).
///
/// Everything here is best-effort: when Firebase isn't configured the token
/// is null and each step no-ops, so the rest of the app is unaffected. The
/// foreground push → banner → inbox path lives in [NotificationIngestor]
/// (bridged off the repository's `incoming` stream); this class only adds
/// token registration and background/terminated tap handling. Tapped pushes
/// are routed to `data['route']` (RULINGS #15).
final class PushRegistrationProvider
    extends $NotifierProvider<PushRegistration, void> {
  /// Owns the FCM device-token lifecycle and notification-tap routing.
  ///
  /// Called from the auth lifecycle:
  ///   - [register] after a successful sign-in (and at boot when a session is
  ///     already present) — requests permission, registers the current token
  ///     with the backend, and starts listening for token rotation + taps.
  ///   - [unregister] at the *start* of sign-out, before the session is
  ///     cleared (the DELETE needs the access token).
  ///
  /// Everything here is best-effort: when Firebase isn't configured the token
  /// is null and each step no-ops, so the rest of the app is unaffected. The
  /// foreground push → banner → inbox path lives in [NotificationIngestor]
  /// (bridged off the repository's `incoming` stream); this class only adds
  /// token registration and background/terminated tap handling. Tapped pushes
  /// are routed to `data['route']` (RULINGS #15).
  PushRegistrationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushRegistrationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushRegistrationHash();

  @$internal
  @override
  PushRegistration create() => PushRegistration();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$pushRegistrationHash() => r'e07c11abc0a64a339f47337c7210670e2b612494';

/// Owns the FCM device-token lifecycle and notification-tap routing.
///
/// Called from the auth lifecycle:
///   - [register] after a successful sign-in (and at boot when a session is
///     already present) — requests permission, registers the current token
///     with the backend, and starts listening for token rotation + taps.
///   - [unregister] at the *start* of sign-out, before the session is
///     cleared (the DELETE needs the access token).
///
/// Everything here is best-effort: when Firebase isn't configured the token
/// is null and each step no-ops, so the rest of the app is unaffected. The
/// foreground push → banner → inbox path lives in [NotificationIngestor]
/// (bridged off the repository's `incoming` stream); this class only adds
/// token registration and background/terminated tap handling. Tapped pushes
/// are routed to `data['route']` (RULINGS #15).

abstract class _$PushRegistration extends $Notifier<void> {
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
