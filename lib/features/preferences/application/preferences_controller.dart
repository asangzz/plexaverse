import 'package:riverpod_annotation/riverpod_annotation.dart';

// The auto-post toggle is not a preferences write — it has side effects and
// its own endpoint — so it stays on the settings repository.
import '../../settings/data/settings_repositories.dart'
    show settingsRepositoryProvider;
import '../data/preferences_repositories.dart';
import '../domain/preferences_repository.dart';
import '../../../core/router/auth_gate.dart';

part 'preferences_controller.g.dart';

/// The preferences row — the app's ONE reader of the keystone state.
///
/// It used to live in `features/settings`, which is where it was first needed.
/// By then home had grown its own `homeUserPreferences` provider and compose
/// was fetching `/user/preferences` inline inside its own repository. Three
/// readers of the state that decides the navigation, which home screen renders
/// and which composer you get is three chances for them to disagree about what
/// brand the user runs — so they are one now, and it lives in the slice that
/// owns the model rather than in the first screen that happened to want it.
///
/// Writes are **partial**: every mutator sends only the keys it changed. The
/// server's schema is `.strict()`, so an unknown key rejects the entire
/// payload with a 400 rather than being dropped, and it strips undefined keys
/// so a small write can never null out an unrelated column.
@riverpod
class PreferencesController extends _$PreferencesController {
  @override
  Future<UserPreferences> build() async {
    // Rebuild whenever the SESSION changes, not just on first read.
    //
    // This is an authenticated call, and the router reads it to decide the
    // onboarding gate — which means it gets initialised while the user is
    // still signed OUT, 401s, and caches that error. Without this watch
    // nothing refetches it after sign-in, so the gate kept falling back to
    // the device-local flag: every user who signed in on a fresh install was
    // sent to onboarding and stayed there, existing account or not.
    //
    // Watching the gate also clears the previous user's preferences on a
    // sign-out, which matters more than the bug that prompted it: the row
    // decides brand type and which dashboard renders, and serving one
    // account's to the next is worse than serving none.
    // AWAITED, not read as an AsyncValue. The gate is itself asynchronous —
    // it reads the token out of the session store — so watching its
    // AsyncValue runs this build twice: once while it is still loading, when
    // there is no answer to branch on, and again when it resolves. That is
    // two fetches per session change, and the first of them is the one made
    // before anyone knows whether there is a session.
    final AuthGate gate = await ref.watch(authGateProvider.future);

    // No session, no call. A 401 here is not a harmless wasted request: it
    // makes AuthInterceptor clear the session and announce a forced
    // sign-out, the router turns that into an auth-gate invalidation, and
    // this controller watches the gate — so the answer to its own failed
    // request is another one. The router no longer subscribes while signed
    // out, which is what broke that loop; this is the same guarantee held
    // one layer lower, where it does not depend on every future caller
    // knowing about it.
    if (!gate.signedIn) return const UserPreferences();

    return ref.watch(preferencesRepositoryProvider).fetch();
  }

  /// Profile Details — the web's first section.
  Future<void> saveProfile({
    required String profession,
    required String headline,
  }) => _patch(<String, dynamic>{
    'profession': profession,
    'headline': headline,
  });

  /// The auto-post kill switch.
  ///
  /// Optimistic: the toggle flips immediately and is reconciled from the
  /// server's answer. A switch that waits on a round-trip before moving reads
  /// as broken, and this one is the most consequential control on the screen.
  Future<void> setAutoPost(bool enabled) async {
    final UserPreferences? current = state.value;
    if (current == null) return;

    state = AsyncData<UserPreferences>(
      current.copyWith(autoPostEnabled: enabled),
    );
    try {
      final bool applied = await ref
          .read(settingsRepositoryProvider)
          .setAutoPostEnabled(enabled);
      state = AsyncData<UserPreferences>(
        current.copyWith(autoPostEnabled: applied),
      );
    } on Object {
      // Put the server's truth back. A failed pause that still shows "paused"
      // would have the user believe they stopped spending AI budget.
      ref.invalidateSelf();
    }
  }

