import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/placement_repositories.dart';
import '../domain/placement_repository.dart';
import '../domain/placement_words.dart';

part 'placement_controllers.g.dart';

/// The learner's band, the last result, an open attempt, and whether Start
/// works — `GET /placement`.
///
/// Read by the placement page and by `PlacementLevelHint` on the contest's
/// join card. Not a pure read: an attempt past its closing time is settled on
/// the server by this very request, which can move the band with no write
/// from here to say so — so every read reports its band to
/// [PlacementBandChanges].
@riverpod
Future<PlacementStatus> placementStatus(Ref ref) async {
  final PlacementStatus status = await ref
      .watch(placementRepositoryProvider)
      .fetchStatus();
  if (ref.mounted) {
    ref.read(placementBandChangesProvider.notifier).observe(status.band);
  }
  return status;
}

/// Counts the moments the learner's band may have moved.
///
/// The band is shown outside this slice — the contest overview carries it on
/// the entry, the board beside every row — and each of those reads goes stale
/// the moment it moves. This slice does not import the contest's providers;
/// they watch this count instead, so a bump re-reads them wherever they are
/// (`noticeBandMove` and `invalidateBand` on the web).
///
/// It moves on a write that can set the band (the last answer, writing,
/// finish, a start that replaced the offered attempt) and on a status read
/// that finds a different band from the last one — a test closed on a
/// walk-away sets its band on a READ, and no write is there to say so.
@Riverpod(keepAlive: true)
class PlacementBandChanges extends _$PlacementBandChanges {
  /// The band the last status read reported. Not state: a read that finds
  /// the same band must not wake anything.
  CefrBand? _seen;

  @override
  int build() => 0;

  /// A status read. The first one has nothing to compare with and says
  /// nothing.
  void observe(CefrBand band) {
    final CefrBand? before = _seen;
    _seen = band;
    if (before != null && before != band) state++;
  }

  /// A write that may have set the band. The next status read starts the
  /// comparison afresh, so the same move is not counted twice.
  void moved() {
    _seen = null;
    state++;
  }
}

/// Which screen the placement page is showing. The only thing the page owns;
/// every step and result is the response to the move that produced it.
sealed class PlacementScreen {
  const PlacementScreen();
}

/// What the test is, the level it set, or where it was left — read off the
/// status.
final class PlacementIntroScreen extends PlacementScreen {
  const PlacementIntroScreen();
}

final class PlacementQuestionScreen extends PlacementScreen {
  const PlacementQuestionScreen(this.step);

  final PlacementStep step;
}

/// The optional writing for [attemptId], which is already complete — the band
/// was set before this screen showed.
final class PlacementWritingScreen extends PlacementScreen {
  const PlacementWritingScreen({required this.attemptId, required this.task});

  final String attemptId;
  final WritingTask task;
}

final class PlacementResultScreen extends PlacementScreen {
  const PlacementResultScreen(this.result);

  final PlacementResult result;
}

/// The four things the learner can press that reach the server.
enum PlacementMove { start, answer, grade, skip }

/// What is in flight. One at a time: every control on the page waits on it.
enum PlacementWork {
  starting,
  answering,

  /// Recording consent, then grading.
  grading,
  skipping,

  /// Writing was refused as already in; a status read is deciding which way.
  /// The draft stays in the box until it lands.
  checking,

  /// Back on the intro after the attempt moved on; the cached status still
  /// describes it as open, so nothing is drawn from it until this read lands.
  rereading,
}

/// A move that failed, in one sentence. The screen the move belongs to says
/// it under its own heading.
class PlacementProblem {
  const PlacementProblem(this.move, this.message);

  final PlacementMove move;
  final String message;
}

/// Everything on the placement page that is not the server's data.
///
/// Held here rather than on the widgets, as every busy and error flag in the
/// app is (`test/architecture/no_async_state_in_widgets_test.dart`).
class PlacementFlowState {
  const PlacementFlowState({
    this.screen = const PlacementIntroScreen(),
    this.work,
    this.problem,
    this.notice,
    this.agreed = false,
    this.consentRefused = false,
    this.newAttemptId,
  });

  final PlacementScreen screen;
  final PlacementWork? work;
  final PlacementProblem? problem;

  /// One neutral line on the intro (or the first question) saying why the
  /// screen changed under the learner. Never the learner's mistake.
  final String? notice;

  /// The writing consent was recorded on this page. The status's
  /// `writingConsent` was read before it and is not re-read for it, so
  /// without this a second press after a failed grade would record it again.
  final bool agreed;

  /// The server refused the writing as CONSENT_REQUIRED — withdrawn in
  /// Settings since the page loaded. The card asks again.
  final bool consentRefused;

  /// The attempt Continue landed on when the one the intro offered had
  /// closed in between. Its first question says so.
  final String? newAttemptId;

