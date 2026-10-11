import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/platform/file_picking.dart';
import 'persona_controller.dart';

part 'persona_write_controller.g.dart';

/// The keys [PersonaWriteController] raises while a write is open.
///
/// Named constants rather than inline strings, for the same reason settings'
/// `SettingsWrite` uses them: the key is the only thing joining a button's
/// busy state to the operation that disabled it, and a typo would silently
/// produce a button that never goes busy at all.
abstract final class PersonaWrite {
  /// "Who you're writing for" — the audience form's Save.
  static const String audience = 'audience';

  /// The LinkedIn analytics `.xlsx` import, document picker included.
  static const String reach = 'reach';

  /// The follower checkpoint's answer.
  ///
  /// Keyed apart from the other two deliberately: the checkpoint strip is
  /// rendered on the ROADMAP, not on the persona page, so a single screen-wide
  /// flag would grey out a field on one screen because a save was open on
  /// another. That is the "pausing one schedule greyed out every other row"
  /// defect wearing different clothes.
  static const String followers = 'followers';
}

/// Every write the persona can start, and which of them are open.
///
/// ## Why the flags are here and not on the widgets
///
/// Each of these was a `_saving` / `_busy` field on the widget holding the
/// button. ARCHITECTURE.md's test — "if the widget were disposed
/// mid-operation, or a second screen asked the same question, would the answer
/// be wrong?" — answers yes for all three. The audience PATCH and the reach
/// import keep running after a back-swipe, and the follower checkpoint is
/// asked from a different screen than the one that owns the persona: a flag
/// that lives on whichever widget happened to host the control cannot be read
/// by the other.
///
/// ## Why the reads stay on [PersonaController]
///
/// [PersonaController] is one controller on purpose — everything the screen
/// shows comes from the same two requests. Nothing about that changes here.
/// This holds only the "is it open" answer, which the snapshot has no field
/// for and should not grow one: a value fetched from the server and a flag
/// about a request in flight have different lifetimes.
///
/// ## Why it is `autoDispose`
///
/// Same bargain `SettingsWriteController` strikes: the flag is worth losing
/// when the screen goes, the WORK is not, and the work is not lost — every
/// method below delegates to [PersonaController], which owns the request and
/// the result. Only the "is it open" answer goes, and by then nobody is
/// asking. Each control watches its own key through `.select`, so the audience
/// form does not rebuild because the reach import moved.
@riverpod
class PersonaWriteController extends _$PersonaWriteController {
  @override
  Set<String> build() => const <String>{};

  /// Whether [key] is open. Call through `.select` so a control rebuilds for
  /// its own write and not for a sibling's.
  bool isBusy(String key) => state.contains(key);

  /// "Who you're writing for". Returns the message to show, or null on
  /// success — the caller keeps its own success behaviour, which here is
  /// collapsing the form back to the summary.
  Future<String?> saveAudience({
    required String role,
    required String industry,
    required String problem,
  }) => _write(
    PersonaWrite.audience,
    () => ref
        .read(personaControllerProvider.notifier)
        .saveAudience(role: role, industry: industry, problem: problem),
    // The web's sentence, kept verbatim: it is the one that tells the user
    // nothing was destroyed by the failure.
    "We couldn't save that. Nothing of yours has been lost.",
  );

  /// Picks the LinkedIn analytics export and imports it, as one operation.
  ///
  /// Returns the note to show, or null when there is nothing to say — closing
  /// the picker is a decision, not a failure. On a rejection the repository
  /// passes the server's own words through, because "that does not look like a
  /// LinkedIn export" tells the user what to do next and a generic failure
  /// does not; that message comes back from here unchanged.
  ///
  /// The pick runs here rather than on the button because the picker is part
  /// of the operation: the sheet is up for as long as the user is choosing,
  /// and an import is open from the moment they tapped — not from the moment
  /// a file came back.
  Future<String?> importReach() => _guard(PersonaWrite.reach, () async {
    final FilePickResult picked = await ref
        .read(filePickingProvider)
        .pick(extensions: <String>['xlsx']);
    switch (picked) {
      case PickedFile():
        return ref.read(personaControllerProvider.notifier).importReach(picked);
      // Closing the picker is a decision.
      case FilePickCancelled():
        return null;
      case FilePickFailure(:final String? message):
        return message ?? 'Could not open your files.';
    }
  });

  /// The follower count the user typed on the roadmap.
  ///
  /// Returns an error sentence, or null on success — the contract
  /// [PersonaController.recordFollowers] already has, passed straight through.
  Future<String?> recordFollowers(int count) => _guard(
    PersonaWrite.followers,
    () => ref.read(personaControllerProvider.notifier).recordFollowers(count),
  );

  /// Runs [action] under [key] and turns a throw into [onFailure]. Returns
  /// null on success.
  Future<String?> _write(
    String key,
    Future<void> Function() action,
    String onFailure,
  ) => _guard(key, () async {
    try {
      await action();
      return null;
    } on Object {
      return onFailure;
    }
  });

  /// Raises [key] for the length of [action].
  Future<T> _guard<T>(String key, Future<T> Function() action) async {
    state = <String>{...state, key};
    try {
      return await action();
    } finally {
      // Leaving the screen mid-write disposes this provider, and writing
      // `state` on a disposed Ref throws out of the `finally` — which would
      // replace whatever the write actually returned with an unhandled error.
      if (ref.mounted) state = <String>{...state}..remove(key);
    }
  }
}
