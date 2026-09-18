import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/compose_repositories.dart';
import '../domain/compose_context.dart';
import '../domain/compose_draft.dart';
import '../domain/compose_models.dart';
import '../domain/compose_repository.dart';
import '../domain/compose_status.dart';
import '../domain/linkedin_account.dart';

part 'compose_controller.g.dart';

/// Who the user is publishing as — preferences plus connected accounts.
///
/// Separate from the draft on purpose. This half is server state that can be
/// refetched and can fail; the draft is the user's work and must survive both.
/// Folding them into one provider would mean a failed accounts fetch threw away
/// a post someone had just written.
@riverpod
class ComposeContextController extends _$ComposeContextController {
  @override
  Future<ComposeContextState> build() =>
      ref.watch(composeRepositoryProvider).fetchContext();
}

/// The post being written.
///
/// A plain synchronous notifier — nothing here touches the network. Keeping it
/// that way is what lets the AI generation, the schedule panel and the preview
/// all read one source of truth without any of them awaiting.
@riverpod
class ComposeDraftController extends _$ComposeDraftController {
  @override
  ComposeDraft build() => const ComposeDraft();

  void setTitle(String value) => state = state.copyWith(title: value);

  void setContent(String value) => state = state.copyWith(content: value);

  void setAccount(String? accountId) =>
      state = state.copyWith(accountId: accountId);

  /// Turns "Schedule for later" on or off.
  ///
  /// Switching it on with no date chosen seeds today, because the web's date
  /// strip always has a selection and a schedule panel with nothing selected
  /// reads as broken rather than as "pick one".
  void setScheduled(bool value) {
    if (!value) {
      state = state.copyWith(scheduled: false);
      return;
    }
    final DateTime now = DateTime.now();
    state = state.copyWith(
      scheduled: true,
      date: state.date ?? DateTime(now.year, now.month, now.day),
    );
  }

  void setDate(DateTime day) =>
      state = state.copyWith(date: DateTime(day.year, day.month, day.day));

  /// [value] is 'HH:mm', 24-hour.
  void setTime(String value) => state = state.copyWith(time: value);

  /// Attaches a freshly generated poster, and records the brief it came from
  /// so Regenerate can reproduce it.
  void setGeneratedImage(ComposeImage image, {PosterPrompt? prompt}) {
    state = state.copyWith(
      image: image,
      lastPosterPrompt: prompt ?? state.lastPosterPrompt,
    );
  }

  /// Records the brief without an image — the case where the body was written
  /// but the poster step failed. Keeping it is what makes Regenerate a
  /// one-tap retry instead of a second trip through the AI sheet.
  void setPosterPrompt(PosterPrompt prompt) =>
      state = state.copyWith(lastPosterPrompt: prompt);

  void removeImage() => state = state.copyWith(image: null);

  /// Clears everything. Used after a successful submission, so the next post
  /// does not start with the last one's body still in the field.
  void reset() => state = const ComposeDraft();
}

/// Everything the composer does that can fail or take time.
///
/// The state it exposes is [ComposeStatus] — what is in flight, what failed,
/// and what just landed. The draft it operates on lives in
/// [ComposeDraftController]; this notifier reads and writes it through that
/// notifier's own methods rather than owning a second copy, because two copies
/// of a post body is exactly how a user loses one.
@riverpod
class ComposeActions extends _$ComposeActions {
  @override
  ComposeStatus build() => const ComposeStatus();

  ComposeRepository get _repo => ref.read(composeRepositoryProvider);

  ComposeDraft get _draft => ref.read(composeDraftControllerProvider);

  ComposeDraftController get _drafts =>
      ref.read(composeDraftControllerProvider.notifier);

  ComposeContextState? get _context =>
      ref.read(composeContextControllerProvider).value;

  /// Clears the last error / success banner. Called as soon as the user types,
  /// so a stale "Saved as draft" never sits above a post they are still
  /// writing.
  void clearFeedback() {
    if (state.error == null && state.outcome == null && !state.insufficientXp) {
      return;
    }
    state = const ComposeStatus();
  }

