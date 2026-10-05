import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/planner/domain/plan_slot.dart';

/// [PlanSlot.kind] — the mirror of `slotKind()` in the web's
/// `lib/week-shape.ts`.
///
/// The week stopped being seven posts: it is two posts, two video scripts, one
/// newsletter and a weekend off. The mobile planner was built for the old
/// shape and the server had already started sending the new one, so these pin
/// the translation.
///
/// The back-compat rule is the dangerous one. `kind` is absent from every plan
/// written before the pivot, and reading the raw field on those rows resolves
/// to null — which blanks the grid for anyone who was mid-week when it
/// shipped. The web guards this by routing every read through `slotKind()`;
/// this is the same guard, and it is why nothing here reads `rawKind`.
void main() {
  PlanSlot slot({String? kind, bool rest = false}) =>
      PlanSlot(day: 'Monday', rawKind: kind, restDay: rest);

  group('the wire values', () {
    test('each kind parses from the string the server sends', () {
      expect(slot(kind: 'post').kind, DayKind.post);
      expect(slot(kind: 'video_script').kind, DayKind.videoScript);
      expect(slot(kind: 'article').kind, DayKind.article);
      expect(slot(kind: 'rest').kind, DayKind.rest);
    });

    test('an unknown kind degrades to a post, never to null', () {
      // A server that adds a fifth kind must not blank the row. A post is the
      // safe reading: it is what the grid already knows how to draw.
      expect(slot(kind: 'webinar').kind, DayKind.post);
    });

    test('the wire spelling round-trips', () {
      for (final DayKind k in DayKind.values) {
        expect(DayKind.parse(k.wire), k);
      }
      // snake_case on the wire, not the Dart name.
      expect(DayKind.videoScript.wire, 'video_script');
    });
  });

  group('plans written before the pivot', () {
    test('a row with no kind and no restDay is a post', () {
      expect(slot().kind, DayKind.post);
    });

    test('a row with no kind but restDay set is a rest day', () {
      // Those rows carry only `restDay`, so they resolve to exactly the two
      // states the product had when they were written.
      expect(slot(rest: true).kind, DayKind.rest);
    });

    test('an explicit kind wins over restDay', () {
      // Belt and braces: the server sends both on new rows, and `kind` is the
      // one that means something.
      expect(slot(kind: 'video_script', rest: true).kind, DayKind.videoScript);
    });
  });

  group('what the chain may publish', () {
    test('only a post day is publishable', () {
      expect(slot(kind: 'post').isPublishable, isTrue);
      expect(slot(kind: 'video_script').isPublishable, isFalse);
      expect(slot(kind: 'article').isPublishable, isFalse);
      expect(slot(kind: 'rest').isPublishable, isFalse);
    });

    test('scripts and the newsletter are hand-offs; posts and rest are not', () {
      // A hand-off is work we prepare and the USER posts. The distinction
      // drives whether the card offers Approve — offering it on a script
      // promises a publish this product cannot perform, because LinkedIn video
      // upload is an API nothing here speaks.
      expect(slot(kind: 'video_script').isHandoff, isTrue);
      expect(slot(kind: 'article').isHandoff, isTrue);
      expect(slot(kind: 'post').isHandoff, isFalse);
      expect(slot(kind: 'rest').isHandoff, isFalse);
    });

    test('a pre-pivot row is publishable, because it was', () {
      expect(slot().isPublishable, isTrue);
      expect(slot(rest: true).isPublishable, isFalse);
    });
  });
}
