import 'package:freezed_annotation/freezed_annotation.dart';

part 'avatar_look.freezed.dart';
part 'avatar_look.g.dart';

/// One portrait card in the Avatars grid (screenshot 2369): a full-bleed
/// look photo with a kebab menu in a dark circle at the top-right. The
/// leading "Add look" gradient card is presentation-only and not part of
/// the data.
///
/// Keys are camelCase per the project json_serializable convention
/// (`field_rename: none`), so the fixture keys are the Dart field names.
@freezed
abstract class AvatarLook with _$AvatarLook {
  const factory AvatarLook({
    required String id,

    /// Portrait look photo (fixtures use picsum 300×400 seeds).
    required String thumbnailUrl,
  }) = _AvatarLook;

  factory AvatarLook.fromJson(Map<String, dynamic> json) =>
      _$AvatarLookFromJson(json);
}
