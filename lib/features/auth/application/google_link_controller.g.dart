// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_link_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether this account can sign in with Google, and the two actions that
/// change that.
///
/// This exists because sign-in deliberately refuses to link Google to an
/// account that has a password: both register routes mark an address verified
/// without ever mailing it, so the server cannot tell the account's owner from
/// someone who pre-registered their address. Refusing is right, but a refusal
/// with no way forward is a dead end — this is the way forward. The user signs
/// in with their password first, which is the proof that was missing, and then
/// links deliberately from Settings.
///
/// The state is `GoogleLinkStatus?` where **null means unknown**, not
/// unlinked. A failed read must not render a "Link Google" button to someone
/// who already linked it.

@ProviderFor(GoogleLinkController)
final googleLinkControllerProvider = GoogleLinkControllerProvider._();

/// Whether this account can sign in with Google, and the two actions that
/// change that.
///
/// This exists because sign-in deliberately refuses to link Google to an
/// account that has a password: both register routes mark an address verified
/// without ever mailing it, so the server cannot tell the account's owner from
/// someone who pre-registered their address. Refusing is right, but a refusal
/// with no way forward is a dead end — this is the way forward. The user signs
/// in with their password first, which is the proof that was missing, and then
/// links deliberately from Settings.
///
/// The state is `GoogleLinkStatus?` where **null means unknown**, not
/// unlinked. A failed read must not render a "Link Google" button to someone
/// who already linked it.
final class GoogleLinkControllerProvider
    extends $AsyncNotifierProvider<GoogleLinkController, GoogleLinkStatus?> {
  /// Whether this account can sign in with Google, and the two actions that
  /// change that.
  ///
  /// This exists because sign-in deliberately refuses to link Google to an
  /// account that has a password: both register routes mark an address verified
  /// without ever mailing it, so the server cannot tell the account's owner from
  /// someone who pre-registered their address. Refusing is right, but a refusal
  /// with no way forward is a dead end — this is the way forward. The user signs
  /// in with their password first, which is the proof that was missing, and then
  /// links deliberately from Settings.
  ///
  /// The state is `GoogleLinkStatus?` where **null means unknown**, not
  /// unlinked. A failed read must not render a "Link Google" button to someone
  /// who already linked it.
  GoogleLinkControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleLinkControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleLinkControllerHash();

  @$internal
  @override
  GoogleLinkController create() => GoogleLinkController();
}

String _$googleLinkControllerHash() =>
    r'8b3e61e948bb1537df2c56c61b0dab5a15c6fb55';

/// Whether this account can sign in with Google, and the two actions that
/// change that.
///
/// This exists because sign-in deliberately refuses to link Google to an
/// account that has a password: both register routes mark an address verified
/// without ever mailing it, so the server cannot tell the account's owner from
/// someone who pre-registered their address. Refusing is right, but a refusal
/// with no way forward is a dead end — this is the way forward. The user signs
/// in with their password first, which is the proof that was missing, and then
/// links deliberately from Settings.
///
/// The state is `GoogleLinkStatus?` where **null means unknown**, not
/// unlinked. A failed read must not render a "Link Google" button to someone
/// who already linked it.

abstract class _$GoogleLinkController
    extends $AsyncNotifier<GoogleLinkStatus?> {
  FutureOr<GoogleLinkStatus?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<GoogleLinkStatus?>, GoogleLinkStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<GoogleLinkStatus?>, GoogleLinkStatus?>,
              AsyncValue<GoogleLinkStatus?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
