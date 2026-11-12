import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Screens that send a user back after a roadmap step land on the ROADMAP.
///
/// The web moved them on 11 Nov 2026 (`ccd7bfb`): `/comments`,
/// `/title-creator` and `/journey-complete` all `router.push('/roadmap')`,
/// because `/dashboard` stopped being the roadmap and became a redirect to
/// the contest. A finish that still named the dashboard would drop the user on
/// the contest — a different screen from the one they started the step on.
///
/// A source scan rather than three widget tests: two of these screens need a
/// planner, a LinkedIn account and an AI fake standing before they will
/// finish anything, and what is being pinned is one route constant each.
/// `journey_complete_page_test.dart` drives the third for real.
void main() {
  const List<String> finishers = <String>[
    'lib/features/engagement/presentation/pages/comments_page.dart',
    'lib/features/studio/presentation/pages/title_creator_page.dart',
    'lib/features/missions/presentation/pages/journey_complete_page.dart',
  ];

  String code(String path) => File(path)
      .readAsStringSync()
      .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
      .replaceAll(RegExp(r'//[^\n]*'), '');

  for (final String path in finishers) {
    test('$path finishes on the roadmap', () {
      final String source = code(path);
      expect(
        source,
        isNot(contains('ZaveRoutes.dashboard')),
        reason: '/dashboard redirects to the contest now',
      );
      expect(source, contains('ZaveRoutes.roadmap'));
    });
  }
}
