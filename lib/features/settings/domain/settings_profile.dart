import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_profile.freezed.dart';
part 'settings_profile.g.dart';

/// The signed-in user's profile display bits, shown at the top of the
/// Settings screen (avatar + name + handle + member-since).
///
/// Settings is a **local-only** feature — theme mode and locale persist to
/// `SharedPreferences` and never touch the network. The profile header,
/// however, is display data sourced from the mock fixture
/// (`assets/mock/settings/profile.json`) so the screen has something to
/// render; a later release can swap this to the auth/profile API without
/// changing the UI. Parsed through the real [fromJson] so the fixture and any
/// future wire payload share one model (feature-slice convention).
@freezed
abstract class SettingsProfile with _$SettingsProfile {
  const SettingsProfile._();

  const factory SettingsProfile({
    required String id,
    required String displayName,
    required String handle,
    required String email,
    // Absent (not null) in the wire/fixture JSON when no avatar is set —
    // matches the "omitted = initials avatar" convention.
    @JsonKey(includeIfNull: false) String? avatarUrl,
    // ISO-8601 date the account was created; drives the "Member since" line.
    @JsonKey(includeIfNull: false) DateTime? memberSince,
  }) = _SettingsProfile;

  factory SettingsProfile.fromJson(Map<String, dynamic> json) =>
      _$SettingsProfileFromJson(json);

  /// "AB" — first letters of up to two name parts, for the initials avatar
  /// fallback when [avatarUrl] is null.
  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first.substring(0, 1).toUpperCase();
    if (parts.length == 1) return first;
    final last = parts.last.substring(0, 1).toUpperCase();
    return '$first$last';
  }

  /// "@handle" — the handle prefixed with an at-sign for display.
  String get handleDisplay => handle.startsWith('@') ? handle : '@$handle';
}
