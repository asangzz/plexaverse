import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/plexa/domain/plexa_day.dart';

void main() {
  group('plexaItemId', () {
    test('mirrors the ids the server writes', () {
      // The server authors these in app/api/mobile/v1/plexa/day/route.ts —
      // `nw:${i}` as it walks the comment rows, `cn:${i}` for connections.
      // Open Plexa reads them off the aggregate and never builds one; the two
      // engagement screens fetch their own batches, so they need this mirror
      // to write into the SAME row.
      expect(plexaItemId(PlexaLane.comments, 0), 'nw:0');
      expect(plexaItemId(PlexaLane.comments, 4), 'nw:4');
      expect(plexaItemId(PlexaLane.connections, 0), 'cn:0');
      expect(plexaItemId(PlexaLane.connections, 11), 'cn:11');
    });

    test('the two lanes never collide at the same index', () {
      // They share one row. `comments:0` and a bare `0` would have — which is
      // exactly the divergence the id prefixes were introduced to stop.
      for (int i = 0; i < 20; i++) {
        expect(
          plexaItemId(PlexaLane.comments, i),
          isNot(plexaItemId(PlexaLane.connections, i)),
        );
      }
    });

    test('never produces a Top Voices id', () {
      // That lane is keyed on a durable TopVoiceShown row id, not a position,
      // and has its own actedAt column. A positional `tv:` would be wrong in
      // a way nothing would notice until two users' days crossed over.
      for (final PlexaLane lane in PlexaLane.values) {
        expect(plexaItemId(lane, 0).startsWith('tv:'), isFalse);
      }
    });
  });

  group('the shared day session', () {
    test('seeds a lane from exactly its own ids', () {
      const PlexaSession session = PlexaSession(
        comments: <String>['nw:0', 'nw:2'],
        connections: <String>['cn:1'],
      );

      bool sentComment(int i) => session
          .doneIn(PlexaLane.comments)
          .contains(plexaItemId(PlexaLane.comments, i));
      bool sentConnection(int i) => session
          .doneIn(PlexaLane.connections)
          .contains(plexaItemId(PlexaLane.connections, i));

      expect(sentComment(0), isTrue);
      expect(sentComment(1), isFalse);
      expect(sentComment(2), isTrue);

      // Index 1 is done in connections and NOT in comments. Reading the wrong
      // lane would have crossed them.
      expect(sentConnection(1), isTrue);
      expect(sentComment(1), isFalse);
    });

    test('an empty session marks nothing sent', () {
      // What a user who has done nothing today sees — and what a failed
      // session read degrades to, which must look like "not yet", never like
      // "all done".
      const PlexaSession empty = PlexaSession();
      for (int i = 0; i < 10; i++) {
        expect(
          empty.doneIn(PlexaLane.comments).contains(
            plexaItemId(PlexaLane.comments, i),
          ),
          isFalse,
        );
      }
    });

    test('a Top Voices id in the comments lane marks no niche draft', () {
      // Both halves of the comments screen write into the same lane: the
      // curated posts as `tv:<shownId>`, the niche drafts as `nw:<i>`. The
      // prefixes are what keep five curated clears from ticking five drafts.
      const PlexaSession session = PlexaSession(
        comments: <String>['tv:shown-1', 'tv:shown-2'],
      );

      for (int i = 0; i < 5; i++) {
        expect(
          session.doneIn(PlexaLane.comments).contains(
            plexaItemId(PlexaLane.comments, i),
          ),
          isFalse,
        );
      }
    });

    test('withDone round-trips an engagement id', () {
      const PlexaSession empty = PlexaSession();
      const DayItem item = DayItem(id: 'nw:3', lane: PlexaLane.comments);

      final PlexaSession after = empty.withDone(item, done: true);
      expect(after.comments, <String>['nw:3']);
      expect(after.connections, isEmpty);

      expect(after.withDone(item, done: false).comments, isEmpty);
    });
  });
}
