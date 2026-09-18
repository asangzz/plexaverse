import 'dart:ui' show Color;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../preferences/domain/user_preferences.dart';

part 'mission_models.freezed.dart';
part 'mission_models.g.dart';

/// What `POST /roadmap/progress` answers with.
///
/// `alreadyCompleted` is not an error: the endpoint is idempotent, and a user
/// who taps Finish twice should see the same calm confirmation both times
/// rather than a failure on the second tap.
@freezed
abstract class MissionStepResult with _$MissionStepResult {
  const MissionStepResult._();

  const factory MissionStepResult({
    @Default(false) bool alreadyCompleted,
    @Default(0) int xpAwarded,
  }) = _MissionStepResult;

  factory MissionStepResult.fromJson(Map<String, dynamic> json) =>
      _$MissionStepResultFromJson(json);
}

/// Preferences plus the one thing the mission pages need that is NOT on the
/// preferences model: the user's LinkedIn profile slug.
///
/// The slug rides in the `GET /user/preferences` payload under
/// `user.linkedinAccounts[0].profileSlug`, which `UserPreferences` does not
/// model (it flattens the row and ignores the nested `user` object). The
/// mission pages build LinkedIn's own edit URL from it —
/// `linkedin.com/in/{slug}/edit/forms/intro/new/` — so it is lifted out here
/// rather than fetched from a second endpoint.
@freezed
abstract class MissionProfile with _$MissionProfile {
  const MissionProfile._();

  const factory MissionProfile({
    @Default(UserPreferences.empty) UserPreferences preferences,

    /// Null when no LinkedIn account is connected yet. The hand-off card then
    /// says so instead of building a URL around an empty segment.
    String? linkedinSlug,

    /// The signed-in user's display name, from `GET /auth/me`.
    ///
    /// The web reads it off the NextAuth session. This app keeps `AuthUser`
    /// inside the auth flow and exposes no app-wide provider for it, so the
    /// one screen that needs a name — the banner — asks the server rather than
    /// reaching into another slice's internals.
    String? displayName,
  }) = _MissionProfile;

  /// The name a banner template's `YOUR NAME` placeholder is replaced with.
  /// The web's own fallback when the session carries no name.
  String get bannerName => (displayName == null || displayName!.isEmpty)
      ? 'Plexaverse User'
      : displayName!;

  /// Which tone the AI routes should optimise for.
  ///
  /// The preferences column carries three values
  /// (`personal_brand` | `get_hired` | `company_brand`) but the AI routes
  /// accept two (`personal_brand` | `recruiter`) and silently drop anything
  /// else. Mapping here rather than passing the column through means a
  /// `get_hired` user actually gets the recruiter tone they asked for, instead
  /// of the service's default because the value was thrown away upstream.
  String get aiPriority =>
      preferences.priority == 'personal_brand' ? 'personal_brand' : 'recruiter';

  /// The persona line the headline mission shows under its heading.
  String get personaLabel => preferences.priority == 'personal_brand'
      ? 'Thought Leader'
      : 'Expert Professional';
}

/// The Season 1 recap numbers.
///
/// The web's server component reads these straight off Prisma. Mobile has no
/// such route, so they are assembled from three reads — see
/// `MissionsRepository.fetchSeasonRecap`, which also explains [postsAtLeast].
@freezed
abstract class SeasonRecap with _$SeasonRecap {
  const SeasonRecap._();

  const factory SeasonRecap({
    @Default(0) int roadmapDay,
    @Default(0) int postsPublished,

    /// True when the post count hit the page limit, so the real figure is
    /// "[postsPublished] or more". Rendered as `100+` rather than a number the
    /// app cannot stand behind.
    @Default(false) bool postsAtLeast,
    @Default(0) int xpBalance,
  }) = _SeasonRecap;
}

// ─── Banner templates ───────────────────────────────────────────────────────

/// A Studio banner template — one entry of
/// `GET /studio/templates?category=banner&includeData=true`.
@freezed
abstract class BannerTemplate with _$BannerTemplate {
  const BannerTemplate._();

