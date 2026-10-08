import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// No screen may draw a header that is only a back arrow.
///
/// ## The fault
///
/// `ZaveScaffold` draws a header as soon as a page passes a `title`, a
/// `largeTitle`, a `leading` OR any `actions` — and it supplies the back
/// arrow itself on every pushed route. So a page that passed only a `leading`,
/// or that relied on the automatic arrow, got a bar with nothing in it but
/// that arrow, while the screen's real name sat in the scroll view underneath.
/// An empty strip above the thing the strip was supposed to name.
///
/// Comments and Connections shipped exactly like that.
///
/// ## Why a source scan
///
/// Nothing throws, nothing overflows, and every widget test passes: it is a
/// page that renders perfectly and just reads wrong. The only way to catch it
/// is to look at what each page declares.
///
/// ## What to do when this fails
///
/// Give the page a name. `largeTitle:` for a screen you arrive at and read —
/// it collapses as you scroll, so it costs nothing once the user is reading.
/// `title:` for a tool, a composer or a canvas, where the work itself is the
/// top of the page and a 90px title would be in the way. If the page already
/// draws its own heading in the body, move that string up rather than adding a
/// second one — see [noNamelessHeaderDuplicateNote].
void main() {
  /// A call's source, from its opening bracket to the matching close.
  String balanced(String src, int open) {
    int depth = 0;
    for (int i = open; i < src.length; i++) {
      final String c = src[i];
      if (c == '(' || c == '[' || c == '{') depth++;
      if (c == ')' || c == ']' || c == '}') {
        depth--;
        if (depth == 0) return src.substring(open, i + 1);
      }
    }
    return src.substring(open);
  }

  /// The names of a call's TOP-LEVEL arguments.
  ///
  /// Depth-aware so a `title:` belonging to a nested widget in the body is not
  /// mistaken for the scaffold's own, and comment-aware because a `//` line
  /// holding a comma used to split an argument in half and hide the real
  /// `largeTitle:` that followed it.
  Set<String> topLevelArgs(String call) {
    final String body = call.substring(1, call.length - 1);
    final List<String> parts = <String>[];
    final StringBuffer cur = StringBuffer();
    int depth = 0;
    bool inLineComment = false;

    for (int i = 0; i < body.length; i++) {
      final String c = body[i];

      if (inLineComment) {
        if (c == '\n') inLineComment = false;
        continue;
      }
      if (c == '/' && i + 1 < body.length && body[i + 1] == '/') {
        inLineComment = true;
        continue;
      }

      if (c == '(' || c == '[' || c == '{') depth++;
      if (c == ')' || c == ']' || c == '}') depth--;

      if (c == ',' && depth == 0) {
        parts.add(cur.toString());
        cur.clear();
      } else {
        cur.write(c);
      }
    }
    parts.add(cur.toString());

    return <String>{
      for (final String p in parts)
        if (RegExp(r'^\s*([a-zA-Z_]\w*)\s*:').firstMatch(p) case final Match m)
          m.group(1)!,
    };
  }

  Iterable<(String, int, Set<String>)> scaffolds() sync* {
    for (final FileSystemEntity f in Directory('lib')
        .listSync(recursive: true)
        .where((FileSystemEntity e) => e.path.endsWith('_page.dart'))) {
      final String src = File(f.path).readAsStringSync();
      for (final Match m in RegExp(r'ZaveScaffold\(').allMatches(src)) {
        yield (
          f.path,
          src.substring(0, m.start).split('\n').length,
          topLevelArgs(balanced(src, m.end - 1)),
        );
      }
    }
  }

  test('the scan finds the scaffolds and reads their arguments', () {
    // Guards the two assertions below. A parser that matched nothing, or that
    // lost `largeTitle` to a comma inside a comment (which it did once), would
    // make them pass vacuously.
    final List<(String, int, Set<String>)> all = scaffolds().toList();
    expect(all.length, greaterThan(25));

    final Set<String> named = <String>{
      for (final (_, _, Set<String> a) in all)
        ...a.where((String k) => k == 'title' || k == 'largeTitle'),
    };
    expect(named, containsAll(<String>['title', 'largeTitle']));

    // Settings is the page whose `largeTitle` sits behind a two-line comment
    // containing a comma — the exact shape that defeated the first parser.
    final Set<String> settings = all
        .firstWhere(
          ((String, int, Set<String>) r) =>
              r.$1.endsWith('settings_page.dart'),
        )
        .$3;
    expect(settings, contains('largeTitle'));
  });

  /// The one screen allowed to show a bare back arrow.
  ///
  /// The sign-in screen names itself with a `ZaveType.hero` watermark —
  /// right-aligned, 30% opacity, immediately under the bar — which is a
  /// deliberate piece of the auth layout rather than a heading that drifted
  /// out of the header. Giving it a bar title would put the words "Sign in"
  /// on screen twice, which is the fault this file exists to prevent.
  ///
  /// Its `leading` is also not a route back button: it unwinds the email
  /// sub-step to the welcome screen without popping. Nothing else in the app
  /// is shaped like this, so it is named here rather than softening the rule
  /// into something that would also let a real regression through.
  const String heroNamedScreen = 'lib/features/auth/presentation/pages/'
      'auth_page.dart';

  test('no page draws a header holding only a back arrow', () {
    final List<String> nameless = <String>[];

    for (final (String path, int line, Set<String> args) in scaffolds()) {
      if (path == heroNamedScreen) continue;
      final bool named =
          args.contains('title') || args.contains('largeTitle');
      // `leading` or `actions` is what FORCES a header into existence. A page
      // with neither draws no header at all, which is a legitimate choice —
      // the lock screen and the sign-in screen do it.
      final bool drawsHeader =
          args.contains('leading') || args.contains('actions');

      if (drawsHeader && !named) nameless.add('$path:$line');
    }

    expect(
      nameless,
      isEmpty,
      reason:
          'These force a header to exist — by passing a leading or actions — '
          'without giving it a name, so the bar renders holding nothing but a '
          "back arrow. See this file's doc for which of title / largeTitle to "
          'reach for.\n  ${nameless.join("\n  ")}',
    );
  });
}

/// Moving a name into the header means DELETING it from the body.
///
/// Banner Blueprint read `Banner Blueprint` in the bar and `Banner Blueprint`
/// again as the first line of its scroll view — the same string, twice, on one
/// screen. Comments was subtler and is the one worth remembering: its body
/// heading came from the DATABASE, so no search for a literal could find it,
/// and the two lines only turned out to be identical on a running simulator
/// because the roadmap step and the screen are the same thing there.
///
/// A static check cannot catch that second case. Look at the screen.
const String noNamelessHeaderDuplicateNote = '';
