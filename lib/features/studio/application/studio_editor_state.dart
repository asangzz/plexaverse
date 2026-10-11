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
    this.swappingElementId,
    this.swapError,
  });

  final StudioDesign design;

  /// There are unsaved edits.
  final bool dirty;

  /// A save is in flight.
  final bool saving;

  /// The last save's failure, or null. Shown in amber — Zave has no red.
  final String? saveError;

  /// The image layer currently having a replacement generated, or null.
  ///
  /// On the design and not on the swap sheet, because the sheet is a modal
  /// the user can dismiss and `POST /ai/image` costs XP. When the flag lived
  /// on the sheet, a dismissal mid-generation threw the image away after it
  /// had been paid for, and the sheet reopened looking idle while the call
  /// was still running. Per-element rather than a bare bool so a second
  /// layer's sheet is not disabled by the first layer's work.
  final String? swappingElementId;

  /// Why the last swap did not happen — a rejected URL, an empty prompt, or
  /// a failed generation. Shown in amber; Zave has no red.
  final String? swapError;

  /// The element tree, or an empty one for a row fetched without its `data`.
  StudioDesignData get data => design.data ?? const StudioDesignData();

  /// True while [elementId]'s replacement image is being generated.
  bool isSwapping(String elementId) => swappingElementId == elementId;

  StudioEditorState copyWith({
    StudioDesign? design,
    bool? dirty,
    bool? saving,
    String? saveError,
    bool clearSaveError = false,
    String? swappingElementId,
    bool clearSwapping = false,
    String? swapError,
    bool clearSwapError = false,
  }) => StudioEditorState(
    design: design ?? this.design,
    dirty: dirty ?? this.dirty,
    saving: saving ?? this.saving,
    saveError: clearSaveError ? null : (saveError ?? this.saveError),
    swappingElementId: clearSwapping
        ? null
        : (swappingElementId ?? this.swappingElementId),
    swapError: clearSwapError ? null : (swapError ?? this.swapError),
  );
}
