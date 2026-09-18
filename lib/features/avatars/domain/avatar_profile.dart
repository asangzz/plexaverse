import 'package:freezed_annotation/freezed_annotation.dart';

part 'avatar_profile.freezed.dart';
part 'avatar_profile.g.dart';

/// The avatar identity shown on the Avatars tab (screenshot 2369): the
/// header pill (circle photo + "Ruchika" + "21 looks") and the floating
/// voice bar at the bottom ("Ruchika" + voice name + Edit voice).
///
/// `lookCount` is the server-side total (the grid may page), and
/// `voiceName` is the display name of the voice bound to this avatar.
/// Keys are camelCase per the project json_serializable convention
/// (`field_rename: none`), so the fixture keys are the Dart field names.
@freezed
abstract class AvatarProfile with _$AvatarProfile {
  const factory AvatarProfile({
    required String name,
    required int lookCount,
    required String voiceName,

    /// Circle profile photo in the header pill (fixtures use picsum seeds).
    required String avatarUrl,
  }) = _AvatarProfile;

  const AvatarProfile._();

  factory AvatarProfile.fromJson(Map<String, dynamic> json) =>
      _$AvatarProfileFromJson(json);

  /// The header pill's grey caption — "21 looks".
  String get looksLabel => '$lookCount looks';
}
