// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the resolved tenant (`null` until resolved from the catalogue on
/// first launch). Persisted via SharedPreferences — wiped on uninstall on
/// both platforms.
///
/// The customer key is a routing identifier, not a credential, so it does
/// NOT live in flutter_secure_storage (RULINGS §11).

@ProviderFor(TenantController)
final tenantControllerProvider = TenantControllerProvider._();

/// Holds the resolved tenant (`null` until resolved from the catalogue on
/// first launch). Persisted via SharedPreferences — wiped on uninstall on
/// both platforms.
///
/// The customer key is a routing identifier, not a credential, so it does
/// NOT live in flutter_secure_storage (RULINGS §11).
final class TenantControllerProvider
    extends $NotifierProvider<TenantController, TenantConfig?> {
  /// Holds the resolved tenant (`null` until resolved from the catalogue on
  /// first launch). Persisted via SharedPreferences — wiped on uninstall on
  /// both platforms.
  ///
  /// The customer key is a routing identifier, not a credential, so it does
  /// NOT live in flutter_secure_storage (RULINGS §11).
  TenantControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tenantControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tenantControllerHash();

  @$internal
  @override
  TenantController create() => TenantController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TenantConfig? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TenantConfig?>(value),
    );
  }
}

String _$tenantControllerHash() => r'ef91ec863af34b83e24c04502eb06a5da3b11e83';

/// Holds the resolved tenant (`null` until resolved from the catalogue on
/// first launch). Persisted via SharedPreferences — wiped on uninstall on
/// both platforms.
///
/// The customer key is a routing identifier, not a credential, so it does
/// NOT live in flutter_secure_storage (RULINGS §11).

abstract class _$TenantController extends $Notifier<TenantConfig?> {
  TenantConfig? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TenantConfig?, TenantConfig?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TenantConfig?, TenantConfig?>,
              TenantConfig?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Resolved tenant config. Throws if accessed before resolution — every
/// post-tenant-gate provider depends on this, and bootstrap guarantees the
/// tenant is set before the first frame (RULINGS §11).

@ProviderFor(tenantConfig)
final tenantConfigProvider = TenantConfigProvider._();

/// Resolved tenant config. Throws if accessed before resolution — every
/// post-tenant-gate provider depends on this, and bootstrap guarantees the
/// tenant is set before the first frame (RULINGS §11).

final class TenantConfigProvider
    extends $FunctionalProvider<TenantConfig, TenantConfig, TenantConfig>
    with $Provider<TenantConfig> {
  /// Resolved tenant config. Throws if accessed before resolution — every
  /// post-tenant-gate provider depends on this, and bootstrap guarantees the
  /// tenant is set before the first frame (RULINGS §11).
  TenantConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tenantConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tenantConfigHash();

  @$internal
  @override
  $ProviderElement<TenantConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TenantConfig create(Ref ref) {
    return tenantConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TenantConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TenantConfig>(value),
    );
  }
}

String _$tenantConfigHash() => r'5196e2800a12c0ae929318fe3fd1a0aa24ca1057';

/// Single answer to "is this feature on for the current tenant?" (RULINGS
/// §11). Every gate in the app reads from this.

@ProviderFor(isFeatureEnabled)
final isFeatureEnabledProvider = IsFeatureEnabledFamily._();

/// Single answer to "is this feature on for the current tenant?" (RULINGS
/// §11). Every gate in the app reads from this.

final class IsFeatureEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Single answer to "is this feature on for the current tenant?" (RULINGS
  /// §11). Every gate in the app reads from this.
  IsFeatureEnabledProvider._({
    required IsFeatureEnabledFamily super.from,
    required AppFeature super.argument,
  }) : super(
         retry: null,
         name: r'isFeatureEnabledProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isFeatureEnabledHash();

  @override
  String toString() {
    return r'isFeatureEnabledProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as AppFeature;
    return isFeatureEnabled(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsFeatureEnabledProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isFeatureEnabledHash() => r'af20b64d6d93c02018c09b5f78c2d251a685f248';

/// Single answer to "is this feature on for the current tenant?" (RULINGS
/// §11). Every gate in the app reads from this.

final class IsFeatureEnabledFamily extends $Family
    with $FunctionalFamilyOverride<bool, AppFeature> {
  IsFeatureEnabledFamily._()
    : super(
        retry: null,
        name: r'isFeatureEnabledProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Single answer to "is this feature on for the current tenant?" (RULINGS
  /// §11). Every gate in the app reads from this.

  IsFeatureEnabledProvider call(AppFeature feature) =>
      IsFeatureEnabledProvider._(argument: feature, from: this);

  @override
  String toString() => r'isFeatureEnabledProvider';
}
