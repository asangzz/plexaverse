import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_protector/screen_protector.dart';

import 'screen_protection_prefs.dart';

/// Wraps a screen that shows sensitive content (the auth page today) and
/// blocks screenshots / screen recording while it is mounted (RULINGS §12
/// hardening).
///
/// Android applies `FLAG_SECURE`; iOS obscures screenshots, screen
/// recordings, and the app-switcher preview. The platform calls are
/// best-effort and guarded, so on an unsupported platform (or in a widget
/// test with no plugin) this is a transparent pass-through — never blocking
/// the wrapped screen.
///
/// Honours the [ScreenProtection] setting (Settings → Security): when the user
/// turns protection OFF — e.g. to share their screen in a meeting — the
/// FLAG_SECURE / obscuring is not applied (and is cleared if the setting is
/// toggled while a secure screen is open).
///
/// Applied at the route level (see `app_router.dart`) so the page widget
/// stays free of the platform channel and remains directly testable.
class SecureScreen extends ConsumerStatefulWidget {
  const SecureScreen({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SecureScreen> createState() => _SecureScreenState();
}

class _SecureScreenState extends ConsumerState<SecureScreen> {
  ProviderSubscription<AsyncValue<bool>>? _sub;

  @override
  void initState() {
    super.initState();
    // Apply on mount and react to the user toggling the setting at runtime.
    // Until the setting resolves we default to protected (fail safe).
    _sub = ref.listenManual<AsyncValue<bool>>(
      screenProtectionProvider,
      (_, next) {
        final enabled = switch (next) {
          AsyncData<bool>(:final value) => value,
          _ => true,
        };
        unawaited(_setProtection(enabled: enabled));
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _sub?.close();
    // Leaving the sensitive screen always clears protection.
    unawaited(_setProtection(enabled: false));
    super.dispose();
  }

  Future<void> _setProtection({required bool enabled}) async {
    try {
      if (enabled) {
        await ScreenProtector.preventScreenshotOn();
        await ScreenProtector.protectDataLeakageOn();
      } else {
        await ScreenProtector.preventScreenshotOff();
        await ScreenProtector.protectDataLeakageOff();
      }
    } on Object {
      // Best-effort: a missing plugin / unsupported platform must not crash
      // or block the sensitive screen.
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