  const factory BannerTemplate({
    required String id,
    @Default('') String name,
    String? description,
    String? thumbnail,
    @Default(1200) int width,
    @Default(400) int height,

    /// Null when the list was fetched without `includeData`. Such a template
    /// cannot be previewed, so the screen drops it rather than rendering an
    /// empty card.
    BannerDesign? data,
  }) = _BannerTemplate;

  factory BannerTemplate.fromJson(Map<String, dynamic> json) =>
      _$BannerTemplateFromJson(json);
}

/// A design's canvas — the coordinate space every element's x/y/width/height is
/// expressed in.
@freezed
abstract class BannerCanvas with _$BannerCanvas {
  const BannerCanvas._();

  const factory BannerCanvas({
    @Default(1200.0) double width,
    @Default(400.0) double height,

    /// A CSS colour string. Parsed by [parseCssColor]; a gradient (which the
    /// Studio does allow) fails that parse and falls back to the Studio's own
    /// default ground.
    String? background,
  }) = _BannerCanvas;

  factory BannerCanvas.fromJson(Map<String, dynamic> json) =>
      _$BannerCanvasFromJson(json);

  double get aspectRatio => height <= 0 ? 3 : width / height;
}

/// One element of a design. Recursive: a group or frame carries [children]
/// whose coordinates are relative to their parent's origin.
@freezed
abstract class BannerElement with _$BannerElement {
  const BannerElement._();

  const factory BannerElement({
    @Default('') String id,

    /// `rectangle` | `ellipse` | `text` | `image` | `line` | `group` | `frame`.
    @Default('rectangle') String type,
    @Default('') String name,
    @Default(0.0) double x,
    @Default(0.0) double y,
    @Default(0.0) double width,
    @Default(0.0) double height,
    @Default('transparent') String fill,
    @Default(1.0) double opacity,
    @Default(true) bool visible,
    double? borderRadius,
    String? text,
    double? fontSize,
    String? fontFamily,
    int? fontWeight,

    /// `left` | `center` | `right`.
    String? textAlign,
    String? imageUrl,
    @Default(<BannerElement>[]) List<BannerElement> children,
  }) = _BannerElement;

  factory BannerElement.fromJson(Map<String, dynamic> json) =>
      _$BannerElementFromJson(json);

  bool get isText => type == 'text';
  bool get isImage => type == 'image';
}

/// A whole design — canvas plus elements.
@freezed
abstract class BannerDesign with _$BannerDesign {
  const BannerDesign._();

  const factory BannerDesign({
    /// Nullable rather than defaulted: `json_serializable` can only take a
    /// LITERAL as a `@JsonKey` default, so a defaulted nested object would not
    /// survive codegen. [frame] is the read side.
    BannerCanvas? canvas,
    @Default(<BannerElement>[]) List<BannerElement> elements,
  }) = _BannerDesign;

  factory BannerDesign.fromJson(Map<String, dynamic> json) =>
      _$BannerDesignFromJson(json);

  /// The canvas to lay out against — the design's own, or the Studio default
  /// when it carries none.
  BannerCanvas get frame => canvas ?? const BannerCanvas();

  /// Substitutes the user's name and position into the template's placeholder
  /// text layers.
  ///
  /// The matching rules are ported VERBATIM from the web's `personalizeDesign`,
  /// including the odd-looking literals (`'founder & ceo'` really is treated as
  /// a placeholder). They are odd because they describe the template library as
  /// it actually is, and loosening them here would leave a stranger's job title
  /// on somebody's banner.
  BannerDesign personalised({required String name, required String position}) {
    final String nameUpper = (name.isEmpty ? 'USER' : name).toUpperCase();
    final String positionUpper = (position.isEmpty ? 'POSITION' : position)
        .toUpperCase();

    List<BannerElement> walk(List<BannerElement> elements) => elements
        .map((BannerElement el) {
          BannerElement next = el;
          if (el.isText) {
            final String textLower = (el.text ?? '').toLowerCase();
            final String nameLower = el.name.toLowerCase();

            if (textLower == 'your name' ||
                nameLower.contains('name') ||
                nameLower.contains('user')) {
              next = next.copyWith(text: nameUpper);
            }

            if (textLower == 'position' ||
                textLower == 'your position' ||
                textLower == 'job title' ||
                textLower == 'founder & ceo' ||
                textLower.contains('placeholder') ||
                nameLower.contains('position') ||
                nameLower.contains('role') ||
                nameLower.contains('title') ||
                nameLower.contains('designation')) {
              next = next.copyWith(text: positionUpper);
            }
          }
          if (el.children.isNotEmpty) {
            next = next.copyWith(children: walk(el.children));
          }
          return next;
        })
        .toList(growable: false);

    return copyWith(elements: walk(elements));
  }

