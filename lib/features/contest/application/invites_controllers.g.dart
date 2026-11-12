// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invites_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Picking and sending the screenshot, with the in-flight and failure state
/// off the widget — `test/architecture/no_async_state_in_widgets_test.dart`.

@ProviderFor(InvitesActions)
final invitesActionsProvider = InvitesActionsProvider._();

/// Picking and sending the screenshot, with the in-flight and failure state
/// off the widget — `test/architecture/no_async_state_in_widgets_test.dart`.
final class InvitesActionsProvider
    extends $NotifierProvider<InvitesActions, InvitesUpload> {
  /// Picking and sending the screenshot, with the in-flight and failure state
  /// off the widget — `test/architecture/no_async_state_in_widgets_test.dart`.
  InvitesActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invitesActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invitesActionsHash();

  @$internal
  @override
  InvitesActions create() => InvitesActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InvitesUpload value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InvitesUpload>(value),
    );
  }
}

String _$invitesActionsHash() => r'aa111181548855597b2e29d66c75665a676e4577';

/// Picking and sending the screenshot, with the in-flight and failure state
/// off the widget — `test/architecture/no_async_state_in_widgets_test.dart`.

abstract class _$InvitesActions extends $Notifier<InvitesUpload> {
  InvitesUpload build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<InvitesUpload, InvitesUpload>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InvitesUpload, InvitesUpload>,
              InvitesUpload,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
