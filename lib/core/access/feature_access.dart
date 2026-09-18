/// Feature-access rules, mirrored from the web app's `lib/feature-access.ts`
/// and the `visibility` field on the web sidebar's nav items
/// (`components/automate/Sidebar.tsx`).
///
/// These rules decide what a user can SEE, and the mobile app must apply them
/// identically — a screen the web hides from a personal-brand user must not be
/// reachable from this app's navigation either.
library;

/// Which brand a user is running. Mirrors `UserPreferences.brandType`.
enum BrandType { personal, company }

/// How a destination is exposed in navigation. Mirrors the `visibility` union
/// on the web's `NavItem`.
enum NavVisibility {
  /// Everyone.
  both,

  /// Personal-brand users only.
  personal,

  /// Company-brand users only.
  company,

  /// Admin OR company brand — [canAccessGatedFeature].
  gated,

  /// Admin only.
  ///
  /// For v1 the web uses this to hide Studio, Reimagine, Template Creator,
  /// Festive, Advocacy and Accounts from every end user's navigation. Those
  /// screens still EXIST and their page-level gates still admit company-brand
  /// users, so a roadmap task can deep-link into one — they are simply absent
  /// from the nav. Do not "fix" this by promoting them to [both].
  admin,
}

/// The gated feature keys, mirrored from `GATED_FEATURE_KEYS`.
const List<String> gatedFeatureKeys = <String>[
  'studio',
  'reimagine',
  'template-creator',
  'festive',
];

/// Mirrors `canAccessGatedFeature(role, brandType)`.
bool canAccessGatedFeature({String? role, BrandType? brandType}) =>
    role == 'admin' || brandType == BrandType.company;

/// Whether a destination with [visibility] should appear in navigation.
///
/// [brandType] is null while preferences are still loading; in that case
/// brand-specific items are withheld rather than guessed, which is what the web
/// does (`brandType !== null && item.visibility === brandType`). Showing a
/// personal item to a company user for one frame is a worse failure than
/// showing nothing for one frame.
bool isNavVisible({
  required NavVisibility visibility,
  required String? role,
  required BrandType? brandType,
}) {
  switch (visibility) {
    case NavVisibility.both:
      return true;
    case NavVisibility.admin:
      return role == 'admin';
    case NavVisibility.gated:
      return canAccessGatedFeature(role: role, brandType: brandType);
    case NavVisibility.personal:
      return brandType == BrandType.personal;
    case NavVisibility.company:
      return brandType == BrandType.company;
  }
}
