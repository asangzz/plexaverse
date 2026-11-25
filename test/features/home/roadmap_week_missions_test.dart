import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/week/week_shape.dart';
import 'package:plexaverse/features/home/domain/roadmap_level.dart';
import 'package:plexaverse/features/home/domain/roadmap_progress.dart';

/// The roadmap's "Publish a post" step follows the playbook week (25 Nov
/// 2026): Mon, Wed and Fri post; Tue and the weekend rest; Thursday is the
/// newsletter, which never becomes a Post. Days lived before it keep the old
/// week (Mon and Tue posts, Wed and Fri video scripts), as the web's
/// `dayKindOn` in lib/roadmap-data.ts keeps them.
void main() {
  // Day 1 = Mon 16 Nov 2026; day 10 = Wed 25 Nov, the first playbook day.
  final DateTime startedAt = DateTime(2026, 11, 16);

  RoadmapProgress progressOn(int currentDay) =>
      RoadmapProgress(currentDay: currentDay, roadmapStartedAt: startedAt);

  Set<int> postDays(List<RoadmapLevel> days) => <int>{
    for (final RoadmapLevel d in days)
      if (d.steps.any((RoadmapStep s) => s.key == 'publish-post')) d.id,
  };

  group('which days ask for a post', () {
    test('Mon, Wed and Fri from 25 Nov; Mon and Tue before it', () {
      // Window 1…19: Mon 16 Nov … Fri 4 Dec.
      final List<RoadmapLevel> days = buildRoadmap(progressOn(12));
      expect(days.first.id, 1);
      expect(days.last.id, 19);
      expect(postDays(days), <int>{
        1, 2, // Mon 16, Tue 17 — the old week
        8, 9, // Mon 23, Tue 24 — the old week
        10, 12, // Wed 25, Fri 27
        15, 17, 19, // Mon 30, Wed 2 Dec, Fri 4 Dec
      });
    });

    test('Thursday is the newsletter, never a post', () {
      expect(roadmapDayKind(11, startedAt), DayKind.article); // Thu 26 Nov
      expect(roadmapDayKind(18, startedAt), DayKind.article); // Thu 3 Dec
    });

    test('Tuesday and the weekend rest in the playbook week', () {
      for (final int day in <int>[13, 14, 16]) {
        expect(roadmapDayKind(day, startedAt), DayKind.rest, reason: '$day');
      }
    });

    test('a lived day keeps the week it was lived under', () {
      expect(roadmapDayKind(2, startedAt), DayKind.post); // Tue 17
      expect(roadmapDayKind(3, startedAt), DayKind.videoScript); // Wed 18
      expect(roadmapDayKind(5, startedAt), DayKind.videoScript); // Fri 20
    });

    test('no day in the playbook week asks for a video script', () {
      for (int day = 10; day <= 30; day++) {
        expect(
          roadmapDayKind(day, startedAt),
          isNot(DayKind.videoScript),
          reason: 'day $day',
        );
      }
      for (final RoadmapLevel d in buildRoadmap(progressOn(20))) {
        for (final RoadmapStep s in d.steps) {
          expect(s.title.toLowerCase(), isNot(contains('script')));
          expect(s.title.toLowerCase(), isNot(contains('video')));
        }
      }
    });

    test('without a start date the step stays', () {
      final List<RoadmapLevel> days = buildRoadmap(
        const RoadmapProgress(currentDay: 5),
      );
      expect(postDays(days), <int>{for (final RoadmapLevel d in days) d.id});
    });
  });

  group('"Generate the next post" opens the next posting day', () {
    String linkOn(int currentDay, DateTime now) {
      final RoadmapLevel today = buildRoadmap(
        progressOn(currentDay),
        now: now,
      ).firstWhere((RoadmapLevel d) => d.id == currentDay);
      final RoadmapStep step = today.steps.firstWhere(
        (RoadmapStep s) => s.key == 'publish-post',
      );
      expect(step.title, '📝 Generate the next post');
      return step.moduleLink;
    }

    test('Wednesday → Friday', () {
      expect(linkOn(10, DateTime(2026, 11, 25, 10)), '/planner?slot=4');
    });

    test('Friday → Monday, over the weekend', () {
      expect(linkOn(12, DateTime(2026, 11, 27, 10)), '/planner?slot=0');
    });

    test('Monday → Wednesday, past the rest day', () {
      expect(linkOn(15, DateTime(2026, 11, 30, 10)), '/planner?slot=2');
    });
  });
}
