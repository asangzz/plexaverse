import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/ui/app_icons.dart';
import 'package:plexaverse/core/ui/zave/zave_kit.dart';

/// The one empty state, in both of its shapes.
///
/// ## Why `boxed` is the test that matters
///
/// Because getting it wrong is invisible in isolation and obvious in place.
/// Settings wraps every section's child in a [ZaveCard]; a component that
/// draws its own would put a bordered card inside a bordered card. That is
/// not hypothetical — this codebase shipped exactly that defect for every
/// loading and failing section in Settings, and it survived review because
/// nobody looks at a section while it is loading.
void main() {
  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('the card layout carries dot, kicker, title, body, action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      host(
        ZaveEmptyState(
          title: 'No topics yet',
          body: 'Create your first topic to start generating content',
          action: ZaveButton(label: 'Create Topic', onPressed: () {}),
        ),
      ),
    );

    expect(find.text('NOTHING HERE'), findsOneWidget);
    expect(find.text('No topics yet'), findsOneWidget);
    expect(
      find.text('Create your first topic to start generating content'),
      findsOneWidget,
    );
    expect(find.text('Create Topic'), findsOneWidget);
    expect(find.byType(ZaveDot), findsOneWidget);
    expect(find.byType(ZaveCard), findsOneWidget);
  });

  testWidgets('body and action are both optional', (WidgetTester tester) async {
    await tester.pumpWidget(host(const ZaveEmptyState(title: 'Nothing')));
    expect(find.text('Nothing'), findsOneWidget);
    expect(find.byType(ZaveButton), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('boxed: false draws no card of its own', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      host(const ZaveEmptyState(title: 'Nothing', boxed: false)),
    );
    expect(
      find.byType(ZaveCard),
      findsNothing,
      reason:
          'the caller supplies the card here; drawing one would nest a '
          'bordered card inside a bordered card',
    );
    expect(find.text('Nothing'), findsOneWidget);
  });

  testWidgets('the kicker is overridable', (WidgetTester tester) async {
    // "All caught up" and "nothing here" are not the same news.
    await tester.pumpWidget(
      host(
        const ZaveEmptyState(title: 'All caught up', kicker: 'ALL CAUGHT UP'),
      ),
    );
    expect(find.text('ALL CAUGHT UP'), findsOneWidget);
    expect(find.text('NOTHING HERE'), findsNothing);
  });

  testWidgets('the pane layout leads with a glyph and centres', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      host(
        const ZaveEmptyState(
          title: 'All caught up',
          body: 'Notifications will appear here.',
          icon: AppIcons.notifications,
          layout: ZaveEmptyLayout.pane,
        ),
      ),
    );

    expect(find.byIcon(AppIcons.notifications), findsOneWidget);
    expect(find.text('All caught up'), findsOneWidget);
    // A pane fills the space it is given rather than sitting in a card at
    // the top of it.
    expect(find.byType(ZaveCard), findsNothing);
    expect(find.byType(Center), findsWidgets);
  });

  testWidgets('the pane falls back to the empty glyph', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      host(
        const ZaveEmptyState(
          title: 'Nothing here',
          layout: ZaveEmptyLayout.pane,
        ),
      ),
    );
    expect(find.byIcon(AppIcons.empty), findsOneWidget);
  });

  testWidgets('the pane survives a box too small for it', (
    WidgetTester tester,
  ) async {
    // Found on the simulator, in the style guide's own specimen: a glyph, a
    // heading and two lines of body do not fit in every box a caller hands
    // this, and an overflowing Column paints stripes across the copy. A
    // short sheet, a landscape phone or a reader at 200% text all produce
    // it.
    await tester.pumpWidget(
      host(
        const SizedBox(
          height: 120,
          child: ZaveEmptyState(
            title: 'All caught up',
            body:
                'Notifications will appear here when your posts go live '
                'or missions complete.',
            icon: AppIcons.notifications,
            layout: ZaveEmptyLayout.pane,
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('a long kicker ellipsises rather than overflowing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      host(
        const SizedBox(
          width: 160,
          child: ZaveEmptyState(
            title: 'x',
            kicker: 'A KICKER FAR LONGER THAN ANY ROW COULD EVER HOLD',
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
