import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/contest/domain/contest_links.dart';

/// The LinkedIn link rules, held to the web's own cases.
///
/// Every expectation here is copied from the web's
/// `__tests__/lib/contest-path.test.ts` ("the feed comments' links",
/// "LinkedIn short links") or from the rules in `lib/contest-week.ts`. These
/// functions exist so the form refuses what the server would refuse, in the
/// same terms — a port that accepts one link the server turns down sends the
/// learner to a 400 they were told was fine.
void main() {
  group('a link to a comment', () {
    const String c =
        'https://www.linkedin.com/feed/update/urn:li:activity:7300?commentUrn=urn%3Ali%3Acomment%3A(activity%3A7300%2C9)';

    test('accepts a comment link on a /feed/update/ or /posts/ post, with or '
        'without the comment id', () {
      expect(isLinkedInCommentUrl(c), isTrue);
      expect(
        isLinkedInCommentUrl(
          'https://linkedin.com/feed/update/urn:li:activity:7300/',
        ),
        isTrue,
      );
      expect(
        isLinkedInCommentUrl(
          'https://www.linkedin.com/posts/jane_reviews-activity-73-abcd?commentUrn=urn%3Ali%3Acomment%3A1',
        ),
        isTrue,
      );
      expect(
        isLinkedInCommentUrl(
          '  https://www.linkedin.com/posts/jane_reviews-activity-73-abcd  ',
        ),
        isTrue,
      );
    });

    test('refuses anything else', () {
      for (final String bad in <String>[
        '',
        'not a url',
        'http://www.linkedin.com/feed/update/urn:li:activity:1',
        'https://www.linkedin.com/in/jane',
        'https://www.linkedin.com/pulse/an-article',
        'https://www.linkedin.com/feed/',
        'https://linkedin.com.evil.example/feed/update/x',
        'https://user:pw@www.linkedin.com/feed/update/x',
        'https://www.linkedin.com:8443/feed/update/x',
        // Country and mobile subdomains: LinkedIn's own, and still refused.
        'https://in.linkedin.com/feed/update/urn:li:activity:1',
        'https://m.linkedin.com/feed/update/urn:li:activity:1',
        'https://www.linkedin.com/feed/update/${'x' * 2000}',
        // A suffix after the post would spell one comment many ways.
        'https://www.linkedin.com/feed/update/urn:li:activity:1/x?commentUrn=X',
        'https://www.linkedin.com/posts/jane-activity-1-ab/y',
      ]) {
        expect(isLinkedInCommentUrl(bad), isFalse, reason: bad);
      }
    });

    test('accepts a real link padded with long tracking, dropped when '
        'normalised', () {
      final String padded = '$c&trk=${'t' * 900}';
      expect(padded.length, greaterThan(500));
      expect(isLinkedInCommentUrl(padded), isTrue);
      expect(normaliseCommentUrl(padded), normaliseCommentUrl(c));
    });

    test('one comment is one claim, however it is spelt', () {
      const String id = 'urn%3Ali%3Acomment%3A(activity%3A7300123%2C7300999)';
      const String a =
          'https://www.linkedin.com/feed/update/urn:li:activity:7300123/?commentUrn=$id';
      const List<String> spellings = <String>[
        'https://www.linkedin.com/FEED/update/urn:li:activity:7300123?commentUrn=$id',
        'https://www.linkedin.com/Feed/Update/urn:li:activity:7300123/?commentUrn=$id&trk=x',
        'https://www.linkedin.com/posts/jane_reviews-activity-7300123-abcd?commentUrn=$id',
        'https://www.linkedin.com/feed/update/urn:li:ugcPost:7300555?commentUrn=urn%3Ali%3Acomment%3A(ugcPost%3A7300555%2C7300999)',
        'https://www.linkedin.com/feed/update/urn:li:activity:7300123?dashCommentUrn=urn%3Ali%3Afsd_comment%3A(7300999%2Curn%3Ali%3Aactivity%3A7300123)',
      ];
      for (final String b in spellings) {
        expect(commentIdentity(b), commentIdentity(a), reason: b);
        expect(
          checkFeedCommentLink(b, <String>[a]),
          FeedCommentLinkProblem.duplicate,
          reason: b,
        );
      }
      expect(normaliseCommentUrl(spellings[0]), normaliseCommentUrl(a));
      // A reply is its own comment, distinct from its parent.
      const String reply =
          '$a&replyUrn=urn%3Ali%3Acomment%3A(activity%3A7300123%2C7301000)';
      expect(commentIdentity(reply), isNot(commentIdentity(a)));
      // Two bare links to one post are one claim, in either URL form.
      expect(
        commentIdentity(
          'https://www.linkedin.com/posts/jane-activity-7300123-ab',
        ),
        commentIdentity(
          'https://linkedin.com/feed/update/urn:li:activity:7300123/',
        ),
      );
      // Two different comments on one post stay two.
      expect(
        commentIdentity(a),
        isNot(commentIdentity(a.replaceAll('7300999', '7300998'))),
      );
    });

    test('normalises: www host, tracking dropped, the comment id kept, no '
        'trailing slash', () {
      final String a = normaliseCommentUrl(c);
      expect(
        a,
        startsWith(
          'https://www.linkedin.com/feed/update/urn:li:activity:7300?commentUrn=',
        ),
      );
      expect(
        normaliseCommentUrl(
          '${c.replaceFirst('www.linkedin.com', 'linkedin.com')}&trk=x&utm_source=share',
        ),
        a,
      );
      expect(
        normaliseCommentUrl(
          'https://LinkedIn.com/feed/update/urn%3Ali%3Aactivity%3A7300/?trk=x',
        ),
        'https://www.linkedin.com/feed/update/urn:li:activity:7300',
      );
      // Two comments on one post are two links.
      expect(
        normaliseCommentUrl(c),
        isNot(normaliseCommentUrl(c.replaceFirst('%2C9)', '%2C10)'))),
      );
    });

    test('checks ONE link against those already sent today, however they '
        'are spelt', () {
      final List<String> ok = <String>[
        for (final int n in <int>[1, 2])
          'https://www.linkedin.com/feed/update/urn:li:activity:$n',
      ];
      expect(checkFeedCommentLink('  '), FeedCommentLinkProblem.empty);
      expect(
        checkFeedCommentLink('https://example.com/x'),
        FeedCommentLinkProblem.bad,
      );
      expect(checkFeedCommentLink(ok[0]), isNull);
      expect(checkFeedCommentLink(ok[1], <String>[ok[0]]), isNull);
      expect(
        checkFeedCommentLink('${ok[0]}/?trk=x', <String>[
          normaliseCommentUrl(ok[0]),
        ]),
        FeedCommentLinkProblem.duplicate,
      );
      // An unreadable stored link matches nothing rather than throwing.
      expect(checkFeedCommentLink(ok[1], <String>['not a url']), isNull);
    });
  });

  group('LinkedIn short links (lnkd.in)', () {
    test('accepts the app’s "Copy link to comment" short link, and only '
        'that host', () {
      expect(isLinkedInCommentUrl('https://lnkd.in/p/dZfCpF4N'), isTrue);
      expect(isLinkedInCommentUrl('https://lnkd.in/dZfCpF4N'), isTrue);
      expect(isLinkedInCommentUrl('http://lnkd.in/p/dZfCpF4N'), isFalse);
      expect(
        isLinkedInCommentUrl('https://lnkd.in.evil.com/p/dZfCpF4N'),
        isFalse,
      );
      expect(isLinkedInCommentUrl('https://lnkd.in/p/a/b'), isFalse);
      expect(isLinkedInCommentUrl('https://lnkd.in/'), isFalse);
      expect(isLinkedInPostUrl('https://lnkd.in/p/dZfCpF4N'), isTrue);
    });

    test('keeps the code’s case and catches the same short link twice', () {
      expect(
        normaliseCommentUrl('https://lnkd.in/p/dZfCpF4N/'),
        'https://lnkd.in/p/dZfCpF4N',
      );
      expect(
        checkFeedCommentLink('https://lnkd.in/p/dZfCpF4N', <String>[
          'https://lnkd.in/dZfCpF4N',
        ]),
        FeedCommentLinkProblem.duplicate,
      );
      expect(
        checkFeedCommentLink('https://lnkd.in/p/dZfCpF4N', <String>[
          'https://lnkd.in/p/DZFCPF4N',
        ]),
        isNull,
      );
    });
  });

  group('a post link, for a claim', () {
    test(
      'a post, an update or an article on linkedin.com — a PREFIX match',
      () {
        expect(
          isLinkedInPostUrl(
            'https://www.linkedin.com/posts/jane_design-reviews-activity-123',
          ),
          isTrue,
        );
        expect(
          isLinkedInPostUrl(
            'https://www.linkedin.com/feed/update/urn:li:activity:123/',
          ),
          isTrue,
        );
        expect(
          isLinkedInPostUrl('https://www.linkedin.com/pulse/my-article-jane'),
          isTrue,
        );
        // Deeper paths are fine for a post, unlike a comment.
        expect(
          isLinkedInPostUrl('https://www.linkedin.com/pulse/my-article-jane/x'),
          isTrue,
        );
      },
    );

    test('refuses a profile, http, another host, a lookalike, or junk', () {
      for (final String bad in <String>[
        'https://www.linkedin.com/in/jane',
        'http://www.linkedin.com/posts/x',
        'https://evil.com/posts/x',
        'https://linkedin.com.evil.com/posts/x',
        'not a url',
        '',
      ]) {
        expect(isLinkedInPostUrl(bad), isFalse, reason: bad);
      }
    });

    test('refuses one longer than the claim route takes', () {
      final String long =
          'https://www.linkedin.com/posts/${'a' * kMaxPostUrlChars}';
      expect(long.length, greaterThan(kMaxPostUrlChars));
      expect(isLinkedInPostUrl(long), isFalse);
    });
  });

  group('opening a post from the app', () {
    test('only https on a LinkedIn host', () {
      expect(
        isLinkedInHost('https://www.linkedin.com/posts/meera_x-activity-1'),
        isTrue,
      );
      expect(isLinkedInHost('https://linkedin.com/feed/update/x'), isTrue);
      expect(isLinkedInHost('https://in.linkedin.com/posts/x'), isTrue);
      expect(isLinkedInHost('http://www.linkedin.com/posts/x'), isFalse);
      expect(isLinkedInHost('https://evil-linkedin.com/posts/x'), isFalse);
      expect(isLinkedInHost('https://linkedin.com.evil.com/posts/x'), isFalse);
      expect(isLinkedInHost('javascript:alert(1)'), isFalse);
      expect(isLinkedInHost(null), isFalse);
    });
  });
}
