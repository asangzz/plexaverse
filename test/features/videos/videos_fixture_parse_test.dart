import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/videos/domain/video_item.dart';

/// Guards the videos mock flavour: the bundled library fixture must parse
/// cleanly through the (generated, camelCase) [VideoItem.fromJson].
///
/// Keys are the Dart field names verbatim (`field_rename: none`, no
/// `@JsonKey` overrides), so any snake_case key would surface here as a
/// null-cast throw or a wrong sample value. The value assertions pin the
/// fixture to the reference screenshot (2354): 7 rows — Quick Avatar
/// Video / Plexaverse Ad / Avatar IV Video ×2 / Elle / Avatar Video ×2.
void main() {
  const fixturePath = 'assets/mock/videos/videos.json';

  List<dynamic> readFixtureFromDisk() {
    final raw = File(fixturePath).readAsStringSync();
    return jsonDecode(raw) as List<dynamic>;
  }

  group('videos.json fixture', () {
    test('parses through VideoItem.fromJson with expected values', () {
      final list = readFixtureFromDisk();
      final videos = list
          .map((e) => VideoItem.fromJson(e as Map<String, dynamic>))
          .toList();

      expect(videos, hasLength(7));
      expect(videos.length, list.length);

      // Row 1 — full house: badge + duration chip.
      final first = videos.first;
      expect(first.id, 'vid_001');
      expect(first.title, 'Quick Avatar Video');
      expect(first.dateLabel, 'July 04, 2026');
      expect(first.badgeLabel, 'Avatar IV');
      expect(first.durationLabel, '00:08');
      expect(first.thumbnailUrl, startsWith('https://picsum.photos/'));

      // Row 2 — a Draft: badge but no rendered duration.
      final draft = videos[1];
      expect(draft.title, 'Plexaverse Ad');
      expect(draft.badgeLabel, 'Draft');
      expect(draft.durationLabel, isNull);

      // Rows 3–4 — no badge, no duration (the two "Avatar IV Video" rows).
      for (final bare in <VideoItem>[videos[2], videos[3]]) {
        expect(bare.title, 'Avatar IV Video');
        expect(bare.badgeLabel, isNull);
        expect(bare.durationLabel, isNull);
      }

      // Last row — "Avatar Video", Avatar IV badge, 00:41.
      final last = videos.last;
      expect(last.title, 'Avatar Video');
      expect(last.dateLabel, 'July 02, 2026');
      expect(last.badgeLabel, 'Avatar IV');
      expect(last.durationLabel, '00:41');

      // Every row carries the required non-null display fields.
      for (final v in videos) {
        expect(v.id, isNotEmpty);
        expect(v.title, isNotEmpty);
        expect(v.dateLabel, isNotEmpty);
        expect(v.thumbnailUrl, isNotEmpty);
      }
    });
  });
}
