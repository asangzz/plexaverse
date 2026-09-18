import 'package:freezed_annotation/freezed_annotation.dart';

part 'studio_design.freezed.dart';
part 'studio_design.g.dart';

/// Whether Studio is unlocked, and what it costs.
///
/// Mirrors `StudioAccessStatus` in the web's `lib/services/studio.service.ts`.
/// The unlock is a one-time XP purchase recorded as an `XPTransaction`, so
/// `hasAccess` is derived from the ledger rather than stored as a flag — which
/// is why the client must ask rather than infer it from a preference.
///
/// The web hard-codes "Unlock for 2,000 XP" in its copy; [requiredXp] comes
/// from the server instead, because the figure is an admin-tunable XP constant
/// and a hard-coded price is the kind of thing that silently goes wrong.
@freezed
abstract class StudioAccess with _$StudioAccess {
  const StudioAccess._();

  const factory StudioAccess({
    @Default(false) bool hasAccess,
    @JsonKey(name: 'currentXP') @Default(0) int currentXp,
    @JsonKey(name: 'requiredXP') @Default(0) int requiredXp,
  }) = _StudioAccess;

  factory StudioAccess.fromJson(Map<String, dynamic> json) =>
      _$StudioAccessFromJson(json);

  /// The user could unlock right now.
  bool get canAfford => currentXp >= requiredXp;

  /// How much more XP is needed. Zero once affordable.
  int get shortfall => canAfford ? 0 : requiredXp - currentXp;
}

/// The result of `POST /studio/access`.
///
/// [alreadyUnlocked] is the idempotent path — a second unlock does not charge
/// again, and the UI must not celebrate a purchase that did not happen.
@freezed
abstract class StudioUnlockResult with _$StudioUnlockResult {
  const factory StudioUnlockResult({
    @Default(false) bool success,
    @Default(false) bool alreadyUnlocked,
    int? newBalance,
  }) = _StudioUnlockResult;

  factory StudioUnlockResult.fromJson(Map<String, dynamic> json) =>
      _$StudioUnlockResultFromJson(json);
}

/// The design's page: its pixel dimensions and paper colour.
///
/// These are DESIGN units, not screen pixels. Everything inside a
/// [StudioDesignData] is laid out against this box and the whole thing is
/// scaled to fit whatever space the phone has.
@freezed
abstract class StudioCanvas with _$StudioCanvas {
  const StudioCanvas._();

  const factory StudioCanvas({
    @Default(1080.0) double width,
    @Default(1080.0) double height,
    @Default('#0a0a0a') String background,
  }) = _StudioCanvas;

  factory StudioCanvas.fromJson(Map<String, dynamic> json) =>
      _$StudioCanvasFromJson(json);

  /// Guarded — a zero from a malformed payload would divide by zero in every
  /// `AspectRatio` that consumes this.
  double get aspectRatio => (width > 0 && height > 0) ? width / height : 1;
}

/// One node in a design.
///
/// Transcribed from `StudioElement` in the web's `lib/studio/types.ts`. Only
/// the fields the phone renders or edits are carried: the Figma-import
/// internals (`_figmaNodeId`, `_needsImageDownload`), per-range rich text
/// (`styleRanges`) and the text effects are deliberately absent, because
/// **this surface never writes them and dropping a field it does not
/// understand would silently destroy it on save.** See the note on
/// [StudioDesignData.rawElements].
///
/// [type] is a string rather than an enum on purpose: the web can add a node
/// type without the app shipping, and an unknown type must render as nothing
/// rather than throw during `fromJson`.
@freezed
abstract class StudioElement with _$StudioElement {
  const StudioElement._();

  const factory StudioElement({
    required String id,

    /// 'rectangle' | 'ellipse' | 'text' | 'image' | 'line' | 'group' | 'frame'.
    @Default('rectangle') String type,
    @Default('') String name,
    @Default(0.0) double x,
    @Default(0.0) double y,
    @Default(0.0) double width,
    @Default(0.0) double height,

    /// Degrees, clockwise, about the element's centre — the web applies
    /// `transform: rotate(Ndeg)` with the default (centre) origin.
    @Default(0.0) double rotation,

    /// A CSS colour string. For a text node this is the TEXT colour, not a
    /// background — the web sets `color: element.fill` there.
    @Default('transparent') String fill,
    @Default('transparent') String stroke,
    @Default(0.0) double strokeWidth,
    @Default(1.0) double opacity,
    @Default(true) bool visible,
    @Default(false) bool locked,
    double? borderRadius,

    // ── Text ───────────────────────────────────────────────────────────────
    String? text,
    double? fontSize,
    String? fontFamily,
    int? fontWeight,

    /// 'normal' | 'italic'.
    String? fontStyle,

    /// 'left' | 'center' | 'right'.
    String? textAlign,
    double? lineHeight,
    double? letterSpacing,
    @Default(false) bool underline,
    @Default(false) bool linethrough,

    /// 'none' | 'uppercase' | 'lowercase' | 'capitalize'.
    String? textTransform,

    // ── Image ──────────────────────────────────────────────────────────────
    /// An `https://` URL or a `data:image/…;base64,…` URI. The AI Designer
    /// returns the latter inline, so both must render.
    String? imageUrl,

    /// 'rectangle' | 'ellipse' | 'custom'.
    String? maskShape,
    double? maskBorderRadius,

    // ── Frame / group ──────────────────────────────────────────────────────
    /// The web clips whenever this is not explicitly `false`, hence the
    /// default of true rather than false.
    @Default(true) bool clipContent,

    /// 'none' | 'horizontal' | 'vertical'.
    String? layoutMode,
    double? layoutGap,
    double? layoutPadding,

    /// Children of a group or frame. Their x/y are **relative to this
    /// element**, because the web nests their absolutely-positioned boxes
    /// inside this one.
    @Default(<StudioElement>[]) List<StudioElement> children,
  }) = _StudioElement;

