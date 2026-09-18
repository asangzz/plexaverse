import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/timeline/domain/timeline_event.dart';
import 'package:plexaverse/features/timeline/domain/wonder_marker.dart';
import 'package:plexaverse/features/timeline/domain/wonder_type.dart';

/// Guards the Global Timeline mock flavour: the bundled world-history-events
/// and wonder-marker fixtures must parse cleanly through the (generated,
/// camelCase) [TimelineEvent.fromJson] and the hand-written
/// [WonderMarker.fromJson] (which routes its `"type"` key through
/// [WonderTypeX.fromJson]).
///
/// Keys are the Dart field names verbatim (`field_rename: none`, no
/// `@JsonKey` overrides), so any snake_case key would surface here as a
/// null-cast throw or a wrong sample value.
///
/// Note: the bundled `global_events.json` carries 43 world-history events,
/// not the 44 Wonderous's own upstream fixture has — this port's fixture
/// (built by an earlier data phase, not this task) is one event short of
/// Wonderous's original. This test pins the fixture's *actual* count rather
/// than silently asserting a wrong number; flagged here for a future data
/// pass to reconcile against Wonderous's `assets/data/timeline/events.json`
/// if full parity is required later.
void main() {
  const globalEventsPath = 'assets/mock/timeline/global_events.json';
  const wondersPath = 'assets/mock/timeline/wonders.json';

  group('global_events.json fixture', () {
    test('every entry parses through TimelineEvent.fromJson', () {
      final raw = File(globalEventsPath).readAsStringSync();
      final list = jsonDecode(raw) as List<dynamic>;
      final events = list
          .map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>))
          .toList();

      expect(events, hasLength(43));
      expect(events.length, list.length);

      // Spot-check a known event: King Khufu completes the Great Pyramid.
      final khufuEvent = events.firstWhere((e) => e.year == -2560);
      expect(khufuEvent.description, contains('Khufu'));

      // Sorted ascending in the fixture itself (the merged+sorted order is
      // GlobalTimelineController's job, not the raw fixture's).
      for (var i = 1; i < events.length; i++) {
        expect(events[i].year, greaterThanOrEqualTo(events[i - 1].year));
      }
    });
  });

  group('wonders.json fixture', () {
    test('every entry parses through WonderMarker.fromJson', () {
      final raw = File(wondersPath).readAsStringSync();
      final list = jsonDecode(raw) as List<dynamic>;
      final wonders = list
          .map((e) => WonderMarker.fromJson(e as Map<String, dynamic>))
          .toList();

      expect(wonders, hasLength(8));
      expect(wonders.length, list.length);

      // Every wonder type appears exactly once (all 8 enum values covered).
      final types = wonders.map((w) => w.type).toSet();
      expect(types, hasLength(8));
      expect(types, WonderType.values.toSet());

      // Spot-check a known wonder: the Pyramids of Giza's construction span.
      final pyramids = wonders.firstWhere(
        (w) => w.type == WonderType.pyramidsGiza,
      );
      expect(pyramids.title, 'Pyramids of Giza');
      expect(pyramids.startYr, -2600);
      expect(pyramids.endYr, -2500);

      // Every marker carries a picsum thumb and a non-empty title.
      for (final wonder in wonders) {
        expect(wonder.title, isNotEmpty);
        expect(wonder.thumbnailUrl, startsWith('https://picsum.photos/'));
        expect(wonder.startYr, lessThan(wonder.endYr));
      }
    });
  });
}
