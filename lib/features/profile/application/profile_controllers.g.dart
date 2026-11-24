// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `GET /profile` — the handle and the `public_profile` consent. The section
/// draws its box from this, so it is never pre-ticked.

@ProviderFor(PublicProfileSettingsController)
final publicProfileSettingsControllerProvider =
    PublicProfileSettingsControllerProvider._();

/// `GET /profile` — the handle and the `public_profile` consent. The section
/// draws its box from this, so it is never pre-ticked.
final class PublicProfileSettingsControllerProvider
    extends
        $AsyncNotifierProvider<
          PublicProfileSettingsController,
          PublicProfileSettings
        > {
  /// `GET /profile` — the handle and the `public_profile` consent. The section
  /// draws its box from this, so it is never pre-ticked.
  PublicProfileSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'publicProfileSettingsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$publicProfileSettingsControllerHash();

  @$internal
  @override
  PublicProfileSettingsController create() => PublicProfileSettingsController();
}

String _$publicProfileSettingsControllerHash() =>
    r'2bcbcd9456358284ce15ab77ab5b6d97e9cb7e80';

/// `GET /profile` — the handle and the `public_profile` consent. The section
/// draws its box from this, so it is never pre-ticked.

abstract class _$PublicProfileSettingsController
    extends $AsyncNotifier<PublicProfileSettings> {
  FutureOr<PublicProfileSettings> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<PublicProfileSettings>, PublicProfileSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PublicProfileSettings>,
                PublicProfileSettings
              >,
              AsyncValue<PublicProfileSettings>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// `GET /profile?handle=` — is this handle free for the user? Asked only for
/// a handle that already passes the shape rule, and only once typing pauses.

@ProviderFor(handleAvailability)
final handleAvailabilityProvider = HandleAvailabilityFamily._();

/// `GET /profile?handle=` — is this handle free for the user? Asked only for
/// a handle that already passes the shape rule, and only once typing pauses.

final class HandleAvailabilityProvider
    extends
        $FunctionalProvider<
          AsyncValue<HandleAvailability>,
          HandleAvailability,
          FutureOr<HandleAvailability>
        >
    with
        $FutureModifier<HandleAvailability>,
        $FutureProvider<HandleAvailability> {
  /// `GET /profile?handle=` — is this handle free for the user? Asked only for
  /// a handle that already passes the shape rule, and only once typing pauses.
  HandleAvailabilityProvider._({
    required HandleAvailabilityFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'handleAvailabilityProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$handleAvailabilityHash();

  @override
  String toString() {
    return r'handleAvailabilityProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<HandleAvailability> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HandleAvailability> create(Ref ref) {
    final argument = this.argument as String;
    return handleAvailability(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HandleAvailabilityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$handleAvailabilityHash() =>
    r'e62e4e2fe736ec3be92f7e6f04cea26c8b3d6a04';

/// `GET /profile?handle=` — is this handle free for the user? Asked only for
/// a handle that already passes the shape rule, and only once typing pauses.

final class HandleAvailabilityFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<HandleAvailability>, String> {
  HandleAvailabilityFamily._()
    : super(
        retry: null,
        name: r'handleAvailabilityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// `GET /profile?handle=` — is this handle free for the user? Asked only for
  /// a handle that already passes the shape rule, and only once typing pauses.

  HandleAvailabilityProvider call(String handle) =>
      HandleAvailabilityProvider._(argument: handle, from: this);

  @override
  String toString() => r'handleAvailabilityProvider';
}

/// `PUT /profile` — publish at a handle, or unpublish. A success writes the
/// server's answer into the settings and re-reads the shoutout card's view
/// of it; a refusal re-reads the settings rather than assume.

@ProviderFor(PublicProfileActions)
final publicProfileActionsProvider = PublicProfileActionsProvider._();

/// `PUT /profile` — publish at a handle, or unpublish. A success writes the
/// server's answer into the settings and re-reads the shoutout card's view
/// of it; a refusal re-reads the settings rather than assume.
final class PublicProfileActionsProvider
    extends $NotifierProvider<PublicProfileActions, PublicProfileSave> {
  /// `PUT /profile` — publish at a handle, or unpublish. A success writes the
  /// server's answer into the settings and re-reads the shoutout card's view
  /// of it; a refusal re-reads the settings rather than assume.
  PublicProfileActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'publicProfileActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$publicProfileActionsHash();

  @$internal
  @override
  PublicProfileActions create() => PublicProfileActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PublicProfileSave value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PublicProfileSave>(value),
    );
  }
}

String _$publicProfileActionsHash() =>
    r'7bad55436b9ed63aa5128b3747a84fcb36f8fc23';

/// `PUT /profile` — publish at a handle, or unpublish. A success writes the
/// server's answer into the settings and re-reads the shoutout card's view
/// of it; a refusal re-reads the settings rather than assume.

abstract class _$PublicProfileActions extends $Notifier<PublicProfileSave> {
  PublicProfileSave build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PublicProfileSave, PublicProfileSave>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PublicProfileSave, PublicProfileSave>,
              PublicProfileSave,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// `GET /profile/cv`, then the share sheet: the PDF is written to the
/// device's temp folder and handed to the user to save or send. Never kept
/// by the app, as the server never keeps it.

@ProviderFor(CvDownloadActions)
final cvDownloadActionsProvider = CvDownloadActionsProvider._();

/// `GET /profile/cv`, then the share sheet: the PDF is written to the
/// device's temp folder and handed to the user to save or send. Never kept
/// by the app, as the server never keeps it.
final class CvDownloadActionsProvider
    extends $NotifierProvider<CvDownloadActions, CvDownload> {
  /// `GET /profile/cv`, then the share sheet: the PDF is written to the
  /// device's temp folder and handed to the user to save or send. Never kept
  /// by the app, as the server never keeps it.
  CvDownloadActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cvDownloadActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cvDownloadActionsHash();

  @$internal
  @override
  CvDownloadActions create() => CvDownloadActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CvDownload value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CvDownload>(value),
    );
  }
}

String _$cvDownloadActionsHash() => r'0e8a291c587e2325d27f74b92a51a167f7e3b654';

/// `GET /profile/cv`, then the share sheet: the PDF is written to the
/// device's temp folder and handed to the user to save or send. Never kept
/// by the app, as the server never keeps it.

abstract class _$CvDownloadActions extends $Notifier<CvDownload> {
  CvDownload build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CvDownload, CvDownload>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CvDownload, CvDownload>,
              CvDownload,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