  bool get isBusy => work != null;

  /// Whether pressing Grade must record the consent first.
  bool needsAgreement(PlacementStatus? status) =>
      !((status?.writingConsent ?? false) || agreed) || consentRefused;

  PlacementFlowState copyWith({
    PlacementScreen? screen,
    PlacementWork? work,
    PlacementProblem? problem,
    String? notice,
    bool? agreed,
    bool? consentRefused,
    String? newAttemptId,
    bool clearWork = false,
    bool clearProblem = false,
    bool clearNotice = false,
    bool clearNewAttempt = false,
  }) => PlacementFlowState(
    screen: screen ?? this.screen,
    work: clearWork ? null : (work ?? this.work),
    problem: clearProblem ? null : (problem ?? this.problem),
    notice: clearNotice ? null : (notice ?? this.notice),
    agreed: agreed ?? this.agreed,
    consentRefused: consentRefused ?? this.consentRefused,
    newAttemptId: clearNewAttempt ? null : (newAttemptId ?? this.newAttemptId),
  );
}

/// A notice decided from the status read that follows a refusal. [fresh] is
/// null when that read failed — the intro then shows its own "could not load".
typedef _NoticeRule = String? Function(PlacementStatus? fresh);

/// The placement test: intro → questions → writing → result.
///
/// A port of the web's `PlacementClient.tsx`, whose header is the long
/// version of the rules below.
///
/// ## Nothing here learns whether an answer was right
///
/// An answer resolves to the next step. There is no verdict to hold, so none
/// is held, and the question screen draws nothing that could be read as one.
///
/// ## An open attempt can end under any move
///
/// It closes 24 hours after its last answer or 48 after its start, lazily, on
/// whichever request next reads it. So an answer can come back
/// ALREADY_COMPLETE (closed, or finished on the web) or NOT_FOUND (cleared,
/// nothing answered), Continue can come back COOLDOWN, and Skip NOT_READY.
/// Each of those sends the learner back to the intro — but only once a fresh
/// status has landed: the cached one still says the attempt is open, and an
/// intro drawn from it would offer a Continue the server would refuse. The
/// notice is decided by that read, not by the refusal: a refusal says the
/// attempt moved on, never how.
///
/// GRADING_UNAVAILABLE is not one of those. It is the provider's moment, not
/// the attempt's: nothing was stored, the writing step is still open, and the
/// draft stays in the box for another try.
///
/// Not keepAlive: leaving the page discards the screen, and nothing is lost —
/// every answer is saved before the next question shows, and Start resumes
/// the open attempt on the same question.
@riverpod
class PlacementFlow extends _$PlacementFlow {
  @override
  PlacementFlowState build() {
    // Kept alive while the flow is: every move that finds its attempt gone
    // re-reads the status, and that read has to outlive a frame with nobody
    // watching it.
    ref.listen(placementStatusProvider, (_, _) {});
    return const PlacementFlowState();
  }

  PlacementRepository get _repo => ref.read(placementRepositoryProvider);

  /// The page opened over a status read earlier — on the contest's join card,
  /// say. Coming back after finishing a test on the web should show the new
  /// band, not the cached one.
  void refreshIfCached() {
    if (ref.read(placementStatusProvider).hasValue) {
      ref.invalidate(placementStatusProvider);
    }
  }

  /// The intro's "Try again" after a status read failed.
  void reloadStatus() => ref.invalidate(placementStatusProvider);

