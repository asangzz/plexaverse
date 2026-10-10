import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/google_link_controller.dart';
import '../../auth/application/sign_out_controller.dart';
import '../data/settings_repositories.dart';
import '../domain/settings_repository.dart';

part 'privacy_controller.g.dart';

/// What an erasure attempt came back with.
///
/// Sealed, rather than this slice's usual "null means it failed": success here
/// CARRIES something the user is entitled to — the records a statutory
/// carve-out kept — and an empty list is a real success, not an absence.
/// Folding that into a nullable list would make the one irreversible call on
/// the screen report its outcome through a nullability puzzle.
sealed class ErasureOutcome {
  const ErasureOutcome();
}

/// The account is gone, and the session with it. [retained] is what SURVIVED
/// under a statutory carve-out; empty means nothing did.
class ErasureSucceeded extends ErasureOutcome {
  const ErasureSucceeded(this.retained);

  final List<String> retained;
}

/// Nothing was changed.
///
/// Deliberately carries no message. `DELETE /user/account` does not translate
/// its rejections into a typed result yet, so a wrong password and an
/// unreachable server arrive here indistinguishable — only the caller knows
/// whether a password was in play, and only it can pick the sentence that
/// names the right thing to try next.
class ErasureFailed extends ErasureOutcome {
  const ErasureFailed();
}

/// The DPDP rights family: export (s11), erasure (s12), grievance (s13) and
/// nomination (s14).
///
/// All five calls used to run from `_DataPrivacySectionState`, which imported
/// `data/` and read `settingsRepositoryProvider` itself — presentation
/// reaching past application straight into data, which is the one dependency
/// direction ARCHITECTURE.md forbids. The cost was not stylistic: the
/// in-flight flag those calls shared was a widget field, so an IRREVERSIBLE
/// request was gated by state that dies with the screen, and everything after
/// an await — including the sign-out that has to follow an erasure — was
/// conditional on the user not having navigated away. [ConsentController],
/// which lives next door and serves the same section, was already doing this
/// correctly; this is its missing other half.
@riverpod
class PrivacyController extends _$PrivacyController {
  /// True while an export or an erasure is open.
  ///
  /// One flag covering both, as the widget's did: they are the two slow calls
  /// in the section and it disables the whole block for either. The nomination
  /// and grievance paths deliberately do NOT raise it — they never did, and
  /// giving them an in-flight state would be a change to what the screen does,
  /// not a move of where it is done.
  ///
  /// Watching this is also what keeps this autoDispose provider alive for the
  /// length of a write: a call site that only `read` the notifier would leave
  /// the element free to be disposed out from under an open request.
  @override
  bool build() => false;

  /// DPDP s14 — the nomination on file, or null when there is none.
  ///
  /// A FAILED read answers null too, deliberately: this value only pre-fills
  /// the form, and a read that could not be reached must never be the reason a
  /// user cannot name someone to act for them. The save is the call that owes
  /// them an answer.
  Future<Nominee?> nomination() async {
    try {
      return await ref.read(settingsRepositoryProvider).fetchNomination();
    } on Object {
      return null;
    }
  }

  /// Saves [nominee]. Returns the failure message, or null on success — the
  /// contract every other controller in this slice uses.
  ///
  /// Passed straight through because the repository already answers this way,
  /// and the message it answers with is the SERVER's where it sent one: it
  /// names the field the user has to fix, which a generic sentence would lose.
  Future<String?> saveNomination(Nominee nominee) =>
      ref.read(settingsRepositoryProvider).saveNomination(nominee);

  /// DPDP s13 — raises a concern. Returns the days the Fiduciary has to
  /// respond, or null when the submission failed.
  ///
  /// The deadline is the server's, never a constant here: it is stamped onto
  /// the row at creation, so a later policy change cannot move a date already
  /// given to someone.
  Future<int?> raiseGrievance({
    required String category,
    required String message,
  }) async {
    try {
      return await ref
          .read(settingsRepositoryProvider)
          .raiseGrievance(category: category, message: message);
    } on Object {
      return null;
    }
  }

  /// DPDP s11 — everything held about the user, or null when it could not be
  /// built.
  Future<Map<String, dynamic>?> export() async {
    state = true;
    try {
      return await ref.read(settingsRepositoryProvider).fetchDataExport();
    } on Object {
      return null;
    } finally {
      // The screen can be popped mid-request, which disposes this autoDispose
      // provider; writing `state` on a disposed Ref throws out of the
      // `finally`, and a throw there replaces whatever this returned — so an
      // export that worked would reach the caller as an unhandled error.
      if (ref.mounted) state = false;
    }
  }

  /// Whether this account signs in with a password.
  ///
  /// **Null is UNKNOWN, not false.** [GoogleLinkController] answers null on
  /// any failed status read, and reading that as "no password" is exactly the
  /// bug that made Delete impossible for every password account. The caller
  /// reads this ONCE and uses it twice — to decide whether the dialog demands
  /// a password, and whether a failure may blame one — so the two cannot
  /// disagree across however long the user sits in that dialog.
  bool? get hasPassword =>
      ref.read(googleLinkControllerProvider).value?.hasPassword;

  /// DPDP s12 erasure. **Irreversible.**
  ///
  /// [password] is the server's gate, not decoration: `DELETE /user/account`
  /// bcrypt-compares it whenever the row has one and refuses the call outright
  /// when none arrives. An EMPTY string is a deliberate confirmation from an
  /// account that has no password — the repository drops the key for it, which
  /// is what the server expects from a Google-only row. Passing `''` for a row
  /// that HAS a password is the defect this parameter exists to prevent, so it
  /// is required and never defaulted.
  Future<ErasureOutcome> erase({required String password}) async {
    // Captured before the request rather than read after it. `ref.read` throws
    // on a disposed Ref, and the moment that must survive a disposal is the
    // one AFTER a successful erasure: the row is gone, so a session still
    // pointing at it is pointing at nothing. On the widget this was guarded by
    // `mounted`, which meant backing out of Settings mid-request left the
    // device signed in to a deleted account. SignOutController is keepAlive,
    // so this reference stays usable even if this controller is torn down.
    final SignOutController signOut = ref.read(
      signOutControllerProvider.notifier,
    );
    state = true;
    try {
      final List<String> retained = await ref
          .read(settingsRepositoryProvider)
          .deleteAccount(password: password);
      // Past this line the account IS gone, and nothing below may report
      // otherwise. A session teardown that stumbles on the way out is not
      // evidence the user's data survived, so it cannot reach the catch.
      try {
        await signOut.signOut();
      } on Object {
        // Nothing to say: the row is erased either way, and the router's gate
        // re-resolves to signed-out on the next launch regardless.
      }
      return ErasureSucceeded(retained);
    } on Object {
      return const ErasureFailed();
    } finally {
      // A successful erasure signs the user out, which redirects away from
      // Settings and disposes this provider — so by here `ref.mounted` is
      // routinely false, not exceptionally.
      if (ref.mounted) state = false;
    }
  }
}
