import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/access/feature_access.dart';
import 'package:plexaverse/core/router/zave_destinations.dart';

/// Nothing the web offers is unreachable on mobile.
///
/// ## Why this got sharper, not looser, when the bar went
///
/// The bottom bar carried four destinations and the More sheet carried the
/// rest, so this property was a sum: bar ∪ sheet had to cover
/// `visibleDestinations`. Two surfaces, one invariant between them, and
/// `moreDestinations` existed only to subtract one from the other.
///
/// There is one surface now. The sheet is handed `visibleDestinations` whole,
/// so the invariant is an identity rather than a union — and the way to break
/// it is to go back to subtracting, which is exactly what someone would do if
/// the sheet ever felt long.
///
/// The four branch routes are the ones that would go first, and they are the
/// four a user needs most, so they are named individually below.
void main() {
  for (final BrandType brand in BrandType.values) {
    for (final String? role in <String?>[null, 'user', 'admin']) {
      test(
        'every branch route is in the sheet for $brand/${role ?? 'no role'}',
        () {
          final List<String> routes = visibleDestinations(
            role: role,
            brandType: brand,
          ).map((ZaveDestination d) => d.route).toList();

          for (final String branch in tabRoutes) {
            expect(
              routes,
              contains(branch),
              reason:
                  '$branch has a shell branch but no row in the sheet, and the '
                  'bar that used to reach it is gone — it is unreachable.',
            );
          }
        },
      );
    }
  }

  test('a null brand still reaches every branch route', () {
    // Preferences have not resolved yet. The shell withholds brand-specific
    // destinations rather than guessing, and that withholding must never take
    // a branch route with it — this is the state the app opens in.
    final List<String> routes = visibleDestinations(
      role: null,
      brandType: null,
    ).map((ZaveDestination d) => d.route).toList();

    for (final String branch in tabRoutes) {
      expect(routes, contains(branch));
    }
  });
}