  /// Start the test, or resume the open one — Continue is the same call.
  Future<void> start() async {
    if (state.isBusy) return;
    // Read before the press: the attempt the intro offered to continue, if it
    // offered one. A different attempt back means that one closed in between.
    final String? offered = ref
        .read(placementStatusProvider)
        .value
        ?.inProgress
        ?.attemptId;
    state = state.copyWith(
      work: PlacementWork.starting,
      clearProblem: true,
      clearNotice: true,
      clearNewAttempt: true,
    );
    try {
      final PlacementStep step = await _repo.start();
      if (!ref.mounted) return;
      final bool replaced = offered != null && step.attemptId != offered;
      if (step.stage == PlacementStage.writing || replaced) {
        // Whatever the offered attempt closed with, everything that shows
        // the band re-reads: guessing "it was cleared, nothing moved" is not
        // this controller's to make.
        _bandMayHaveMoved();
      } else {
        // There is an open attempt now; the intro should say Continue.
        ref.invalidate(placementStatusProvider);
      }
      state = state.copyWith(
        clearWork: true,
        screen: _screenOf(step),
        newAttemptId: replaced ? step.attemptId : null,
      );
    } on PlacementCooldown catch (e) {
      if (!ref.mounted) return;
      // With an attempt offered, this means it closed with answers in it and
      // the cooldown runs from the close: show the result it closed with.
      await _backToIntro(
        offered == null
            ? null
            : (PlacementStatus? fresh) => endedNotice(offered, fresh),
        problem: PlacementProblem(PlacementMove.start, placementMessage(e)),
      );
    } on Object catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        clearWork: true,
        problem: PlacementProblem(PlacementMove.start, placementMessage(e)),
      );
    }
  }

  /// Answer the question on screen with the option's TEXT.
  ///
  /// The step that comes back is the next question, or — when this answer
  /// finished the third part — the writing stage of an attempt that is now
  /// complete, with its band set.
  Future<void> answer(String value) async {
    final PlacementScreen screen = state.screen;
    if (state.isBusy || screen is! PlacementQuestionScreen) return;
    final PlacementStep step = screen.step;
    final PublicPlacementItem? item = step.item;
    if (item == null) return;
    state = state.copyWith(work: PlacementWork.answering, clearProblem: true);
    try {
      final PlacementStep next = await _repo.answer(
        attemptId: step.attemptId,
        // The handle exactly as it arrived — never built or parsed here.
        itemId: item.id,
        value: value,
      );
      if (!ref.mounted) return;
      if (next.stage == PlacementStage.writing) _bandMayHaveMoved();
      // "This is a new one" belongs to the new attempt's first question only.
      state = state.copyWith(
        clearWork: true,
        screen: _screenOf(next),
        clearNewAttempt: true,
      );
    } on Object catch (e) {
      if (!ref.mounted) return;
      if (_movedOn(e)) {
        await _backToIntro(_noticeFor(PlacementMove.answer, e, step.attemptId));
        return;
      }
      state = state.copyWith(
        clearWork: true,
        problem: PlacementProblem(PlacementMove.answer, placementMessage(e)),
      );
    }
  }

  /// The intro's offer: writing for a result that has none yet.
  void openWriting(String attemptId) {
    if (state.isBusy) return;
    state = state.copyWith(
      screen: PlacementWritingScreen(
        attemptId: attemptId,
        task: standardWritingTask,
      ),
      clearProblem: true,
      clearNotice: true,
      consentRefused: false,
    );
  }

  /// Send the writing to be graded.
  ///
  /// The agreement is recorded BEFORE the text is sent, and only when it is
  /// not already on record: pressing Grade under the card's words IS the
  /// affirmative act, and a grade requested before the grant lands is
  /// processing nobody agreed to yet.
  Future<void> grade(String text) async {
    final PlacementScreen screen = state.screen;
    if (state.isBusy || screen is! PlacementWritingScreen) return;
    final String attemptId = screen.attemptId;
    final bool ask = state.needsAgreement(
      ref.read(placementStatusProvider).value,
    );
    state = state.copyWith(work: PlacementWork.grading, clearProblem: true);
    if (ask) {
      try {
        await _repo.grantWritingConsent();
      } on Object catch (e) {
        // Nothing was sent; the card's words stay, with the reason.
        if (!ref.mounted) return;
        state = state.copyWith(
          clearWork: true,
          problem: PlacementProblem(PlacementMove.grade, placementMessage(e)),
        );
        return;
      }
      if (!ref.mounted) return;
      state = state.copyWith(agreed: true, consentRefused: false);
    }
    try {
      final PlacementResult result = await _repo.submitWriting(
        attemptId: attemptId,
        text: text,
      );
      if (!ref.mounted) return;
      _bandMayHaveMoved();
      state = state.copyWith(
        clearWork: true,
        screen: PlacementResultScreen(result),
      );
    } on PlacementConsentRequired {
      if (!ref.mounted) return;
      // Withdrawn since the page loaded. Not an error line: the card goes
      // back to asking, and the next press records the agreement again.
      state = state.copyWith(clearWork: true, consentRefused: true);
    } on PlacementAlreadyComplete catch (e) {
      if (!ref.mounted) return;
      await _settleRefusedWriting(attemptId, e);
    } on Object catch (e) {
      if (!ref.mounted) return;
      if (_movedOn(e)) {
        await _backToIntro(_noticeFor(PlacementMove.grade, e, attemptId));
        return;
      }
      // GRADING_UNAVAILABLE lands here: the same screen, the draft intact,
      // the same button to send it again.
      state = state.copyWith(
        clearWork: true,
        problem: PlacementProblem(PlacementMove.grade, placementMessage(e)),
      );
    }
  }

  /// Skip the writing: read back the result that is already stored. It
  /// finishes nothing — the band was set before this screen showed.
  Future<void> skip() async {
    final PlacementScreen screen = state.screen;
    if (state.isBusy || screen is! PlacementWritingScreen) return;
    final String attemptId = screen.attemptId;
    state = state.copyWith(
      work: PlacementWork.skipping,
      clearProblem: true,
      consentRefused: false,
    );
    try {
      final PlacementResult result = await _repo.finish(attemptId);
      if (!ref.mounted) return;
      // Cheap insurance for a band whose answer's response was lost.
      _bandMayHaveMoved();
      state = state.copyWith(
        clearWork: true,
        screen: PlacementResultScreen(result),
      );
    } on Object catch (e) {
      if (!ref.mounted) return;
      if (_movedOn(e)) {
        await _backToIntro(_noticeFor(PlacementMove.skip, e, attemptId));
        return;
      }
      state = state.copyWith(
        clearWork: true,
        problem: PlacementProblem(PlacementMove.skip, placementMessage(e)),
      );
    }
  }

  /// The intro's open attempt reached its closing time. The server closes it
  /// on the next read, and the card turns into the result it closed with —
  /// say why. Cleared with nothing answered, it is simply gone, and there is
  /// no level to explain.
  Future<void> recheckClosed(String attemptId) async {
    if (state.isBusy || state.screen is! PlacementIntroScreen) return;
    final PlacementStatus? fresh = await _reread();
    if (!ref.mounted) return;
    final String? ended = endedNotice(attemptId, fresh);
    if (ended != null) state = state.copyWith(notice: ended);
  }

  /// Show the intro once the status has been re-read, with the notice [rule]
  /// picks from that read.
  Future<void> _backToIntro(
    _NoticeRule? rule, {
    PlacementProblem? problem,
  }) async {
    state = PlacementFlowState(
      work: PlacementWork.rereading,
      problem: problem,
      agreed: state.agreed,
    );
    final PlacementStatus? fresh = await _reread();
    if (!ref.mounted) return;
    state = state.copyWith(clearWork: true, notice: rule?.call(fresh));
  }

  /// Writing refused as ALREADY_COMPLETE: either it is already in (sent on
  /// the web, or this send's response was lost) or the result no longer takes
  /// any. Only a fresh status tells which, so the draft stays until it lands —
  /// and for good, with the server's words, if the read fails.
  Future<void> _settleRefusedWriting(
    String attemptId,
    PlacementAlreadyComplete refusal,
  ) async {
    state = state.copyWith(
      work: PlacementWork.checking,
      problem: PlacementProblem(PlacementMove.grade, placementMessage(refusal)),
    );
    final PlacementStatus? fresh = await _reread();
    if (!ref.mounted) return;
    if (fresh == null) {
      state = state.copyWith(clearWork: true);
      return;
    }
    final PlacementSummary? latest = fresh.latest;
    final bool isIn =
        latest != null &&
        latest.attemptId == attemptId &&
        !latest.writingPending;
    state = PlacementFlowState(
      agreed: state.agreed,
      notice: isIn ? writingInNotice : writingClosedNotice,
    );
  }

  /// The status as it is now, or null when the read failed.
  Future<PlacementStatus?> _reread() async {
    try {
      return await ref.refresh(placementStatusProvider.future);
    } on Object {
      return null;
    }
  }

  void _bandMayHaveMoved() {
    ref.invalidate(placementStatusProvider);
    ref.read(placementBandChangesProvider.notifier).moved();
  }
}

