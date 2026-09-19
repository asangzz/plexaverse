import 'package:freezed_annotation/freezed_annotation.dart';

part 'persona_entities.freezed.dart';
part 'persona_entities.g.dart';

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

/// One piece of real material Plexa can ground a post in.
///
/// The bank is what keeps generated posts from being invented. An item is
/// "used" once a post has spent it.
@freezed
abstract class SubstanceItem with _$SubstanceItem {
  const SubstanceItem._();

  const factory SubstanceItem({
    required String id,
    @Default('') String kind,
    @Default('') String text,
    @Default(<String>[]) List<String> entities,
    @Default(false) bool hasNumber,
    @Default('') String source,
    DateTime? happenedAt,
    DateTime? usedAt,
    String? usedInPostId,
  }) = _SubstanceItem;

  factory SubstanceItem.fromJson(Map<String, dynamic> json) =>
      _$SubstanceItemFromJson(json);

  bool get isUsed => usedAt != null;
}

/// The Substance Bank, split by whether each item has been spent.
@freezed
abstract class SubstanceBank with _$SubstanceBank {
  const SubstanceBank._();

  const factory SubstanceBank({
    @Default(<SubstanceItem>[]) List<SubstanceItem> available,
    @Default(<SubstanceItem>[]) List<SubstanceItem> used,
    @Default(0) int availableCount,
    @Default(0) int usedCount,

    /// The bank could not be READ — a DB blip, not an empty bank.
    ///
    /// Distinct from empty **on purpose**, and the distinction is the product
    /// promise: an empty bank tells the user "Plexa won't invent a story to
    /// fill the gap", which is true and actionable. Showing that when the read
    /// simply failed is a lie, and it pushes the user to re-enter material
    /// they already gave us.
    @Default(false) bool unavailable,
  }) = _SubstanceBank;

  factory SubstanceBank.fromJson(Map<String, dynamic> json) =>
      _$SubstanceBankFromJson(json);

  bool get isEmpty => !unavailable && availableCount == 0 && usedCount == 0;
}

/// Everything the persona screen can read.
@freezed
abstract class PersonaSnapshot with _$PersonaSnapshot {
  const PersonaSnapshot._();

  const factory PersonaSnapshot({
    required PersonaIdentity identity,
    @Default(PersonaAudience()) PersonaAudience audience,
    @Default(SubstanceBank()) SubstanceBank bank,

    /// How many writing samples the style memory holds. Drives the Voice row's
    /// "Learned from N samples".
    @Default(0) int voiceSampleCount,
  }) = _PersonaSnapshot;
}

/// One turn of the Plexa conversation.
@freezed
abstract class PersonaReply with _$PersonaReply {
  const PersonaReply._();

  const factory PersonaReply({
    @Default('') String reply,

    /// Suggested edits to the persona. **Never applied by the chat turn** —
    /// the user accepts them explicitly, which is why `apply` is its own call.
    /// A conversation must not silently rewrite who the user says they are.
    @Default(<PersonaProposal>[]) List<PersonaProposal> proposals,
  }) = _PersonaReply;

  factory PersonaReply.fromJson(Map<String, dynamic> json) =>
      _$PersonaReplyFromJson(json);
}

/// A single proposed field change.
@freezed
abstract class PersonaProposal with _$PersonaProposal {
  const PersonaProposal._();

  const factory PersonaProposal({
    required String field,
    @Default('') String to,
    String? from,
    String? label,
  }) = _PersonaProposal;

  factory PersonaProposal.fromJson(Map<String, dynamic> json) =>
      _$PersonaProposalFromJson(json);
}
