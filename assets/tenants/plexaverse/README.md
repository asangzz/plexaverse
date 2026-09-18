# Tenant brand assets — `plexaverse`

Per-tenant brand images for the single `plexaverse` tenant (RULINGS §11).

Tenant configuration itself is **compile-time** and lives in
`lib/core/tenant/catalogue.dart` (AOT-embedded — no JSON ships in the bundle).
This directory holds only the branded image binaries that `TenantConfig.assets`
(`lib/core/tenant/tenant_config.dart`) points at. `AppAssets`-style global,
non-tenant images live under `assets/images/` instead.

The `plexaverse` `TenantAssets` entry references these exact paths — drop the
final artwork in with these names (design deliverable):

| Path                                     | Purpose                                    |
| ---------------------------------------- | ------------------------------------------ |
| `assets/tenants/plexaverse/logo.png`     | Primary logo (light surfaces)              |
| `assets/tenants/plexaverse/logo_dark.png`| Logo variant for the dark-default identity |
| `assets/tenants/plexaverse/splash.png`   | Splash / launch artwork                    |
| `assets/tenants/plexaverse/login_banner.png` | Auth-page banner image                 |

The directory is already listed under `flutter: assets:` in `pubspec.yaml`.
Adding a second tenant means a new `assets/tenants/<key>/` folder (listed in
pubspec), a `TenantConfig` entry in the catalogue, and — if new surfaces are
gated — new `AppFeature` values.
