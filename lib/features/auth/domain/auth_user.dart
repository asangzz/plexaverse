import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// The signed-in user as returned inside the auth payload's `user` object
/// (login / register / LinkedIn exchange → profile). Mirrors the Plexaverse
/// mobile API `User` schema. The backend sends the avatar under the JSON key
/// `image`, aliased here to [avatarUrl]; `role` defaults so a lean payload
/// still deserialises.
///
/// There is no `xpBalance`. Wallet XP was retired on 10 Nov 2026 — the plan
/// pays for AI features — and the column is dead server-side. An older server
/// or fixture that still sends the key is harmless: json_serializable drops
/// keys it does not model.
///
/// This is the domain-facing successor to the old layer-first `UserEntity`
/// (lib/domain/entities/user_entity.dart), which the cleanup phase retires.
@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String name,
    required String email,
    @JsonKey(name: 'image') String? avatarUrl,
    @Default('user') String role,
    String? createdAt,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}
