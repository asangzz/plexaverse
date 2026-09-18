# Plexaverse Mobile App — Work Completed

> Last updated: 24 May 2026  
> Flutter `^3.8.0` · Dart `^3.8.0` · Riverpod 3.x · GoRouter 14.x · Drift 2.x

---

## 1. Project Scaffold & Architecture

- **Clean Architecture** enforced across three layers: `domain` → `data` → `presentation`
- **Folder structure** established:
  ```
  lib/
  ├── core/          # config, constants, errors, extensions, network, router, services, utils
  ├── data/          # DAOs, database, DTOs, remote APIs, repository implementations
  ├── domain/        # entities, repository interfaces, use-cases
  ├── l10n/          # generated ARB localizations
  ├── presentation/  # features (auth, home, posts, odyssey, analytics, settings, …)
  └── theme/         # AppColors, AppTextStyles, AppTheme, AppThemeMode
  ```
- **`pubspec.yaml`** configured with all production dependencies (state management, navigation, DB, networking, Firebase, OAuth, i18n, utilities)
- **Asset folders** declared: `assets/images/`, `assets/icons/`, `assets/animations/`
- **`flutter analyze`** passes with zero issues at every milestone

---

## 2. Theme System

### Colors (`lib/theme/app_colors.dart`)
- Primary `#6C63FF` (purple), secondary `#00D4AA` (teal), full greyscale ramp (`grey50`–`grey900`)
- Semantic tokens: `success`, `warning`, `error`, `info`
- Dark/light surface + background pairs
- High-contrast palette (WCAG AAA): `hcPrimary`, `hcBackground`, `hcBorder` and dark variants

### Typography (`lib/theme/app_text_styles.dart`)
- Two font families: **Sora** (headings) + **Urbanist** (body/labels) via `google_fonts`
- Full Material 3 text scale: `displayLarge` → `labelSmall` with responsive `.sp` sizing via `ScreenUtils`

### Theme builder (`lib/theme/app_theme.dart`)
- `AppTheme.light`, `AppTheme.dark` — Material 3, `ColorScheme.fromSeed`
- `AppTheme.highContrastLight`, `AppTheme.highContrastDark` — 2px borders, no fill, passes WCAG AAA
- Themed: `AppBarTheme`, `CardThemeData`, `ElevatedButtonThemeData`, `OutlinedButtonThemeData`, `InputDecorationTheme`, `BottomNavigationBarThemeData`, `DividerThemeData`

### Theme mode (`lib/theme/app_theme_mode.dart` + `lib/presentation/features/settings/providers/theme_provider.dart`)
- `AppThemeMode` enum: `light`, `dark`, `system`, `highContrastLight`, `highContrastDark`
- `ThemeNotifier` (Riverpod code-gen) persists selection to `SharedPreferences`
- **Default theme: dark** — both `build()` initial value and `orElse` fallback set to `AppThemeMode.dark`

---

## 3. Core Infrastructure

### App entry (`lib/main.dart`)
- `WidgetsFlutterBinding.ensureInitialized()`
- **Firebase Crashlytics** — `setCrashlyticsCollectionEnabled(!kDebugMode)`, `FlutterError.onError = recordFlutterFatalError`, `PlatformDispatcher.instance.onError` wired for non-Flutter errors
- **Firebase Analytics** — collection disabled in debug
- Portrait-only orientation lock
- Transparent status bar overlay
- `ProviderScope` wrapping `PlexaverseApp`
- `NotificationService.initialize()` called post-frame

### Logging (`lib/core/utils/logger.dart`)
- `appLogger` — singleton `Logger` instance (package: `logger`)

### Screen utils (`lib/core/utils/screen_utils.dart`)
- `ScreenUtils.init(context)` called in both `PlexaverseApp.build` and `builder:` callback
- `.sp`, `.w`, `.h`, `.r` extension getters on `num` (`lib/core/extensions/num_extensions.dart`)

### App config (`lib/core/config/app_config.dart`)
- `AppConfig.baseUrl` (environment-switchable)

### Constants (`lib/core/constants/app_constants.dart`)
- `connectTimeout`, `receiveTimeout`, `maxRetries`
- `accessTokenKey`, `refreshTokenKey`, `themeModeKey`, `localeModeKey`

### Extensions
- `BuildContext` extensions: theme shortcuts, media query helpers (`lib/core/extensions/context_extensions.dart`)
- `String` extensions: capitalize, truncate, etc. (`lib/core/extensions/string_extensions.dart`)
- `num` extensions: `.sp`, `.w`, `.h`, `.r` responsive sizing (`lib/core/extensions/num_extensions.dart`)

