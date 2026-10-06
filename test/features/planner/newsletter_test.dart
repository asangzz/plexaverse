import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/planner/domain/weekly_article.dart';

void main() {
  group('WeeklyArticle', () {
    test('carries the name candidates the first article is written with', () {
      // Already on the wire — the mobile route spreads the service's row and
      // strips only `body` — and dropped on the floor until the naming flow
      // existed to use them.
      final WeeklyArticle a = WeeklyArticle.fromJson(<String, dynamic>{
        'id': 'a1',
        'weekNumber': 3,
        'season': 1,
        'title': 'A title',
        'newsletterNameSuggestions': <String>[
          'The Onboarding Letter',
          'First Week',
        ],
      });

      expect(a.newsletterNameSuggestions, hasLength(2));
      expect(a.newsletterNameSuggestions.first, 'The Onboarding Letter');
    });

    test(
      'an article after the first carries none, and that is not an error',
      () {
        final WeeklyArticle a = WeeklyArticle.fromJson(<String, dynamic>{
          'id': 'a2',
          'weekNumber': 4,
          'season': 1,
        });
        expect(a.newsletterNameSuggestions, isEmpty);
      },
    );
  });

  group('ArticleState', () {
    test('isFirstArticle is independent of having a name', () {
      // The distinction the whole flow turns on. `isFirstArticle` does not
      // mean "has no name" — it means LinkedIn will ask the user to CREATE the
      // newsletter while they publish this edition, which stays true for this
      // article after the name is recorded. Collapsing the two would delete
      // the create-a-newsletter step from under the user at exactly the moment
      // LinkedIn asks them to create one.
      const ArticleState justNamed = ArticleState(
        isFirstArticle: true,
        newsletterName: 'The Onboarding Letter',
      );

      expect(justNamed.isFirstArticle, isTrue);
      expect(justNamed.newsletterName, isNotNull);
    });

    test('parses the mobile article payload', () {
      final ArticleState s = ArticleState.fromJson(<String, dynamic>{
        'weekNumber': 3,
        'season': 1,
        'newsletterName': null,
        'isFirstArticle': true,
        'article': <String, dynamic>{
          'id': 'a1',
          'weekNumber': 3,
          'season': 1,
          'title': 'A title',
          'newsletterNameSuggestions': <String>['First Week'],
        },
      });

      expect(s.isFirstArticle, isTrue);
      expect(s.newsletterName, isNull);
      expect(s.article?.newsletterNameSuggestions, <String>['First Week']);
    });

    test('the step survives naming it, which is the whole point', () {
      // Recording the name is not creating the newsletter — LinkedIn is where
      // it comes into being, and it asks for it WHILE the user publishes this
      // edition. So a state that has just been named locally must still carry
      // isFirstArticle, or the card's create-a-newsletter note vanishes
      // seconds before LinkedIn asks for exactly that.
      const ArticleState before = ArticleState(isFirstArticle: true);
      final ArticleState after = before.copyWith(
        newsletterName: 'The Onboarding Letter',
      );

      expect(after.newsletterName, 'The Onboarding Letter');
      expect(
        after.isFirstArticle,
        isTrue,
        reason: 'naming it must not delete the create-a-newsletter step',
      );
    });

    test('a user with a name recorded is no longer on their first', () {
      // What the server answers once setNewsletter has run: isFirstArticle is
      // computed as `!newsletterName`, so the NEXT week's article arrives with
      // the flag already false and the create-a-newsletter step gone.
      final ArticleState s = ArticleState.fromJson(<String, dynamic>{
        'weekNumber': 4,
        'season': 1,
        'newsletterName': 'The Onboarding Letter',
        'isFirstArticle': false,
      });

      expect(s.isFirstArticle, isFalse);
      expect(s.newsletterName, 'The Onboarding Letter');
    });
  });
}
