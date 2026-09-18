# Plexaverse — Architecture Reference

## Overview

Plexaverse is a **feature-sliced** Flutter application. The codebase is organised
by *feature* first, and each feature is internally layered with a strict
Clean-Architecture dependency rule: dependencies point inward only
(presentation → application → domain ← data).

```
lib/features/<slice>/
┌──────────────────────────────────────────────┐
│  presentation/   Pages, widgets (UI only)     │
├──────────────────────────────────────────────┤
│  application/    Controllers / Notifiers      │
│                  (Riverpod state, use-cases)  │
├──────────────────────────────────────────────┤
│  domain/         Entities + repository        │
│                  interfaces (pure Dart)       │
├──────────────────────────────────────────────┤
│  data/           Repository impls, DTOs,      │
│                  provider selection           │
└──────────────────────────────────────────────┘
     ↑ presentation/application depend on domain ↑
     ↑ data implements the domain contracts     ↑
```

Cross-cutting concerns that are not owned by any single feature live under
`lib/core/` (networking, storage, router, sync, security, tenant, etc.).

---

## Directory Structure

```
lib/
├── main.dart              # default entry point
├── main_dev.dart          # dev flavor      → bootstrap(env: Env.dev)
├── main_staging.dart      # staging flavor  → bootstrap(env: Env.staging)
├── main_prod.dart         # prod flavor     → bootstrap(env: Env.prod)
├── main_mock.dart         # mock flavor     → bootstrap(env: Env.mock)
│
├── bootstrap.dart         # single boot path shared by every flavor
├── bootstrap/
│   ├── firebase_init.dart     # best-effort Firebase + Crashlytics init
│   ├── error_handlers.dart    # attachErrorHandlers (framework + platform)
│   ├── release_guards.dart    # prod-only release config assertions
│   └── plexaverse_app.dart    # root MaterialApp.router widget
│
├── core/
│   ├── config/            # Env enum, useFakeBackend, API base URLs
│   ├── network/           # Dio client, interceptors, InternetMonitor
│   ├── router/            # GoRouter, auth gate, redirect, route paths
│   ├── storage/           # Drift AppDatabase, DAOs, session store, cache
│   ├── sync/              # Offline mutation queue, sync engine/dispatcher
│   ├── security/          # Jailbreak/RASP detector, secure storage
│   ├── tenant/            # Tenant catalogue + controller (single-tenant)
│   ├── platform/          # Notifications service, web auth, platform glue
│   ├── mock/              # MockApi — loads assets/mock/*.json fixtures
│   ├── responsive/        # ScreenUtilInit wiring (360 x 760 design frame)
│   ├── logging/           # PII-scrubbing AppLogger
│   ├── theme/             # theme controller glue
│   ├── ui/                # shared UI primitives
│   └── extensions/        # BuildContext / String extensions
│
├── features/
│   ├── auth/              # application · data · domain · presentation
│   ├── home/              # application · data · domain · presentation
│   ├── posts/             # application · data · domain · presentation
│   ├── odyssey/           # application · data · domain · presentation
│   ├── analytics/         # application · data · domain · presentation
│   ├── notifications/     # application · data · domain · presentation
│   ├── settings/          # application · data · domain · presentation
│   └── onboarding/        # application · presentation (no data/domain — UI-only)
│
├── theme/                 # AppColors, AppTextStyles, AppThemeMode
└── l10n/                  # ARB localisation files
```

Each feature slice holds its own imports relative to itself
(`../data/...`, `../domain/...`); there is no top-level `lib/data`,
`lib/domain`, or `lib/presentation` — those were removed in the migration.

---

## Flavors

The build-time flavor is the `Env` enum (`lib/core/config/env.dart`):

| Flavor    | Entry point         | Backend                                   |
|-----------|---------------------|-------------------------------------------|
| `mock`    | `main_mock.dart`    | bundled JSON fixtures (`assets/mock/`)    |
| `dev`     | `main_dev.dart`     | local backend on your machine             |
| `staging` | `main_staging.dart` | staging API                               |
| `prod`    | `main_prod.dart`    | live plexaverse.com API                   |

