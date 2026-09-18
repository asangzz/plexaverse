// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Template Creator wizard — the web's `/template-creator`.
///
/// ## Why this controller has no repository
///
/// The web's terminal action is `POST /api/ai/template-creator`. **That route
/// has no mobile counterpart** — there is no `app/api/mobile/v1/ai/
/// template-creator/route.ts` — so there is nothing for a repository to call.
///
/// Rather than invent a path and let the 404 be swallowed by a `catch`, the
/// wizard is built end to end and the generate step says plainly what is
/// missing. Every choice the user makes here is real state in the shape the
/// endpoint will want, so wiring it later is a repository and one call, not a
/// screen.

@ProviderFor(TemplateCreatorController)
final templateCreatorControllerProvider = TemplateCreatorControllerProvider._();

/// The Template Creator wizard — the web's `/template-creator`.
///
/// ## Why this controller has no repository
///
/// The web's terminal action is `POST /api/ai/template-creator`. **That route
/// has no mobile counterpart** — there is no `app/api/mobile/v1/ai/
/// template-creator/route.ts` — so there is nothing for a repository to call.
///
/// Rather than invent a path and let the 404 be swallowed by a `catch`, the
/// wizard is built end to end and the generate step says plainly what is
/// missing. Every choice the user makes here is real state in the shape the
/// endpoint will want, so wiring it later is a repository and one call, not a
/// screen.
final class TemplateCreatorControllerProvider
    extends $NotifierProvider<TemplateCreatorController, TemplateCreatorState> {
  /// The Template Creator wizard — the web's `/template-creator`.
  ///
  /// ## Why this controller has no repository
  ///
  /// The web's terminal action is `POST /api/ai/template-creator`. **That route
  /// has no mobile counterpart** — there is no `app/api/mobile/v1/ai/
  /// template-creator/route.ts` — so there is nothing for a repository to call.
  ///
  /// Rather than invent a path and let the 404 be swallowed by a `catch`, the
  /// wizard is built end to end and the generate step says plainly what is
  /// missing. Every choice the user makes here is real state in the shape the
  /// endpoint will want, so wiring it later is a repository and one call, not a
  /// screen.
  TemplateCreatorControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'templateCreatorControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$templateCreatorControllerHash();

  @$internal
  @override
  TemplateCreatorController create() => TemplateCreatorController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TemplateCreatorState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TemplateCreatorState>(value),
    );
  }
}

String _$templateCreatorControllerHash() =>
    r'bfcf5d5f797fb7723fb54ddd2158433f0d17c874';

/// The Template Creator wizard — the web's `/template-creator`.
///
/// ## Why this controller has no repository
///
/// The web's terminal action is `POST /api/ai/template-creator`. **That route
/// has no mobile counterpart** — there is no `app/api/mobile/v1/ai/
/// template-creator/route.ts` — so there is nothing for a repository to call.
///
/// Rather than invent a path and let the 404 be swallowed by a `catch`, the
/// wizard is built end to end and the generate step says plainly what is
/// missing. Every choice the user makes here is real state in the shape the
/// endpoint will want, so wiring it later is a repository and one call, not a
/// screen.

abstract class _$TemplateCreatorController
    extends $Notifier<TemplateCreatorState> {
  TemplateCreatorState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TemplateCreatorState, TemplateCreatorState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TemplateCreatorState, TemplateCreatorState>,
              TemplateCreatorState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
