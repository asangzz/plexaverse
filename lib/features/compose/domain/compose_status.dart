import 'package:freezed_annotation/freezed_annotation.dart';

part 'compose_status.freezed.dart';

/// What the composer is doing right now.
///
/// One enum rather than five booleans because the states are mutually
/// exclusive and the UI has to pick exactly one label for the progress strip.
/// The web tracks `isGenerating`, `isRegeneratingImage` and `isSaving`
/// separately and then has to reason about which combinations are possible.
enum ComposeBusy {
  idle,

  /// `POST /ai/generate` — the post body.
  writing,

  /// `POST /ai/poster` — the hero image. A separate step because the web's
  /// pipeline is two calls and the second one is allowed to fail on its own
  /// (see [ComposeStatus.error] and the poster note in the controller).
  designing,

  /// `POST /upload/image` — moving an inline poster into storage.
  uploading,

  /// `POST /posts`.
  saving,

  /// `POST /linkedin/company-post`.
  publishing,
}

/// How a finished submission ended, so the screen can say the right thing.
enum ComposeOutcome {
  /// `POST /posts` with `status: 'draft'`.
  draftSaved,

  /// `POST /posts` with `status: 'pending_approval'`, no schedule.
  submitted,

  /// `POST /posts` with `status: 'pending_approval'` and a `scheduledFor`.
  scheduled,

  /// `POST /linkedin/company-post` — live on the page now.
  published,
}

/// The composer's transient state: what is in flight, what failed, and what
/// just succeeded.
@freezed
abstract class ComposeStatus with _$ComposeStatus {
  const ComposeStatus._();

  const factory ComposeStatus({
    @Default(ComposeBusy.idle) ComposeBusy busy,

    /// The line under the spinner. The web's exact strings: "Generating post
    /// content...", "Designing your poster...".
    String? progress,

    /// A message to show the user. Rendered in amber, never red — Zave has no
    /// red, and a failed generation is "needs attention", not a destructive
    /// state.
    String? error,

    /// The server answered 402 INSUFFICIENT_XP. Distinct from [error] because
    /// the remedy is different: the user has to top up, not retry.
    @Default(false) bool insufficientXp,

    /// Set once a submission lands, and cleared the moment the user edits
    /// again.
    ComposeOutcome? outcome,

    /// What the in-flight submission is TRYING to be.
    ///
    /// Three buttons share one save path, so without this they would all spin
    /// together — a user who tapped "Save as draft" would watch "Submit for
    /// approval" appear to be working. The spinner belongs on the button that
    /// was pressed.
    ComposeOutcome? intent,

    /// The id `POST /posts` returned. Carried so a company publish can tell
    /// LinkedIn which row to stamp `published` on.
    String? savedPostId,

    /// The live LinkedIn URL, after a company publish.
    String? publishedUrl,
  }) = _ComposeStatus;

  bool get isBusy => busy != ComposeBusy.idle;

  /// True while an AI call is in flight — the two steps the modal reports on.
  bool get isGenerating =>
      busy == ComposeBusy.writing || busy == ComposeBusy.designing;

  /// True while a submission is in flight.
  bool get isSubmitting =>
      busy == ComposeBusy.uploading ||
      busy == ComposeBusy.saving ||
      busy == ComposeBusy.publishing;
}