Each `main_<flavor>.dart` is a one-liner that calls
`bootstrap(env: Env.<flavor>)`. The flavor selects the API base URL and,
through `useFakeBackend`, whether repository providers resolve their
`Fake*/Mock*` or `Api*` implementations.

`useFakeBackend` is **true only for `Env.mock`**. It can be forced either way
without changing flavor via `--dart-define=USE_FAKE_BACKEND=true|false`. As a
defence-in-depth measure, the mock implementations assert they never resolve in
a release build (`kReleaseMode`), so test credentials can never ship live.

### Running the mock backend

```bash
flutter run -t lib/main_mock.dart
```

No network, no live API, no Firebase config required — the app resolves the
`Mock*` repositories, which read the bundled fixtures under `assets/mock/`
(`auth/`, `home/`, `posts/`, `odyssey/`, `analytics/`, `notifications/`,
`settings/`) via `core/mock/mock_api.dart`. Ideal for UI work, demos, and
widget/golden tests.

---

## Bootstrap Order

All flavors funnel through `bootstrap(env:)` in `lib/bootstrap.dart`. The entire
boot runs inside `runZonedGuarded`, so any escaped error still reaches
Crashlytics in release. The ordered steps:

1. **Flutter init** — `WidgetsFlutterBinding.ensureInitialized()`.
2. **Firebase + Crashlytics** (best-effort). On success, register the FCM
   background-message handler in the main isolate.
3. **Root `ProviderContainer`** — built with `envProvider` overridden to the
   selected flavor, and Riverpod auto-retry disabled (the app owns its own retry
   story: the offline gate fast-fails and `InternetMonitor` re-probes).
4. **Logger + error handlers** — build the PII-scrubbing `AppLogger`, then
   `attachErrorHandlers` routes `FlutterError.onError` and
   `PlatformDispatcher.onError` through it (Crashlytics forwarding gated on
   `firebaseReady`).
5. **Startup asserts** — tenant catalogue completeness (debug) and release
   config sanity (prod-only).
6. **Tenant hydration** — restore the tenant controller from SharedPreferences;
   single-tenant, so seed the default Plexaverse key when nothing is stored.
7. **Sync engine start** — drains any offline mutations left from a prior
   session (no-ops when signed out).
8. **RASP listener** — jailbreak detector started non-blocking.
9. **Media-cache sweep** — fire-and-forget disk cleanup with its own guard.
10. **Push registration** — fire-and-forget, only when Firebase is ready *and* a
    session was restored (signed-out devices never register).
11. **`runApp`** — inside `ScreenUtilInit(designSize: Size(360, 760))` wrapping
    `PlexaverseApp` in an `UncontrolledProviderScope`.

---

## Slice Layout

Every feature slice follows the same internal layering:

- **`domain/`** — pure Dart. Entities and the abstract repository interface. No
  Flutter, no Dio, no Drift imports. This is the contract the rest of the slice
  depends on.
- **`data/`** — implements the domain contract:
  - `api_*_repository.dart` — the real implementation over Dio / Drift.
  - `mock_*_repository.dart` — the fixture-backed implementation.
  - `*_repository_providers.dart` — a provider that reads `useFakeBackend` and
    returns the mock (debug-only) or the API implementation. Going live is
    configuration, not a code change. Overridable in tests via
    `overrideWithValue(...)`.
- **`application/`** — Riverpod controllers / notifiers holding UI-facing state
  and orchestrating use-case logic. Depends on `domain/` (and on `data/` only to
  read the repository provider).
- **`presentation/`** — pages and widgets. UI only; reads state from
  `application/` controllers.

`onboarding` is intentionally lighter (`application/` + `presentation/` only) —
it is a UI-only flow with no repository or persisted entities.

---

## Mock Backend

The mock backend lets the whole app run with zero external dependencies:

- **Entry:** `flutter run -t lib/main_mock.dart` (or `--dart-define=USE_FAKE_BACKEND=true`).
- **Selection:** `useFakeBackend` returns `true` for `Env.mock`, so each slice's
  `*_repository_providers.dart` resolves its `Mock*` implementation.