  factory StudioElement.fromJson(Map<String, dynamic> json) =>
      _$StudioElementFromJson(json);

  bool get isText => type == 'text';
  bool get isImage => type == 'image';
  bool get isContainer => type == 'group' || type == 'frame';

  /// What to call this layer in a list. Falls back to the type, because a
  /// Figma-imported node often arrives unnamed.
  String get displayName => name.trim().isEmpty ? type : name.trim();

  /// The text a user would edit, never null.
  String get textValue => text ?? '';
}

/// A whole design: the canvas plus its element tree.
///
/// ## The round-trip problem, and how this type handles it
///
/// A phone edits a caption and an image URL. It does NOT understand
/// `styleRanges`, `textShadow`, `constraints` or the Figma import flags — but
/// the design it saves back replaces the row wholesale. Parsing into a typed
/// model and re-serialising would therefore quietly delete every field this
/// app has not heard of, and the user would find their design flattened next
/// time they opened it on the web.
///
/// So [rawElements] keeps the untouched JSON the server sent, and
/// [toWireJson] merges the edits back onto it rather than emitting the typed
/// model. The typed [elements] tree is for RENDERING and EDITING only.
@freezed
abstract class StudioDesignData with _$StudioDesignData {
  const StudioDesignData._();

  const factory StudioDesignData({
    @Default(1) int version,
    @Default(StudioCanvas()) StudioCanvas canvas,
    @Default(<StudioElement>[]) List<StudioElement> elements,
    @Default(<String>[]) List<String> selectedIds,

    /// The verbatim `elements` array as the server sent it. Never rendered;
    /// used only to rebuild the wire payload without losing unknown fields.
    /// Excluded from JSON in both directions — it IS the JSON.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(<Map<String, dynamic>>[])
    List<Map<String, dynamic>> rawElements,
  }) = _StudioDesignData;

  /// Hand-written, not generated.
  ///
  /// This type deliberately has a bespoke [toJson] (it must emit the WIRE form
  /// so unknown element fields survive — see the class doc). Defining one makes
  /// json_serializable treat the whole class as manually serialised and skip
  /// generating its `fromJson` partner, so the partner is written out here
  /// rather than left half-generated.
  factory StudioDesignData.fromJson(Map<String, dynamic> json) {
    final Object? raw = json['elements'];
    final List<Map<String, dynamic>> rawElements = raw is List
        ? raw
              .whereType<Map<String, dynamic>>()
              .map(Map<String, dynamic>.from)
              .toList(growable: false)
        : const <Map<String, dynamic>>[];

    final Object? canvas = json['canvas'];
    final Object? selected = json['selectedIds'];

    return StudioDesignData(
      version: (json['version'] as num?)?.toInt() ?? 1,
      canvas: canvas is Map<String, dynamic>
          ? StudioCanvas.fromJson(canvas)
          : const StudioCanvas(),
      elements: rawElements
          .map(StudioElement.fromJson)
          .toList(growable: false),
      selectedIds: selected is List
          ? selected.whereType<String>().toList(growable: false)
          : const <String>[],
      rawElements: rawElements,
    );
  }

  /// Every text node in the tree, depth-first, in paint order.
  List<StudioElement> get textElements =>
      _collect(elements, (StudioElement e) => e.isText);

  /// Every image node in the tree, depth-first, in paint order.
  List<StudioElement> get imageElements =>
      _collect(elements, (StudioElement e) => e.isImage);

  /// Returns a copy with the element carrying [id] replaced by [update]'s
  /// result, at whatever depth it sits. Both the typed tree and the raw
  /// mirror are patched, so a later [toWireJson] carries the edit.
  StudioDesignData patch(
    String id,
    StudioElement Function(StudioElement) update,
    Map<String, dynamic> Function(Map<String, dynamic>) rawUpdate,
  ) => copyWith(
    elements: _patchTree(elements, id, update),
    rawElements: _patchRawTree(rawElements, id, rawUpdate),
  );

