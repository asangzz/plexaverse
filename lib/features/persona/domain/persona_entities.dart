import 'package:freezed_annotation/freezed_annotation.dart';

part 'persona_entities.freezed.dart';

/// Who Plexa thinks you are — the read-only "Who you are" block of the web's
/// `/persona`.
///
/// **There is no `fromJson` here on purpose.** The web has a `getPersona()`
/// service and a `queryKeys.persona.detail` payload; the mobile API has no
/// `/persona` route at all. So this is COMPOSED on the client from two reads
/// that do exist — `GET /user/preferences` and `GET /auth/me` — and a wire
/// deserialiser would imply an endpoint that nobody can call.
///
/// What that composition can and cannot reach is the whole story of this
/// screen: every identity field below is a real preferences column, while the
/// material bank, the reach numbers, the voice-sample count and the chat are
/// server-side concepts with no mobile route. Those render as explicit
/// unavailable states rather than as empty ones — see [PersonaPage].
@freezed
abstract class PersonaIdentity with _$PersonaIdentity {
  const PersonaIdentity._();

  const factory PersonaIdentity({
    /// From `/auth/me`; every other field is a preferences column.
    @Default('') String name,
    String? profession,
    String? headline,
    String? industry,
    @Default(<String>[]) List<String> skills,

    /// `postCategories` on the wire — what the week's topics are drawn from.
    @Default(<String>[]) List<String> topics,

    /// The role the user is moving toward. Rendered "(transitioning)" when
    /// [contentMode] is `transformation`, because in that mode the posts argue
    /// FROM the target role rather than the current one.
    String? targetRole,
    @Default('authority') String contentMode,
    @Default(false) bool isCompany,
    String? companyName,
    String? companyIndustry,
    String? companyDescription,
    @Default(<String>[]) List<String> companyFeatures,
  }) = _PersonaIdentity;

  /// The suffix the web appends to "Working toward".
  String? get workingToward {
    final String? role = targetRole;
    if (role == null || role.isEmpty) return null;
    return contentMode == 'transformation' ? '$role (transitioning)' : role;
  }
}

/// Who the user writes FOR.
///
/// The most load-bearing field on the persona screen and the one nobody fills
/// in unprompted. The web's own copy names the cost of leaving it unset: posts
/// get written for people in the user's own job, "who enjoy them and cannot
/// hire you."
///
/// It maps to three preferences columns — `serveRole`, `serveIndustry`,
/// `problemSolved` — all of which the mobile preferences PATCH accepts.
@freezed
abstract class PersonaAudience with _$PersonaAudience {
  const PersonaAudience._();

  const factory PersonaAudience({
    String? role,
    String? industry,
    String? problem,
  }) = _PersonaAudience;

  /// The web treats the audience as "set" once it has somebody to write to.
  /// The problem sentence sharpens it but is not what makes it usable.
  bool get isSet =>
      (role != null && role!.trim().isNotEmpty) &&
      (industry != null && industry!.trim().isNotEmpty);

  /// `Role · Industry`, the heading the web renders for a set audience.
  String get headline => <String>[
    if (role != null && role!.trim().isNotEmpty) role!.trim(),
    if (industry != null && industry!.trim().isNotEmpty) industry!.trim(),
  ].join(' · ');
}

/// Everything the persona screen can actually read.
@freezed
abstract class PersonaSnapshot with _$PersonaSnapshot {
  const PersonaSnapshot._();

  const factory PersonaSnapshot({
    required PersonaIdentity identity,
    @Default(PersonaAudience()) PersonaAudience audience,
  }) = _PersonaSnapshot;
}
