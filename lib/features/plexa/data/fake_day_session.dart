import '../domain/plexa_day.dart';

/// The one in-memory `plexa_day` row the mock flavor shares.
///
/// On a real backend there is exactly one row per user per day, and Open Plexa,
/// the comments screen and the connections screen all read and write it. That
/// sharing IS the feature: clearing an item in the chat has to show up on the
/// engagement screens and the other way round, because they are two views of
/// one morning's work.
///
/// The fakes used to hold a session each, so under the mock flavor the two
/// surfaces could never agree no matter how correct the code was — the build
/// this app is manually tested on would have shown the exact bug the shared row
/// exists to prevent, and shown it as if it were the design. A fixture that
/// cannot demonstrate the behaviour it stands in for is worse than no fixture:
/// it teaches the wrong thing confidently.
///
/// Module-level rather than injected: it stands in for a database row, its
/// lifetime is the process, and threading a provider through two slices to
/// simulate shared storage would be more machinery than the thing it mocks.
class FakeDaySession {
  const FakeDaySession._();

  static PlexaSession _session = const PlexaSession(
    // One Top Voice already cleared, so the resume line in Open Plexa ("Picking
    // up at 2 of 4") is exercised rather than assumed — and so the comments
    // screen opens at 1/10 rather than 0, which is the state that showed the
    // counting bug.
    comments: <String>['tv:shown-1'],
  );

  static PlexaSession get current => _session;

  static PlexaSession setDone({
    required PlexaLane lane,
    required String itemId,
    required bool done,
  }) {
    final List<String> next = List<String>.of(_session.doneIn(lane));
    if (done) {
      if (!next.contains(itemId)) next.add(itemId);
    } else {
      next.remove(itemId);
    }
    _session = lane == PlexaLane.comments
        ? _session.copyWith(comments: next)
        : _session.copyWith(connections: next);
    return _session;
  }
}
