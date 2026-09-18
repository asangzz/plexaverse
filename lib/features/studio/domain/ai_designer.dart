import 'package:freezed_annotation/freezed_annotation.dart';

import 'studio_design.dart';

part 'ai_designer.freezed.dart';
part 'ai_designer.g.dart';

/// One turn's author. The wire uses the plain lowercase names.
enum AiDesignerRole {
  user,
  assistant;

  String get wire => name;
}

/// What `POST /studio/ai-designer` sends back.
///
/// The design is a whole [StudioDesignData], not a patch: the model rewrites
/// the poster each turn and the client decides whether to adopt it. That is
/// why applying a reply is an explicit tap ("Use this design") rather than
/// something that happens on arrival — the web has the same Apply button, and
/// silently overwriting the user's edits with a suggestion would be the worst
/// possible reading of "conversational".
@freezed
abstract class AiDesignerReply with _$AiDesignerReply {
  const factory AiDesignerReply({
    @Default('') String message,
    StudioDesignData? design,
    @Default('') String model,

    /// How many images the route actually generated. Non-zero means XP was
    /// charged per image on top of the base cost, which the server states in
    /// [message] when it had to strip them for affordability.
    @Default(0) int imagesGenerated,
  }) = _AiDesignerReply;

  factory AiDesignerReply.fromJson(Map<String, dynamic> json) =>
      _$AiDesignerReplyFromJson(json);
}

/// One line of the AI Designer conversation, as the screen holds it.
///
/// Deliberately not the wire type. A turn can be [pending] (the request is in
/// flight) or [failed] (it came back as an error), and neither of those is
/// something the server ever sends — they are states of the client's own
/// optimistic bubble. The web models this the same way, with `pending` and
/// `error` flags on its local message array.
@freezed
abstract class AiDesignerTurn with _$AiDesignerTurn {
  const AiDesignerTurn._();

  const factory AiDesignerTurn({
    required String id,
    required AiDesignerRole role,
    @Default('') String content,

    /// The design this assistant turn produced, if any.
    StudioDesignData? design,
    @Default(false) bool pending,

    /// Rendered in amber, not red — Zave has no red, and a failed turn is
    /// "this needs your attention", not a destructive state.
    @Default(false) bool failed,
  }) = _AiDesignerTurn;

  bool get isUser => role == AiDesignerRole.user;
}
