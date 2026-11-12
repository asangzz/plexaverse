import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// `/learn` is gone, as it is on the web (10 Nov 2026): the English lesson is
/// the contest's daily lesson now, and the post-drafting levels went with it.
/// This fails the build if code starts pointing at it again.
///
/// ## Why a scan and not a list
///
/// The removal touched the API paths, the generation timeouts, the route
/// table, the router and the More sheet. The server routes the old screen
/// called no longer exist, so a `/learn` that comes back in any of them is a
/// 404 or a "Page not found" for a user — and nothing else would notice: a
/// path is a string, so the analyzer is happy with it.
///
/// ## What counts
///
/// Code only. Comments are stripped first, because the history of why /learn
/// went is worth keeping in the files it touched. Strings are code: a path is
/// exactly the thing this is for. `/learning`, `/learned` and a host that
/// starts with the word are not the route and do not match — the pattern is
/// the web's `LEARN_ROUTE` (`__tests__/lib/no-learn.test.ts`), so the two
/// guards agree on what a /learn link is.
///
/// ## The one allowed shape
///
/// A `GoRoute` in the router whose path is `/learn` and which only redirects:
/// no page, no builder, no child routes. That is this app's half of the web
/// middleware's `/learn → /contest`, which keeps stored notifications and old
/// links landing somewhere. Where it redirects TO is pinned by the router's
/// own redirect tests, not here.
void main() {
  test('stripComments drops comments and keeps strings that look like them', () {
    const String src =
        "const String a = 'https://x.com/learn'; // the /learn page\n"
        '/// The /learn path, in a doc comment.\n'
        '/* href="/learn" /* nested /learn */ still a comment */ final b = 1;\n'
        "final String c = '\$base/learn';\n"
        "final String d = r'C:\\'; // a raw string's tail";
    final String out = stripComments(src);

    expect(out, contains("'https://x.com/learn'"));
    expect(out, isNot(contains('the /learn page')));
    expect(out, isNot(contains('in a doc comment')));
    expect(out, isNot(contains('href=')));
    expect(out, isNot(contains('still a comment')));
    expect(out, contains('final b = 1;'));
    expect(out, contains("'\$base/learn'"));
    expect(
      out,
      isNot(contains("a raw string's tail")),
      reason: r"r'C:\' ends at its quote; the backslash escapes nothing",
    );
    expect(
      out.split('\n'),
      hasLength(5),
      reason: 'newlines are kept so a failure names the right line',
    );
  });

  test('the pattern matches the route, not what merely starts with it', () {
    for (final String yes in <String>[
      "'/learn'",
      "'/learn?week=1'",
      "'/learn/unit'",
      "'../../features/learn/presentation/pages/learn_page.dart'",
      "'package:plexaverse/features/learn/domain/learn_unit.dart'",
    ]) {
      expect(learnRoute.hasMatch(yes), isTrue, reason: yes);
    }
    for (final String no in <String>[
      "'/learning'",
      "'/learned'",
      "'/learn-reminder'",
      "'/contest/lesson'",
      "'https://learn.microsoft.com/x'",
    ]) {
      expect(learnRoute.hasMatch(no), isFalse, reason: no);
    }
  });

  group('the redirect is the only /learn the router may name', () {
    test('a GoRoute that only redirects passes', () {
      const String src = '''
GoRoute(
  path: '/learn',
  parentNavigatorKey: _rootNavigatorKey,
  redirect: (_, _) => ZaveRoutes.contest,
),
''';
      expect(offendersIn(routerFile, src), isEmpty);
    });

    test('a /learn that opens a page does not', () {
      expect(
        offendersIn(routerFile, "_fullScreen('/learn', const LessonPage()),"),
        hasLength(1),
      );
      expect(
        offendersIn(
          routerFile,
          "GoRoute(path: '/learn', redirect: _r, builder: (_, _) => const X()),",
        ),
        hasLength(1),
        reason: 'a builder means a page answers at /learn',
      );
      expect(
        offendersIn(
          routerFile,
          "GoRoute(path: '/learn', redirect: _r, routes: <RouteBase>[]),",
        ),
        hasLength(1),
        reason: 'child routes mean pages answer under /learn',
      );
    });

    test('nor does the same redirect anywhere but the router', () {
      const String src =
          "GoRoute(path: '/learn', redirect: (_, _) => '/contest'),";
      expect(offendersIn('lib/features/x/x.dart', src), hasLength(1));
    });
  });

  test('no code in lib/ links to, calls or imports /learn', () {
    final List<String> offenders = <String>[];
    for (final FileSystemEntity entity in Directory(
      'lib',
    ).listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      offenders.addAll(offendersIn(entity.path, entity.readAsStringSync()));
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'These point at /learn, which is gone on the server and in the '
          'app. The lesson is /contest/lesson now.\n  '
          '${offenders.join("\n  ")}',
    );
  });

  test('the slice is not lying around unimported', () {
    // The scan above catches every IMPORT of it. A slice nothing imports is
    // invisible to that — and is the half-finished removal someone revives.
    expect(Directory('lib/features/learn').existsSync(), isFalse);
  });
}