  /// Which brand the user runs. Changing it re-shapes navigation, the compose
  /// screen and half of this page, so it is deliberately its own save rather
  /// than a field inside a bigger form.
  Future<void> saveBrandType(String brandType) =>
      _patch(<String, dynamic>{'brandType': brandType});

  /// Cadence — how often and when the week publishes.
  ///
  /// `preferredDays` is a list of `DateTime.weekday`-style day numbers in the
  /// server's convention, which is **0 = Sunday** (the zod schema is
  /// `min(0).max(6)`), NOT Dart's 1 = Monday. The UI converts at the edge.
  Future<void> saveCadence({
    int? postsPerWeek,
    List<int>? preferredDays,
    String? preferredTime,
  }) {
    final Map<String, dynamic> patch = <String, dynamic>{};
    if (postsPerWeek != null) patch['postsPerWeek'] = postsPerWeek;
    if (preferredDays != null) patch['preferredDays'] = preferredDays;
    if (preferredTime != null) patch['preferredTime'] = preferredTime;
    return _patch(patch);
  }

  /// Where approval requests are delivered. Wire values are
  /// `slack` | `whatsapp` | `email`; the web offers the first two.
  Future<void> saveApprovalChannel(String channel) =>
      _patch(<String, dynamic>{'approvalChannel': channel});

  /// Company-brand identity. Company users only — these anchor the voice every
  /// company post is written in.
  Future<void> saveCompanyBrand({
    String? companyIndustry,
    String? companyWebsite,
    String? companyTagline,
    String? companyDescription,
    List<String>? companyFeatures,
    String? companyLogoUrl,
    String? posterTheme,
    String? posterPrimaryColor,
    String? posterSecondaryColor,
  }) {
    final Map<String, dynamic> patch = <String, dynamic>{};
    if (companyIndustry != null) patch['companyIndustry'] = companyIndustry;
    if (companyWebsite != null) patch['companyWebsite'] = companyWebsite;
    if (companyTagline != null) patch['companyTagline'] = companyTagline;
    if (companyDescription != null) {
      patch['companyDescription'] = companyDescription;
    }
    if (companyFeatures != null) patch['companyFeatures'] = companyFeatures;
    if (companyLogoUrl != null) patch['companyLogoUrl'] = companyLogoUrl;
    if (posterTheme != null) patch['posterTheme'] = posterTheme;
    if (posterPrimaryColor != null) {
      patch['posterPrimaryColor'] = posterPrimaryColor;
    }
    if (posterSecondaryColor != null) {
      patch['posterSecondaryColor'] = posterSecondaryColor;
    }
    return _patch(patch);
  }

  /// Who the user writes for. Lives on preferences, which is why the Persona
  /// screen's audience block is editable at all — see `features/persona`.
  Future<void> saveAudience({
    String? serveRole,
    String? serveIndustry,
    String? problemSolved,
  }) {
    final Map<String, dynamic> patch = <String, dynamic>{};
    if (serveRole != null) patch['serveRole'] = serveRole;
    if (serveIndustry != null) patch['serveIndustry'] = serveIndustry;
    if (problemSolved != null) patch['problemSolved'] = problemSolved;
    return _patch(patch);
  }

  /// Applies [patch] and publishes the server's row.
  ///
  /// Not optimistic. Every write here is a deliberate "Save" tap with a busy
  /// button attached, so there is no dead-feeling UI to paper over — and a
  /// setting that appears to save and then quietly reverts is worse than one
  /// that takes a beat.
  Future<void> _patch(Map<String, dynamic> patch) async {
    if (patch.isEmpty) return;
    final UserPreferences updated = await ref
        .read(preferencesRepositoryProvider)
        .patch(patch);
    state = AsyncData<UserPreferences>(updated);
  }
}

/// Identity + billing state, from `GET /auth/me`.