  /// Crops the canvas to the elements' real bounds.
  ///
  /// Ported from the web's `normalizeDesign`. Studio designs are often authored
  /// on a canvas larger than the artwork, and without this the preview renders
  /// a banner floating in a field of background. Only TOP-LEVEL elements shift:
  /// children are already relative to their parent, so shifting them too would
  /// move them twice.
  BannerDesign normalised() {
    if (elements.isEmpty) return this;

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    void bounds(List<BannerElement> list, double parentX, double parentY) {
      for (final BannerElement el in list) {
        final double gx = parentX + el.x;
        final double gy = parentY + el.y;
        if (gx < minX) minX = gx;
        if (gy < minY) minY = gy;
        if (gx + el.width > maxX) maxX = gx + el.width;
        if (gy + el.height > maxY) maxY = gy + el.height;
        if (el.children.isNotEmpty) bounds(el.children, gx, gy);
      }
    }

    bounds(elements, 0, 0);
    if (minX == double.infinity) return this;

    return copyWith(
      canvas: frame.copyWith(width: maxX - minX, height: maxY - minY),
      elements: elements
          .map(
            (BannerElement el) => el.copyWith(x: el.x - minX, y: el.y - minY),
          )
          .toList(growable: false),
    );
  }
}

/// The Studio's own default canvas ground, used when a design names no
/// background or names one this parser cannot read (a gradient, say).
const Color kBannerFallbackGround = Color(0xFF0A0A0F);

/// Parses the CSS colour strings Studio designs carry.
///
/// Returns null for `transparent`, for an empty value, and for anything this
/// does not understand — a gradient, a named colour, `currentColor`. Callers
/// treat null as "paint nothing", which is what the web's own renderer does
/// when it hands an unparseable fill to the DOM.
///
/// This lives in `domain/` rather than in the widget because it is a property
/// of the DATA (what a Studio fill string means), not of how it is drawn.
Color? parseCssColor(String? raw) {
  if (raw == null) return null;
  final String value = raw.trim().toLowerCase();
  if (value.isEmpty || value == 'transparent' || value == 'none') return null;

  if (value.startsWith('#')) {
    final String hex = value.substring(1);
    switch (hex.length) {
      case 3:
        final int? rgb = int.tryParse(hex, radix: 16);
        if (rgb == null) return null;
        // #abc → #aabbcc
        final int r = ((rgb >> 8) & 0xF) * 0x11;
        final int g = ((rgb >> 4) & 0xF) * 0x11;
        final int b = (rgb & 0xF) * 0x11;
        return Color.fromARGB(255, r, g, b);
      case 6:
        final int? rgb = int.tryParse(hex, radix: 16);
        return rgb == null ? null : Color(0xFF000000 | rgb);
      case 8:
        // CSS orders this #RRGGBBAA; Flutter wants 0xAARRGGBB.
        final int? rgba = int.tryParse(hex, radix: 16);
        if (rgba == null) return null;
        final int alpha = rgba & 0xFF;
        return Color((alpha << 24) | (rgba >> 8));
      default:
        return null;
    }
  }

  if (value.startsWith('rgb')) {
    final int open = value.indexOf('(');
    final int close = value.indexOf(')');
    if (open < 0 || close < open) return null;
    final List<String> parts = value
        .substring(open + 1, close)
        .split(',')
        .map((String p) => p.trim())
        .toList(growable: false);
    if (parts.length < 3) return null;
    final int? r = int.tryParse(parts[0]);
    final int? g = int.tryParse(parts[1]);
    final int? b = int.tryParse(parts[2]);
    if (r == null || g == null || b == null) return null;
    final double a = parts.length > 3
        ? (double.tryParse(parts[3]) ?? 1).clamp(0, 1).toDouble()
        : 1;
    return Color.fromARGB((a * 255).round(), r, g, b);
  }

  return null;
}