### Type aliases (`lib/core/utils/typedef.dart`)
- `Either<Failure, T>` shorthand for `dartz`-based result types

---

## 4. Error Handling

### Domain exceptions (`lib/core/errors/exceptions.dart`)
- `ServerException(message, {statusCode})`
- `NetworkException([message])`
- `CacheException([message])`
- `UnauthorizedException([message])`
- `NotFoundException([message])`

### Domain failures (`lib/core/errors/failures.dart`)
- `Failure` sealed class hierarchy mirroring exceptions for use-case return types

---

## 5. Networking (Dio)

### Dio client (`lib/core/network/dio_client.dart`)
- `plainDioProvider` — bare Dio instance for token-refresh calls (no auth interceptor)
- `dioClientProvider` (Riverpod code-gen) — fully configured Dio with ordered interceptor chain:
  1. `PrettyDioLogger` (debug only) — **first**, so it sees raw request/response/error before any interception
  2. `AuthInterceptor` — injects `Authorization: Bearer <token>`
  3. `ResponseUnwrapInterceptor` — unwraps `{ data: ... }` envelope
  4. `ErrorInterceptor` — maps HTTP status codes to domain exceptions
  5. `RetryInterceptor` — retries on transient network failures

### Auth interceptor (`lib/core/network/interceptors/auth_interceptor.dart`)
- Reads `accessToken` from `FlutterSecureStorage` and injects header on every request
- **Silent token refresh**: on 401, acquires new token via `POST /auth/refresh`, retries original request once
- **Queued refresh**: concurrent 401s share a single refresh call via `List<Completer<String?>>`; all are resolved together
- Clears tokens from secure storage on refresh failure

### Response unwrap interceptor (`lib/core/network/interceptors/response_unwrap_interceptor.dart`)
- Transparently strips the API's `{ data: ... }` envelope so repositories receive plain payloads

### Error interceptor (`lib/core/network/interceptors/error_interceptor.dart`)
- Maps `DioExceptionType` variants → typed exceptions
- Uses `handler.next()` (not `handler.reject()`) so retry and logger interceptors still execute downstream
- Extracts `message` field from response body for user-facing error text

### Retry interceptor (`lib/core/network/interceptors/retry_interceptor.dart`)
- Retries up to `AppConstants.maxRetries` times on connection/timeout errors with exponential back-off

### Network info (`lib/core/network/network_info.dart`)
- `NetworkInfo` class wrapping `connectivity_plus`
- `networkInfoProvider` — stream of connectivity state available for UI to consume

---

## 6. Local Database (Drift / SQLite)

### Tables (`lib/data/local/database/tables.dart`) — 7 tables
| Table | Purpose |
|---|---|
| `UsersTable` | Cached user profile (remoteId, name, email, avatarUrl, role) |
| `SessionsTable` | Access + refresh token pair with expiry |
| `NotificationsTable` | Inbox of received push/local notifications |
| `PostsTable` | LinkedIn posts — draft / scheduled / published / failed |
| `PostMetricsTable` | Per-post engagement metrics (impressions, likes, comments, reposts) with cascade delete |
| `UserStatsTable` | Single-row streak, XP, level, weekly XP progress |
| `MissionsTable` | Gamification missions with status, progress, XP reward |

### Database (`lib/data/local/database/app_database.dart`)
- `AppDatabase` Drift database referencing all 7 tables
- Schema migration v1 → v2 defined

### DAOs
- `UserDao` — CRUD + upsert for user profile
- `PostsDao` — insert/update/query/delete posts + metrics join
- `NotificationDao` — insert, mark-read, unread count stream
- `UserStatsDao` — upsert single-row stats, watch stream

---

## 7. Remote API Layer (Retrofit)

### Auth API (`lib/data/remote/api/auth_api.dart`)
- `POST /auth/login` → `AuthResponseDto`
- `POST /auth/register` → `AuthResponseDto`
- `POST /auth/refresh` → token refresh
- `POST /auth/logout`

### DTOs (`lib/data/remote/dto/auth_dto.dart`)
- `LoginRequestDto`, `RegisterRequestDto`, `AuthResponseDto` — Freezed + `json_serializable`

---

## 8. Domain Layer

### Entities (all Freezed immutable value objects)
- `UserEntity` — id, name, email, avatarUrl, role
- `PostEntity` — content, hookLine, status, platform, scheduledAt, publishedAt, metrics
- `UserStatsEntity` — streakDays, xp, level, levelTitle, weeklyXp, weeklyXpGoal
- `MissionEntity` — missionKey, title, description, status, xpReward, progress, total
- `NotificationEntity` — title, body, type, payload, isRead, receivedAt
- `AnalyticsEntity` — aggregate stats for analytics dashboard

