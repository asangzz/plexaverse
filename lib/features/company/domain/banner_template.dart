import 'package:freezed_annotation/freezed_annotation.dart';

import '../../studio/domain/studio_design.dart';

export '../../studio/domain/studio_design.dart'
    show StudioCanvas, StudioDesignData, StudioElement;

part 'banner_template.freezed.dart';
part 'banner_template.g.dart';

/// One banner template, from `GET /studio/templates?category=banner`.
///
/// ## Why this is not `StudioTemplate`
///
/// `features/aitools` already models a template row — and deliberately has no
/// `data` field, because the Reimagine gallery renders thumbnails and the
/// listing endpoint omits the design blob by default. The banner screen does
/// the opposite: it passes `includeData=true` and RENDERS the design, because
/// it has to substitute the user's name into it before it is worth looking at.
///
/// So this is the with-data variant of the same row. The design itself is
/// **the studio slice's** [StudioDesignData] — re-exported above rather than
/// re-declared, so there is one Studio element model in the app and one
/// renderer (`DesignCanvas`) that understands it.
@freezed
abstract class BannerTemplate with _$BannerTemplate {
  const BannerTemplate._();

  const factory BannerTemplate({
    required String id,
    @Default('') String name,
    String? description,
    String? thumbnail,

    /// The authored size, as the row records it. The design's own canvas wins
    /// when there is one — these are only the fallback for a row whose blob
    /// did not come back.
    @Default(1584) int width,
    @Default(396) int height,
    StudioDesignData? data,
  }) = _BannerTemplate;

  factory BannerTemplate.fromJson(Map<String, dynamic> json) =>
      _$BannerTemplateFromJson(json);

  /// Only a template that carries a design can be rendered or applied.
  bool get isRenderable => data != null && data!.elements.isNotEmpty;
}
