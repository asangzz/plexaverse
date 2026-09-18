/// Source of truth for the per-tenant feature catalogue (RULINGS §11).
///
/// Adding a feature is adding an enum value. Every [TenantConfig] must then
/// explicitly declare `true`/`false` for it — enforced by
/// [validateTenantFeatureMatrix] at startup (see `tenant_controller.dart`).
///
/// Plexaverse ships a single `plexaverse` tenant (mirrors ProHealth's
/// single-tenant boilerplate), so today these gates are effectively product
/// feature flags; the multi-tenant machinery stays in place so a second
/// tenant is a catalogue entry, not a refactor.
enum AppFeature {
  /// Social feed — posts, likes, comments (the primary product surface).
  posts,

  /// Odyssey — the gamified journey / progression surface.
  odyssey,

  /// Analytics dashboards (creator / profile insights).
  analytics,

  /// Studio — long-form / rich content authoring.
  studio,

  /// Post scheduling.
  schedule,

  /// In-app notification inbox + push.
  notifications,

  /// Referral program (invite codes / rewards).
  referrals,
}