### Repository interfaces
- `AuthRepository` — login, register, logout, refresh
- `PostRepository` — CRUD + stream of posts + publish + metrics sync
- `UserStatsRepository` — watch stats, update streak/XP
- `NotificationRepository` — watch notifications, mark-read

### Use-cases (`lib/domain/usecases/auth/`)
- `LoginUsecase` — validates input, calls `AuthRepository.login`, persists tokens
- `RegisterUsecase` — validates input, calls `AuthRepository.register`
- `LogoutUsecase` — calls `AuthRepository.logout`, clears local session

---

## 9. Repository Implementations

### Auth (`lib/data/repositories/auth_repository_impl.dart`)
- Implements `AuthRepository`; uses `AuthApi` (remote) + `SessionsTable`/`UsersTable` (local)
- Catches exceptions and maps to `Failure` via `Either`

### Posts (`lib/data/repositories/post_repository_impl.dart`)
- Local-first: reads from `PostsDao`, syncs with remote in background

### User stats (`lib/data/repositories/user_stats_repository_impl.dart`)
- Watches `UserStatsDao` stream; seeds default row on first access

---

## 10. State Management (Riverpod)

### Auth state (`lib/presentation/features/auth/providers/auth_provider.dart`)
- `AuthNotifier` (Riverpod code-gen + Freezed states): `initial | loading | authenticated(user) | unauthenticated | error(message)`
- Exposes `login()`, `register()`, `logout()` methods

### Dashboard (`lib/presentation/features/home/providers/dashboard_provider.dart`)
- Aggregates user stats + recent posts into a single dashboard state

### Posts (`lib/presentation/features/posts/providers/posts_provider.dart`)
- Watches `PostRepository` stream; exposes create/update/delete

### Odyssey (`lib/presentation/features/odyssey/providers/odyssey_provider.dart`)
- Watches missions and user stats for the gamification screen

### Notifications (`lib/presentation/features/notifications/providers/notifications_provider.dart`)
- Watches unread count + notification list

### Theme (`lib/presentation/features/settings/providers/theme_provider.dart`)
- Persists + restores theme across app restarts; default dark

### Locale (`lib/presentation/features/settings/providers/locale_provider.dart`)
- Persists + restores locale; `supportedLocales`: `en`, `es`, `fr`

---

## 11. Navigation (GoRouter)

### Route definitions (`lib/core/router/app_router.dart`)
- `AppRoutes` constants for all paths
- **Redirect guard**: checks `authProvider` + `onboardingProvider` state on every navigation
  - Not onboarded → `/onboarding`
  - Unauthenticated → `/login`
  - Authenticated + on auth page → `/home`
- **Shell route** (`AppScaffold`) wraps: `/home`, `/posts`, `/odyssey`, `/analytics`, `/settings`
- **Full-screen routes** (outside shell): `/create`, `/schedule`, `/studio`, `/styleguide`
- **Page transitions**:
  - Fade — onboarding, auth
  - No transition — shell tab switches
  - Slide right — settings, schedule, studio, styleguide
  - Slide up — create post (modal feel)
- **Typed extras dispatch** on `/create`: `extra is DateTime` → pre-fills schedule date; `extra is PostEntity` → edit mode

---

## 12. Services

### Storage service (`lib/core/services/storage_service.dart`)
- `sharedPreferencesProvider` — async Riverpod provider for `SharedPreferences`
- Thin wrapper; token storage uses `FlutterSecureStorage` directly in `AuthInterceptor`

### Notification service (`lib/core/services/notification_service.dart`)
- `flutter_local_notifications` + `firebase_messaging` initialised together
- Foreground, background, and terminated-state message handlers registered
- `_handleNotificationOpened` and `_onNotificationTapped` handlers scaffolded (navigation wiring pending)

---

## 13. Onboarding

### Onboarding provider (`lib/core/providers/onboarding_provider.dart`)
- Persists completion flag to `SharedPreferences`; nullable bool (`null` = loading, `false` = unseen, `true` = complete)

### Onboarding page (`lib/presentation/features/onboarding/pages/onboarding_page.dart`)
- Multi-step page view with animated indicators
- Calls `onboardingProvider.complete()` on finish; GoRouter guard redirects to auth

---

## 14. Auth UI

