import 'package:freezed_annotation/freezed_annotation.dart';

part 'compose_models.freezed.dart';
part 'compose_models.g.dart';

/// The wire models the composer exchanges with the mobile API.
///
/// Each one is a transcription of a `lib/services/*.ts` return type in the web
/// repo, named here after the service that produces it rather than after the
/// screen that consumes it — the same payload feeds the planner's regenerate
/// path and would feed a future studio surface, and a model called
/// `ComposeResponse` would have to be renamed the first time that happened.

/// `GeneratedPost` from `lib/services/ai.service.ts`, returned by
/// `POST /ai/generate`.
///
/// [category] is the visual flavour hint ('technical', 'reflective', …) that
/// the poster step takes as an input — it is NOT shown to the user anywhere.
/// [posterTitle] is the 3–7 word headline; the web composer copies it into the
/// post title when the user has not typed one, and we do the same.
@freezed
abstract class GeneratedPost with _$GeneratedPost {
  const factory GeneratedPost({
    @Default('') String content,
    @Default('') String category,
    String? posterTitle,
    @Default('') String model,
    @Default('') String provider,
  }) = _GeneratedPost;

  factory GeneratedPost.fromJson(Map<String, dynamic> json) =>
      _$GeneratedPostFromJson(json);
}

/// One row of `GET /poster-tags` — a poster style, and how many live reference
/// images the admin library holds for it.
///
/// [live] is the whole reason this model carries two fields instead of being a
/// list of strings. The server composites a poster against the reference images
/// filed under the chosen tag; a tag with none behaves exactly like no tag, so
/// the count is the only thing that separates a style that works from one that
/// silently does nothing.
@freezed
abstract class PosterTagOption with _$PosterTagOption {
  const PosterTagOption._();

  const factory PosterTagOption({
    @Default('') String tag,
    @Default(0) int live,
  }) = _PosterTagOption;

  factory PosterTagOption.fromJson(Map<String, dynamic> json) =>
      _$PosterTagOptionFromJson(json);

  /// 'data-story' → 'Data Story'. The web gets this from `tag.replace('-', ' ')`
  /// plus a `capitalize` class; with no stylesheet to lean on the chip has to
  /// do both halves itself.
  String get label => tag
      .split('-')
      .where((String word) => word.isNotEmpty)
      .map((String word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');

  /// False for a tag the library has no references for — pickable in principle,
  /// indistinguishable from "no style" in practice.
  bool get usable => live > 0;
}

/// `GeneratedPoster` from `lib/services/ai-poster.service.ts`, returned by
/// `POST /ai/poster`.
///
/// [imageUrl] is a `data:image/jpeg;base64,…` URI, not a link. The server hands
/// the composited poster back inline so the client can show it without a second
/// round-trip; it only becomes a storage URL if the user actually saves the
/// post (see `POST /upload/image`).
@freezed
abstract class GeneratedPoster with _$GeneratedPoster {
  const factory GeneratedPoster({
    @Default('') String imageUrl,
    @Default('') String posterTitle,
    @Default('') String model,
    @Default('') String provider,
  }) = _GeneratedPoster;

  factory GeneratedPoster.fromJson(Map<String, dynamic> json) =>
      _$GeneratedPosterFromJson(json);
}

/// `UploadImageResult` from `lib/services/uploads.service.ts`, returned by
/// `POST /upload/image`.
///
/// [thumbUrl] is null when the thumbnail leg of the upload failed. That is not
/// an error: the full image is canonical and the thumb is an optimisation the
/// server never fails the whole upload over.
@freezed
abstract class UploadedImage with _$UploadedImage {
  const factory UploadedImage({@Default('') String url, String? thumbUrl}) =
      _UploadedImage;

  factory UploadedImage.fromJson(Map<String, dynamic> json) =>
      _$UploadedImageFromJson(json);
}

/// The subset of `ListedPost` the composer reads back after `POST /posts`.
///
/// The server returns the whole row; we model the four fields the composer
/// acts on. json_serializable ignores the rest, so the server can grow columns
/// without breaking this screen.
///
/// [imageUrl] matters for one reason: the company publish path needs the URL
/// the poster ended up at, and LinkedIn cannot fetch the inline data URI the
/// generator produced. Reading it back off the created row is what keeps that
/// leg from uploading the same image a second time.
@freezed
abstract class CreatedPost with _$CreatedPost {
  const factory CreatedPost({
    @Default('') String id,
    @Default('draft') String status,
    String? scheduledFor,
    String? imageUrl,
  }) = _CreatedPost;

  factory CreatedPost.fromJson(Map<String, dynamic> json) =>
      _$CreatedPostFromJson(json);
}

/// `PublishCompanyPostResult` from `lib/services/linkedin-publish.service.ts`,
/// returned by `POST /linkedin/company-post`.
@freezed
abstract class CompanyPublishResult with _$CompanyPublishResult {
  const factory CompanyPublishResult({
    @Default(false) bool success,
    @Default('') String postUrn,
    @Default('') String postUrl,
  }) = _CompanyPublishResult;

  factory CompanyPublishResult.fromJson(Map<String, dynamic> json) =>
      _$CompanyPublishResultFromJson(json);
}
