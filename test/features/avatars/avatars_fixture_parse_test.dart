import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/avatars/domain/avatar_look.dart';
import 'package:plexaverse/features/avatars/domain/avatar_profile.dart';

/// Guards the avatars mock flavour: the bundled profile + looks fixtures
/// must parse cleanly through the (generated, camelCase)
/// [AvatarProfile.fromJson] / [AvatarLook.fromJson].
///
/// Keys are the Dart field names verbatim (`field_rename: none`, no
/// `@JsonKey` overrides), so any snake_case key would surface here as a
/// null-cast throw or a wrong sample value. The value assertions pin the
/// fixtures to the reference screenshot (2369): "Ruchika", 21 looks, voice
/// "Ruchika", 8 portrait look cards.
void main() {
  const profilePath = 'assets/mock/avatars/profile.json';
  const looksPath = 'assets/mock/avatars/looks.json';

  group('profile.json fixture', () {
    test('parses through AvatarProfile.fromJson with expected values', () {
      final raw = File(profilePath).readAsStringSync();
      final profile = AvatarProfile.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );

      expect(profile.name, 'Ruchika');
      expect(profile.lookCount, 21);
      expect(profile.voiceName, 'Ruchika');
      expect(profile.avatarUrl, startsWith('https://picsum.photos/'));

      // The header pill caption derived on the model.
      expect(profile.looksLabel, '21 looks');
    });
  });

  group('looks.json fixture', () {
    test('every entry parses through AvatarLook.fromJson', () {
      final raw = File(looksPath).readAsStringSync();
      final list = jsonDecode(raw) as List<dynamic>;
      final looks = list
          .map((e) => AvatarLook.fromJson(e as Map<String, dynamic>))
          .toList();

      expect(looks, hasLength(8));
      expect(looks.length, list.length);

      expect(looks.first.id, 'look_001');
      expect(looks.last.id, 'look_008');

      // Every card carries a portrait picsum thumb and a unique id.
      final ids = <String>{};
      for (final look in looks) {
        expect(look.id, isNotEmpty);
        expect(look.thumbnailUrl, startsWith('https://picsum.photos/'));
        expect(look.thumbnailUrl, endsWith('/300/400'));
        expect(ids.add(look.id), isTrue, reason: 'duplicate id ${look.id}');
      }
    });
  });
}
