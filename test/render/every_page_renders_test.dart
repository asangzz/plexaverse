import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:plexaverse/core/config/env.dart';

import 'package:plexaverse/features/auth/presentation/pages/auth_page.dart';
import 'package:plexaverse/features/calendar/presentation/pages/calendar_page.dart';
import 'package:plexaverse/features/calendar/presentation/pages/schedules_page.dart';
import 'package:plexaverse/features/company/presentation/pages/company_advocacy_page.dart';
import 'package:plexaverse/features/company/presentation/pages/company_analytics_page.dart';
import 'package:plexaverse/features/company/presentation/pages/company_banner_page.dart';
import 'package:plexaverse/features/company/presentation/pages/company_inbox_page.dart';
import 'package:plexaverse/features/compose/presentation/pages/compose_page.dart';
import 'package:plexaverse/features/engagement/presentation/pages/comments_page.dart';
import 'package:plexaverse/features/engagement/presentation/pages/connections_page.dart';
import 'package:plexaverse/features/home/presentation/pages/home_page.dart';
import 'package:plexaverse/features/missions/presentation/pages/about_odyssey_page.dart';
import 'package:plexaverse/features/missions/presentation/pages/banner_blueprint_page.dart';
import 'package:plexaverse/features/missions/presentation/pages/headline_hook_page.dart';
import 'package:plexaverse/features/missions/presentation/pages/season_complete_page.dart';
import 'package:plexaverse/features/persona/presentation/pages/persona_page.dart';
import 'package:plexaverse/features/planner/presentation/pages/planner_page.dart';
import 'package:plexaverse/features/posts/presentation/pages/post_detail_page.dart';
import 'package:plexaverse/features/posts/presentation/pages/posts_page.dart';
import 'package:plexaverse/features/pricing/presentation/pages/pricing_page.dart';
import 'package:plexaverse/features/settings/presentation/pages/accounts_page.dart';
import 'package:plexaverse/features/settings/presentation/pages/settings_page.dart';
import 'package:plexaverse/features/topics/presentation/pages/topics_page.dart';

/// Every page, pumped at every width the product ships on, asserting that
/// nothing throws.
///
/// ## Why this exists
///
/// Three render faults shipped in one day's work, and all three were found by
/// eye — a 114px overflow in the planner's week navigation, a 41px one in the
/// slot card's today row, and a chip that threw `BoxBorder.lerp` on every tap.
/// Each was invisible to the whole suite, because a widget test only sees what
/// it pumps and nothing pumped these screens at a width where they broke.
///
/// Overflows are width-dependent and silent in release: `RenderFlex
/// overflowed` is a debug-only assertion, so a layout that bursts on a small
/// phone ships looking fine on the developer's large one. The narrow entries
/// below are the point of this file.
///
/// ## What a failure here means
///
/// The page threw during build, layout or paint. Read the reason — it is
/// usually `A RenderFlex overflowed by N pixels`, naming the Row or Column.
/// It is a real defect at that width, not a test artifact.
void main() {
  /// The fakes serve picsum URLs for uploaded images. `NetworkImage` in a test
  /// has no network and throws, which would be a false failure about something
  /// this file is not testing — so every request answers with a 1x1 PNG.
  setUpAll(() => HttpOverrides.global = _TransparentPixelHttp());
  tearDownAll(() => HttpOverrides.global = null);

  /// Widths the product actually meets. The narrow one is the point: an
  /// overflow is a function of width, and the roomy one hides it.
  const Map<String, Size> sizes = <String, Size>{
    'iPhone SE (narrowest)': Size(375, 667),
    'iPhone 16 Pro': Size(402, 874),
    'iPhone Pro Max': Size(430, 932),
  };

  /// Every page the app can show. Constructed, not routed — a route needs a
  /// session and a redirect chain, and what is under test is the layout.
  final Map<String, Widget Function()> pages = <String, Widget Function()>{
    'Home': () => const HomePage(),
    'Planner': () => const PlannerPage(),
    'Calendar': () => const CalendarPage(),
    'Posts': () => const PostsPage(),
    'Post detail': () => const PostDetailPage(postId: 'mock-post-1'),
    'Persona': () => const PersonaPage(),
    'Settings': () => const SettingsPage(),
    'Accounts': () => const AccountsPage(),
    'Schedules': () => const SchedulesPage(),
    'Topics': () => const TopicsPage(),
    'Pricing': () => const PricingPage(),
    'Compose': () => const ComposePage(),
    'Comments': () => const CommentsPage(),
    'Connections': () => const ConnectionsPage(),
    'Auth': () => const AuthPage(),
    'About Odyssey': () => const AboutOdysseyPage(),
    'Headline Hook': () => const HeadlineHookPage(),
    'Banner Blueprint': () => const BannerBlueprintPage(),
    'Season Complete': () => const SeasonCompletePage(),
    'Company analytics': () => const CompanyAnalyticsPage(),
    'Company inbox': () => const CompanyInboxPage(),
    'Company advocacy': () => const CompanyAdvocacyPage(),
    'Company banner': () => const CompanyBannerPage(),
  };

  for (final MapEntry<String, Size> size in sizes.entries) {
    group(size.key, () {
      for (final MapEntry<String, Widget Function()> page in pages.entries) {
        testWidgets(page.key, (WidgetTester tester) async {
          tester.view.physicalSize = size.value * 3;
          tester.view.devicePixelRatio = 3;
          addTearDown(tester.view.reset);

          // A real router, because some pages read one during BUILD — Topics
          // calls into GoRouter before it paints anything, and a bare
          // MaterialApp made it throw "No GoRouter found in context", which
          // reads like a page fault and is really a harness gap. One route,
          // so the page is the whole app.
          final GoRouter router = GoRouter(
            routes: <RouteBase>[
              GoRoute(path: '/', builder: (_, _) => page.value()),
            ],
          );
          addTearDown(router.dispose);

          await tester.pumpWidget(
            ProviderScope(
              // Resolves every repository to its in-memory fake, so the page
              // gets the same shaped data the mock flavour shows.
              overrides: [envProvider.overrideWithValue(Env.mock)],
              child: MaterialApp.router(routerConfig: router),
            ),
          );

          // The fakes answer after a delay. Pump past it in steps rather than
          // settling: a page with a looping animation never settles, and the
          // frames in between are where a transient overflow lives.
          for (int i = 0; i < 12; i++) {
            await tester.pump(const Duration(milliseconds: 120));
            final Object? error = tester.takeException();
            expect(
              error,
              isNull,
              reason: '${page.key} threw at ${size.key}:\n$error',
            );
          }
        });
      }
    });
  }
}

/// Answers every image request with a 1x1 transparent PNG.
class _TransparentPixelHttp extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _FakeClient();
}

const List<int> _kPixel = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];

class _FakeClient implements HttpClient {
  @override
  bool autoUncompress = true;
  @override
  Duration? connectionTimeout;
  @override
  Duration idleTimeout = const Duration(seconds: 15);
  @override
  int? maxConnectionsPerHost;
  @override
  String? userAgent;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeRequest();
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async =>
      _FakeRequest();

  @override
  void close({bool force = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _FakeHeaders();

  @override
  Future<HttpClientResponse> close() async => _FakeResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeResponse implements HttpClientResponse {
  @override
  int statusCode = HttpStatus.ok;
  @override
  int contentLength = _kPixel.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
  @override
  final HttpHeaders headers = _FakeHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) => Stream<List<int>>.value(Uint8List.fromList(_kPixel)).listen(
    onData,
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
