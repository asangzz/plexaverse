import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/contest_repositories.dart';
import '../domain/contest_repository.dart';
import 'contest_controllers.dart';

part 'shoutout_controllers.g.dart';

/// Where a "Feature me" save stands — the card's button and the line under
/// it.
class ShoutoutSave {
  const ShoutoutSave({
    this.saving = false,
    this.error,
    this.badLink = false,
    this.adultRequired = false,
  });

  final bool saving;

  /// The server's sentence for a refused save, or the generic one. Null while
  /// nothing has gone wrong.
  final String? error;

  /// The refusal was INVALID_LINKEDIN_URL: said beside the field.
  final bool badLink;

  /// The refusal was ADULT_REQUIRED: the card shows the 18+ box.
  final bool adultRequired;
}

/// `PUT /contest/shoutout`, with its busy and error state off the widget —
/// the web's `useSetContestShoutout`.
///
/// A success writes the server's answer into the choice
/// ([ContestShoutout.settle]) and re-reads the cards, so switching off takes
/// the learner off every card they were on at once.
@riverpod
class ContestShoutoutActions extends _$ContestShoutoutActions {
  @override
  ShoutoutSave build() => const ShoutoutSave();

  /// Clears a shown refusal — the box was touched again.
  void reset() {
    if (state.saving) return;
    state = const ShoutoutSave();
  }

  /// [featured] is exactly what the learner did: ticked and pressed "Feature
  /// me" (true, with the link from the field, and [adult] when the card asked
  /// for the 18+ tick and it was ticked), or un-ticked (false — the whole
  /// withdrawal, nothing else asked).
  Future<bool> save({
    required bool featured,
    String? linkedinUrl,
    bool adult = false,
  }) async {
    if (state.saving) return false;
    state = const ShoutoutSave(saving: true);
    try {
      final ShoutoutSettings settings = await ref
          .read(contestRepositoryProvider)
          .setShoutout(
            featured: featured,
            linkedinUrl: linkedinUrl,
            adult: adult,
          );
      if (!ref.mounted) return false;
      state = const ShoutoutSave();
      ref.read(contestShoutoutProvider.notifier).settle(settings);
      ref.invalidate(contestFeaturedProvider);
      return true;
    } on Object catch (e) {
      if (!ref.mounted) return false;
      state = ShoutoutSave(
        error: contestMessage(e),
        badLink: e is ContestBadProfileLink,
        adultRequired: e is ContestAdultRequired,
      );
      // A refused withdrawal must show as still on, not as what was tapped.
      ref.invalidate(contestShoutoutProvider);
      return false;
    }
  }
}
