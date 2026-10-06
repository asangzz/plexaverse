/// Today's auto-post, as the roadmap and the planner both see it.
///
/// On the server these are two columns on one roadmap read and they are
/// documented as mutually exclusive: `pendingPostIdToday` is set while a
/// generated post is waiting for approval, and `scheduledPostId` +
/// `scheduledPostAt` replace it the moment the user approves one. The
/// transition between them is an approval, which happens in the PLANNER — a
/// different slice from the roadmap that renders the result.
///
/// The home fake used to set `pendingPostIdToday` and never the other two, so
/// of the three branches in `roadmap_level.dart` only the first could ever be
/// reached. The "your next post is scheduled" state — the one that exists so a
/// fully-approved chain does not look broken — and the "nothing lined up"
/// state were both dead on the build this app is manually tested on.
///
/// Module-level for the same reason `FakeDaySession` is: it stands in for a
/// row two slices read, its lifetime is the process, and threading a provider
/// between them to simulate shared storage would be more machinery than the
/// thing it mocks.
library;

class FakeAutoPostState {
  const FakeAutoPostState._();

  /// Awaiting approval. The state a user opens the app to.
  static String? _pendingPostId = 'mock-post-today';

  static String? _scheduledPostId;
  static DateTime? _scheduledAt;

  static String? get pendingPostId => _pendingPostId;
  static String? get scheduledPostId => _scheduledPostId;
  static DateTime? get scheduledAt => _scheduledAt;

  /// The user approved today's post. Pending clears, scheduled takes over —
  /// never both, which is what the server guarantees.
  static void approved({DateTime? at}) {
    _scheduledPostId = _pendingPostId ?? 'mock-post-today';
    _scheduledAt = at ?? DateTime.now().add(const Duration(hours: 3));
    _pendingPostId = null;
  }

  /// The chain did not run today: nothing pending, nothing scheduled. The
  /// third branch, which prompts a manual generate on the next posting day.
  static void nothingLinedUp() {
    _pendingPostId = null;
    _scheduledPostId = null;
    _scheduledAt = null;
  }
}
