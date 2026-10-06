// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plexa_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The day's conversation.
///
/// One fetch, then local edits folded over it. The screen is a thread the user
/// walks down, so a reload after every tap would scroll them away from the
/// item they just finished — and the server returns the new session from the
/// write anyway, which is the whole reason that endpoint answers with it.

@ProviderFor(PlexaController)
final plexaControllerProvider = PlexaControllerProvider._();

/// The day's conversation.
///
/// One fetch, then local edits folded over it. The screen is a thread the user
/// walks down, so a reload after every tap would scroll them away from the
/// item they just finished — and the server returns the new session from the
/// write anyway, which is the whole reason that endpoint answers with it.
final class PlexaControllerProvider
    extends $AsyncNotifierProvider<PlexaController, PlexaDay> {
  /// The day's conversation.
  ///
  /// One fetch, then local edits folded over it. The screen is a thread the user
  /// walks down, so a reload after every tap would scroll them away from the
  /// item they just finished — and the server returns the new session from the
  /// write anyway, which is the whole reason that endpoint answers with it.
  PlexaControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plexaControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plexaControllerHash();

  @$internal
  @override
  PlexaController create() => PlexaController();
}

String _$plexaControllerHash() => r'f834aa708947905e3a003679f5f1164ca72a5456';

/// The day's conversation.
///
/// One fetch, then local edits folded over it. The screen is a thread the user
/// walks down, so a reload after every tap would scroll them away from the
/// item they just finished — and the server returns the new session from the
/// write anyway, which is the whole reason that endpoint answers with it.

abstract class _$PlexaController extends $AsyncNotifier<PlexaDay> {
  FutureOr<PlexaDay> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PlexaDay>, PlexaDay>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlexaDay>, PlexaDay>,
              AsyncValue<PlexaDay>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
