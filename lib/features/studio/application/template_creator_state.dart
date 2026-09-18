import 'package:flutter/foundation.dart';

import '../presentation/widgets/canvas_presets.dart';

/// The four steps the web's Template Creator walks through.
///
/// [result] is reachable only once `POST /ai/template-creator` exists on the
/// mobile API. It is modelled anyway so the screen's shape is the web's and
/// the gap is a missing call rather than a missing design.
enum TemplateStep { upload, configure, generate, result }

/// Everything the Template Creator wizard is holding.
@immutable
class TemplateCreatorState {
  const TemplateCreatorState({
    this.step = TemplateStep.upload,
    this.referenceImageUrl,
    this.logoImageUrl,
    this.preset = CanvasPreset.instagramPost,
    this.styleId = 'copy_original',
    this.includeText = true,
    this.name = '',
    this.category = 'social_media',
    this.error,
  });

  final TemplateStep step;

  /// The design being reimagined.
  ///
  /// The web takes a dropped FILE and base64s it. This build ships no
  /// photo-library plugin, so the reference arrives as a URL — which is the
  /// honest option rather than a dropzone that cannot open anything.
  final String? referenceImageUrl;

  final String? logoImageUrl;
  final CanvasPreset preset;
  final String styleId;

  /// The web's "Include AI Content" — heading, subheading and CTA.
  final bool includeText;

  final String name;
  final String category;

  /// Shown in amber, never red.
  final String? error;

  bool get hasReference => (referenceImageUrl ?? '').isNotEmpty;

  /// What the web sends as `templateName` when the field is left blank.
  String get effectiveName {
    final String typed = name.trim();
    if (typed.isNotEmpty) return typed;
    final String style = styleId.replaceAll('_', ' ');
    return '${style[0].toUpperCase()}${style.substring(1)} Template';
  }

  TemplateCreatorState copyWith({
    TemplateStep? step,
    String? referenceImageUrl,
    String? logoImageUrl,
    CanvasPreset? preset,
    String? styleId,
    bool? includeText,
    String? name,
    String? category,
    String? error,
    bool clearError = false,
    bool clearLogo = false,
  }) => TemplateCreatorState(
    step: step ?? this.step,
    referenceImageUrl: referenceImageUrl ?? this.referenceImageUrl,
    logoImageUrl: clearLogo ? null : (logoImageUrl ?? this.logoImageUrl),
    preset: preset ?? this.preset,
    styleId: styleId ?? this.styleId,
    includeText: includeText ?? this.includeText,
    name: name ?? this.name,
    category: category ?? this.category,
    error: clearError ? null : (error ?? this.error),
  );
}
