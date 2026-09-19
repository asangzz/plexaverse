import 'user_preferences.dart';

export 'user_preferences.dart';

/// Thrown when the preferences row can't be read or written.
class PreferencesUnavailable implements Exception {
  const PreferencesUnavailable();
}

/// Reads and writes the preferences row.
///
/// This lives in its own slice on purpose. `UserPreferences` is the keystone
/// the whole app branches on — the shell reads `brandType` to decide the
/// navigation, home reads `currentSeason` to decide which of two screens to
/// render, compose reads it to decide which composer it is, and the router
/// reads `onboardingCompleted` to decide whether the dashboard is reachable at
/// all. Three slices had each grown their own reader before this existed, and
/// three copies of "what brand is this user" is three chances to disagree.
abstract class PreferencesRepository {
  Future<UserPreferences> fetch();

  /// Partial upsert. Send ONLY the keys that changed: the server's schema is
  /// `.strict()`, so an unknown key rejects the whole payload with a 400, and
  /// it strips undefined keys so a small write cannot null out a column the
  /// user never touched.
  ///
  /// `autoPostEnabled` is deliberately NOT accepted here — it has side effects
  /// and goes through its own endpoint. See `setAutoPostEnabled` on the
  /// settings repository.
  Future<UserPreferences> patch(Map<String, dynamic> patch);
}