  /// The payload to PATCH back to `/studio/designs/[id]`.
  ///
  /// Emits [rawElements] when there is one, so fields this app does not model
  /// Serialising this type IS [toWireJson].
  ///
  /// json_serializable needs a `toJson` on the nested type to serialise the
  /// `data` / `design` fields on [StudioDesign] and the AI-designer reply. The
  /// generated one would emit the TYPED tree and so drop every element field
  /// this app does not model — which is the exact data loss [rawElements]
  /// exists to prevent. So the wire form is the only correct answer here.
  Map<String, dynamic> toJson() => toWireJson();

  /// survive the round trip. A design the app created itself (the AI Designer
  /// path) has no raw mirror, and then the typed tree is authoritative.
  Map<String, dynamic> toWireJson() => <String, dynamic>{
    'version': version,
    'canvas': <String, dynamic>{
      'width': canvas.width,
      'height': canvas.height,
      'background': canvas.background,
    },
    'elements': rawElements.isNotEmpty
        ? rawElements
        : elements.map((StudioElement e) => e.toJson()).toList(growable: false),
    'selectedIds': selectedIds,
  };
}

/// Depth-first collect over the element tree.
List<StudioElement> _collect(
  List<StudioElement> nodes,
  bool Function(StudioElement) test,
) {
  final List<StudioElement> out = <StudioElement>[];
  for (final StudioElement node in nodes) {
    if (test(node)) out.add(node);
    if (node.children.isNotEmpty) out.addAll(_collect(node.children, test));
  }
  return out;
}

List<StudioElement> _patchTree(
  List<StudioElement> nodes,
  String id,
  StudioElement Function(StudioElement) update,
) => nodes
    .map(
      (StudioElement node) => node.id == id
          ? update(node)
          : (node.children.isEmpty
                ? node
                : node.copyWith(
                    children: _patchTree(node.children, id, update),
                  )),
    )
    .toList(growable: false);

List<Map<String, dynamic>> _patchRawTree(
  List<Map<String, dynamic>> nodes,
  String id,
  Map<String, dynamic> Function(Map<String, dynamic>) update,
) => nodes
    .map((Map<String, dynamic> node) {
      if (node['id'] == id) return update(Map<String, dynamic>.from(node));
      final Object? kids = node['children'];
      if (kids is! List) return node;
      final List<Map<String, dynamic>> typed = kids
          .whereType<Map<String, dynamic>>()
          .map(Map<String, dynamic>.from)
          .toList(growable: false);
      if (typed.length != kids.length) return node;
      return <String, dynamic>{
        ...node,
        'children': _patchRawTree(typed, id, update),
      };
    })
    .toList(growable: false);

/// A saved Studio design.
///
/// One type covers both the list row and the full record: the list endpoints
/// deliberately omit the heavy `data` JSON to keep responses small, so [data]
/// is null on a summary and populated after `GET /studio/designs/[id]`. That
/// is a real distinction the UI has to respect — a tile cannot preview a
/// design it has not fetched, which is why the server also sends [thumbnail].
@freezed
abstract class StudioDesign with _$StudioDesign {
  const StudioDesign._();

  const factory StudioDesign({
    required String id,
    @Default('Untitled') String name,
    String? description,

    /// A data-URI or URL snapshot, saved by the web editor. Absent for
    /// designs that have never been opened there.
    String? thumbnail,
    @Default(1080) int width,
    @Default(1080) int height,
    @Default(false) bool isPublic,
    @Default(false) bool isTemplate,
    String? category,

    /// ISO-8601, as Prisma serialises it. Kept as a string and parsed
    /// leniently at the point of display — a date that fails to parse must
    /// cost a caption, not the whole list.
    String? createdAt,
    String? updatedAt,

    /// Null on a list row; present after a single-design fetch.
    StudioDesignData? data,
  }) = _StudioDesign;

  factory StudioDesign.fromJson(Map<String, dynamic> json) =>
      _$StudioDesignFromJson(json);

  /// The canvas box, from [data] when loaded and from the row's own columns
  /// otherwise — so a tile can reserve the right shape before the design is
  /// fetched.
  double get aspectRatio =>
      data?.canvas.aspectRatio ??
      ((width > 0 && height > 0) ? width / height : 1);

  DateTime? get updatedAtDate =>
      updatedAt == null ? null : DateTime.tryParse(updatedAt!);

  /// The category as a human reads it: the web stores `automate_posts_company`
  /// and renders "Automate Posts Company".
  String? get categoryLabel {
    final String? raw = category;
    if (raw == null || raw.isEmpty) return null;
    return raw
        .split('_')
        .where((String w) => w.isNotEmpty)
        .map((String w) => '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}
