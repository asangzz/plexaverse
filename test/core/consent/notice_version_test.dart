import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/consent/notice.dart';

/// The app's notice version must equal the web's `NOTICE_VERSION`: the mobile
/// register route refuses any other with `NOTICE_VERSION_STALE`, so a drift
/// means no email sign-up from the app succeeds. That happened once, for
/// weeks (the web moved to 2026-10-31, the app still sent 2026-10-22).
///
/// The app lives inside the web monorepo (`Plexaverse Application/plexaverse`),
/// so the web's constant is two directories up. A checkout without the web
/// repo beside it skips this rather than failing.
void main() {
  test('kNoticeVersion equals the web server\'s NOTICE_VERSION', () {
    final File web = File('../../lib/consent.ts');
    if (!web.existsSync()) {
      markTestSkipped('web repo not beside this checkout');
      return;
    }
    final RegExpMatch? m = RegExp(
      r"export const NOTICE_VERSION = '(\d{4}-\d{2}-\d{2})'",
    ).firstMatch(web.readAsStringSync());
    expect(m, isNotNull, reason: 'NOTICE_VERSION not found in lib/consent.ts');
    expect(
      kNoticeVersion,
      m!.group(1),
      reason:
          'Update kNoticeVersion in lib/core/consent/notice.dart. Then check '
          'that the sign-up text in consent_block.dart is still true of the '
          'new notice.',
    );
  });
}
