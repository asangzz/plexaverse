import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../l10n/gen/app_localizations.dart';
import 'package:plexaverse/core/theme/app_theme_mode.dart';
import '../../../auth/application/sign_out_controller.dart';
import '../../application/locale_controller.dart';
import '../../application/theme_controller.dart';
import '../widgets/settings_profile_header.dart';

// ── Settings page ─────────────────────────────────────────────────────────────
//
// Ported from `lib/presentation/features/settings/pages/settings_page.dart`.
// Visuals are unchanged (RULINGS: product UI stays); the plumbing was rewired
// to the feature slice:
//   • theme mode  ← `themeProvider` (generated from `ThemeNotifier`)
//   • locale      ← `localeProvider` (generated from `LocaleNotifier`)
//   • sign-out    → `signOutControllerProvider.signOut()` (the SINGLE sign-out
//                   path — router redirects on the auth-gate flip, so no manual
//                   `context.go(login)` here, unlike the legacy page)
//   • strings     → `AppL10n.of(context)` (was `context.l10n`)
//   • colours     → `Theme.of(context).colorScheme` / `context.brand`
//   • sizing      → the new `core/responsive/screen_util.dart` extensions
// A profile header (avatar + name + handle) now sits at the top, fed by the
// bundled `assets/mock/settings/profile.json` fixture.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        children: [
          const SettingsProfileHeader(),
          const Divider(),
          _SectionHeader(l.themeLabel),
          _ThemeTile(current: themeMode),
          const Divider(),
          _SectionHeader(l.languageLabel),
          _LanguageTile(current: locale),
          const Divider(),
          _SectionHeader(l.notificationsLabel),
          SwitchListTile(
            title: Text(l.enableNotifications),
            value: true,
            onChanged: (_) {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l.privacyPolicy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l.termsOfService),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          _SectionHeader(l.developerLabel),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l.styleGuideLabel),
            subtitle: Text(l.styleGuideSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(RoutePaths.styleguide),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snap) => ListTile(
              leading: const Icon(Icons.info_outlined),
              title: Text(l.versionLabel),
              trailing: snap.hasData
                  ? Text('v${snap.data!.version}+${snap.data!.buildNumber}')
                  : null,
            ),
          ),
          const Divider(),
          Builder(
            builder: (context) {
              final errorColor = Theme.of(context).colorScheme.error;
              return ListTile(
                leading: Icon(Icons.logout, color: errorColor),
                title: Text(l.logout, style: TextStyle(color: errorColor)),
                onTap: () => _confirmLogout(context, ref),
              );
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final l = AppL10n.of(context);
    final logoutLabel = l.logout;
    final cancelLabel = l.cancel;
    final confirmLabel = l.confirm;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(logoutLabel),
        // TODO(l10n): add a `signOutConfirmBody` ARB key; hardcoded EN for now.
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: Text(cancelLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      // The SINGLE sign-out path. It clears the session and flips the auth
      // gate; the router's redirect handles navigation to `/login`, so there
      // is deliberately no `context.go(...)` here.
      await ref.read(signOutControllerProvider.notifier).signOut();
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ── Theme mode tile + picker ────────────────────────────────────────────────

class _ThemeTile extends ConsumerWidget {
  const _ThemeTile({required this.current});

  final AppThemeMode current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(_themeIcon(current)),
      title: Text(AppL10n.of(context).themeLabel),
      subtitle: Text(_themeLabel(context, current)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        builder: (_) => _ThemePicker(current: current),
      ),
    );
  }
}

class _ThemePicker extends ConsumerWidget {
  const _ThemePicker({required this.current});

  final AppThemeMode current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetGrabber(),
          for (final mode in AppThemeMode.values)
            RadioListTile<AppThemeMode>(
              value: mode,
              // ignore: deprecated_member_use
              groupValue: current,
              title: Text(_themeLabel(context, mode)),
              secondary: Icon(_themeIcon(mode)),
              // ignore: deprecated_member_use
              onChanged: (v) {
                if (v != null) {
                  ref.read(themeProvider.notifier).setTheme(v);
                  Navigator.pop(context);
                }
              },
            ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

IconData _themeIcon(AppThemeMode mode) => switch (mode) {
      AppThemeMode.light => Icons.light_mode,
      AppThemeMode.dark => Icons.dark_mode,
      AppThemeMode.system => Icons.brightness_auto,
      AppThemeMode.highContrastLight => Icons.contrast,
      AppThemeMode.highContrastDark => Icons.contrast,
    };

String _themeLabel(BuildContext context, AppThemeMode mode) {
  final l = AppL10n.of(context);
  return switch (mode) {
    AppThemeMode.light => l.lightTheme,
    AppThemeMode.dark => l.darkTheme,
    AppThemeMode.system => l.systemTheme,
    AppThemeMode.highContrastLight => l.highContrastLightTheme,
    AppThemeMode.highContrastDark => l.highContrastDarkTheme,
  };
}

// ── Language tile + picker ──────────────────────────────────────────────────

class _LanguageTile extends ConsumerWidget {
  const _LanguageTile({required this.current});

  final Locale current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(AppL10n.of(context).languageLabel),
      subtitle: Text(_localeLabel(context, current)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        builder: (_) => _LanguagePicker(current: current),
      ),
    );
  }
}

class _LanguagePicker extends ConsumerWidget {
  const _LanguagePicker({required this.current});

  final Locale current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetGrabber(),
          for (final locale in LocaleNotifier.supportedLocales)
            RadioListTile<Locale>(
              value: locale,
              // ignore: deprecated_member_use
              groupValue: current,
              title: Text(_localeLabel(context, locale)),
              // ignore: deprecated_member_use
              onChanged: (v) {
                if (v != null) {
                  ref.read(localeProvider.notifier).setLocale(v);
                  Navigator.pop(context);
                }
              },
            ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

String _localeLabel(BuildContext context, Locale locale) {
  final l = AppL10n.of(context);
  return switch (locale.languageCode) {
    'es' => l.spanish,
    'fr' => l.french,
    _ => l.english,
  };
}

/// The rounded drag handle shared by both bottom-sheet pickers.
class _SheetGrabber extends StatelessWidget {
  const _SheetGrabber();

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: onSurface.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }
}
