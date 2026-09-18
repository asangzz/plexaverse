import 'package:freezed_annotation/freezed_annotation.dart';

part 'studio_template.freezed.dart';
part 'studio_template.g.dart';

/// One Studio design offered in **Reimagine** — the web's `/reimagine`.
///
/// The row is a `StudioDesign` that is either public or the user's own
/// template; `GET /studio/templates` returns exactly the list select
/// (`DESIGN_LIST_SELECT`), which deliberately excludes the canvas JSON so the
/// gallery response stays small. That is why there is no `data` field here:
/// the phone has no Fabric canvas to render it into, so fetching it would cost
/// bandwidth for nothing.
@freezed
abstract class StudioTemplate with _$StudioTemplate {
  const StudioTemplate._();

  const factory StudioTemplate({
    required String id,
    required String name,
    String? description,

    /// A rendered preview. Null for a design that has never been saved from
    /// the canvas — the tile then falls back to the size badge, as the web's
    /// no-thumbnail branch does.
    String? thumbnail,
    @Default(0) int width,
    @Default(0) int height,
    String? category,
    @Default(false) bool isPublic,
    @Default(false) bool isTemplate,

    /// ISO-8601 as the server sent it. Kept as a string because nothing on
    /// this screen does date arithmetic — it is shown, at most, as-is.
    String? createdAt,
    String? updatedAt,
  }) = _StudioTemplate;

  factory StudioTemplate.fromJson(Map<String, dynamic> json) =>
      _$StudioTemplateFromJson(json);

  /// `1080 × 1080`. The web paints this as a badge in the tile's top-right,
  /// and as the whole placeholder when there is no thumbnail.
  String get sizeLabel => '$width × $height';
}

/// The unique, sorted category set behind a template list.
///
/// Derived on the client on purpose. The **web** route
/// (`/api/studio/templates`) returns `{templates, categories}`; the **mobile**
/// route returns `{templates}` only. Rather than invent a second request or
/// pretend the filter bar has no data, the same set is computed from the list
/// we already hold — it is the identical answer, one round-trip cheaper.
List<String> studioCategoriesOf(List<StudioTemplate> templates) {
  final Set<String> seen = <String>{};
  for (final StudioTemplate t in templates) {
    final String? c = t.category;
    if (c != null && c.isNotEmpty) seen.add(c);
  }
  final List<String> out = seen.toList(growable: false)..sort();
  return out;
}

/// What the "copy this template into my designs" action is doing.
///
/// A copy is per-tile, so the id of the tile in flight is part of the state:
/// without it every tile in the gallery would spin at once, which is exactly
/// what a single `isCopying` boolean would produce.
@freezed
abstract class TemplateCopyState with _$TemplateCopyState {
  const TemplateCopyState._();

  const factory TemplateCopyState({
    /// The template id currently being copied, if any.
    String? copyingId,

    /// The design the last successful copy produced.
    StudioTemplate? copied,

    /// The id of the template [copied] was made FROM.
    ///
    /// Needed because the copy gets a fresh id: without it, opening a second
    /// template's sheet after a successful copy would find `copied != null`
    /// and show that template as already copied.
    String? copiedFromId,

    /// Amber, never red — Zave has no red, and a failed copy is "needs
    /// attention", not a destructive state.
    String? error,
  }) = _TemplateCopyState;

  bool isCopying(String id) => copyingId == id;
  bool didCopy(String id) => copiedFromId == id;
  bool get busy => copyingId != null;
}
