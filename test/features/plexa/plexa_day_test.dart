import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/plexa/domain/plexa_day.dart';

/// [PlexaDay] — the wire shape of Open Plexa's day.
///
/// The mapping is hand-written because the server nests lanes under `lanes`
/// and the session under `done`, so these pin the two places that nesting can
/// be got wrong, plus the one distinction the whole screen is built around:
/// a lane that is NOT READY is not a lane that is FINISHED.
void main() {
  Map<String, dynamic> wire({
    Object? session,
    Object? lanes,
    String topic = '',
  }) => <String, dynamic>{
    'session': ?session,
    'lanes': ?lanes,
    'topic': topic,
  };

  final Map<String, dynamic> lanes = <String, dynamic>{
    'comments': <String, dynamic>{
      'ready': true,
      'items': <dynamic>[
        <String, dynamic>{
          'id': 'comments:0',
          'comment': 'a remark',
          'searchKeywords': 'onboarding',
          'targetPostTitle': 'a founder post',
        },
      ],
    },
    'connections': <String, dynamic>{
      'ready': true,
      'items': <dynamic>[
        <String, dynamic>{
          'id': 'connections:0',
          'role': 'Head of Product',
          'company': 'Razorpay',
          'note': 'hello',
          'searchUrl': 'https://www.linkedin.com/search/x',
          'isDirectMessage': true,
        },
      ],
    },
    'topVoices': <String, dynamic>{
      'ready': true,
      'items': <dynamic>[
        <String, dynamic>{
          'id': 'shown-1',
          'postUrl': 'https://www.linkedin.com/feed/x',
          'authorName': 'A Person',
          'firstLine': 'An opening line.',
          'comment': 'well put',
          'actedAt': null,
        },
        <String, dynamic>{
          'id': 'shown-2',
          'postUrl': 'https://www.linkedin.com/feed/y',
          'authorName': 'Another',
          'firstLine': 'Another line.',
          'comment': 'agreed',
          'actedAt': '2026-10-06T09:00:00.000Z',
        },
      ],
    },
  };

  group('the session', () {
    test('reads the ids out of the nested done map', () {
      final PlexaDay d = PlexaDay.fromWire(
        wire(
          session: <String, dynamic>{
            'done': <String, dynamic>{
              'comments': <String>['comments:0', 'comments:2'],
              'connections': <String>['connections:1'],
            },
          },
        ),
      );

      expect(d.session.comments, <String>['comments:0', 'comments:2']);
      expect(d.session.connections, <String>['connections:1']);
      expect(d.session.isDone(PlexaLane.comments, 'comments:2'), isTrue);
      expect(d.session.isDone(PlexaLane.connections, 'comments:2'), isFalse);
    });

    test('a missing or malformed session is empty, not a crash', () {
      // The server's own read never throws — it returns an empty session on a
      // database error so the user gets a day they can still work through.
      // The client must not be the thing that breaks instead.
      expect(PlexaDay.fromWire(wire()).session.comments, isEmpty);
      expect(
        PlexaDay.fromWire(wire(session: 'nonsense')).session.connections,
        isEmpty,
      );
      expect(
        PlexaDay.fromWire(
          wire(session: <String, dynamic>{'done': 42}),
        ).session.comments,
        isEmpty,
      );
    });

    test('non-string ids are dropped rather than coerced', () {
      final PlexaDay d = PlexaDay.fromWire(
        wire(
          session: <String, dynamic>{
            'done': <String, dynamic>{
              'comments': <dynamic>['comments:0', 7, null],
            },
          },
        ),
      );
      expect(d.session.comments, <String>['comments:0']);
    });
  });

  group('ready is not the same as empty', () {
    // THE DISTINCTION THE SCREEN IS BUILT ON. `ready: false` means today's
    // work has not been generated, which costs XP to fix and needs a button.
    // An empty list means it was generated and cleared. Collapsing the two
    // hides that button behind a day that looks finished.
    test('a lane with no items and ready:false is not ready', () {
      final PlexaDay d = PlexaDay.fromWire(
        wire(
          lanes: <String, dynamic>{
            'comments': <String, dynamic>{'ready': false, 'items': <dynamic>[]},
          },
        ),
      );
      expect(d.comments.ready, isFalse);
      expect(d.comments.items, isEmpty);
    });

    test('a lane with no items but ready:true IS ready', () {
      final PlexaDay d = PlexaDay.fromWire(
        wire(
          lanes: <String, dynamic>{
            'comments': <String, dynamic>{'ready': true, 'items': <dynamic>[]},
          },
        ),
      );
      expect(d.comments.ready, isTrue);
    });

    test('a day with nothing prepared anywhere reports itself empty', () {
      expect(PlexaDay.fromWire(wire()).isEmpty, isTrue);
    });

    test('one prepared lane is enough to not be empty', () {
      final PlexaDay d = PlexaDay.fromWire(
        wire(
          lanes: <String, dynamic>{
            'topVoices': <String, dynamic>{'ready': true, 'items': <dynamic>[]},
          },
        ),
      );
      expect(d.isEmpty, isFalse);
    });
  });

  group('items', () {
    test('every lane parses', () {
      final PlexaDay d = PlexaDay.fromWire(
        wire(lanes: lanes, topic: 'onboarding'),
      );
      expect(d.comments.items.single.comment, 'a remark');
      expect(d.connections.items.single.isDirectMessage, isTrue);
      expect(d.topVoices.items, hasLength(2));
      expect(d.topic, 'onboarding');
    });

    test('a Top Voice knows it is done from its own stamp', () {
      // That lane does not use the session: the comments screen reads the same
      // rows, so the stamp has to be the shared truth.
      final PlexaDay d = PlexaDay.fromWire(wire(lanes: lanes));
      expect(d.topVoices.items[0].isDone, isFalse);
      expect(d.topVoices.items[1].isDone, isTrue);
    });

    test('an unparseable lane is empty rather than fatal', () {
      final PlexaDay d = PlexaDay.fromWire(
        wire(
          lanes: <String, dynamic>{
            'comments': 'not a lane',
            'connections': <String, dynamic>{'items': 'not a list'},
          },
        ),
      );
      expect(d.comments.items, isEmpty);
      expect(d.connections.items, isEmpty);
    });
  });

  group('the day’s count', () {
    test('totals every lane and counts both kinds of done', () {
      // Two sources of truth meet here: the session covers the generated
      // lanes, the stamp covers Top Voices. Counting only one of them is how
      // a finished day reads as half done.
      final PlexaDay d = PlexaDay.fromWire(
        wire(
          session: <String, dynamic>{
            'done': <String, dynamic>{
              'comments': <String>['comments:0'],
            },
          },
          lanes: <String, dynamic>{
            'comments': <String, dynamic>{
              'ready': true,
              'items': <dynamic>[
                <String, dynamic>{'id': 'comments:0'},
                <String, dynamic>{'id': 'comments:1'},
              ],
            },
            'topVoices': <String, dynamic>{
              'ready': true,
              'items': <dynamic>[
                <String, dynamic>{
                  'id': 's1',
                  'actedAt': '2026-10-06T00:00:00Z',
                },
              ],
            },
          },
        ),
      );

      expect(d.total, 3);
      expect(d.done, 2); // one session id + one stamped Top Voice
    });

    test('an untouched day is zero of its total', () {
      final PlexaDay d = PlexaDay.fromWire(wire(lanes: lanes));
      expect(d.done, 1); // shown-2 arrives already stamped
      expect(d.total, 4);
    });
  });
}
