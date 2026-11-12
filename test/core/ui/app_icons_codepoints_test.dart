import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plexaverse/core/ui/app_icons.dart';

/// The contest's glyphs are the glyphs their names say.
///
/// A wrong codepoint fails nothing: the font draws the tofu box, or a
/// different glyph, and neither the analyzer nor a render test can tell.
/// Codepoints also move between Font Awesome majors — `wand-magic-sparkles`
/// is 0xe2ca in FA7 and 0xf72b in FA6 — so one typed from memory is a coin
/// toss. Each entry below is held to the package's own declaration of the
/// glyph, in the version the app actually resolved.
///
/// [AppIcons] builds plain `IconData` rather than using `FontAwesomeIcons`
/// (its header says why); the package is read here only as the reference.
///
/// It covers the glyphs the contest added and the ones its path reuses, not
/// the whole file. Some older entries name their glyph loosely in a trailing
/// comment — [AppIcons.share] draws share-nodes — and a sweep would fail on
/// those names rather than on a wrong glyph. A glyph added later for the
/// contest belongs in this map.
void main() {
  const Map<String, (IconData, IconData)> glyphs =
      <String, (IconData, IconData)>{
        // Added for the contest.
        'fire': (AppIcons.fire, FontAwesomeIcons.fire),
        'medal': (AppIcons.medal, FontAwesomeIcons.medal),
        'userGroup': (AppIcons.userGroup, FontAwesomeIcons.userGroup),
        'bullseye': (AppIcons.bullseye, FontAwesomeIcons.bullseye),
        'chest': (AppIcons.chest, FontAwesomeIcons.boxOpen),
        // The roadmap's nav row, when the contest took the home slot.
        'roadmap': (AppIcons.roadmap, FontAwesomeIcons.solidMap),
        // Reused by the path, one per kind of level.
        'star': (AppIcons.star, FontAwesomeIcons.solidStar),
        'linkedInIn': (AppIcons.linkedInIn, FontAwesomeIcons.linkedinIn),
        'comment': (AppIcons.comment, FontAwesomeIcons.solidComment),
        'forum': (AppIcons.forum, FontAwesomeIcons.solidComments),
        'camera': (AppIcons.camera, FontAwesomeIcons.solidCamera),
        'sparkle': (AppIcons.sparkle, FontAwesomeIcons.wandMagicSparkles),
        'play': (AppIcons.play, FontAwesomeIcons.play),
        'article': (AppIcons.article, FontAwesomeIcons.solidFileLines),
        'bolt': (AppIcons.bolt, FontAwesomeIcons.bolt),
        'trophy': (AppIcons.trophy, FontAwesomeIcons.trophy),
      };

  for (final MapEntry<String, (IconData, IconData)> e in glyphs.entries) {
    test("AppIcons.${e.key} is Font Awesome's glyph", () {
      final (IconData ours, IconData theirs) = e.value;
      expect(
        ours.codePoint,
        theirs.codePoint,
        reason:
            'AppIcons.${e.key} is 0x${ours.codePoint.toRadixString(16)}; the '
            'bundled font has it at 0x${theirs.codePoint.toRadixString(16)}',
      );
      expect(
        ours.fontFamily,
        theirs.fontFamily,
        reason:
            'the same codepoint in another style is another glyph, or none — '
            'brand marks live in their own font',
      );
      expect(ours.fontPackage, theirs.fontPackage);
    });
  }

  test('the style guide lists every glyph the contest added', () {
    for (final String name in <String>[
      'fire',
      'medal',
      'userGroup',
      'bullseye',
      'chest',
      'roadmap',
    ]) {
      expect(AppIcons.all[name], glyphs[name]!.$1, reason: name);
    }
  });
}