  /// "Write it" — the web's two-step generation pipeline.
  ///
  /// Step one writes the body; step two composites the poster. **The poster
  /// step is allowed to fail on its own.** The web is explicit about this
  /// ("Poster is the secondary step — text already succeeded, so surface the
  /// failure but don't abort the rest of the flow"), and it is the right trade:
  /// losing a finished post because its illustration failed would be a far
  /// worse outcome than a post with no image.
  Future<void> generate({
    required String topic,
    required ComposeTone tone,
    required ComposeLength length,
  }) async {
    if (state.isBusy) return;
    final String trimmed = topic.trim();
    if (trimmed.isEmpty) return;

    state = const ComposeStatus(
      busy: ComposeBusy.writing,
      progress: 'Generating post content...',
    );

    final GeneratedPost written;
    try {
      written = await _repo.generatePost(
        topic: trimmed,
        tone: tone,
        length: length,
      );
    } on ComposeFailure catch (e) {
      state = ComposeStatus(
        error: e.insufficientXp ? null : e.message,
        insufficientXp: e.insufficientXp,
      );
      return;
    }

    _drafts.setContent(written.content);
    // The headline is a sensible default the user can edit — never an
    // overwrite. Someone who already titled their post meant it.
    final String? headline = written.posterTitle;
    if (_draft.title.trim().isEmpty &&
        headline != null &&
        headline.trim().isNotEmpty) {
      _drafts.setTitle(headline);
    }

    final ComposeContextState? context = _context;
    final LinkedinAccount? account = context?.activeAccount(_draft.accountId);
    final PosterPrompt prompt = PosterPrompt(
      topic: trimmed,
      content: written.content,
      posterTitle: headline,
      userName: context != null && context.isCompanyBrand
          ? context.companyPageLabel
          : account?.profileName,
      profileImageUrl: account?.profileImage,
      category: written.category.isEmpty ? null : written.category,
    );

    state = const ComposeStatus(
      busy: ComposeBusy.designing,
      progress: 'Designing your poster...',
    );

    try {
      final GeneratedPoster poster = await _repo.generatePoster(prompt);
      _drafts.setGeneratedImage(
        ComposeImage(dataUri: poster.imageUrl),
        prompt: prompt,
      );
      state = const ComposeStatus();
    } on ComposeFailure catch (e) {
      // Text survived. Keep it, keep the brief so Regenerate can retry, and
      // say what happened.
      _drafts.setPosterPrompt(prompt);
      state = ComposeStatus(
        error: e.insufficientXp
            ? null
            : 'Your post is written, but the poster failed. ${e.message}',
        insufficientXp: e.insufficientXp,
      );
    }
  }

  /// Regenerates the poster from the brief the last one used.
  ///
  /// Reusing the stored [PosterPrompt] verbatim is what keeps the second
  /// poster in the same family as the first — the headline, the author name
  /// and the visual category are all reapplied rather than re-derived.
  Future<void> regeneratePoster() async {
    final PosterPrompt? prompt = _draft.lastPosterPrompt;
    if (prompt == null || state.isBusy) return;

    state = const ComposeStatus(
      busy: ComposeBusy.designing,
      progress: 'Designing your poster...',
    );
    try {
      final GeneratedPoster poster = await _repo.generatePoster(prompt);
      _drafts.setGeneratedImage(ComposeImage(dataUri: poster.imageUrl));
      state = const ComposeStatus();
    } on ComposeFailure catch (e) {
      state = ComposeStatus(
        error: e.insufficientXp ? null : e.message,
        insufficientXp: e.insufficientXp,
      );
    }
  }

  /// "Save as Draft" — never needs a LinkedIn connection.
  Future<void> saveDraft() => _submit(
    wireStatus: 'draft',
    outcome: ComposeOutcome.draftSaved,
    requiresConnection: false,
  );

  /// "Submit for Approval" / "Schedule Post".
  ///
  /// One action, two labels, exactly as on the web: the presence of a schedule
  /// decides the wording, not the wire status. Both go out as
  /// `pending_approval` and the server's Slack flow takes it from there.
  Future<void> submitForApproval() => _submit(
    wireStatus: 'pending_approval',
    outcome: _draft.scheduledFor != null
        ? ComposeOutcome.scheduled
        : ComposeOutcome.submitted,
    requiresConnection: true,
  );

