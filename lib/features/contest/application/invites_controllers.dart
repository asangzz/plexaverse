import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/platform/image_picking.dart';
import '../data/contest_repositories.dart';
import '../domain/contest_repository.dart';
import 'contest_controllers.dart';

part 'invites_controllers.g.dart';

// Saturday's level: send the week's invitations, then prove it with one
// screenshot of LinkedIn's Sent page. A port of the web's
// `components/contest/tasks/InvitesUpload.tsx`.
//
// WHY A SCREENSHOT, AND WHY A PERSON READS IT
//   LinkedIn has no API that says how many invitations someone sent; the
//   learner's own Sent page does. No AI reads it. It pays ON UPLOAD and our
//   team checks every one after — a fake one loses the XP and the same again.
//   That rule is said, with the real numbers, above the send button and again
//   once the XP lands.
//
// WHERE THE STATE COMES FROM
//   The path's `weekly_invites` node, and nothing else: there is no GET for
//   invites. Right after an upload the level shows what the upload's own
//   answer paid, before the re-read path confirms it.

/// LinkedIn's page of sent invitations — what the screenshot is of.
const String kSentInvitationsUrl =
    'https://www.linkedin.com/mynetwork/invitation-manager/sent/';

/// Said beside the upload, where the decision to send it is made: the page
/// shows other people's names, so it is stored privately and deleted once
/// checked. The web's `PRIVACY_LINE`.
const String kInvitesPrivacyLine =
    'Your screenshot is seen only by our team and deleted once it is checked.';

/// Why a chosen file was not taken. The web's `fileProblem` for size; the
/// server refuses the same, at the same 8 MB.
const String kInvitesTooLargeLine =
    'That image is over 8 MB. Send a smaller screenshot.';

/// The audit rule in real numbers: what a fake screenshot costs — the XP it
/// paid and the same again. The web's `fakeRule`, over the server's
/// `invitesFakeDeduction` (×2).
String invitesFakeRule(int points) => points > 0
    ? 'We check every screenshot. A fake one loses these $points XP and the '
          'same again as a penalty (−${points * 2} XP in all).'
    : 'We check every screenshot. A fake one loses the XP it earned and the '
          'same again as a penalty.';

/// The week's invites level, and whether it is LAST week's.
///
/// Weeks run Sunday to Saturday, so a screenshot still waiting for review, or
/// sent back, under the old review flow is drawn again on the Sunday after
/// and can be re-sent that day — that node sits on a day that is not a
/// Saturday.
class InvitesLevel {
  const InvitesLevel({required this.node, required this.lastWeek});

  final PathNode node;
  final bool lastWeek;
}

/// The first `weekly_invites` node on the shown week, wherever it sits.
/// Null when the week has none (a contest that ends before Saturday).
InvitesLevel? invitesLevelOf(ContestPath? path) {
  for (final PathDay day in path?.days ?? const <PathDay>[]) {
    for (final PathNode node in day.nodes) {
      if (node.kind == PathNodeKind.weeklyInvites) {
        // The server's weekday, 6 = Saturday — never the device's.
        return InvitesLevel(node: node, lastWeek: day.weekday != 6);
      }
    }
  }
  return null;
}

/// What an upload paid, kept for as long as the level is open.
class InvitesSent {
  const InvitesSent({required this.points, required this.lastWeek});

  /// The upload's own `pointsApplied` — 0 while scoring is paused.
  final int points;

  /// Whether it was last week's screenshot, as the level said when it was
  /// sent. Held so the header does not change under the learner: once a
  /// Sunday re-send lands, the path stops drawing last week's node and would
  /// otherwise jump to the coming Saturday's.
  final bool lastWeek;
}

/// The upload as it stands: the chosen screenshot, why it cannot go, what is
/// in flight, what the server said, and what landed.
class InvitesUpload {
  const InvitesUpload({
    this.screenshot,
    this.problem,
    this.busy = false,
    this.error,
    this.sent,
  });

  /// The picked file, ready to send. Its name decides the part's
  /// `image/*` type.
  final PickedImage? screenshot;

  /// Why the chosen file was not taken, or the picker failed — said before
  /// anything is uploaded.
  final String? problem;
  final bool busy;

  /// The server's refusal, in its own words.
  final String? error;

  /// Set once an upload landed. From then on the level shows it as sent,
  /// whatever the re-read path draws.
  final InvitesSent? sent;
}

/// Picking and sending the screenshot, with the in-flight and failure state
/// off the widget — `test/architecture/no_async_state_in_widgets_test.dart`.
@riverpod
class InvitesActions extends _$InvitesActions {
  @override
  InvitesUpload build() => const InvitesUpload();

  /// Opens the photo library for the screenshot.
  ///
  /// A dismissed picker changes nothing and says nothing — it is a decision,
  /// not a failure. A file over 8 MB is refused here, before a byte of it
  /// crosses a mobile connection, in the words the web uses.
  Future<void> choose() async {
    if (state.busy || state.sent != null) return;
    final ImagePickResult result = await ref
        .read(imagePickingProvider)
        .pick(ImageSourceKind.gallery);
    if (!ref.mounted) return;
    switch (result) {
      case final PickedImage picked:
        state = picked.bytes.length > kMaxInvitesScreenshotBytes
            ? const InvitesUpload(problem: kInvitesTooLargeLine)
            : InvitesUpload(screenshot: picked);
      case ImagePickCancelled():
        return;
      case ImagePickFailure(:final String? message):
        state = InvitesUpload(
          screenshot: state.screenshot,
          problem: message ?? 'Could not open your photos.',
        );
    }
  }

  /// `POST /contest/tasks/invites` with the chosen screenshot.
  ///
  /// [lastWeek] is what the level said when the learner pressed send; see
  /// [InvitesSent.lastWeek]. On success the XP that landed is shown at once
  /// and the standing is re-read.
  Future<void> send({required bool lastWeek}) async {
    final PickedImage? shot = state.screenshot;
    if (shot == null || state.busy || state.sent != null) return;
    state = InvitesUpload(screenshot: shot, busy: true);
    try {
      final InvitesSubmitResult result = await ref
          .read(contestRepositoryProvider)
          .submitInvites(shot.bytes, shot.name);
      if (!ref.mounted) return;
      state = InvitesUpload(
        sent: InvitesSent(points: result.pointsApplied, lastWeek: lastWeek),
      );
      refreshContestStanding(ref.invalidate);
    } on Object catch (e) {
      if (!ref.mounted) return;
      state = InvitesUpload(screenshot: shot, error: contestMessage(e));
      // These say the path the level was drawn from has moved — a level
      // before it still open, the week already in or audited, the day
      // turned. Re-reading it is the cure; the screenshot stays chosen.
      if (e is ContestLocked ||
          e is ContestAlreadyDone ||
          e is ContestRevoked ||
          e is ContestWrongDay ||
          e is ContestConflict) {
        ref.invalidate(contestPathProvider);
      }
    }
  }
}
