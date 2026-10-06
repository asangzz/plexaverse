import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/plexa/domain/plexa_day.dart';

void main() {
  group('PlexaDay.fromWire', () {
    test('reads the aggregate the mobile route sends', () {
      final PlexaDay day = PlexaDay.fromWire(<String, dynamic>{
        'session': <String, dynamic>{
          'done': <String, dynamic>{
            'comments': <String>['tv:shown-1'],
            'connections': <String>[],
          },
        },
        'items': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'tv:shown-1',
            'lane': 'comments',
            'headline': 'A curated post',
            'context': 'Priya Raman · priyaraman',
            'draft': 'A comment',
            'url': 'https://www.linkedin.com/feed/update/urn:li:share:1',
            'topVoiceId': 'shown-1',
          },
          <String, dynamic>{
            'id': 'cn:0',
            'lane': 'connections',
            'headline': 'Head of Product',
            'draft': 'A note',
            'url': 'https://www.linkedin.com/search/results/people/',
          },
        ],
        'ready': <String, dynamic>{
          'comments': true,
          'connections': true,
          'topVoices': true,
        },
        'topic': 'onboarding',
      });

      expect(day.items, hasLength(2));
      expect(day.items.first.lane, PlexaLane.comments);
      expect(day.items.first.topVoiceId, 'shown-1');
      expect(day.items.last.lane, PlexaLane.connections);
      // Absent, not empty string — the sub-line is skipped when there is none.
      expect(day.items.last.context, isNull);
      expect(day.topic, 'onboarding');
      expect(day.clearedCount, 1);
    });

    test('ids keep the web prefixes they arrived with', () {
      // The two clients write cleared ids into the SAME `plexa_day` row. If
      // this port ever re-derived ids locally, a user who worked on the
      // browser in the morning and the phone in the evening would be shown
      // the same five posts twice.
      final PlexaDay day = PlexaDay.fromWire(<String, dynamic>{
        'items': <Map<String, dynamic>>[
          <String, dynamic>{'id': 'tv:abc', 'lane': 'comments'},
          <String, dynamic>{'id': 'nw:0', 'lane': 'comments'},
          <String, dynamic>{'id': 'cn:3', 'lane': 'connections'},
        ],
      });

      expect(day.items.map((DayItem i) => i.id), <String>[
        'tv:abc',
        'nw:0',
        'cn:3',
      ]);
    });

    test('survives a malformed payload instead of taking the sheet down', () {
      // The server answers an empty session on a database error so the user
      // still gets a day they can work through. The client must not be the
      // thing that throws instead.
      final PlexaDay day = PlexaDay.fromWire(<String, dynamic>{
        'session': 'nonsense',
        'items': 'nonsense',
        'ready': 42,
      });

      expect(day.items, isEmpty);
      expect(day.session.comments, isEmpty);
      expect(day.ready.nothingPrepared, isTrue);
    });

    test('an unknown lane falls back to comments rather than throwing', () {
      final PlexaDay day = PlexaDay.fromWire(<String, dynamic>{
        'items': <Map<String, dynamic>>[
          <String, dynamic>{'id': 'x:1', 'lane': 'endorsements'},
        ],
      });

      expect(day.items.single.lane, PlexaLane.comments);
    });
  });

  group('PlexaSession', () {
    const DayItem comment = DayItem(id: 'tv:1', lane: PlexaLane.comments);
    const DayItem connection = DayItem(id: 'cn:0', lane: PlexaLane.connections);

    test('isDone reads the item’s own lane, not both', () {
      // Both lanes can hold the same index — `nw:0` and `cn:0` coexist — so a
      // session that searched both lists would mark one lane's item done
      // because the other lane had cleared its own.
      const PlexaSession session = PlexaSession(comments: <String>['cn:0']);

      expect(session.isDone(connection), isFalse);
    });

    test('withDone adds, removes, and never duplicates', () {
      const PlexaSession empty = PlexaSession();

      final PlexaSession once = empty.withDone(comment, done: true);
      final PlexaSession twice = once.withDone(comment, done: true);
      expect(twice.comments, <String>['tv:1']);

      final PlexaSession undone = twice.withDone(comment, done: false);
      expect(undone.comments, isEmpty);
    });

    test('fromWire reads the nested done map', () {
      final PlexaSession session = PlexaSession.fromWire(<String, dynamic>{
        'done': <String, dynamic>{
          'comments': <dynamic>['a', 7, 'b'],
        },
      });

      // 7 is dropped rather than crashing the parse or becoming "7".
      expect(session.comments, <String>['a', 'b']);
      expect(session.connections, isEmpty);
    });
  });

  group('PlexaReady', () {
    test('nothingPrepared separates "not generated" from "all cleared"', () {
      // The two need different answers: a day with nothing PREPARED can be
      // fixed by generating it, which costs XP; a day that was generated and
      // cleared is simply finished.
      expect(const PlexaReady().nothingPrepared, isTrue);
      expect(const PlexaReady(topVoices: true).nothingPrepared, isFalse);
    });
  });

  group('PlexaLane', () {
    test('the noun is what heads an item line', () {
      expect(PlexaLane.comments.noun, 'Comment');
      expect(PlexaLane.connections.noun, 'Request');
    });

    test('parse defaults to comments', () {
      expect(PlexaLane.parse('connections'), PlexaLane.connections);
      expect(PlexaLane.parse('comments'), PlexaLane.comments);
      expect(PlexaLane.parse(null), PlexaLane.comments);
    });
  });
}
