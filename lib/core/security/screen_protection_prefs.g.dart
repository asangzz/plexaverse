// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_protection_prefs.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App-wide screenshot / screen-share protection setting. When `false`,
/// [SecureScreen] stops applying Android `FLAG_SECURE` / iOS obscuring so the
/// screen can be shared. Toggled from Settings → Security.

@ProviderFor(ScreenProtection)
final screenProtectionProvider = ScreenProtectionProvider._();

/// App-wide screenshot / screen-share protection setting. When `false`,
/// [SecureScreen] stops applying Android `FLAG_SECURE` / iOS obscuring so the
/// screen can be shared. Toggled from Settings → Security.
final class ScreenProtectionProvider
    extends $AsyncNotifierProvider<ScreenProtection, bool> {
  /// App-wide screenshot / screen-share protection setting. When `false`,
  /// [SecureScreen] stops applying Android `FLAG_SECURE` / iOS obscuring so the
  /// screen can be shared. Toggled from Settings → Security.
  ScreenProtectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'screenProtectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$screenProtectionHash();

  @$internal
  @override
  ScreenProtection create() => ScreenProtection();
}

String _$screenProtectionHash() => r'85c94964fe8f7db4a12dffe6841ab2ad57a60e06';

/// App-wide screenshot / screen-share protection setting. When `false`,
/// [SecureScreen] stops applying Android `FLAG_SECURE` / iOS obscuring so the
/// screen can be shared. Toggled from Settings → Security.

abstract class _$ScreenProtection extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