  /// Company mode only — save the row, then push it to the page now.
  ///
  /// This is a mobile addition, not a web behaviour: on the web a company post
  /// goes through the same approval queue as a personal one. It exists here
  /// because `POST /linkedin/company-post` is the only route the mobile API
  /// gives a company user to actually reach LinkedIn, and a phone-only user
  /// would otherwise be able to write company posts and never publish one.
  ///
  /// The post is created first and its id handed to the publish call, so the
  /// server flips that row to `published` — without it we would leave a
  /// permanent draft sitting next to a live LinkedIn post.
  Future<void> publishToCompanyPage() async {
    final ComposeContextState? context = _context;
    final String? orgId = context?.companyPageId;
    if (context == null || orgId == null || orgId.isEmpty) {
      state = const ComposeStatus(
        error: 'Connect a Company LinkedIn Page in Settings first.',
      );
      return;
    }
    if (context.companyAccount == null) {
      state = const ComposeStatus(
        error:
            'Connect a Company LinkedIn account in Settings to publish company '
            'posts.',
      );
      return;
    }

    final String body = _draft.content.trim();
    // `outcome` doubles as the intent while this leg is in flight, so the
    // spinner sits on "Publish now" rather than on "Save as draft" — which is
    // the button that is technically running, and the wrong one to point at.
    final CreatedPost? created = await _submit(
      wireStatus: 'draft',
      outcome: ComposeOutcome.published,
      requiresConnection: true,
      resetOnSuccess: false,
    );
    if (created == null) return;

    state = const ComposeStatus(
      busy: ComposeBusy.publishing,
      intent: ComposeOutcome.published,
    );
    try {
      final CompanyPublishResult result = await _repo.publishCompanyPost(
        content: body,
        organizationId: orgId,
        // The stored URL, not the inline data URI — _submit has already moved
        // the poster into storage, and LinkedIn cannot fetch a data URI.
        imageUrl: created.imageUrl,
        postId: created.id,
      );
      _drafts.reset();
      state = ComposeStatus(
        outcome: ComposeOutcome.published,
        savedPostId: created.id,
        publishedUrl: result.postUrl.isEmpty ? null : result.postUrl,
      );
    } on ComposeFailure catch (e) {
      // The row exists and is a draft. Say so, rather than implying nothing
      // happened — a user who retried blind would create a second draft.
      state = ComposeStatus(
        error:
            'Saved as a draft, but LinkedIn rejected the publish. ${e.message}',
        savedPostId: created.id,
        insufficientXp: e.insufficientXp,
      );
    }
  }

  /// The shared save path. Returns the created row, or null when it did not
  /// get that far.
  Future<CreatedPost?> _submit({
    required String wireStatus,
    required ComposeOutcome outcome,
    required bool requiresConnection,
    bool resetOnSuccess = true,
  }) async {
    if (state.isBusy) return null;

    final ComposeDraft draft = _draft;
    if (!draft.canSubmit) return null;

    final ComposeContextState? context = _context;
    if (requiresConnection) {
      if (context == null) {
        state = const ComposeStatus(
          error: 'Still checking your LinkedIn connection. Try again.',
        );
        return null;
      }
      if (!context.canPublish) {
        state = ComposeStatus(
          error: context.isCompanyBrand
              ? 'Connect a Company LinkedIn account in Settings to publish '
                    'company posts.'
              : 'Connect LinkedIn to submit for approval.',
        );
        return null;
      }
    }

    // An inline AI poster has to reach storage before the post is saved, or the
    // row carries a multi-megabyte data URI that every list view then has to
    // download.
    String? imageUrl;
    String? imageThumbUrl;
    final ComposeImage? image = draft.image;
    if (image != null && image.hasPreview) {
      if (image.needsUpload) {
        state = ComposeStatus(busy: ComposeBusy.uploading, intent: outcome);
        try {
          final UploadedImage uploaded = await _repo.uploadBase64Image(
            image.dataUri!,
          );
          imageUrl = uploaded.url;
          imageThumbUrl = uploaded.thumbUrl;
        } on ComposeFailure catch (e) {
          state = ComposeStatus(
            error: 'Could not upload the image. ${e.message}',
            insufficientXp: e.insufficientXp,
          );
          return null;
        }
      } else {
        // Already in storage. Saved as-is; there is no thumbnail for it.
        imageUrl = image.url;
      }
    }

    state = ComposeStatus(busy: ComposeBusy.saving, intent: outcome);
    try {
      final CreatedPost created = await _repo.createPost(
        content: draft.content.trim(),
        status: wireStatus,
        title: draft.title.trim().isEmpty ? null : draft.title.trim(),
        imageUrl: imageUrl,
        imageThumbUrl: imageThumbUrl,
        accountId: context?.activeAccount(draft.accountId)?.id,
        scheduledFor: draft.scheduledFor,
      );
      if (resetOnSuccess) {
        _drafts.reset();
        state = ComposeStatus(outcome: outcome, savedPostId: created.id);
      }
      // The server echoes the stored image URL back; the company publish leg
      // needs it and must not re-upload.
      return created.imageUrl == null && imageUrl != null
          ? created.copyWith(imageUrl: imageUrl)
          : created;
    } on ComposeFailure catch (e) {
      state = ComposeStatus(error: e.message, insufficientXp: e.insufficientXp);
      return null;
    }
  }
}
