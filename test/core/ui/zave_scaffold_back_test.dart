import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plexaverse/core/router/app_router.dart';
import 'package:plexaverse/core/ui/zave/zave_kit.dart';

/// Every screen you can push onto has a way back off it.
///
/// ## The bug
///
/// iOS has no system back button, and these routes had no edge-swipe either:
/// `_fullScreen` built a `CustomTransitionPage`, which carries no back
/// gesture. So the only way out of a pushed screen was an in-app control —
/// and nine of the 22 did not have one. Settings, Accounts, Schedules,
/// Studio, Festive and the four company screens could all be reached and then
/// could not be left.
///
/// The cause was that it was every page's own job. `ZaveScaffold` only draws a
/// header when a page passes a `title`, a `leading` or `actions`, so a screen
/// that draws its own large title inside the scroll view had no header at all
/// — and therefore nowhere to put a back button even if its author wanted one.
///
/// ## What is pinned
///
/// Both halves, because they fail independently: the gesture can be lost by
/// changing a page type, and the button can be lost by changing a condition.
void main() {
  group('ZaveScaffold supplies the back control', () {
    testWidgets('a pushed screen gets one', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(body: SizedBox()),
          routes: <String, WidgetBuilder>{
            '/next': (_) => const ZaveScaffold(body: SizedBox()),
          },
        ),
      );

      tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/next');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('tapping it pops', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(body: Text('root')),
          routes: <String, WidgetBuilder>{
            '/next': (_) => const ZaveScaffold(body: Text('pushed')),
          },
        ),
      );

      tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/next');
      await tester.pumpAndSettle();
      expect(find.text('pushed'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('root'), findsOneWidget);
    });

    testWidgets('a root screen does NOT get one', (WidgetTester tester) async {
      // The four shell branches sit at the root of their navigator. A back
      // arrow on Home would point at nothing.
      await tester.pumpWidget(
        const MaterialApp(home: ZaveScaffold(body: SizedBox())),
      );
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('a page that passes its own leading keeps it', (
      WidgetTester tester,
    ) async {
      // The auth page puts a back arrow there that unwinds its OWN email
      // sub-step rather than popping the route. Overriding that would break it.
      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(body: SizedBox()),
          routes: <String, WidgetBuilder>{
            '/next': (_) => const ZaveScaffold(
              leading: Icon(Icons.close),
              body: SizedBox(),
            ),
          },
        ),
      );

      tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/next');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });
  });

  group('the expanded header', () {
    testWidgets('carries the large title and subtitle', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ZaveScaffold(
            largeTitle: 'Settings',
            subtitle: 'Manage integrations and preferences',
            body: SizedBox(),
          ),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Manage integrations and preferences'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('does not overflow at a range of heights', (
      WidgetTester tester,
    ) async {
      // The Scaffold can hand the header a pixel less than `preferredSize`
      // asked for — rounding, or a harness with no status-bar inset — and a
      // rigid control row then overflowed the Column by exactly that pixel.
      // It surfaced as three red RenderFlex failures in this file rather than
      // anywhere near the header, so the sizes are swept here directly.
      for (final double h in <double>[600, 700, 812, 900]) {
        tester.view.physicalSize = Size(390 * 3, h * 3);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          const MaterialApp(
            home: ZaveScaffold(
              largeTitle: 'Your Persona',
              subtitle: 'Everything Plexa knows about you',
              body: SizedBox(),
            ),
          ),
        );
        expect(tester.takeException(), isNull, reason: 'overflowed at ${h}px');
      }
    });

    testWidgets('a long title truncates rather than growing the bar', (
      WidgetTester tester,
    ) async {
      // `preferredSize` has to be known before layout, so a title that wrapped
      // would be clipped by the Scaffold rather than making room for itself.
      await tester.pumpWidget(
        const MaterialApp(
          home: ZaveScaffold(
            largeTitle: 'A title far longer than any screen in this app uses',
            body: SizedBox(),
          ),
        ),
      );

      final Text title = tester.widget<Text>(
        find.text('A title far longer than any screen in this app uses'),
      );
      expect(title.maxLines, 1);
      expect(title.overflow, TextOverflow.ellipsis);
      expect(tester.takeException(), isNull);
    });

    testWidgets('title and largeTitle together is a programming error', (
      WidgetTester tester,
    ) async {
      // Two renderings of the same thing. A screen never wears both.
      await tester.pumpWidget(
        const MaterialApp(
          home: ZaveScaffold(
            title: 'Settings',
            largeTitle: 'Settings',
            body: SizedBox(),
          ),
        ),
      );
      expect(tester.takeException(), isA<AssertionError>());
    });
  });

  group('pushed routes carry the back gesture', () {
    testWidgets('every full-screen route builds a page that supports it', (
      WidgetTester tester,
    ) async {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);
      final GoRouter router = container.read(appRouterProvider);

      // A real BuildContext for the page builders, from a pumped widget.
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      final BuildContext context = tester.element(find.byType(SizedBox));

      // The root-navigator routes that are not the shell: these are the
      // pushed, full-screen screens.
      final List<GoRoute> pushed = router.configuration.routes
          .whereType<GoRoute>()
          .where(
            (GoRoute r) =>
                r.parentNavigatorKey != null && r.pageBuilder != null,
          )
          .toList();

      expect(
        pushed,
        isNotEmpty,
        reason: 'no full-screen routes found — has _fullScreen changed?',
      );

      for (final GoRoute route in pushed) {
        // `/posts/:id` reads its parameter with a null check, so a synthetic
        // state has to carry one or the builder throws before we can look at
        // the page type.
        final Map<String, String> params = <String, String>{
          for (final String seg in route.path.split('/'))
            if (seg.startsWith(':')) seg.substring(1): 'x',
        };

        final Page<Object?> page =
            route.pageBuilder!(
                  context,
                  GoRouterState(
                    router.configuration,
                    uri: Uri.parse(route.path),
                    matchedLocation: route.path,
                    pageKey: ValueKey<String>(route.path),
                    pathParameters: params,
                    fullPath: route.path,
                  ),
                )
                as Page<Object?>;

        expect(
          page,
          isA<CupertinoPage<Object?>>(),
          reason:
              '${route.path} is not a CupertinoPage, so it has no iOS '
              'edge-swipe back — and iOS has no system back button.',
        );
      }
    });
  });
}
