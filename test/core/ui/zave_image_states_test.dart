import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/ui/app_icons.dart';
import 'package:plexaverse/core/ui/zave/zave_kit.dart';

/// A failed image must never shimmer.
///
/// ## Why this is a test
///
/// `_ZaveImageState` is BOTH the loading state and the failed one — the only
/// difference is a bool — and in the quiet tone it used to return before that
/// bool was read at all. A sweep added without noticing would have run
/// forever on a permanently broken image, telling the user to keep waiting
/// for something that is never coming. That is the most misleading thing a
/// loading indicator can do, and it is invisible in review because both
/// branches are one widget.
void main() {
  Widget host(Widget child) => MaterialApp(
    home: Scaffold(body: SizedBox(width: 200, height: 200, child: child)),
  );

  testWidgets('a source that is not an address shows no sweep', (
    WidgetTester tester,
  ) async {
    // Not http and not data: — the "nothing to load" branch, which is a
    // resting state, not an in-flight one.
    await tester.pumpWidget(host(const ZaveImage(source: 'not-a-url')));
    expect(find.byType(ZaveShimmer), findsNothing);
  });

  testWidgets('an empty source shows no sweep', (WidgetTester tester) async {
    await tester.pumpWidget(host(const ZaveImage(source: null)));
    expect(find.byType(ZaveShimmer), findsNothing);
  });

  testWidgets('a malformed data URI reads as failed, not as loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      host(
        const ZaveImage(
          source: 'data:image/png;base64,@@@not-base64@@@',
          errorMessage: 'That poster could not be loaded.',
        ),
      ),
    );

    expect(
      find.byType(ZaveShimmer),
      findsNothing,
      reason: 'a payload that will never parse is not still arriving',
    );
    expect(
      find.byIcon(AppIcons.warning),
      findsOneWidget,
      reason: 'the failed state is amber and says so',
    );
    expect(find.text('That poster could not be loaded.'), findsOneWidget);
  });

  testWidgets('the quiet tone stays silent on failure', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      host(
        const ZaveImage(
          source: 'data:image/png;base64,@@@not-base64@@@',
          tone: ZaveImageTone.quiet,
        ),
      ),
    );

    expect(find.byType(ZaveShimmer), findsNothing);
    // Quiet means quiet: no broken-image glyph on a card nobody asked to
    // load. The row still reads correctly without it.
    expect(find.byIcon(AppIcons.warning), findsNothing);
  });
}
