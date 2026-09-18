import 'package:flutter/foundation.dart';

import '../domain/studio_design.dart';

/// What the light-edit surface is holding for one design.
///
/// A plain immutable class rather than a freezed one: nothing here is ever
/// serialised, and a codegen'd model for three flags and a design would be
/// ceremony without a payer.
///
/// [dirty] is the load-bearing field. The phone edits in memory and saves on a
/// tap — it does NOT autosave the way the web editor does every five minutes,
/// because a background PATCH that silently replaces a design the user is
/// also editing on a laptop is a data-loss bug, not a convenience.
@immutable
class StudioEditorState {
  const StudioEditorState({
    required this.design,
    this.dirty = false,
    this.saving = false,
    this.saveError,
  });

  final StudioDesign design;

  /// There are unsaved edits.
  final bool dirty;

  /// A save is in flight.
  final bool saving;

  /// The last save's failure, or null. Shown in amber — Zave has no red.
  final String? saveError;

  /// The element tree, or an empty one for a row fetched without its `data`.
  StudioDesignData get data => design.data ?? const StudioDesignData();

  StudioEditorState copyWith({
    StudioDesign? design,
    bool? dirty,
    bool? saving,
    String? saveError,
    bool clearSaveError = false,
  }) => StudioEditorState(
    design: design ?? this.design,
    dirty: dirty ?? this.dirty,
    saving: saving ?? this.saving,
    saveError: clearSaveError ? null : (saveError ?? this.saveError),
  );
}