/// Where a step from the server lands: a question, or the writing of an
/// attempt that is already complete.
PlacementScreen _screenOf(PlacementStep step) =>
    step.stage == PlacementStage.writing
    ? PlacementWritingScreen(
        attemptId: step.attemptId,
        task: step.writingTask ?? standardWritingTask,
      )
    : PlacementQuestionScreen(step);

/// The attempt on screen is out of step with the server's: finished or
/// closed (ALREADY_COMPLETE), cleared (NOT_FOUND), the cooldown began
/// between loading and pressing (COOLDOWN), or writing for an attempt whose
/// parts are not done (NOT_READY). The intro re-reads and shows whichever is
/// true.
bool _movedOn(Object error) =>
    error is PlacementAlreadyComplete ||
    error is PlacementNotFound ||
    error is PlacementCooldown ||
    error is PlacementNotReady;

/// The intro's line saying why the learner is back there — only where the
/// reason is certain. An answer refused because its attempt is gone names
/// the level only when the re-read shows that attempt as the latest result;
/// one cleared with nothing answered set no level, and is told only that the
/// answer was not kept.
_NoticeRule? _noticeFor(PlacementMove move, Object error, String attemptId) {
  if (move == PlacementMove.answer &&
      (error is PlacementAlreadyComplete || error is PlacementNotFound)) {
    return (PlacementStatus? fresh) =>
        '$answerNotSavedNotice '
        '${endedNotice(attemptId, fresh) ?? (error is PlacementNotFound ? clearedNotice : 'That test has closed.')}';
  }
  if (error is PlacementNotFound) {
    return (PlacementStatus? fresh) => 'That test could not be found.';
  }
  return null;
}