- **Fixtures:** JSON under `assets/mock/<feature>/*.json`, loaded through
  `core/mock/mock_api.dart`. All fixtures are declared in `pubspec.yaml` assets
  and parse as valid JSON.
- **Fidelity:** mocks honour connectivity (online-first) — offline calls
  fast-fail exactly as the gated Dio path would.

---

## Key Subsystems

### State Management — Riverpod + Code Generation

Providers use `riverpod_annotation` (`@riverpod` / `@Riverpod`) with
`riverpod_generator`. Repository *selection* providers are hand-written plain
`Provider`s (see the fake/real split above). Riverpod's `ref` is the DI
mechanism — no `get_it` / service locator.

### Networking — Dio

`DioClient` (`core/network/`) configures a `Dio` instance with a stacked
interceptor chain (auth token attach, error mapping, retry, logging). A separate
refresh Dio reads `apiBaseUrlProvider` directly (single-brand, no tenant→dio
cycle). `InternetMonitor` drives the online-first offline gate.

### Local Storage — Drift

`core/storage/app_database.dart` defines the Drift `AppDatabase`; per-feature
DAOs live in `core/storage/dao/`. Generated `*.g.dart` / `*.drift.dart` files
are never edited by hand.

### Offline Sync

`core/sync/` holds the offline mutation queue: `mutation_dispatcher.dart`,
`sync_controller.dart`, and `sync_engine.dart`. The engine is started during
bootstrap and drains queued mutations once tokens are present.

### Router — GoRouter

`core/router/app_router.dart` builds the `GoRouter`. `auth_gate.dart` +
`redirect.dart` implement the auth guard; `route_paths.dart` centralises paths.

### Notifications

Push (FCM) + local notifications, bridged by `PushRegistration` in the
`notifications` slice and `core/platform/notifications_service.dart`. Background
handler is wired in the main isolate during bootstrap.

### Tenant

Single-tenant today, but modelled through `core/tenant/` (catalogue + controller)
so multi-tenant is a config change. Bootstrap seeds the default key when none is
persisted.

### Localisation

Flutter ARB localisation (`generate: true`). ARB files in `lib/l10n/`; active
locale managed by a settings controller and persisted to `SharedPreferences`.

### Theme

Material 3 theming from `theme/app_colors.dart`, `theme/app_text_styles.dart`,
and `theme/app_theme_mode.dart`; the active `ThemeMode` is controlled by the
settings slice.

---

## Code Generation

```bash
# One-shot (CI, fresh build)
dart run build_runner build --delete-conflicting-outputs

# Watch mode (development)
dart run build_runner watch --delete-conflicting-outputs

# Localisation only
flutter gen-l10n
```

Never hand-edit generated files: `*.g.dart` (Riverpod, JSON), `*.freezed.dart`
(Freezed), `*.drift.dart` (Drift).

---

## Adding a New Feature Slice

1. Create `lib/features/<slice>/{domain,data,application,presentation}/`.
2. **domain/** — entities + abstract repository interface (pure Dart).
3. **data/** — `api_*_repository.dart`, `mock_*_repository.dart`, and a
   `*_repository_providers.dart` selecting between them via `useFakeBackend`.
4. **application/** — controllers/notifiers holding UI state.
5. **presentation/** — pages + widgets.
6. Add mock fixtures under `assets/mock/<slice>/` and register them in
   `pubspec.yaml`.
7. Wire routes in `core/router/`.
8. Add strings to the ARB files and run `flutter gen-l10n`.
9. Run `build_runner` for any generated code.

---

## Testing

| Type                 | Location            | Tools                          |
|----------------------|---------------------|--------------------------------|
| Unit — domain/app    | `test/features/...` | `dart:test`, `mocktail`        |
| Repository           | `test/features/...` | `mocktail`, Drift in-memory DB |
| Widget               | `test/`             | `flutter_test`                 |

Override a repository in tests with
`authRepositoryProvider.overrideWithValue(mockRepo)`, or re-override
`envProvider` / `useFakeBackendProvider` to flip into fixture mode.
