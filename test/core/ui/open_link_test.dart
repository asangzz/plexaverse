import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/platform/link_opening.dart';
import 'package:plexaverse/core/ui/widgets/open_link.dart';

/// `openLinkOrCopy` — the one rule three screens share.
///
/// The seam itself is a platform channel and is not worth testing; the policy
/// on top of it is. Two things must hold, and both used to be decided
/// separately in each screen:
///
///   - a successful hand-off does NOT touch the clipboard. Copying anyway
///     would silently overwrite whatever the user had — on the mission cards
///     that is the headline they copied one tap earlier and are on their way
///     to paste.
///   - a failed hand-off DOES copy, and says so. That is the whole reason the
///     old copy-only behaviour was kept as a fallback rather than deleted.
class _FakeLinkOpening implements LinkOpeningService {
  _FakeLinkOpening(this._result);

  final LinkOpenResult _result;
  final List<String> opened = <String>[];

  @override
  Future<LinkOpenResult> open(String url) async {
    opened.add(url);
    return _result;
  }
}

/// Records what reaches the clipboard without a real platform channel.
List<String> _captureClipboard(WidgetTester tester) {
  final List<String> writes = <String>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (MethodCall call) async {
      if (call.method == 'Clipboard.setData') {
        writes.add((call.arguments as Map<Object?, Object?>)['text'] as String);
      }
      return null;
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    ),
  );
  return writes;
}

/// Pumps a bare consumer and hands back a ref-bound call.
Future<Future<String?> Function(String)> _harness(
  WidgetTester tester,
  LinkOpeningService service,
) async {
  late WidgetRef captured;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [linkOpeningProvider.overrideWithValue(service)],
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? _) {
          captured = ref;
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return (String url) => openLinkOrCopy(captured, url);
}

void main() {
  const String url = 'https://www.linkedin.com/feed/update/urn:li:share:1';

  testWidgets('a successful open reports nothing and copies nothing', (
    WidgetTester tester,
  ) async {
    final List<String> clipboard = _captureClipboard(tester);
    final _FakeLinkOpening service = _FakeLinkOpening(const LinkOpened());

    final Future<String?> Function(String) open = await _harness(
      tester,
      service,
    );
    final String? message = await open(url);

    expect(service.opened, <String>[url]);
    expect(message, isNull, reason: 'the user is looking at LinkedIn');
    expect(clipboard, isEmpty, reason: 'their clipboard is not ours to take');
  });

  testWidgets('a failed open falls back to the clipboard and says so', (
    WidgetTester tester,
  ) async {
    final List<String> clipboard = _captureClipboard(tester);
    final _FakeLinkOpening service = _FakeLinkOpening(const LinkOpenFailed());

    final Future<String?> Function(String) open = await _harness(
      tester,
      service,
    );
    final String? message = await open(url);

    expect(clipboard, <String>[url]);
    expect(message, isNotNull);
    expect(message, contains('copied'));
  });
}
