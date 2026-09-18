import 'package:freezed_annotation/freezed_annotation.dart';

part 'festive_template.freezed.dart';
part 'festive_template.g.dart';

/// One festive poster template — the web's `/festive` gallery tile.
///
/// These are Figma-derived base images, not AI output: `POST /festive/generate`
/// composites a logo and some text onto [previewUrl]'s source with sharp. That
/// distinction is why the server keeps festive in its own service rather than
/// in `ai.service` — same "generate" verb, entirely different failure modes.
@freezed
abstract class FestiveTemplate with _$FestiveTemplate {
  const factory FestiveTemplate({
    required String id,
    required String name,
    String? description,
    @Default('general') String category,
    @Default('') String previewUrl,

    /// `'1:1'`, `'4:5'`, … The gallery tile and the customizer preview both
    /// size themselves from this rather than assuming a square.
    @Default('1:1') String aspectRatio,
    String? figmaNodeId,
  }) = _FestiveTemplate;

  factory FestiveTemplate.fromJson(Map<String, dynamic> json) =>
      _$FestiveTemplateFromJson(json);
}

/// `GET /festive/templates` in full.
///
/// Unlike Studio, this route DOES return the category set, so it is read from
/// the payload instead of being derived — see `studioCategoriesOf` for the
/// other half of that asymmetry.
@freezed
abstract class FestiveGallery with _$FestiveGallery {
  const factory FestiveGallery({
    @Default(<FestiveTemplate>[]) List<FestiveTemplate> templates,
    @Default(<String>[]) List<String> categories,
  }) = _FestiveGallery;

  factory FestiveGallery.fromJson(Map<String, dynamic> json) =>
      _$FestiveGalleryFromJson(json);
}

/// Everything the user typed into the customizer.
///
/// One field of the web's form is missing here and it is missing on purpose:
/// `logoUrl`. The web reads a file into a data URI with `FileReader`; this app
/// ships no image-picker package, so there is nothing to read. The sheet says
/// so out loud rather than rendering a dead upload box — see
/// `FestiveCustomizerSheet`.
@freezed
abstract class FestiveCustomizations with _$FestiveCustomizations {
  const FestiveCustomizations._();

  const factory FestiveCustomizations({
    @Default('') String companyName,

    /// Replaces the template's title, e.g. "Happy Diwali".
    @Default('') String eventName,

    /// Replaces the template's subtitle.
    @Default('') String additionalText,
    DateTime? date,

    /// The user's brand colour as `#RRGGBB`. The web's default is `#7000ff`,
    /// which is a legacy gradient colour rather than a brand token; it is kept
    /// verbatim because it is the value the server composites with, and
    /// changing it would silently change every poster generated from the app.
    @Default('#7000FF') String primaryColor,
  }) = _FestiveCustomizations;

  /// The date exactly as the web sends it: `toLocaleDateString('en-US', …)`
  /// with weekday, long month, day and year.
  ///
  /// Spelled out by hand rather than with `DateFormat`, for two reasons: the
  /// string is baked into an image by the server and must not change shape
  /// with the phone's locale, and an explicit `'en_US'` `DateFormat` needs
  /// `initializeDateFormatting` to have run, which nothing in this app
  /// guarantees.
  String? get formattedDate {
    final DateTime? d = date;
    if (d == null) return null;
    const List<String> weekdays = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const List<String> months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}, '
        '${d.year}';
  }
}

/// What `POST /festive/generate` hands back.
///
/// [imageUrl] is a `data:image/png;base64,…` URI, not a link: the poster is
/// composited in the request and returned inline so the user sees it without a
/// second round-trip. Anything that needs a durable URL (the composer,
/// LinkedIn) has to put it through `POST /upload/image` first.
@freezed
abstract class FestivePoster with _$FestivePoster {
  const factory FestivePoster({
    @Default('') String imageUrl,
    @Default('') String templateName,
  }) = _FestivePoster;

  factory FestivePoster.fromJson(Map<String, dynamic> json) =>
      _$FestivePosterFromJson(json);
}

/// What the customizer is doing right now.
enum FestivePosterBusy {
  idle,

  /// `POST /festive/generate` — 800 XP, 5–15s of sharp work.
  generating,

  /// `POST /upload/image` — moving the inline poster into storage so it has a
  /// URL the user can actually use.
  saving,
}

/// The customizer's transient state.
@freezed
abstract class FestivePosterState with _$FestivePosterState {
  const FestivePosterState._();

  const factory FestivePosterState({
    @Default(FestivePosterBusy.idle) FestivePosterBusy busy,
    FestivePoster? poster,

    /// The storage URL, once the poster has been saved.
    String? savedUrl,

    /// Rendered in amber, never red.
    String? error,

    /// 402. The remedy is topping up, so the UI must not offer a retry.
    @Default(false) bool insufficientXp,
  }) = _FestivePosterState;

  bool get isBusy => busy != FestivePosterBusy.idle;
  bool get hasPoster => poster != null && poster!.imageUrl.isNotEmpty;
}
