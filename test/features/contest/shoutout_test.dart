import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show SemanticsNode;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/links/plexaverse.dart';
import 'package:plexaverse/core/network/dio_client.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';
import 'package:plexaverse/core/platform/link_opening.dart';
import 'package:plexaverse/features/contest/application/contest_controllers.dart';
import 'package:plexaverse/features/contest/application/lesson_controllers.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/domain/linkedin_profile_url.dart';
import 'package:plexaverse/features/contest/domain/shoutout_words.dart';
import 'package:plexaverse/features/contest/presentation/widgets/contest_kit.dart';
import 'package:plexaverse/features/contest/presentation/widgets/featured/hall_of_fame.dart';
import 'package:plexaverse/features/contest/presentation/widgets/featured/learners_of_the_week.dart';
import 'package:plexaverse/features/contest/presentation/widgets/featured/shoutout_card.dart';
import 'package:plexaverse/features/contest/presentation/widgets/feed/feed_panels.dart';
import 'package:plexaverse/features/settings/application/settings_controllers.dart';
import 'package:plexaverse/features/settings/data/settings_repositories.dart';

import 'contest_home_harness.dart';

/// The contest shoutout (owner, 22 Nov 2026: the prize of every contest is a
/// profile shoutout) — the web's `featured/*` cards, its consent card and its
/// LinkedIn profile rule, held to the web's words and the web's rules.
///
/// What these pin, beyond "it draws":
///   * the week's learners carry no rank, no XP and no order of the app's
///     own — the board stays hidden until the contest's last days;
///   * the card shows nothing until the server says `ready`: no teaser;
///   * the "Feature me" box starts empty, ticking it is not yet a yes, and
///     un-ticking is the whole withdrawal;
///   * a profile link is opened only after the server's own rule passes it,
///     and the rules and appeals open on the web.
void main() {
  setUp(FakeContestWorld.reset);

  group('the profile link — the web’s rule, case for case', () {
    const Map<String, String> accepted = <String, String>{
      'https://www.linkedin.com/in/asha-rao':
          'https://www.linkedin.com/in/asha-rao',
      'https://linkedin.com/in/asha-rao':
          'https://www.linkedin.com/in/asha-rao',
      'https://www.linkedin.com/in/asha-rao/':
          'https://www.linkedin.com/in/asha-rao',
      '  https://www.linkedin.com/in/Asha-Rao  ':
          'https://www.linkedin.com/in/asha-rao',
      'HTTPS://WWW.LINKEDIN.COM/in/asha_rao':
          'https://www.linkedin.com/in/asha_rao',
      'https://www.linkedin.com/in/asha-rao-12345678?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=ios_app':
          'https://www.linkedin.com/in/asha-rao-12345678',
      'https://www.linkedin.com/in/asha-rao#experience':
          'https://www.linkedin.com/in/asha-rao',
      'www.linkedin.com/in/asha-rao': 'https://www.linkedin.com/in/asha-rao',
      'linkedin.com/in/asha-rao': 'https://www.linkedin.com/in/asha-rao',
    };

    for (final MapEntry<String, String> e in accepted.entries) {
      test('accepts ${e.key.trim()}', () {
        expect(normaliseLinkedInProfileUrl(e.key), e.value);
        expect(isLinkedInProfileUrl(e.key), isTrue);
      });
    }

    final Map<String, String> refused = <String, String>{
      'a look-alike suffix': 'https://linkedin.com.evil.com/in/asha',
      'a look-alike prefix': 'https://evil-linkedin.com/in/asha',
      'a lookalike TLD': 'https://www.linkedin.co/in/asha',
      'the host in the path': 'https://evil.com/www.linkedin.com/in/asha',
      'credentials before the real host':
          'https://www.linkedin.com@evil.com/in/asha',
      'credentials on the real host':
          'https://user:pass@www.linkedin.com/in/asha',
      'a port': 'https://www.linkedin.com:8443/in/asha',
      'a trailing-dot host': 'https://www.linkedin.com./in/asha',
      'a country subdomain': 'https://in.linkedin.com/in/asha',
      'a punycode host': 'https://www.xn--linkedn-p2a.com/in/asha',
      'lnkd.in short links': 'https://lnkd.in/asha',
      'plain http': 'http://www.linkedin.com/in/asha',
      'javascript:': 'javascript:alert(document.cookie)',
      'javascript: dressed as a path':
          'javascript://www.linkedin.com/in/asha%0aalert(1)',
      'data:': 'data:text/html,<script>alert(1)</script>',
      'a protocol-relative link': '//www.linkedin.com/in/asha',
      'ftp': 'ftp://www.linkedin.com/in/asha',
      'a company page': 'https://www.linkedin.com/company/plexaverse',
      'a post': 'https://www.linkedin.com/posts/asha_activity-123',
      'a profile sub-page':
          'https://www.linkedin.com/in/asha/details/experience',
      'the bare /in/': 'https://www.linkedin.com/in/',
      'a dot-segment escape':
          'https://www.linkedin.com/in/asha/../../company/x',
      'an encoded slash': 'https://www.linkedin.com/in/asha%2Fadmin',
      'an encoded character': 'https://www.linkedin.com/in/asha%20rao',
      'a too-short slug': 'https://www.linkedin.com/in/ab',
      'a slug of only hyphens': 'https://www.linkedin.com/in/---',
      'a 101-character slug': 'https://www.linkedin.com/in/${'a' * 101}',
      'whitespace inside': 'https://www.linkedin.com/in/asha rao',
      'a newline inside': 'https://www.linkedin.com/in/asha\nrao',
      'the home page': 'https://www.linkedin.com/',
      'nothing': '',
      'spaces': '   ',
      'an over-long input': 'https://www.linkedin.com/in/asha?${'x' * 400}',
    };

    for (final MapEntry<String, String> e in refused.entries) {
      test('refuses ${e.key}', () {
        expect(normaliseLinkedInProfileUrl(e.value), isNull);
        expect(isLinkedInProfileUrl(e.value), isFalse);
      });
    }

    test('null is no link', () {
      expect(normaliseLinkedInProfileUrl(null), isNull);
      expect(isLinkedInProfileUrl(null), isFalse);
    });

    test('a stored link is re-checked on the way out', () {
      expect(
        profileHref('https://www.linkedin.com/in/asha-rao'),
        'https://www.linkedin.com/in/asha-rao',
      );
      expect(profileHref('javascript:alert(1)'), isNull);
      expect(profileHref('https://evil.com/in/asha'), isNull);
      expect(profileHref(null), isNull);
    });
  });

  group('the wire', () {
    test('the web’s body: the week, and the Hall of Fame with places', () {
      final ContestFeatured f = ContestFeatured.fromJson(<String, dynamic>{
        'week': <String, dynamic>{
          'state': 'ready',
          'weekStart': '2026-11-15',
          'weekEnd': '2026-11-21',
          'learners': <Object>[
            <String, dynamic>{
              'key': 'a1',
              'name': 'Asha',
              'image': null,
              'headline': 'Designer',
              'linkedinUrl': 'https://www.linkedin.com/in/asha',
            },
          ],
        },
        'hallOfFame': <Object>[
          <String, dynamic>{
            'contestId': 'c1',
            'title': 'Business English Contest',
            'prizeTitle': 'a profile shoutout',
            'rewardTopN': 10,
            'finalisedAt': '2026-11-20T05:30:00.000Z',
            'featuredUntil': '2026-12-20T05:30:00.000Z',
            'winners': <Object>[
              <String, dynamic>{
                'rank': 1,
                'key': 'w1',
                'name': 'Ravi',
                'image': null,
                'headline': null,
                'linkedinUrl': null,
              },
            ],
          },
        ],
      });
      expect(f.week.state, LearnersOfWeekState.ready);
      expect(f.week.shows, isTrue);
      expect(f.week.learners.single.name, 'Asha');
      expect(f.hallOfFame.single.winners.single.rank, 1);
      expect(f.hallOfFame.single.winners.single.person.name, 'Ravi');
      expect(
        f.hallOfFame.single.featuredUntil,
        DateTime.utc(2026, 12, 20, 5, 30),
      );
      // Through the wire and back, as the fake's answers must survive.
      expect(
        ContestFeatured.fromJson(
          jsonDecode(jsonEncode(f.toJson())) as Map<String, dynamic>,
        ),
        f,
      );
    });

    test('snake-case states, and an unknown one shows nothing', () {
      for (final (String wire, LearnersOfWeekState want)
          in <(String, LearnersOfWeekState)>[
            ('none', LearnersOfWeekState.none),
            ('after_lesson', LearnersOfWeekState.afterLesson),
            ('no_week', LearnersOfWeekState.noWeek),
            ('ready', LearnersOfWeekState.ready),
            ('podium', LearnersOfWeekState.none),
          ]) {
        final LearnersOfWeek w = LearnersOfWeek.fromJson(<String, dynamic>{
          'state': wire,
        });
        expect(w.state, want, reason: wire);
        expect(w.shows, isFalse, reason: '$wire carries nobody');
      }
      expect(ContestFeatured.fromJson(<String, dynamic>{}).week.shows, isFalse);
    });

    test('the choice: off and no link unless the server says otherwise', () {
      expect(
        ShoutoutSettings.fromJson(<String, dynamic>{}),
        const ShoutoutSettings(),
      );
      expect(
        ShoutoutSettings.fromJson(<String, dynamic>{
          'featured': true,
          'linkedinUrl': 'https://www.linkedin.com/in/asha',
        }),
        const ShoutoutSettings(
          featured: true,
          linkedinUrl: 'https://www.linkedin.com/in/asha',
        ),
      );
    });
  });

  group('the repository', () {
    test('the cards: a GET, bare inside data', () async {
      final (ApiContestRepository repo, _Canned wire) = _stack(
        200,
        _ok(<String, dynamic>{
          'week': <String, dynamic>{'state': 'after_lesson'},
          'hallOfFame': <Object>[],
        }),
      );
      final ContestFeatured f = await repo.fetchFeatured();
      expect(f.week.state, LearnersOfWeekState.afterLesson);
      expect(wire.seen.single.method, 'GET');
      expect(wire.seen.single.path, '/contest/featured');
    });

    test('the choice: a GET, bare inside data', () async {
      final (ApiContestRepository repo, _Canned wire) = _stack(
        200,
        _ok(<String, dynamic>{'featured': false, 'linkedinUrl': null}),
      );
      expect(await repo.fetchShoutout(), const ShoutoutSettings());
      expect(wire.seen.single.path, '/contest/shoutout');
    });

    test('agreeing sends a literal true and the trimmed link', () async {
      final (ApiContestRepository repo, _Canned wire) = _stack(
        200,
        _ok(<String, dynamic>{
          'featured': true,
          'linkedinUrl': 'https://www.linkedin.com/in/asha',
        }),
      );
      final ShoutoutSettings s = await repo.setShoutout(
        featured: true,
        linkedinUrl: '  https://www.linkedin.com/in/Asha  ',
      );
      expect(s.featured, isTrue);
      expect(wire.seen.single.method, 'PUT');
      expect(wire.seen.single.path, '/contest/shoutout');
      expect(wire.seen.single.data, <String, dynamic>{
        'featured': true,
        'linkedinUrl': 'https://www.linkedin.com/in/Asha',
      });
    });

    test('withdrawing sends featured: false and nothing else', () async {
      final (ApiContestRepository repo, _Canned wire) = _stack(
        200,
        _ok(<String, dynamic>{'featured': false, 'linkedinUrl': null}),
      );
      await repo.setShoutout(
        featured: false,
        linkedinUrl: 'https://www.linkedin.com/in/asha',
      );
      expect(wire.seen.single.data, <String, dynamic>{'featured': false});
    });

    test('INVALID_LINKEDIN_URL is the bad-link refusal, in the server’s '
        'words', () async {
      const String said =
          'Paste the link to your public LinkedIn profile, like '
          'https://www.linkedin.com/in/your-name.';
      final (ApiContestRepository repo, _) = _stack(
        400,
        _refusal('INVALID_LINKEDIN_URL', said),
      );
      Object? thrown;
      try {
        await repo.setShoutout(featured: true, linkedinUrl: 'x');
      } on Object catch (e) {
        thrown = e;
      }
      expect(thrown, isA<ContestBadProfileLink>());
      expect(contestMessage(thrown!), said);
    });
  });

  group('the mock flavor plays the server', () {
    FakeContestRepository fake([
      FakeContestScenario s = FakeContestScenario.running,
    ]) => FakeContestRepository(scenario: s, latency: Duration.zero);

    test('the week waits for today’s lesson, then names the last full '
        'week', () async {
      final FakeContestRepository repo = fake();
      expect(
        (await repo.fetchFeatured()).week.state,
        LearnersOfWeekState.afterLesson,
      );
      await repo.startLesson();
      while (true) {
        final TodayQuiz q = await repo.fetchTodayQuiz();
        final int? i = q.firstUnansweredIndex;
        if (i == null) break;
        await repo.answerQuiz(
          day: q.day!,
          itemId: q.questions[i].id,
          value: q.questions[i].options.first,
        );
      }
      final LearnersOfWeek week = (await repo.fetchFeatured()).week;
      expect(week.state, LearnersOfWeekState.ready);
      expect(week.shows, isTrue);
      // Today is Wednesday 11 Nov: the last full week is Sun 1 – Sat 7.
      expect(week.weekStart, '2026-11-01');
      expect(week.weekEnd, '2026-11-07');
      expect(week.learners.length, lessThanOrEqualTo(kLearnersOfTheWeekMax));
      for (final FeaturedPerson p in week.learners) {
        final String? link = p.linkedinUrl;
        if (link != null) expect(profileHref(link), link);
      }
    });

    test('nobody outside a running contest’s entrants gets the week', () async {
      for (final FakeContestScenario s in <FakeContestScenario>[
        FakeContestScenario.notJoined,
        FakeContestScenario.upcoming,
        FakeContestScenario.ended,
        FakeContestScenario.noContest,
      ]) {
        expect(
          (await fake(s).fetchFeatured()).week.state,
          LearnersOfWeekState.none,
          reason: s.name,
        );
      }
    });

    test(
      'the Hall of Fame: a finalised contest’s winners, in place order',
      () async {
        for (final FakeContestScenario s in <FakeContestScenario>[
          FakeContestScenario.ended,
          FakeContestScenario.noContest,
        ]) {
          final List<HallOfFameEntry> fame = (await fake(
            s,
          ).fetchFeatured()).hallOfFame;
          expect(fame, hasLength(1), reason: s.name);
          final List<int> places = <int>[
            for (final HallOfFameWinner w in fame.single.winners)
              if (w.rank case final int r) r,
          ];
          expect(places, orderedEquals(<int>[...places]..sort()));
          expect(places.every((int r) => r <= fame.single.rewardTopN), isTrue);
          expect(
            fame.single.featuredUntil.difference(fame.single.finalisedAt),
            const Duration(days: 30),
          );
        }
        expect((await fake().fetchFeatured()).hallOfFame, isEmpty);
      },
    );

    test('the choice: a link is needed to agree, kept canonical, and erased '
        'on withdrawal', () async {
      final FakeContestRepository repo = fake();
      expect(await repo.fetchShoutout(), const ShoutoutSettings());
      await expectLater(
        repo.setShoutout(featured: true),
        throwsA(isA<ContestBadProfileLink>()),
      );
      await expectLater(
        repo.setShoutout(
          featured: true,
          linkedinUrl: 'https://www.linkedin.com/company/x',
        ),
        throwsA(isA<ContestBadProfileLink>()),
      );
      // A good link without the 18+ declaration: refused, nothing recorded.
      await expectLater(
        repo.setShoutout(
          featured: true,
          linkedinUrl: 'linkedin.com/in/Asha-Rao?utm_source=share',
        ),
        throwsA(isA<ContestAdultRequired>()),
      );
      expect((await repo.fetchShoutout()).featured, isFalse);
      expect(
        await repo.setShoutout(
          featured: true,
          linkedinUrl: 'linkedin.com/in/Asha-Rao?utm_source=share',
          adult: true,
        ),
        const ShoutoutSettings(
          featured: true,
          linkedinUrl: 'https://www.linkedin.com/in/asha-rao',
          adultDeclared: true,
        ),
      );
      // On again with no link confirms the one on record.
      expect((await repo.setShoutout(featured: true)).featured, isTrue);
      expect(
        await repo.setShoutout(featured: false),
        const ShoutoutSettings(adultDeclared: true),
      );
    });
  });

  group('the lesson re-reads the week’s card', () {
    /// The mock's running contest with all but [left] of today's questions
    /// answered, and a lesson visit open on the next.
    Future<(ProviderContainer, _Shoutout)> visit(int left) async {
      final _Shoutout repo = _Shoutout();
      await repo.startLesson();
      while (true) {
        final TodayQuiz q = await repo.fetchTodayQuiz();
        final int? i = q.firstUnansweredIndex;
        if (i == null || q.total - q.answeredCount <= left) break;
        await repo.answerQuiz(
          day: q.day!,
          itemId: q.questions[i].id,
          value: q.questions[i].options.first,
        );
      }
      final ProviderContainer c = ProviderContainer(
        overrides: <Override>[
          contestRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(c.dispose);
      c.listen(contestFeaturedProvider, (_, _) {});
      c.listen(lessonRunProvider, (_, _) {});
      await c.read(contestFeaturedProvider.future);
      await pumpEventQueue();
      return (c, repo);
    }

    Future<void> answerOnScreen(ProviderContainer c) async {
      final LessonRunState s = c.read(lessonRunProvider);
      final LessonAt at = s.at;
      expect(at, isA<AtQuestion>());
      final int i = (at as AtQuestion).index;
      await c
          .read(lessonRunProvider.notifier)
          .answer(s.questions[i].options.first);
      await pumpEventQueue();
    }

    test('an answer that leaves the lesson open re-reads nothing', () async {
      final (ProviderContainer c, _Shoutout repo) = await visit(2);
      expect(repo.featuredReads, 1);
      await answerOnScreen(c);
      expect(repo.featuredReads, 1);
    });

    test('the answer that finishes the lesson re-reads it — and the week '
        'opens', () async {
      final (ProviderContainer c, _Shoutout repo) = await visit(1);
      expect(
        c.read(contestFeaturedProvider).value?.week.state,
        LearnersOfWeekState.afterLesson,
      );
      await answerOnScreen(c);
      final ContestFeatured f = await c.read(contestFeaturedProvider.future);
      expect(repo.featuredReads, 2);
      expect(f.week.state, LearnersOfWeekState.ready);
    });
  });

  group('Settings withdraws it too', () {
    test('a contest_shoutout decision in Settings re-reads the card’s '
        'choice — the contest page stays alive under Settings', () async {
      final _Shoutout contest = _Shoutout();
      final ProviderContainer c = ProviderContainer(
        overrides: <Override>[
          contestRepositoryProvider.overrideWithValue(contest),
          settingsRepositoryProvider.overrideWithValue(
            FakeSettingsRepository(),
          ),
        ],
      );
      addTearDown(c.dispose);
      c.listen(contestShoutoutProvider, (_, _) {});
      c.listen(consentControllerProvider, (_, _) {});
      await c.read(contestShoutoutProvider.future);
      await c.read(consentControllerProvider.future);
      expect(contest.shoutoutReads, 1);

      // Another purpose leaves the card alone.
      await c.read(consentControllerProvider.notifier).set('marketing', true);
      await c.read(contestShoutoutProvider.future);
      expect(contest.shoutoutReads, 1);

      await c
          .read(consentControllerProvider.notifier)
          .set('contest_shoutout', false);
      await c.read(contestShoutoutProvider.future);
      expect(contest.shoutoutReads, 2);
    });
  });

  group('the appeal, under a removed claim', () {
    testWidgets('“Appeal the decision” opens the web’s removed claims and '
        'appeals', (WidgetTester tester) async {
      final _Opener opener = _Opener();
      await tester.pumpWidget(
        ProviderScope(
          overrides: <Override>[linkOpeningProvider.overrideWithValue(opener)],
          child: const MaterialApp(
            home: Scaffold(
              body: FeedCommentsRevoked(
                view: FeedCommentsView(
                  status: FeedCommentsStatus.revoked,
                  revokeReason: 'The same comment twice',
                  pointsDeducted: 110,
                ),
              ),
            ),
          ),
        ),
      );
      expect(
        find.text(
          'Other days of the contest count as usual. Think we got it wrong?',
        ),
        findsOneWidget,
      );
      await tester.tap(find.bySemanticsLabel('Appeal the decision'));
      await tester.pump();
      expect(opener.opened, <String>[plexaverseContestAppealsUrl]);
    });
  });

  group('the cards on the contest page', () {
    testWidgets('before today’s lesson is finished: no week’s card, not even '
        'a teaser — and the box is empty', (WidgetTester tester) async {
      await pumpContestPage(tester, repo: _Shoutout());
      expect(find.byType(LearnersOfTheWeek), findsOneWidget);
      expect(find.text('Learners of the week'), findsNothing);
      expect(find.text('The prize is a shoutout'), findsOneWidget);
      expect(find.text(kShoutoutToggleLabel), findsOneWidget);
      expect(find.text('$kShoutoutConsentText.'), findsOneWidget);
      expect(find.text(kShoutoutWithdrawLine), findsOneWidget);
      expect(_box(tester), _unticked);
      // Nothing asked for until the box is ticked.
      expect(find.byType(TextField), findsNothing);
      expect(find.text('You’re in if you make it'), findsNothing);
    });

    testWidgets('the week’s learners: as the server ordered them, with no '
        'place, no XP, and a link only where the profile rule passes it', (
      WidgetTester tester,
    ) async {
      await pumpContestPage(tester, repo: _Shoutout(featured: _readyWeek));
      final Finder card = find.byType(LearnersOfTheWeek);
      Finder inCard(Finder f) => find.descendant(of: card, matching: f);

      expect(inCard(find.text('Learners of the week')), findsOneWidget);
      expect(
        inCard(
          find.text('$kLearnersOfTheWeekLine Week of 1 Nov 2026 – 7 Nov 2026.'),
        ),
        findsOneWidget,
      );
      expect(inCard(find.text(kFollowOptionalLine)), findsOneWidget);

      // The server's order, untouched — not alphabetical, not by anything.
      final List<double> ys = <double>[
        for (final String n in <String>['Zoya Khan', 'Aman Gupta', 'Bela Roy'])
          tester.getTopLeft(inCard(find.text(n))).dy,
      ];
      expect(ys, orderedEquals(<double>[...ys]..sort()));

      // No place and no figure: nothing numbered, no XP tag.
      expect(inCard(find.textContaining(RegExp(r'#\d'))), findsNothing);
      expect(inCard(find.textContaining(RegExp(r'\d+\s*XP'))), findsNothing);
      expect(inCard(find.byType(XpTag)), findsNothing);

      // A javascript: link and no link at all both open nothing.
      expect(
        inCard(find.bySemanticsLabel('View Zoya Khan on LinkedIn')),
        findsOneWidget,
      );
      expect(
        inCard(find.bySemanticsLabel(RegExp('View .* on LinkedIn'))),
        findsOneWidget,
      );
    });

    testWidgets('“View on LinkedIn” hands the checked link to the OS', (
      WidgetTester tester,
    ) async {
      final _Opener opener = _Opener();
      await pumpContestPage(
        tester,
        repo: _Shoutout(featured: _readyWeek),
        overrides: <Override>[linkOpeningProvider.overrideWithValue(opener)],
      );
      await tapVisible(
        tester,
        find.bySemanticsLabel('View Zoya Khan on LinkedIn'),
      );
      expect(opener.opened, <String>['https://www.linkedin.com/in/zoya-khan']);
    });

    testWidgets('the Hall of Fame: each winner’s place, after the contest '
        'ends', (WidgetTester tester) async {
      await pumpContestPage(tester, scenario: FakeContestScenario.ended);
      final Finder fame = find.byType(HallOfFame);
      Finder inFame(Finder f) => find.descendant(of: fame, matching: f);
      expect(inFame(find.text('Hall of Fame')), findsOneWidget);
      expect(
        inFame(
          find.textContaining(
            'The top 10 won a profile shoutout. Featured until ',
          ),
        ),
        findsOneWidget,
      );
      expect(inFame(find.bySemanticsLabel('Place 1')), findsOneWidget);
      expect(inFame(find.text('#1')), findsOneWidget);
      expect(inFame(find.text('Aarav Rao')), findsOneWidget);
      expect(inFame(find.text(kFollowOptionalLine)), findsOneWidget);
    });

    testWidgets('the Hall of Fame shows between contests too', (
      WidgetTester tester,
    ) async {
      await pumpContestPage(tester, scenario: FakeContestScenario.noContest);
      expect(find.text('No contest right now'), findsOneWidget);
      expect(find.text('Hall of Fame'), findsOneWidget);
      // Not one of the winners, no contest: no consent card.
      expect(find.byType(ShoutoutCard), findsNothing);
    });

    testWidgets('a WINNER of a contest whose Hall of Fame is showing gets '
        '“Feature me” between contests — the prize is only theirs if they '
        'say yes', (WidgetTester tester) async {
      await pumpContestPage(
        tester,
        scenario: FakeContestScenario.noContest,
        repo: _Shoutout(
          scenario: FakeContestScenario.noContest,
          featured: const ContestFeatured(viewerPlaced: true),
        ),
      );
      expect(find.byType(ShoutoutCard), findsOneWidget);
      expect(_box(tester), _unticked);
    });

    testWidgets('a winner without a place (declined the leaderboard) is '
        'drawn unnumbered, after the placed', (WidgetTester tester) async {
      await pumpContestPage(
        tester,
        scenario: FakeContestScenario.noContest,
        repo: _Shoutout(
          scenario: FakeContestScenario.noContest,
          featured: ContestFeatured(
            hallOfFame: <HallOfFameEntry>[
              HallOfFameEntry(
                contestId: 'c0',
                title: 'Autumn contest',
                prizeTitle: 'a profile shoutout',
                rewardTopN: 10,
                finalisedAt: DateTime.utc(2026, 11, 20),
                featuredUntil: DateTime.utc(2026, 12, 20),
                winners: const <HallOfFameWinner>[
                  HallOfFameWinner(key: 'a', name: 'Unplaced Winner'),
                  HallOfFameWinner(rank: 1, key: 'b', name: 'First Place'),
                ],
              ),
            ],
          ),
        ),
      );
      expect(find.text('Unplaced Winner'), findsOneWidget);
      expect(find.text('First Place'), findsOneWidget);
      // The placed winner comes first, and only the placed one has a number.
      expect(
        tester.getTopLeft(find.text('First Place')).dy,
        lessThan(tester.getTopLeft(find.text('Unplaced Winner')).dy),
      );
      expect(find.textContaining('#'), findsOneWidget);
    });

    testWidgets('ticking is not yet a yes; a bad link is said in its field; '
        '“Feature me” agrees; un-ticking is the whole withdrawal', (
      WidgetTester tester,
    ) async {
      final _Shoutout repo = _Shoutout();
      await pumpContestPage(tester, repo: repo);

      await tapVisible(tester, _boxFinder);
      expect(find.text('Your public LinkedIn profile link'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(repo.saves, isEmpty, reason: 'a tick is not consent');

      await tester.enterText(
        find.byType(TextField),
        'https://www.linkedin.com/company/plexaverse',
      );
      await tapVisible(tester, find.bySemanticsLabel('Feature me'));
      expect(find.text(kShoutoutBadLink), findsOneWidget);
      expect(repo.saves, isEmpty, reason: 'a bad link is never sent');

      await tester.enterText(
        find.byType(TextField),
        'linkedin.com/in/Asha-Rao',
      );
      await settle(tester);
      expect(find.text(kShoutoutBadLink), findsNothing);

      // No 18+ declaration on record (the app never asks at sign-up): the
      // card asks, un-ticked, and sends nothing until it is ticked.
      final Finder adultBox = find.bySemanticsLabel(
        '$kAdultDeclarationLabel $kAdultDeclarationReason',
      );
      expect(adultBox, findsOneWidget);
      expect(tester.getSemantics(adultBox), _unticked);
      await tapVisible(tester, find.bySemanticsLabel('Feature me'));
      expect(find.text(kShoutoutNeedsAdult), findsOneWidget);
      expect(repo.saves, isEmpty, reason: 'no 18+ tick, nothing sent');

      await tapVisible(tester, adultBox);
      await tapVisible(tester, find.bySemanticsLabel('Feature me'));
      expect(repo.saves, <(bool, String?)>[(true, 'linkedin.com/in/Asha-Rao')]);
      expect(repo.adultTicks, <bool>[true]);
      expect(find.text('You’re in if you make it'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Your link: www.linkedin.com/in/asha-rao'),
        findsOneWidget,
      );
      expect(find.byType(TextField), findsNothing);
      expect(_box(tester), _ticked);

      await tapVisible(tester, _boxFinder);
      expect(repo.saves.last, (false, null));
      expect(find.text('You’re in if you make it'), findsNothing);
      expect(find.byType(TextField), findsNothing);
      expect(_box(tester), _unticked);
    });

    testWidgets('“Not now” closes the field and sends nothing', (
      WidgetTester tester,
    ) async {
      final _Shoutout repo = _Shoutout();
      await pumpContestPage(tester, repo: repo);
      await tapVisible(tester, _boxFinder);
      await tapVisible(tester, find.bySemanticsLabel('Not now'));
      expect(find.byType(TextField), findsNothing);
      expect(repo.saves, isEmpty);
      expect(_box(tester), _unticked);
    });

    testWidgets('the rules open on the web, from the page and from the card', (
      WidgetTester tester,
    ) async {
      final _Opener opener = _Opener();
      await pumpContestPage(
        tester,
        repo: _Shoutout(),
        overrides: <Override>[linkOpeningProvider.overrideWithValue(opener)],
      );
      await tapVisible(
        tester,
        find.bySemanticsLabel(
          'Contest rules — how XP works, what the prize is, and how claims '
          'are checked.',
        ),
      );
      await tapVisible(tester, find.bySemanticsLabel('How featuring works'));
      expect(opener.opened, <String>[
        plexaverseContestRulesUrl,
        '$plexaverseContestRulesUrl#featured',
      ]);
    });

    testWidgets('the join card links the full rules', (
      WidgetTester tester,
    ) async {
      final _Opener opener = _Opener();
      await pumpContestPage(
        tester,
        scenario: FakeContestScenario.notJoined,
        overrides: <Override>[linkOpeningProvider.overrideWithValue(opener)],
      );
      await tapVisible(
        tester,
        find.bySemanticsLabel(
          'Read the full contest rules — every figure, how claims are '
          'checked, and how to appeal.',
        ),
      );
      expect(opener.opened, <String>[plexaverseContestRulesUrl]);
      // A non-entrant has nothing to be featured in.
      expect(find.byType(ShoutoutCard), findsNothing);
    });

    testWidgets('a page that will not open is copied, and said as a page', (
      WidgetTester tester,
    ) async {
      final List<Object?> copied = <Object?>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall call) async {
          if (call.method == 'Clipboard.setData') copied.add(call.arguments);
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      final _Opener opener = _Opener(const LinkOpenFailed());
      await pumpContestPage(
        tester,
        repo: _Shoutout(),
        overrides: <Override>[linkOpeningProvider.overrideWithValue(opener)],
      );
      await tapVisible(tester, find.bySemanticsLabel('How featuring works'));
      expect(copied, <Object?>[
        <String, dynamic>{'text': '$plexaverseContestRulesUrl#featured'},
      ]);
      // A page, not "LinkedIn": the shared helper's words would be wrong here.
      expect(
        find.text('Could not open the page — link copied instead.'),
        findsOneWidget,
      );
    });
  });
}

// ── Fixtures ───────────────────────────────────────────────────────────────

/// Three learners in an order that is no sort of theirs, one with a link the
/// profile rule refuses and one with none.
const ContestFeatured _readyWeek = ContestFeatured(
  week: LearnersOfWeek(
    state: LearnersOfWeekState.ready,
    weekStart: '2026-11-01',
    weekEnd: '2026-11-07',
    learners: <FeaturedPerson>[
      FeaturedPerson(
        key: 'k3',
        name: 'Zoya Khan',
        headline: 'Nurse educator',
        linkedinUrl: 'https://www.linkedin.com/in/zoya-khan',
      ),
      FeaturedPerson(
        key: 'k1',
        name: 'Aman Gupta',
        linkedinUrl: 'javascript:alert(1)',
      ),
      FeaturedPerson(key: 'k2', name: 'Bela Roy', headline: 'Analyst'),
    ],
  ),
);

final Finder _boxFinder = find.bySemanticsLabel(
  RegExp('^${RegExp.escape(kShoutoutToggleLabel)}\\.'),
);

SemanticsNode _box(WidgetTester tester) => tester.getSemantics(_boxFinder);

final Matcher _ticked = isSemantics(hasCheckedState: true, isChecked: true);
final Matcher _unticked = isSemantics(hasCheckedState: true, isChecked: false);

/// The mock flavor's running contest, with the cards' read replaceable and
/// every save recorded.
class _Shoutout extends FakeContestRepository {
  _Shoutout({this.featured, super.scenario}) : super(latency: Duration.zero);

  final ContestFeatured? featured;
  final List<(bool, String?)> saves = <(bool, String?)>[];
  final List<bool> adultTicks = <bool>[];
  int featuredReads = 0;
  int shoutoutReads = 0;

  @override
  Future<ContestFeatured> fetchFeatured() async {
    featuredReads++;
    return featured ?? await super.fetchFeatured();
  }

  @override
  Future<ShoutoutSettings> fetchShoutout() {
    shoutoutReads++;
    return super.fetchShoutout();
  }

  @override
  Future<ShoutoutSettings> setShoutout({
    required bool featured,
    String? linkedinUrl,
    bool adult = false,
  }) {
    saves.add((featured, linkedinUrl));
    adultTicks.add(adult);
    return super.setShoutout(
      featured: featured,
      linkedinUrl: linkedinUrl,
      adult: adult,
    );
  }
}

class _Opener implements LinkOpeningService {
  _Opener([this.result = const LinkOpened()]);

  final LinkOpenResult result;
  final List<String> opened = <String>[];

  @override
  Future<LinkOpenResult> open(String url) async {
    opened.add(url);
    return result;
  }
}

/// The real network stack over a canned answer.
class _Canned implements HttpClientAdapter {
  _Canned(this.status, this.body);

  final int status;
  final Object? body;
  final List<RequestOptions> seen = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiContestRepository, _Canned) _stack(int status, Object? body) {
  final _Canned adapter = _Canned(status, body);
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = adapter
    ..interceptors.add(ErrorInterceptor());
  return (ApiContestRepository(DioClient(dio)), adapter);
}

Map<String, dynamic> _ok(Object? data) => <String, dynamic>{
  'data': data,
  'error': null,
  'meta': <String, dynamic>{'version': 'v1'},
};

Map<String, dynamic> _refusal(String code, String message) => <String, dynamic>{
  'data': null,
  'error': <String, dynamic>{'code': code, 'message': message},
  'meta': <String, dynamic>{'version': 'v1'},
};
