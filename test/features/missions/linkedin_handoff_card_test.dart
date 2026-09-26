import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/platform/link_opening.dart';
import 'package:plexaverse/features/missions/presentation/widgets/linkedin_handoff_card.dart';

/// The mission hand-off card's "Open LinkedIn" button.
///
/// This surface is covered here rather than by hand because nothing in the app
/// navigates to `/roadmap/headline-hook` or `/roadmap/about-odyssey` yet — the
/// routes are registered and the pages are unreachable, so the card cannot be
/// tapped on a device at all. A test is the only way to exercise it, and it
/// keeps working once those entry points land.
///
/// What matters here is that the card builds the edit URL from the slug and
/// hands THAT to the seam. The card is the one place in the app that composes
/// a LinkedIn URL itself instead of being given one by the server, so a wrong
/// path here sends the user to the wrong screen inside LinkedIn — which reads
/// as a broken link rather than a missing one.
class _RecordingLinkOpening implements LinkOpeningService {
  final List<String> opened = <String>[];

  /// Always succeeds. The fallback-to-clipboard branch belongs to
  /// `openLinkOrCopy` and is covered in `test/core/ui/open_link_test.dart`;
  /// repeating it here would test the helper twice and the card not at all.
  @override
  Future<LinkOpenResult> open(String url) async {
    opened.add(url);
    return const LinkOpened();
  }
}

Future<void> _pump(
  WidgetTester tester,
  LinkOpeningService service, {
  required String? slug,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [linkOpeningProvider.overrideWithValue(service)],
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: LinkedInHandoffCard(
              title: 'Update it on LinkedIn',
              payload: 'the headline text',
              copyLabel: 'Copy headline',
              slug: slug,
              editPath: 'edit/forms/intro/new/',
              steps: const <String>['Open the editor', 'Paste it'],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('opens the composed edit URL, not the bare profile', (
    WidgetTester tester,
  ) async {
    final _RecordingLinkOpening service = _RecordingLinkOpening();
    await _pump(tester, service, slug: 'asang-borkar');

    await tester.tap(find.text('Open LinkedIn'));
    await tester.pumpAndSettle();

    expect(service.opened, <String>[
      'https://www.linkedin.com/in/asang-borkar/edit/forms/intro/new/',
    ]);
  });

  testWidgets('still shows the literal URL beside the button', (
    WidgetTester tester,
  ) async {
    // The button replaced a "paste this in your browser" heading, not the URL
    // underneath it. A user whose hand-off fails still needs the address, and
    // the card cannot regenerate it for them.
    await _pump(tester, _RecordingLinkOpening(), slug: 'asang-borkar');

    expect(
      find.text(
        'https://www.linkedin.com/in/asang-borkar/edit/forms/intro/new/',
      ),
      findsOneWidget,
    );
    expect(find.text('Copy link'), findsOneWidget);
  });

  testWidgets('offers nothing to open when no account is connected', (
    WidgetTester tester,
  ) async {
    // Null slug is the one case where no URL can be built. The card must fall
    // back to the "connect an account" note rather than render a button that
    // would open linkedin.com/in/null/.
    await _pump(tester, _RecordingLinkOpening(), slug: null);

    expect(find.text('Open LinkedIn'), findsNothing);
    expect(find.textContaining('Connect a LinkedIn account'), findsOneWidget);
  });
}
