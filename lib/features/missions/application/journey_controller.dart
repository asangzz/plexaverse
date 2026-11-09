import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../home/application/home_controllers.dart';
import '../../preferences/application/preferences_controller.dart';

/// Starting a new 1000-day journey, from the journey-complete screen.
///
/// Hand-written rather than `@riverpod` so it needs no generated part.
///
/// The request goes to `POST /season/advance`. The name is a compatibility
/// alias the server keeps for shipped builds: it now runs the same
/// `startNewJourney` as the web's `/api/journey/start`, ignores the old
/// `choice`, and answers `{ success, alreadyAdvanced, currentSeason, choice }`.
/// `currentSeason` there is the journey number.
class JourneyStartController extends Notifier<bool> {
  /// True while the start request is open.
  ///
  /// Held here, not on the screen: starting a journey is one irreversible
  /// write for the whole account (it resets the clock), and a flag on the
  /// widget dies with the widget — popping mid-request and coming back would
  /// offer a second start while the first was still in flight.
  @override
  bool build() => false;

  /// Starts the next journey. [targetRole] is optional: a new one makes the
  /// journey a pivot toward it, none means the user has arrived in the role
  /// they were working toward (the server decides the content mode from it).
  ///
  /// Returns the server's answer as-is. `alreadyAdvanced` alone does not say
  /// whether a journey started: the alias answers it both when an earlier
  /// tap or another device already started the next journey AND when the
  /// journey is not finished at all (its `NOT_FINISHED`). Only the caller
  /// knows which journey it was looking at, so it compares
  /// [JourneyStartResult.journeyNumber] with that.
  ///
  /// Throws on failure so the caller can say nothing changed.
  Future<JourneyStartResult> start({String? targetRole}) async {
    // Loud on purpose: the screen gates on [state] before it calls, so
    // getting here means a call site skipped that gate.
    if (state) throw StateError('A journey start is already in flight.');
    state = true;
    try {
      final response = await ref
          .read(dioClientProvider)
          .post<Map<String, dynamic>>(
            ApiPaths.seasonAdvance,
            data: <String, dynamic>{'targetRole': ?targetRole},
          );
      // The clock, the journey number and maybe the role all changed. Home
      // reads all three, and without the refetch it would keep showing day
      // 1000 and push the finish screen straight back.
      ref.invalidate(preferencesControllerProvider);
      ref.invalidate(roadmapProgressControllerProvider);
      final Map<String, dynamic>? data = response.data;
      final Object? number = data?['currentSeason'];
      return JourneyStartResult(
        alreadyAdvanced: data?['alreadyAdvanced'] == true,
        journeyNumber: number is num ? number.toInt() : null,
      );
    } finally {
      // Not autoDispose, but kept symmetrical with the other controllers: a
      // write to a disposed notifier throws out of `finally` and would turn a
      // journey that DID start into "that didn't go through".
      if (ref.mounted) state = false;
    }
  }
}

/// What `POST /season/advance` answered.
class JourneyStartResult {
  const JourneyStartResult({
    required this.alreadyAdvanced,
    required this.journeyNumber,
  });

  /// The server started nothing on this call.
  final bool alreadyAdvanced;

  /// The account's journey number after the call (`currentSeason`), or null
  /// when the response did not carry one.
  final int? journeyNumber;

  /// Whether the user is now on a journey after [before].
  ///
  /// A fresh start always is. An `alreadyAdvanced` answer is only when the
  /// number moved past the one the screen showed — otherwise the server
  /// refused because the journey is not finished (a device clock running
  /// ahead of the server's near day 1000 shows the screen early). An unknown
  /// number on either side is read as "nothing started": telling someone a
  /// journey began when it did not is the worse mistake.
  bool startedAfter(int? before) {
    if (!alreadyAdvanced) return true;
    final int? after = journeyNumber;
    return before != null && after != null && after > before;
  }
}

final NotifierProvider<JourneyStartController, bool>
journeyStartControllerProvider = NotifierProvider<JourneyStartController, bool>(
  JourneyStartController.new,
);

/// Whether the journey-complete screen has already been offered in this app
/// session.
///
/// The web keeps the same fact in a session cookie set by "Keep going for
/// now". Here it is set as soon as home pushes the screen, not only on that
/// button: back and the edge swipe are also "not now", and a home that
/// re-pushed after every pop would be a screen the user could never leave.
/// It lives in memory, so the question comes back on the next cold start —
/// the same lifetime as the web's cookie.
class JourneyCompletePrompt extends Notifier<bool> {
  @override
  bool build() => false;

  /// Records that the screen was offered (or declined) for this session.
  void markHandled() => state = true;
}

final NotifierProvider<JourneyCompletePrompt, bool>
journeyCompletePromptProvider = NotifierProvider<JourneyCompletePrompt, bool>(
  JourneyCompletePrompt.new,
);
