import 'package:freezed_annotation/freezed_annotation.dart';

part 'headshot_session.freezed.dart';
part 'headshot_session.g.dart';

/// The fewest reference photos `POST /ai/headshot` will accept.
const int minHeadshotPhotos = 3;

/// The most the web lets you attach; the server uses the first four.
const int maxHeadshotPhotos = 10;

/// The four steps of the web's `/headshots` wizard, in order.
///
/// Kept as an enum rather than an int so the stepper cannot render a state the
/// controller cannot be in — the web tracks this as a string union and then
/// does `['upload','style','generate','results'].indexOf(step) > i` three
/// times per node to work out what is behind it.
enum HeadshotStep {
  upload,
  style,
  generate,
  results;

  String get label => switch (this) {
    HeadshotStep.upload => 'Upload photos',
    HeadshotStep.style => 'Select style',
    HeadshotStep.generate => 'Generate',
    HeadshotStep.results => 'Results',
  };
}

/// The four looks the generator offers. `wire` is what the API validates
/// against — anything else falls back to `professional` server-side.
enum HeadshotStyle {
  professional,
  creative,

  /// The API calls this `corporate`; the web labels it "Executive". Both are
  /// kept: the wire value is the contract, the label is the copy.
  corporate,
  casual;

  String get wire => name;

  String get label => switch (this) {
    HeadshotStyle.professional => 'Professional',
    HeadshotStyle.creative => 'Creative',
    HeadshotStyle.corporate => 'Executive',
    HeadshotStyle.casual => 'Casual professional',
  };

  String get description => switch (this) {
    HeadshotStyle.professional => 'Clean, corporate look perfect for LinkedIn',
    HeadshotStyle.creative => 'Modern and artistic style',
    HeadshotStyle.corporate => 'Formal executive portrait style',
    HeadshotStyle.casual => 'Approachable and friendly look',
  };
}

/// Where the generated portrait is set.
enum HeadshotBackground {
  studio,
  office,
  outdoor,

  /// `abstract` is a built-in identifier in Dart and cannot be a constant
  /// name, so the constant is spelled `abstractBg` and [wire] restores the
  /// value the API validates against.
  abstractBg;

  String get wire => this == HeadshotBackground.abstractBg ? 'abstract' : name;

  String get label => switch (this) {
    HeadshotBackground.studio => 'Studio',
    HeadshotBackground.office => 'Office',
    HeadshotBackground.outdoor => 'Outdoor',
    HeadshotBackground.abstractBg => 'Abstract',
  };
}

/// What `POST /ai/headshot` hands back.
///
/// [headshots] are `data:image/png;base64,…` URIs, four of them, generated in
/// parallel. The call is all-or-nothing: if any of the four is rejected the
/// whole request fails and no XP is spent, so there is no partial state to
/// model here.
@freezed
abstract class HeadshotResult with _$HeadshotResult {
  const factory HeadshotResult({
    @Default(<String>[]) List<String> headshots,
    @Default(0) int count,
    @Default('professional') String style,
    @Default('studio') String background,
  }) = _HeadshotResult;

  factory HeadshotResult.fromJson(Map<String, dynamic> json) =>
      _$HeadshotResultFromJson(json);
}

/// The whole `/headshots` wizard, as one value.
///
/// The web spreads this across ten `useState` calls and then has to keep them
/// consistent by hand — which is how `step` can be `'generate'` while
/// `isGenerating` is already false. One object makes the impossible
/// combinations unrepresentable.
@freezed
abstract class HeadshotSession with _$HeadshotSession {
  const HeadshotSession._();

  const factory HeadshotSession({
    @Default(HeadshotStep.upload) HeadshotStep step,

    /// Reference photos as `data:image/…;base64,…` URIs.
    ///
    /// Always empty in this build: there is no image-picker package, so
    /// nothing can put a photo here. The field is real rather than removed
    /// because the rest of the flow is written against it and works the day
    /// the dependency lands.
    @Default(<String>[]) List<String> photos,
    @Default(HeadshotStyle.professional) HeadshotStyle style,
    @Default(HeadshotBackground.studio) HeadshotBackground background,

    /// The generated portraits, as data URIs.
    @Default(<String>[]) List<String> results,
    @Default(false) bool generating,

    /// `POST /roadmap/progress` in flight, and then done. Headshots is the
    /// roadmap's Level 1 Step 5, and closing it out is part of the page.
    @Default(false) bool finishing,
    @Default(false) bool finished,

    /// Amber, never red.
    String? error,

    /// 402 — the user needs more XP, not another attempt.
    @Default(false) bool insufficientXp,
  }) = _HeadshotSession;

  /// The server's gate, restated client-side so the button can say why it is
  /// off before the request is spent.
  bool get canGenerate => photos.length >= minHeadshotPhotos;

  bool get hasResults => results.isNotEmpty;
}
