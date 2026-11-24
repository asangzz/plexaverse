import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/planner/domain/weekly_article.dart';
import 'package:plexaverse/features/planner/presentation/widgets/article_card.dart';
import 'package:plexaverse/features/profile/domain/public_profile_words.dart';

/// Review of 24 Nov 2026 (FL2): while the public profile is published, "I
/// published it" puts the article's text — as Plexaverse prepared it — on the
/// user's public page. The web says so beside the button
/// (`PUBLIC_PROFILE_ARTICLE_LINE`); the app's card says the same, word for
/// word, and only where the button is.
void main() {
  const WeeklyArticle ready = WeeklyArticle(
    id: 'a1',
    weekNumber: 3,
    season: 1,
    title: 'Why I build',
  );
  const WeeklyArticle published = WeeklyArticle(
    id: 'a1',
    weekNumber: 3,
    season: 1,
    title: 'Why I build',
    status: 'published',
    publishedAt: '2026-11-20T10:00:00.000Z',
  );

  Future<void> pump(
    WidgetTester tester, {
    required WeeklyArticle article,
    required bool publicProfileOn,
  }) async {
    // Wide: this is about what the card says, not its phone layout.
    tester.view.physicalSize = const Size(800, 1400) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ArticleCard(
              state: ArticleState(article: article, newsletterName: 'Notes'),
              publicProfileOn: publicProfileOn,
              onOpen: () {},
              onCopy: () {},
              onMarkPublished: () {},
              onNameNewsletter: () {},
              onSetReminder: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('profile on, article not yet published: the line, in the '
      'web’s words, beside “I published it”', (WidgetTester tester) async {
    await pump(tester, article: ready, publicProfileOn: true);
    expect(find.text(kPublicProfileArticleLine), findsOneWidget);
    expect(find.text('I published it'), findsOneWidget);
    expect(
      kPublicProfileArticleLine,
      'Your public profile is on: once you press “I published it”, this '
      'article’s text as written here appears on your page. If you changed it '
      'in LinkedIn’s editor, the page will not show your changes.',
    );
  });

  testWidgets('profile off: no line', (WidgetTester tester) async {
    await pump(tester, article: ready, publicProfileOn: false);
    expect(find.text(kPublicProfileArticleLine), findsNothing);
    expect(find.text('I published it'), findsOneWidget);
  });

  testWidgets('already published: no button, so no line', (
    WidgetTester tester,
  ) async {
    await pump(tester, article: published, publicProfileOn: true);
    expect(find.text('I published it'), findsNothing);
    expect(find.text(kPublicProfileArticleLine), findsNothing);
  });
}
