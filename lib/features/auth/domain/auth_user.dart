import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// The signed-in user as returned inside the auth payload's `user` object
/// (login / register / LinkedIn exchange → profile). Mirrors the Plexaverse
/// mobile API `User` schema. The backend sends the avatar under the JSON key
/// `image`, aliased here to [avatarUrl]; `role` and `xpBalance` default so a
/// lean payload still deserialises.
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
    @Default(0) int xpBalance,
    String? createdAt,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}
