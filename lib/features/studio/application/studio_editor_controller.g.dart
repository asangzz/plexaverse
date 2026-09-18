// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_editor_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One design, open for light editing.
///
/// **Scope, stated once so it is not re-litigated by accident:** Studio on a
/// phone is VIEW plus LIGHT EDIT. This controller can retype a text layer and
/// swap an image layer, and that is all it can do. There is no move, no
/// resize, no new element and no vector tooling, because there is no canvas
/// editor on this platform — the web's is 4,400 lines of pointer maths against
/// a 280px-panel layout that does not survive a 375px viewport.
///
/// Edits are applied to the in-memory tree immediately and pushed with an
/// explicit [save]. See [StudioEditorState.dirty] for why there is no
/// autosave.

@ProviderFor(StudioEditor)
final studioEditorProvider = StudioEditorFamily._();

/// One design, open for light editing.
///
/// **Scope, stated once so it is not re-litigated by accident:** Studio on a
/// phone is VIEW plus LIGHT EDIT. This controller can retype a text layer and
/// swap an image layer, and that is all it can do. There is no move, no
/// resize, no new element and no vector tooling, because there is no canvas
/// editor on this platform — the web's is 4,400 lines of pointer maths against
/// a 280px-panel layout that does not survive a 375px viewport.
///
/// Edits are applied to the in-memory tree immediately and pushed with an
/// explicit [save]. See [StudioEditorState.dirty] for why there is no
/// autosave.
final class StudioEditorProvider
    extends $AsyncNotifierProvider<StudioEditor, StudioEditorState> {
  /// One design, open for light editing.
  ///
  /// **Scope, stated once so it is not re-litigated by accident:** Studio on a
  /// phone is VIEW plus LIGHT EDIT. This controller can retype a text layer and
  /// swap an image layer, and that is all it can do. There is no move, no
  /// resize, no new element and no vector tooling, because there is no canvas
  /// editor on this platform — the web's is 4,400 lines of pointer maths against
  /// a 280px-panel layout that does not survive a 375px viewport.
  ///
  /// Edits are applied to the in-memory tree immediately and pushed with an
  /// explicit [save]. See [StudioEditorState.dirty] for why there is no
  /// autosave.
  StudioEditorProvider._({
    required StudioEditorFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'studioEditorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$studioEditorHash();

  @override
  String toString() {
    return r'studioEditorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  StudioEditor create() => StudioEditor();

  @override
  bool operator ==(Object other) {
    return other is StudioEditorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$studioEditorHash() => r'cb67517241010c8fdf4e259b1acb63845c752867';

/// One design, open for light editing.
///
/// **Scope, stated once so it is not re-litigated by accident:** Studio on a
/// phone is VIEW plus LIGHT EDIT. This controller can retype a text layer and
/// swap an image layer, and that is all it can do. There is no move, no
/// resize, no new element and no vector tooling, because there is no canvas
/// editor on this platform — the web's is 4,400 lines of pointer maths against
/// a 280px-panel layout that does not survive a 375px viewport.
///
/// Edits are applied to the in-memory tree immediately and pushed with an
/// explicit [save]. See [StudioEditorState.dirty] for why there is no
/// autosave.

final class StudioEditorFamily extends $Family
    with
        $ClassFamilyOverride<
          StudioEditor,
          AsyncValue<StudioEditorState>,
          StudioEditorState,
          FutureOr<StudioEditorState>,
          String
        > {
  StudioEditorFamily._()
    : super(
        retry: null,
        name: r'studioEditorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One design, open for light editing.
  ///
  /// **Scope, stated once so it is not re-litigated by accident:** Studio on a
  /// phone is VIEW plus LIGHT EDIT. This controller can retype a text layer and
  /// swap an image layer, and that is all it can do. There is no move, no
  /// resize, no new element and no vector tooling, because there is no canvas
  /// editor on this platform — the web's is 4,400 lines of pointer maths against
  /// a 280px-panel layout that does not survive a 375px viewport.
  ///
  /// Edits are applied to the in-memory tree immediately and pushed with an
  /// explicit [save]. See [StudioEditorState.dirty] for why there is no
  /// autosave.

  StudioEditorProvider call(String designId) =>
      StudioEditorProvider._(argument: designId, from: this);

  @override
  String toString() => r'studioEditorProvider';
}

/// One design, open for light editing.
///
/// **Scope, stated once so it is not re-litigated by accident:** Studio on a
/// phone is VIEW plus LIGHT EDIT. This controller can retype a text layer and
/// swap an image layer, and that is all it can do. There is no move, no
/// resize, no new element and no vector tooling, because there is no canvas
/// editor on this platform — the web's is 4,400 lines of pointer maths against
/// a 280px-panel layout that does not survive a 375px viewport.
///
/// Edits are applied to the in-memory tree immediately and pushed with an
/// explicit [save]. See [StudioEditorState.dirty] for why there is no
/// autosave.

abstract class _$StudioEditor extends $AsyncNotifier<StudioEditorState> {
  late final _$args = ref.$arg as String;
  String get designId => _$args;

  FutureOr<StudioEditorState> build(String designId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<StudioEditorState>, StudioEditorState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<StudioEditorState>, StudioEditorState>,
              AsyncValue<StudioEditorState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// The AI Designer conversation for one design.
///
/// Keyed by design id so switching designs does not inherit the previous
/// design's chat — the route is stateless and replays whatever history it is
/// given, so a leaked conversation would actively mislead the model.

@ProviderFor(AiDesigner)
final aiDesignerProvider = AiDesignerFamily._();

/// The AI Designer conversation for one design.
///
/// Keyed by design id so switching designs does not inherit the previous
/// design's chat — the route is stateless and replays whatever history it is
/// given, so a leaked conversation would actively mislead the model.
final class AiDesignerProvider
    extends $NotifierProvider<AiDesigner, List<AiDesignerTurn>> {
  /// The AI Designer conversation for one design.
  ///
  /// Keyed by design id so switching designs does not inherit the previous
  /// design's chat — the route is stateless and replays whatever history it is
  /// given, so a leaked conversation would actively mislead the model.
  AiDesignerProvider._({
    required AiDesignerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'aiDesignerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$aiDesignerHash();

  @override
  String toString() {
    return r'aiDesignerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AiDesigner create() => AiDesigner();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AiDesignerTurn> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AiDesignerTurn>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AiDesignerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$aiDesignerHash() => r'29e21aa705baaca52d9ebe01fbb9e333943297e7';

/// The AI Designer conversation for one design.
///
/// Keyed by design id so switching designs does not inherit the previous
/// design's chat — the route is stateless and replays whatever history it is
/// given, so a leaked conversation would actively mislead the model.

final class AiDesignerFamily extends $Family
    with
        $ClassFamilyOverride<
          AiDesigner,
          List<AiDesignerTurn>,
          List<AiDesignerTurn>,
          List<AiDesignerTurn>,
          String
        > {
  AiDesignerFamily._()
    : super(
        retry: null,
        name: r'aiDesignerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The AI Designer conversation for one design.
  ///
  /// Keyed by design id so switching designs does not inherit the previous
  /// design's chat — the route is stateless and replays whatever history it is
  /// given, so a leaked conversation would actively mislead the model.

  AiDesignerProvider call(String designId) =>
      AiDesignerProvider._(argument: designId, from: this);

  @override
  String toString() => r'aiDesignerProvider';
}

/// The AI Designer conversation for one design.
///
/// Keyed by design id so switching designs does not inherit the previous
/// design's chat — the route is stateless and replays whatever history it is
/// given, so a leaked conversation would actively mislead the model.

abstract class _$AiDesigner extends $Notifier<List<AiDesignerTurn>> {
  late final _$args = ref.$arg as String;
  String get designId => _$args;

  List<AiDesignerTurn> build(String designId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<AiDesignerTurn>, List<AiDesignerTurn>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<AiDesignerTurn>, List<AiDesignerTurn>>,
              List<AiDesignerTurn>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
