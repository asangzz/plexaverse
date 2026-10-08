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

  group('the expanded header collapses on scroll', () {
    /// A page tall enough to scroll.
    Widget host({String? subtitle}) => MaterialApp(
      home: ZaveScaffold(
        largeTitle: 'Your Persona',
        subtitle: subtitle,
        body: ListView(
          key: const Key('probe'),
          children: <Widget>[
            for (int i = 0; i < 40; i++)
              SizedBox(height: 60, child: Text('row $i')),
          ],
        ),
      ),
    );

    double headerHeight(WidgetTester tester) =>
        tester.getSize(find.byKey(zaveSliverHeaderKey)).height;

    testWidgets('opens expanded and shrinks to the control row', (
      WidgetTester tester,
    ) async {
      // The whole point: a 34px title is an entrance, not a fixture. It costs
      // ~90px of a phone screen on every frame it stays pinned.
      await tester.pumpWidget(host(subtitle: 'Everything Plexa knows'));
      await tester.pumpAndSettle();

      final double open = headerHeight(tester);

      await tester.drag(find.byKey(const Key('probe')), const Offset(0, -400));
      await tester.pumpAndSettle();

      final double collapsed = headerHeight(tester);

      expect(
        collapsed,
        lessThan(open),
        reason: 'the header did not collapse — it is still a fixed bar',
      );
      expect(
        open - collapsed,
        greaterThan(40),
        reason: 'it collapsed by less than the title block it should shed',
      );
    });

    testWidgets('the control row survives the collapse', (
      WidgetTester tester,
    ) async {
      // Pinned, not floating away: the back button has to stay reachable at
      // any scroll offset, which is the entire reason it was added.
      await tester.pumpWidget(host());
      await tester.drag(find.byKey(const Key('probe')), const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsNothing); // root route
      expect(headerHeight(tester), greaterThan(0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('the title is on screen at both ends of the scroll', (
      WidgetTester tester,
    ) async {
      // Two renderings of one string — the big one leaves as the compact one
      // arrives — so the screen is never nameless mid-scroll.
      await tester.pumpWidget(host(subtitle: 'Everything Plexa knows'));
      await tester.pumpAndSettle();
      expect(find.text('Your Persona'), findsWidgets);

      await tester.drag(find.byKey(const Key('probe')), const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(find.text('Your Persona'), findsWidgets);
    });

    testWidgets('content starts BELOW the header, not behind it', (
      WidgetTester tester,
    ) async {
      // The failure this replaces: the body cleared only the control row, so
      // its first rows sat behind the bar and could not be scrolled out.
      await tester.pumpWidget(host(subtitle: 'Everything Plexa knows'));
      await tester.pumpAndSettle();

      final double headerBottom = tester
          .getRect(find.byKey(zaveSliverHeaderKey))
          .bottom;
      final double firstRowTop = tester.getRect(find.text('row 0')).top;

      expect(
        firstRowTop,
        greaterThanOrEqualTo(headerBottom - 0.5),
        reason: 'the first row is underneath the header',
      );
    });

    testWidgets('a long title truncates rather than growing the bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ZaveScaffold(
            largeTitle: 'A title far longer than any screen in this app uses',
            body: SizedBox(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (final Text t
          in tester
              .widgetList<Text>(
                find.text(
                  'A title far longer than any screen in this app uses',
                ),
              )
              .toList()) {
        expect(t.maxLines, 1);
        expect(t.overflow, TextOverflow.ellipsis);
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('title and largeTitle together is a programming error', (
      WidgetTester tester,
    ) async {
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

  group('the body clears the header it was given', () {
    /// What a scrolling body is told to leave clear at the top.
    double publishedInset(WidgetTester tester) {
      final BuildContext ctx = tester.element(find.byKey(const Key('probe')));
      return ZaveScaffold.contentTop(ctx);
    }

    /// What the COMPACT header actually occupies. `_ZaveHeader` is private and
    /// is a bare PreferredSizeWidget rather than an AppBar, so it is matched
    /// by type name.
    double headerHeight(WidgetTester tester) => tester
        .getSize(
          find.byWidgetPredicate(
            (Widget w) => w.runtimeType.toString() == '_ZaveHeader',
          ),
        )
        .height;

    testWidgets('an EXPANDED header publishes no inset — it is a sliver', (
      WidgetTester tester,
    ) async {
      // It used to be a pinned appBar whose body padded to clear it. It is a
      // NestedScrollView header now, which lays the body out BELOW itself, so
      // publishing a clearance as well would push the first item down by the
      // header height twice over. "content starts BELOW the header" above is
      // what proves the body is genuinely clear of it.
      await tester.pumpWidget(
        const MaterialApp(
          home: ZaveScaffold(
            largeTitle: 'Settings',
            subtitle: 'Manage integrations and preferences',
            body: SizedBox(key: Key('probe')),
          ),
        ),
      );
      expect(publishedInset(tester), 0);
    });

    testWidgets('a COMPACT header still publishes its own height', (
      WidgetTester tester,
    ) async {
      // Unchanged, deliberately: one 56px row has nothing worth reclaiming,
      // and its body scrolls under the blur the way the web's sticky header
      // does — which needs the clearance published. This is the arithmetic
      // that silently went 90px short when the header learned to expand, so
      // it is measured against the header rather than described again.
      await tester.pumpWidget(
        const MaterialApp(
          home: ZaveScaffold(
            title: 'Schedules',
            body: SizedBox(key: Key('probe')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        publishedInset(tester),
        moreOrLessEquals(headerHeight(tester), epsilon: 0.5),
        reason:
            'the clearance a body is told to leave and the space the header '
            'actually takes have drifted apart',
      );
    });

    testWidgets('no header publishes no inset', (WidgetTester tester) async {
      // SafeArea(top: true) already consumes the status bar there; publishing
      // it again double-padded every headerless screen by the notch height.
      await tester.pumpWidget(
        const MaterialApp(
          home: ZaveScaffold(body: SizedBox(key: Key('probe'))),
        ),
      );
      expect(publishedInset(tester), 0);
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
