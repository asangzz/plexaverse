import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/placement/domain/placement_repository.dart';

/// The placement wire shapes, read from bodies shaped exactly like the web's
/// `PlacementStatus`, `PlacementStep` and `PlacementResult` as they arrive
/// over JSON (dates as ISO strings).
void main() {
  group('PlacementStatus', () {
    test('reads a placed learner in the cooldown', () {
      final PlacementStatus s = PlacementStatus.fromJson(<String, dynamic>{
        'band': 'B1',
        'hasPlacement': true,
        'latest': <String, dynamic>{
          'attemptId': 'att_1',
          'completedAt': '2026-11-09T10:00:00.000Z',
          'band': 'B1',
          'vocabularyBand': 'B2',
          'grammarBand': 'B1',
          'readingBand': 'A2',
          'writingBand': null,
          'writingFeedback': null,
          'writingPending': true,
          'closedEarly': false,
          'measured': <String, dynamic>{
            'vocabulary': true,
            'grammar': true,
            'reading': true,
          },
        },
        'inProgress': null,
        'canStart': false,
        'nextRetakeAt': '2026-12-09T10:00:00.000Z',
        'writingConsent': false,
      });

      expect(s.band, CefrBand.b1);
      expect(s.hasPlacement, isTrue);
      expect(s.canStart, isFalse);
      expect(s.nextRetakeAt, DateTime.utc(2026, 12, 9, 10));
      expect(s.latest?.skillBands, <ObjectiveSkill, CefrBand>{
        ObjectiveSkill.vocabulary: CefrBand.b2,
        ObjectiveSkill.grammar: CefrBand.b1,
        ObjectiveSkill.reading: CefrBand.a2,
      });
      expect(s.latest?.writingPending, isTrue);
    });

    test('a learner who never placed is at the server\'s default band', () {
      final PlacementStatus s = PlacementStatus.fromJson(<String, dynamic>{
        'hasPlacement': false,
        'latest': null,
        'inProgress': <String, dynamic>{
          'attemptId': 'att_2',
          'answered': 0,
          'closesAt': '2026-11-13T09:00:00.000Z',
        },
        'canStart': true,
        'nextRetakeAt': null,
        'writingConsent': false,
      });

      expect(s.band, defaultBand);
      expect(s.inProgress?.closesAt, DateTime.utc(2026, 11, 13, 9));
    });

    test('an unknown band is no band, never a guessed one', () {
      final PlacementSummary latest =
          PlacementSummary.fromJson(<String, dynamic>{
            'attemptId': 'att_3',
            'band': 'C3',
            'vocabularyBand': 'B1',
            'grammarBand': null,
            'readingBand': 'B1',
          });
      expect(latest.band, isNull);
      // A missing part means the three are not all there to show.
      expect(latest.skillBands, isNull);
    });

    test('a missing `measured` reads as measured, as the web reads it', () {
      final PlacementResult r = PlacementResult.fromJson(<String, dynamic>{
        'band': 'B2',
        'vocabularyBand': 'B2',
        'grammarBand': 'B2',
        'readingBand': 'B2',
      });
      for (final ObjectiveSkill skill in ObjectiveSkill.values) {
        expect(r.measured.of(skill), isTrue);
      }
    });

    test('a part a closed test never scored reads as not measured', () {
      final PlacementResult r = PlacementResult.fromJson(<String, dynamic>{
        'band': 'B1',
        'vocabularyBand': 'B1',
        'grammarBand': 'B1',
        'readingBand': 'B1',
        'closedEarly': true,
        'measured': <String, dynamic>{
          'vocabulary': true,
          'grammar': true,
          'reading': false,
        },
      });
      expect(r.closedEarly, isTrue);
      expect(r.measured.of(ObjectiveSkill.reading), isFalse);
    });
  });

  group('PlacementStep', () {
    test('an objective step carries a question and its handle', () {
      final PlacementStep step = PlacementStep.fromJson(<String, dynamic>{
        'attemptId': 'att_1',
        'stage': 'objective',
        'skill': 'reading',
        'item': <String, dynamic>{
          'id': 'step-14',
          'skill': 'reading',
          'passage': 'A short passage.',
          'prompt': 'What is the passage about?',
          'options': <String>['One', 'Two', 'Three', 'Four'],
        },
        'answered': 14,
        'estimatedTotal': 24,
        'writingTask': null,
        'closesAt': '2026-11-13T09:00:00.000Z',
      });

      expect(step.stage, PlacementStage.objective);
      expect(step.skill, ObjectiveSkill.reading);
      expect(step.item?.id, 'step-14');
      expect(step.item?.options, hasLength(4));
      expect(step.closesAt, isNotNull);
    });

    test('a writing step carries the task and nothing to answer', () {
      final PlacementStep step = PlacementStep.fromJson(<String, dynamic>{
        'attemptId': 'att_1',
        'stage': 'writing',
        'skill': null,
        'item': null,
        'answered': 25,
        'estimatedTotal': 25,
        'writingTask': <String, dynamic>{
          'prompt': standardWritingTask.prompt,
          'hint': standardWritingTask.hint,
          'minChars': 30,
          'maxChars': 1200,
        },
        'closesAt': null,
      });

      expect(step.stage, PlacementStage.writing);
      expect(step.item, isNull);
      expect(step.writingTask, standardWritingTask);
    });

    test('an unknown stage reads as a question, which the page re-checks', () {
      final PlacementStep step = PlacementStep.fromJson(<String, dynamic>{
        'attemptId': 'att_1',
        'stage': 'speaking',
      });
      expect(step.stage, PlacementStage.objective);
    });
  });

  group('the item has nowhere to keep an answer', () {
    test('an answer key or a band on the wire is dropped, not kept', () {
      final PublicPlacementItem item = PublicPlacementItem.fromJson(
        <String, dynamic>{
          'id': 'step-0',
          'skill': 'vocabulary',
          'prompt': 'Pick the word.',
          'options': <String>['a', 'b', 'c', 'd'],
          // Neither is ever sent; if one were, the model must not carry it
          // anywhere a screen could read it.
          'answer': 2,
          'band': 'B1',
        },
      );
      final Map<String, dynamic> kept = item.toJson();
      expect(kept.keys, isNot(contains('answer')));
      expect(kept.keys, isNot(contains('band')));
      expect(kept.keys.toSet(), <String>{
        'id',
        'skill',
        'passage',
        'prompt',
        'options',
      });
    });
  });

  test('every band reads back as itself and names itself', () {
    for (final CefrBand band in CefrBand.values) {
      expect(CefrBand.parse(band.wire), band);
    }
    expect(CefrBand.b2.plainName, 'Upper intermediate');
    expect(CefrBand.parse('b2'), isNull);
    expect(
      placementDisclaimer,
      'A placement estimate to set your lesson level — not a CEFR '
      'certificate.',
    );
  });
}
