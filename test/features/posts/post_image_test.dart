import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/posts/presentation/widgets/post_card.dart';

/// [PostImage] and the three shapes a post's image URL actually takes.
///
/// The one that matters is `data:`. `image_url` holds an inline base64 JPEG on
/// 152 of the 246 posts on the live table that have an image — the generated
/// poster is written straight into the column rather than uploaded — and the
/// loader used to reject anything that did not start with `http`. The LinkedIn
/// preview therefore drew an empty grey box where the post's own picture
/// should be, on most posts that have one, and nothing failed loudly enough to
/// notice: the placeholder IS the error state.
///
/// A 2x2 red PNG, small enough to read inline and real enough to decode.
const String _redDotPng =
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAIAAAD91Jpz'
    'AAAAEElEQVR4nGP4z8AARAwQCgAf7gP9i18U1AAAAABJRU5ErkJggg==';

Future<void> _pump(WidgetTester tester, String url) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(width: 100, height: 100, child: PostImage(url: url)),
      ),
    ),
  );
}

void main() {
  testWidgets('a data: URL is decoded and drawn', (WidgetTester tester) async {
    await _pump(tester, _redDotPng);

    final Image image = tester.widget<Image>(find.byType(Image));
    expect(
      image.image,
      isA<MemoryImage>(),
      reason: 'the bytes are in the URL; there is nothing to fetch',
    );
    // And it must NOT have been handed to the network loader, which cannot
    // read a data: URL and would have produced the placeholder.
    expect(find.byType(CachedNetworkImage), findsNothing);
  });

  testWidgets('the same data: URL yields the identical byte list', (
    WidgetTester tester,
  ) async {
    // Flutter's image cache is keyed on the Uint8List identity. A fresh list
    // per build re-rasterises a megabyte on every "see more" tap, so the
    // memoisation is load-bearing, not an optimisation.
    await _pump(tester, _redDotPng);
    final MemoryImage first =
        tester.widget<Image>(find.byType(Image)).image as MemoryImage;

    await _pump(tester, 'https://example.com/other.jpg');
    await _pump(tester, _redDotPng);
    final MemoryImage second =
        tester.widget<Image>(find.byType(Image)).image as MemoryImage;

    expect(identical(first.bytes, second.bytes), isTrue);
  });

  testWidgets('an http URL still goes to the network loader', (
    WidgetTester tester,
  ) async {
    await _pump(tester, 'https://cdn.example/poster.jpg');
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('a malformed data: URL falls back rather than throwing', (
    WidgetTester tester,
  ) async {
    // Truncated base64 reaches this widget from real rows often enough to
    // matter, and a throw inside build takes the whole screen with it.
    await _pump(tester, 'data:image/png;base64,!!!not-base64!!!');

    expect(find.byType(Image), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a relative path draws the placeholder', (
    WidgetTester tester,
  ) async {
    await _pump(tester, '/uploads/poster.jpg');
    expect(find.byType(Image), findsNothing);
    expect(find.byType(CachedNetworkImage), findsNothing);
  });
}
