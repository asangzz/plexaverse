import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/bootstrap/plexaverse_app.dart';
import 'package:plexaverse/core/config/env.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    // `PlexaverseApp` lives in the bootstrap layer now and reads `envProvider`,
    // which throws unless overridden (bootstrap() sets it in production). The
    // mock flavor keeps the smoke test hermetic — no real network.
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[envProvider.overrideWithValue(Env.mock)],
        // Mirrors production (bootstrap.dart): auto-retry is disabled; the app
        // owns its own retry/recovery story.
        retry: (retryCount, error) => null,
        child: const PlexaverseApp(),
      ),
    );
    expect(find.byType(ProviderScope), findsOneWidget);
  });
}
