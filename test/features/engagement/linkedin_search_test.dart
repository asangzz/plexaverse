import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/engagement/domain/connection_target.dart';
import 'package:plexaverse/core/links/linkedin.dart';

/// The LinkedIn search URLs the engagement screens open.
///
/// These strings are the whole feature: the screens write a comment or a note,
/// and the URL is how the user reaches something to attach it to. A wrong
/// vertical or a mangled query does not fail — it opens LinkedIn on a
/// confidently wrong page, which is harder to notice and harder to report than
/// a dead button.
void main() {
  group('content search (comments — find POSTS)', () {
    test('uses the content vertical, not people', () {
      // Sending a comment's keywords to /people/ returns strangers whose
      // headlines happen to match. Nothing errors; it is just useless.
      final String url = linkedInContentSearchUrl('remote onboarding');
      expect(url, contains('/search/results/content/'));
      expect(url, isNot(contains('/people/')));
    });

    test('percent-encodes the query', () {
      final String url = linkedInContentSearchUrl('remote onboarding & hiring');
      expect(url, contains('keywords=remote%20onboarding%20%26%20hiring'));
      // A raw & would terminate the parameter and drop half the search.
      expect(url, isNot(contains('keywords=remote onboarding & hiring')));
    });

    test('matches the origin the web sends', () {
      expect(
        linkedInContentSearchUrl('x'),
        endsWith('origin=GLOBAL_SEARCH_HEADER'),
      );
    });

    test('trims, so a stray space is not encoded into the query', () {
      expect(
        linkedInContentSearchUrl('  hiring  '),
        contains('keywords=hiring&'),
      );
    });
  });

  group('people search (connections — find PEOPLE)', () {
    test('uses the people vertical and the server’s origin', () {
      final String url = linkedInPeopleSearchUrl('Head of Product Razorpay');
      expect(url, contains('/search/results/people/'));
      expect(url, endsWith('origin=SWITCH_SEARCH_VERTICAL'));
    });

    test('encodes exactly as the server does', () {
      // The server builds this with encodeURIComponent in ai.service.ts. If
      // the two ever disagree the app and the web open different searches for
      // the same target.
      expect(
        linkedInPeopleSearchUrl('Head of Product Razorpay'),
        'https://www.linkedin.com/search/results/people/'
        '?keywords=Head%20of%20Product%20Razorpay'
        '&origin=SWITCH_SEARCH_VERTICAL',
      );
    });
  });

  group('ConnectionTarget.searchUrl', () {
    test('prefers the server’s URL over building one', () {
      const ConnectionTarget t = ConnectionTarget(
        searchQuery: 'Head of Product Razorpay',
        linkedinSearchUrl:
            'https://www.linkedin.com/search/results/people/?x=1',
      );
      expect(
        t.searchUrl,
        'https://www.linkedin.com/search/results/people/?x=1',
      );
    });

    test('builds one when the server sent none', () {
      // `linkedinSearchUrl` defaults to '' rather than null, so an older
      // server hands the UI an empty string. Empty is not a link.
      const ConnectionTarget t = ConnectionTarget(searchQuery: 'VP Product');
      expect(t.searchUrl, contains('keywords=VP%20Product'));
      expect(t.searchUrl, contains('/people/'));
    });

    test('treats a whitespace-only URL as absent', () {
      const ConnectionTarget t = ConnectionTarget(
        searchQuery: 'VP Product',
        linkedinSearchUrl: '   ',
      );
      expect(t.searchUrl, contains('keywords=VP%20Product'));
    });

    test('is null when there is nothing to search for', () {
      // The one case where the card must disable its action rather than open
      // LinkedIn on an empty search.
      expect(const ConnectionTarget().searchUrl, isNull);
      expect(const ConnectionTarget(searchQuery: '  ').searchUrl, isNull);
    });
  });

  group('fixed destinations match the web', () {
    // Each of these replaced a sentence telling the user where to navigate.
    // If LinkedIn moves one, the app sends people somewhere that no longer
    // exists — and unlike a 404 in a browser, a wrong App Link just opens the
    // LinkedIn app on its feed, which looks like the button did nothing.
    test('article composer', () {
      expect(
        linkedInArticleComposerUrl,
        'https://www.linkedin.com/article/new/',
      );
    });

    test(
      'own profile carries the self-profile flag the photo editor needs',
      () {
        expect(
          linkedInOwnProfileUrl,
          'https://www.linkedin.com/in/me/?isSelfProfile=true',
        );
        // /in/me/ resolves server-side, so no slug is needed — which is what
        // lets the headshot flow link out before any account is connected.
        expect(linkedInOwnProfileUrl, contains('/in/me/'));
      },
    );

    test('creator analytics', () {
      expect(
        linkedInCreatorAnalyticsUrl,
        'https://www.linkedin.com/analytics/creator/content/',
      );
    });

    test('profile builder composes an edit path', () {
      expect(
        linkedInProfileUrl('asang', editPath: 'edit/forms/intro/new/'),
        'https://www.linkedin.com/in/asang/edit/forms/intro/new/',
      );
      expect(linkedInProfileUrl('asang'), 'https://www.linkedin.com/in/asang/');
    });

    test('company page builder', () {
      expect(
        linkedInCompanyPageUrl('123'),
        'https://www.linkedin.com/company/123/',
      );
    });
  });
}
