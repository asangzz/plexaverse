import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/onboarding_controller.dart';

/// First-run onboarding carousel (pre-auth gate).
///
/// Ported from `lib/presentation/features/onboarding/pages/onboarding_page.dart`.
/// Visuals are unchanged (three-slide `PageView`, animated dots, skip / next /
/// get-started controls) per the ruling that product UI stays; the file is
/// moved into the feature-first `presentation` layer and rewired:
///   - `HookConsumerWidget` + `usePageController`/`useState` →
///     [ConsumerStatefulWidget] + a plain [PageController] and `setState`
///     (flutter_hooks is removed from the project).
///   - `context.l10n` (the retired extension) → `AppL10n.of(context)`.
///   - `context.colors` / `context.textTheme` → `Theme.of(context)`.
///   - `.w/.h/.r` now resolve against the core responsive `ScreenUtil`.
///
/// Completion no longer navigates imperatively. The old page called
/// `context.go(AppRoutes.login)` after flipping the flag; the ProHealth-style
/// router owns that transition declaratively — completing onboarding mutates
/// [OnboardingController], the router's `refreshListenable` re-runs the guard,
/// and the onboarding gate releases the user to `/login` (or `/home` if already
/// signed in). This page only records completion.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _skip() => _finish();

  /// Records completion. The router redirect reacts to the state change and
  /// moves the user on — no imperative navigation here.
  void _finish() {
    ref.read(onboardingControllerProvider.notifier).complete();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (!isLast)
                    TextButton(
                      onPressed: _skip,
                      child: Text(l10n.skip),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (int i) => setState(() => _currentPage = i),
                itemBuilder: (BuildContext context, int index) =>
                    _OnboardingSlide(data: _pages[index]),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                children: <Widget>[
                  _DotsIndicator(
                    count: _pages.length,
                    current: _currentPage,
                  ),
                  SizedBox(height: 24.h),
                  FilledButton(
                    onPressed: _next,
                    style: FilledButton.styleFrom(
                      minimumSize: Size(double.infinity, 52.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(isLast ? l10n.getStarted : l10n.next),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.data});

  final _OnboardingData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            data.icon,
            size: 96.r,
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 40.h),
          Text(
            data.title,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Text(
            data.body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(count, (int i) {
        final bool isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: isActive ? 24.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isActive
                ? scheme.primary
                : scheme.onSurface.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}

class _OnboardingData {
  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

/// The three-slide first-run pitch. Copy is intentionally hard-coded English
/// (as in the pre-migration page) — these marketing strings were never in the
/// ARB catalogue; only the skip / next / get-started controls are localized.
const List<_OnboardingData> _pages = <_OnboardingData>[
  _OnboardingData(
    icon: Icons.rocket_launch_outlined,
    title: 'Welcome to Plexaverse',
    body: 'Your all-in-one platform for managing\nprojects, teams, and tasks.',
  ),
  _OnboardingData(
    icon: Icons.dashboard_outlined,
    title: 'Stay Organised',
    body: 'Track progress in real time with\npowerful dashboards and insights.',
  ),
  _OnboardingData(
    icon: Icons.group_outlined,
    title: 'Collaborate Anywhere',
    body: 'Work seamlessly with your team,\nwherever you are.',
  ),
];