### Auth page (`lib/presentation/features/auth/pages/auth_page.dart`)
- **Dual-mode**: dark (default) and light — driven by `Theme.of(context).brightness`
- Sign-in and Register tabs in a single `SegmentedButton` toggle
- Social auth: Google + LinkedIn buttons (`SocialAuthButton`) with mode-aware labels ("Continue with" vs "Sign up with")
- `AuthDivider` separator
- Form fields with inline validation, `FloatingLabelBehavior.always` in light mode
- Password field with show/hide toggle
- `PasswordStrengthBar` — live strength indicator (too short / weak / good / strong) with animated progress bar
- `ReferralCodeField` — collapsible referral input with `SizeTransition` + `FadeTransition` animation; validity checkmark / cancel icon
- `FormErrorBanner` — dismissible top-of-form error display
- CTA `FilledButton` with `StadiumBorder`, purple fill, spinner on loading state
- Light mode: grid paper `CustomPainter` background, white card overlay, `Color(0x1F000000)` borders
- Dark mode: deep navy gradient background, purple glow on logo

### Social auth button (`lib/presentation/features/auth/widgets/social_auth_button.dart`)
- Handles Google (custom `G` painter) and LinkedIn (SVG icon)
- Dark: outlined white border style; Light: white fill with grey border
- `isSignIn` parameter controls label ("Continue with" vs "Sign up with")

---

## 15. Common Widgets

| Widget | Description |
|---|---|
| `AppScaffold` | Shell scaffold with bottom `NavigationBar`; wraps all shell-route pages |
| `AppButton` | Themed `ElevatedButton` / `OutlinedButton` with loading state |
| `AppTextField` | Themed `TextField` with label, prefix icon, error display |
| `GlassCard` | `BackdropFilter` + semi-transparent container for glassmorphism cards |
| `LoadingView` | Centered `CircularProgressIndicator` with optional message |
| `ErrorView` | Icon + message + retry button |
| `EmptyView` | Illustration + message for empty states |

---

## 16. Feature Screens (Scaffold)

| Screen | Route | Status |
|---|---|---|
| Onboarding | `/onboarding` | Complete |
| Auth (login + register) | `/login` | Complete |
| Home / Dashboard | `/home` | Scaffolded |
| Posts list | `/posts` | Scaffolded |
| Create / Edit post | `/create` | Scaffolded |
| Odyssey (gamification) | `/odyssey` | Scaffolded |
| Analytics | `/analytics` | Scaffolded |
| Schedule | `/schedule` | Scaffolded |
| Studio (AI writing) | `/studio` | Scaffolded |
| Settings | `/settings` | Scaffolded |
| Styleguide | `/styleguide` | Dev-only reference |

---

## 17. Internationalisation (i18n)

- ARB-based localisation with `flutter_localizations`
- `AppLocalizations` generated delegate
- Supported locales: **English** (`en`), **Spanish** (`es`), **French** (`fr`)
- `LocaleNotifier` persists selected locale to `SharedPreferences`

---

## 18. Code Generation

All generated files (`*.g.dart`, `*.freezed.dart`) are produced by:

| Generator | Used for |
|---|---|
| `riverpod_generator` | All `@riverpod` providers and notifiers |
| `drift_dev` | Database, tables, DAOs |
| `freezed` | Immutable entities, union states |
| `json_serializable` | DTO `fromJson` / `toJson` |
| `retrofit_generator` | Retrofit API clients |

Run with: `dart run build_runner build --delete-conflicting-outputs`

---

## 19. Bug Fixes & Refactors

| Issue | Fix |
|---|---|
| Dio response bodies not appearing in debug logs | `ErrorInterceptor.onError` was calling `handler.reject()` which terminates the interceptor chain — changed to `handler.next()` so `PrettyDioLogger` and `RetryInterceptor` still run |
| `PrettyDioLogger` never logged errors | Moved from last position to first in the interceptor list — it now observes every raw request, response, and error before any other interceptor runs |
| `RetryInterceptor` never retried | Same root cause as above (`handler.reject()` short-circuited the chain); fixed by the `handler.next()` change |
| Dark mode not default on fresh install | `ThemeNotifier.build()` and `orElse` fallback both returned `AppThemeMode.system` — changed to `AppThemeMode.dark` |

---

## 20. Outstanding Items (Planned)

- [ ] Wire `networkInfoProvider` to an offline connectivity banner in `AppScaffold`
- [ ] Wire notification tap → route navigation (parse `message.data['route']` / `response.payload`)
- [ ] Connect home, posts, odyssey, analytics screens to their Riverpod providers (replace scaffold placeholders)
- [ ] Post creation: AI hook-line suggestions, character count, platform selector
- [ ] LinkedIn OAuth flow via `flutter_web_auth_2`
- [ ] Push notification deep-link routing
- [ ] End-to-end testing suite (integration tests with `flutter_test`)
- [ ] CI pipeline (GitHub Actions: analyze → test → build)
