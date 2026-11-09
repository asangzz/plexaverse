import '../../../core/plan/plan_refusal.dart';

/// The one exception every AI-tool call fails with.
///
/// The three screens in this slice (`/reimagine`, `/festive`, `/headshots`)
/// all talk to plan-gated endpoints, and all three of them have to tell the
/// same two stories apart:
///
///   • "that didn't work, try again"     → [message]
///   • "the plan said no" (no plan, or this feature's limit is used up)
///                                        → [refusal]
///
/// The web handles this three different ways across the same three pages.
/// One shape here, surfaced one way, is the deliberate correction.
///
/// The server's own message is what the user reads: it names the feature and,
/// for a limit, the period — more specific than anything this client could
/// reconstruct.
class AiToolFailure implements Exception {
  const AiToolFailure(this.message, {this.refusal, this.code});

  /// Safe to show the user. For a plan refusal this already includes when a
  /// limit comes back.
  final String message;

  /// Set when the server answered 402. The remedy is a plan or waiting for the
  /// limit to reset, not retrying, so the UI must not offer "Try again".
  final PlanRefusal? refusal;

  /// The envelope's stable `error.code`, for branching that outlives copy.
  final String? code;

  /// Refused by the plan rather than failed — no retry is offered.
  bool get refusedByPlan => refusal != null;

  @override
  String toString() => 'AiToolFailure($code): $message';
}
