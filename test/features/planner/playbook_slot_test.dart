import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/week/week_shape.dart';
import 'package:plexaverse/features/planner/domain/plan_slot.dart';
import 'package:plexaverse/features/planner/domain/post_formats.dart';
import 'package:plexaverse/features/planner/presentation/widgets/playbook_panels.dart';

/// The playbook week's slot keys (PLANNER_REDESIGN.md §3.2), as the planner
/// reads them: all additive, all absent on a legacy row, and none of them
/// allowed to fail the week's parse when malformed.
void main() {
  PlanSlot parse(Map<String, dynamic> json) =>
      PlanSlot.fromJson(<String, dynamic>{'day': 'Monday', ...json});

  group('a playbook post day', () {
    final PlanSlot slot = parse(<String, dynamic>{
      'kind': 'post',
      'format': 'text_image',
      'role': 'story',
      'formatId': 'mistake_lesson',
      'imageKind': 'photo',
      'formatFellBack': true,
      'review': <String, dynamic>{
        'ok': false,
        'errors': <String>['End with a question.'],
        'warnings': <String>['Shorten the first line.'],
        'checkedAt': '2026-11-25T04:00:00.000Z',
        'refined': true,
      },
      'cardText': 'One line',
      'referencePhoto': <String, dynamic>{
        'path': 'u1/abc.jpg',
        'uploadedAt': '2026-11-25T04:00:00.000Z',
      },
      'status': 'generated',
      'postId': 'p1',
    });

    test('reads role, format, image kind and the fall-back flag', () {
      expect(slot.isNewShape, isTrue);
      expect(slot.role, PostRole.story);
      expect(slot.formatSpec?.name, 'Mistake → lesson');
      expect(slot.imageKind, ImageKind.photo);
      expect(slot.formatFellBack, isTrue);
      expect(slot.cardText, 'One line');
      expect(slot.hasReferencePhoto, isTrue);
      // `format` is still the LinkedIn shape — shipped builds print it raw.
      expect(slot.format, 'text_image');
    });

    test('reads the stored review', () {
      final SlotReview review = slot.review!;
      expect(review.ok, isFalse);
      expect(review.errors, <String>['End with a question.']);
      expect(review.warnings, <String>['Shorten the first line.']);
      expect(review.refined, isTrue);
    });

    test('a stored imageKind beats the format default (a company card)', () {
      final PlanSlot company = parse(<String, dynamic>{
        'kind': 'post',
        'formatId': 'timeline',
        'imageKind': 'text_card',
      });
      expect(company.imageKind, ImageKind.textCard);
    });

    test('without a stored imageKind, the format decides', () {
      final PlanSlot s = parse(<String, dynamic>{
        'kind': 'post',
        'formatId': 'numbered_steps',
      });
      expect(s.imageKind, ImageKind.aiPoster);
      expect(s.role, PostRole.teach);
    });
  });

  group('a legacy or malformed day', () {
    test('a pre-playbook post day has no format, role or image kind', () {
      final PlanSlot s = parse(<String, dynamic>{
        'kind': 'post',
        'format': 'text_image',
        'status': 'planned',
      });
      expect(s.isNewShape, isFalse);
      expect(s.formatSpec, isNull);
      expect(s.imageKind, isNull);
      expect(s.review, isNull);
      expect(s.news, isNull);
      expect(s.wantsImage, isTrue, reason: 'a legacy text_image day');
    });

    test('an unknown formatId is a legacy day, never a guessed format', () {
      final PlanSlot s = parse(<String, dynamic>{
        'kind': 'post',
        'formatId': 'some_future_format',
      });
      expect(s.isNewShape, isFalse);
      expect(s.imageKind, isNull);
    });

    test('garbage in the new keys parses as absent', () {
      final PlanSlot s = parse(<String, dynamic>{
        'kind': 'post',
        'formatId': 42,
        'role': <String>['teach'],
        'imageKind': true,
        'formatFellBack': 'yes',
        'review': 'not a map',
        'referencePhoto': 7,
        'news': <int>[1, 2],
        'cardText': 3,
      });
      expect(s.isNewShape, isFalse);
      expect(s.role, isNull);
      expect(s.formatFellBack, isFalse);
      expect(s.review, isNull);
      expect(s.hasReferencePhoto, isFalse);
      expect(s.news, isNull);
      expect(s.cardText, isNull);
    });

    test('a review without a boolean ok is no review', () {
      expect(SlotReview.tryParse(<String, dynamic>{'errors': <String>[]}), isNull);
    });

    test('a legacy video_script day still parses and is a hand-off', () {
      final PlanSlot s = parse(<String, dynamic>{'kind': 'video_script'});
      expect(s.kind, DayKind.videoScript);
      expect(s.isHandoff, isTrue);
      expect(s.isNewShape, isFalse);
    });
  });

  group('the week news', () {
    Map<String, dynamic> news({int? picked, String? publishedAt}) =>
        <String, dynamic>{
          'candidates': <Map<String, dynamic>>[
            <String, dynamic>{
              'title': 'A',
              'source': 'Mint',
              'url': 'https://www.livemint.com/a',
              'publishedAt': publishedAt,
              'summary': 'S',
            },
            <String, dynamic>{
              'title': 'B',
              'source': 'ET',
              'url': 'https://economictimes.indiatimes.com/b',
              'publishedAt': null,
              'summary': '',
            },
            // Not https — dropped, as the server never stores one.
            <String, dynamic>{'title': 'C', 'url': 'http://x.test/c'},
          ],
          'pickedIndex': picked,
          'fetchedAt': '2026-11-23T04:00:00.000Z',
          'query': 'q',
          'formatId': 'industry_take',
          'fallback': null,
        };

    test('reads the candidates and defaults the pick to the first', () {
      final SlotNews n = SlotNews.tryParse(news())!;
      expect(n.candidates.map((NewsCandidate c) => c.title), <String>['A', 'B']);
      expect(n.pickedIndex, isNull);
      expect(n.chosenIndex, 0);
      expect(n.chosen?.title, 'A');
    });

    test('a stored pick wins; an out-of-range pick is no pick', () {
      expect(SlotNews.tryParse(news(picked: 1))!.chosen?.title, 'B');
      expect(SlotNews.tryParse(news(picked: 5))!.chosenIndex, 0);
    });

    test('an unknown news format or a missing fetchedAt is no news', () {
      expect(
        SlotNews.tryParse(<String, dynamic>{
          ...news(),
          'formatId': 'timeline',
        }),
        isNull,
      );
      expect(
        SlotNews.tryParse(<String, dynamic>{...news(), 'fetchedAt': 'x'}),
        isNull,
      );
    });

    test('freshness: within ten days of publishing, or of the search', () {
      final NewsCandidate dated = SlotNews.tryParse(
        news(publishedAt: '2026-11-20'),
      )!.chosen!;
      final DateTime fetched = DateTime.utc(2026, 11, 23, 4);
      expect(dated.isUsable(fetched, now: DateTime.utc(2026, 11, 29)), isTrue);
      expect(dated.isUsable(fetched, now: DateTime.utc(2026, 12, 1)), isFalse);
    });

    test('odd weeks: Friday opinion; even weeks: Monday teach', () {
      expect(newsDayFor(3).dayIndex, 4);
      expect(newsDayFor(3).formatId, 'industry_take');
      expect(newsDayFor(4).dayIndex, 0);
      expect(newsDayFor(4).formatId, 'educational_infographic');
    });

    test('the news day is the post day whose role is the news role', () {
      final PlanSlot friday = PlanSlot.fromJson(<String, dynamic>{
        'day': 'Friday',
        'kind': 'post',
        'role': 'opinion',
        'formatId': 'industry_take',
      });
      expect(NewsPicker.isNewsDay(friday, 3, 4), isTrue);
      expect(NewsPicker.isNewsDay(friday, 4, 4), isFalse, reason: 'even week');
      final PlanSlot rest = PlanSlot.fromJson(<String, dynamic>{
        'day': 'Friday',
        'kind': 'rest',
      });
      expect(NewsPicker.isNewsDay(rest, 3, 4), isFalse);
    });

    test('a slot carries its news through the plan JSON', () {
      final PlanSlot s = parse(<String, dynamic>{
        'kind': 'post',
        'role': 'opinion',
        'formatId': 'industry_take',
        'news': news(picked: 1),
      });
      expect(s.news?.chosen?.title, 'B');
    });
  });

  group('the photo ask', () {
    test('"a …" guides read as they are; others as "a photo of …"', () {
      expect(
        photoAsk('a candid photo of you at your desk with your laptop and coffee'),
        'Give us a candid photo of you at your desk with your laptop and coffee.',
      );
      expect(
        photoAsk('you doing what this post is about'),
        'Give us a photo of you doing what this post is about.',
      );
      expect(photoAsk(null), 'Give us a photo of you that fits this post.');
    });
  });

  group('the format table agrees with the server', () {
    test('every id, role, name, image kind and photo guide matches', () {
      final File web = File('../../lib/post-formats.ts');
      if (!web.existsSync()) {
        markTestSkipped('web repo not beside this checkout');
        return;
      }
      final String src = web.readAsStringSync();
      final String defs = src.substring(src.indexOf('const DEFS'));
      final List<String> blocks = defs.split(RegExp(r"\n\s*id: '")).skip(1).toList();
      expect(blocks, hasLength(postFormats.length));

      String? field(String block, String name) {
        final RegExpMatch? m = RegExp(
          "\\n\\s*$name: (null|'((?:[^'\\\\]|\\\\.)*)')",
        ).firstMatch(block);
        if (m == null || m.group(1) == 'null') return null;
        return m.group(2)!.replaceAll(r"\'", "'");
      }

      for (final String block in blocks) {
        final String id = block.substring(0, block.indexOf("'"));
        final PostFormatInfo? mine = postFormats[id];
        expect(mine, isNotNull, reason: 'the app does not know $id');
        expect(mine!.role.wire, field(block, 'role'), reason: id);
        expect(mine.name, field(block, 'name'), reason: id);
        expect(mine.oneLine, field(block, 'oneLine'), reason: id);
        expect(mine.imageKind.wire, field(block, 'imageKind'), reason: id);
        expect(mine.photoGuide, field(block, 'photoGuide'), reason: id);
      }
    });
  });
}
