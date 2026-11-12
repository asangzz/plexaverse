import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/studio/application/studio_editor_controller.dart';
import 'package:plexaverse/features/studio/application/studio_editor_state.dart';
import 'package:plexaverse/features/studio/data/studio_repositories.dart';
import 'package:plexaverse/features/studio/domain/studio_design.dart';

/// A pasted image URL must be one the server's renderer will draw.
///
/// Since web 92f6aa2 the renderer fetches a design's images from inside our
/// network with the `public` policy, which takes https only. An `http://`
/// image used to be accepted here, saved with the design, and then drawn as
/// an empty placeholder — a swap that reported success and showed nothing.
void main() {
  const String design = 'mock-design-1';
  const String hero = 'hero';

  Future<ProviderContainer> open() async {
    final ProviderContainer c = ProviderContainer(
      overrides: <Override>[
        studioRepositoryProvider.overrideWithValue(FakeStudioRepository()),
      ],
    );
    addTearDown(c.dispose);
    // Keep the auto-disposed editor alive for the length of the test.
    c.listen(studioEditorProvider(design), (_, _) {});
    await c.read(studioEditorProvider(design).future);
    return c;
  }

  StudioEditorState state(ProviderContainer c) =>
      c.read(studioEditorProvider(design)).requireValue;

  String? heroUrl(ProviderContainer c) => state(
    c,
  ).data.elements.firstWhere((StudioElement e) => e.id == hero).imageUrl;

  test('an https URL is swapped in', () async {
    final ProviderContainer c = await open();
    final bool ok = c
        .read(studioEditorProvider(design).notifier)
        .swapImageFromUrl(hero, '  https://art.example/hero.png ');

    expect(ok, isTrue);
    expect(heroUrl(c), 'https://art.example/hero.png');
    expect(state(c).swapError, isNull);
    expect(state(c).dirty, isTrue);
  });

  test('plain http is refused, and says why', () async {
    final ProviderContainer c = await open();
    final String? before = heroUrl(c);
    final bool ok = c
        .read(studioEditorProvider(design).notifier)
        .swapImageFromUrl(hero, 'http://art.example/hero.png');

    expect(ok, isFalse);
    expect(heroUrl(c), before);
    expect(state(c).swapError, contains('https://'));
  });

  for (final String bad in <String>[
    'art.example/hero.png',
    'file:///etc/passwd',
    'https://',
    'ftp://art.example/hero.png',
    '',
  ]) {
    test('"$bad" is not an image URL', () async {
      final ProviderContainer c = await open();
      final String? before = heroUrl(c);
      final bool ok = c
          .read(studioEditorProvider(design).notifier)
          .swapImageFromUrl(hero, bad);

      expect(ok, isFalse);
      expect(heroUrl(c), before);
      expect(state(c).swapError, 'That does not look like an image URL.');
    });
  }
}