/// The file allowed to hold the redirect.
const String routerFile = 'lib/core/router/app_router.dart';

/// The /learn route — not /learning, not /learn-reminder, and not a host that
/// starts with it (`https://learn.microsoft.com`, whose `//` is not a path).
final RegExp learnRoute = RegExp(r'(?<!/)/learn(?![\w.-])');

/// Each `/learn` in [source] as `path:line: text`, except a redirect-only
/// `GoRoute` path in [routerFile].
List<String> offendersIn(String path, String source) {
  final String code = stripComments(source);
  final Set<int> allowed = path == routerFile
      ? _redirectOnlyLearnPaths(code)
      : const <int>{};
  final List<String> lines = code.split('\n');

  final List<String> hits = <String>[];
  for (final Match m in learnRoute.allMatches(code)) {
    if (allowed.contains(m.start)) continue;
    final int line = '\n'.allMatches(code.substring(0, m.start)).length;
    hits.add('$path:${line + 1}: ${lines[line].trim()}');
  }
  return hits;
}

/// Where the `/learn` of each redirect-only `GoRoute(path: '/learn', …)`
/// starts.
///
/// The span is read by counting parentheses. A string holding an unbalanced
/// one would throw it off; no route definition does, and the cost of that
/// mistake is a false failure, never a pass.
Set<int> _redirectOnlyLearnPaths(String code) {
  final RegExp pathArg = RegExp(r'''path:\s*(['"])/learn\1''');
  final RegExp opensAPage = RegExp(r'\b(?:builder|pageBuilder|routes)\s*:');

  final Set<int> starts = <int>{};
  for (final Match open in 'GoRoute('.allMatches(code)) {
    int depth = 0;
    int end = open.end - 1;
    for (; end < code.length; end++) {
      if (code[end] == '(') depth++;
      if (code[end] == ')' && --depth == 0) break;
    }
    final String span = code.substring(open.start, end);
    final Match? path = pathArg.firstMatch(span);
    if (path == null) continue;
    if (!span.contains('redirect:') || opensAPage.hasMatch(span)) continue;
    starts.add(open.start + path.start + path.group(0)!.indexOf('/learn'));
  }
  return starts;
}

/// The source with every comment blanked and every string kept.
///
/// A small state machine rather than a regex: `'https://x'` holds a `//` that
/// is not a comment, and a comment can hold a quote that opens no string.
/// Dart's block comments nest, so they are counted. A `${…}` holding a nested
/// quote ends the string early; what follows is still kept as code, so that
/// can only cost a comment-looking `//` inside it, which no /learn link hides
/// behind in this codebase. Newlines are kept so a failure names the right
/// line.
String stripComments(String src) {
  final StringBuffer out = StringBuffer();
  int i = 0;
  while (i < src.length) {
    if (src.startsWith('//', i)) {
      while (i < src.length && src[i] != '\n') {
        i++;
      }
      continue;
    }
    if (src.startsWith('/*', i)) {
      int depth = 0;
      while (i < src.length) {
        if (src.startsWith('/*', i)) {
          depth++;
          i += 2;
        } else if (src.startsWith('*/', i)) {
          depth--;
          i += 2;
          if (depth == 0) break;
        } else {
          if (src[i] == '\n') out.write('\n');
          i++;
        }
      }
      continue;
    }
    final String c = src[i];
    if (c == "'" || c == '"') {
      // r'…' takes no escapes: a backslash before its closing quote is a
      // backslash, not an escaped quote.
      final bool raw =
          i > 0 &&
          src[i - 1] == 'r' &&
          (i < 2 || !RegExp(r'[\w$]').hasMatch(src[i - 2]));
      final String quote = src.startsWith(c * 3, i) ? c * 3 : c;
      out.write(quote);
      i += quote.length;
      while (i < src.length && !src.startsWith(quote, i)) {
        if (!raw && src[i] == r'\' && i + 1 < src.length) {
          out.write(src.substring(i, i + 2));
          i += 2;
          continue;
        }
        // A one-quote string cannot cross a line; an unclosed one is not a
        // string.
        if (quote.length == 1 && src[i] == '\n') break;
        out.write(src[i]);
        i++;
      }
      if (src.startsWith(quote, i)) {
        out.write(quote);
        i += quote.length;
      }
      continue;
    }
    out.write(c);
    i++;
  }
  return out.toString();
}
