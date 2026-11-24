import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// No "contest" in anything a learner reads (owner, 24 Nov 2026). The app's
/// half of the web's `__tests__/lib/no-contest-word.test.ts`.
///
/// Learners are never told about a contest. They pass levels, earn XP, and
/// every three months the levels reset — a round — and the top learners get
/// a shoutout. So no string a learner can read says "contest": not a screen,
/// a button, a refusal's sentence, a semantics label or the mock's fixtures,
/// which are what this app is tested on by eye.
///
/// ## What counts as words
///
/// Natural language only, read as Dart reads it — never the code around it.
/// Every string literal in `lib/` is read, adjacent literals joined as Dart
/// joins them, interpolations read as a gap (and the strings inside an
/// interpolation read on their own). A string is words when it contains a
/// space or starts with a capital letter. So "Join the contest", "Contest
/// rules" and 'The contest’s last day is $last.' fail, while identifiers
/// (`contestPathProvider`), the routes' paths ('/contest/lesson',
/// '/api/mobile/v1/contest/path' — code, and the server's to keep), kebab
/// ids ('contest-joined') and consent purposes ('contest_leaderboard') pass.
/// Comments are not strings and are never read; nor are `import`, `export`
/// and `part` directives. Generated files hold no copy and are skipped.
void main() {
  test('scans something (a moved directory must not make this pass)', () {
    expect(
      _files().map((File f) => f.path),
      containsAll(<String>[
        'lib/features/contest/presentation/pages/contest_page.dart',
        'lib/features/contest/presentation/pages/contest_follow_page.dart',
        'lib/features/contest/domain/levels_words.dart',
        'lib/features/contest/data/fake_contest_world.dart',
        'lib/features/onboarding/domain/onboarding_step.dart',
        'lib/features/profile/presentation/widgets/public_profile_section.dart',
        'lib/core/router/zave_destinations.dart',
      ]),
    );
  });

  test('no string a learner can read says "contest"', () {
    final List<String> offenders = <String>[
      for (final File f in _files())
        for (final (int line, String text) in learnerWordsIn(
          f.readAsStringSync(),
        ))
          '${f.path}:$line: $text',
    ];
    expect(
      offenders,
      isEmpty,
      reason:
          'Say "levels", "XP", "round", "Top learners" or "shoutout" '
          'instead (lib/features/contest/domain/levels_words.dart).',
    );
  });

  group('the rule catches what it is for', () {
    List<String> hits(String src) => <String>[
      for (final (int _, String text) in learnerWordsIn(src)) text,
    ];

    test('words', () {
      expect(hits("const a = 'Join the contest';"), hasLength(1));
      expect(hits("Text('Contest rules')"), hasLength(1));
      expect(hits("label: 'Contest',"), hasLength(1));
      expect(hits('x = "Back to the contest";'), hasLength(1));
      expect(hits("final s = 'Join the ' 'contest';"), hasLength(1));
      // Inside an interpolation, a string is words of its own.
      expect(
        hits(r"Text('${last.isEmpty ? '' : 'The contest’s last day. '}x')"),
        hasLength(1),
      );
      expect(hits("label: 'Contests'"), hasLength(1));
    });

    test('code', () {
      expect(hits('final p = contestPathProvider;'), isEmpty);
      expect(hits("static const String contest = '/contest';"), isEmpty);
      expect(hits("path: '/contest/lesson?part=2'"), isEmpty);
      expect(hits("ApiPaths.x = '/api/mobile/v1/contest/path';"), isEmpty);
      expect(hits("PlexaMomentClip.contestJoined('contest_joined')"), isEmpty);
      expect(hits("purpose: 'contest_leaderboard'"), isEmpty);
      expect(hits("debugLabel: 'contest-path'"), isEmpty);
      expect(
        hits("import '../../contest/domain/contest_words.dart';"),
        isEmpty,
      );
      expect(hits('// Back to the contest'), isEmpty);
      expect(hits('/// The contest page. "Join the contest"'), isEmpty);
      expect(hits("Text('Your levels')"), isEmpty);
    });
  });
}

List<File> _files() => <File>[
  for (final FileSystemEntity e in Directory('lib').listSync(recursive: true))
    if (e is File &&
        e.path.endsWith('.dart') &&
        !e.path.endsWith('.g.dart') &&
        !e.path.endsWith('.freezed.dart'))
      e,
]..sort((File a, File b) => a.path.compareTo(b.path));

final RegExp _word = RegExp(r'\bcontests?\b', caseSensitive: false);

/// Paths are code: the app's own routes and the API's.
final RegExp _codePath = RegExp(
  r'(/api/(mobile/v1/)?contest|/admin/contest|/contest)[\w/.\-?=&#%]*',
  caseSensitive: false,
);

/// Is this the text a learner reads?
bool _isWords(String text) {
  final String t = text.replaceAll(_codePath, '').trim();
  if (!_word.hasMatch(t)) return false;
  return RegExp(r'\s').hasMatch(t) || RegExp(r'^[A-Z]').hasMatch(t);
}

/// Every string in [src] that is words and says the word, as (line, text).
List<(int, String)> learnerWordsIn(String src) => <(int, String)>[
  for (final (int line, String text) in _literals(src))
    if (_isWords(text)) (line, text.trim().replaceAll(RegExp(r'\s+'), ' ')),
];

/// Every string literal in [src], adjacent ones joined, with its line.
List<(int, String)> _literals(String src) {
  final List<(int, String)> out = <(int, String)>[];
  _Scanner(src, out).code(0, untilBrace: false);
  return out;
}

class _Scanner {
  _Scanner(this.src, this.out);

  final String src;
  final List<(int, String)> out;

  int get n => src.length;

  int _lineOf(int at) => '\n'.allMatches(src.substring(0, at)).length + 1;

  bool _wordChar(String c) => RegExp(r'[A-Za-z0-9_$]').hasMatch(c);

  /// Reads code from [i]; inside an interpolation, up to its closing brace.
  /// Returns the index after it.
  int code(int i, {required bool untilBrace}) {
    int depth = 0;
    int? lastEnd;
    int? lastIndex;
    while (i < n) {
      if (src.startsWith('//', i)) {
        final int j = src.indexOf('\n', i);
        i = j < 0 ? n : j;
        continue;
      }
      if (src.startsWith('/*', i)) {
        final int j = src.indexOf('*/', i + 2);
        i = j < 0 ? n : j + 2;
        continue;
      }
      // Directives name files, not words.
      if (!untilBrace && (i == 0 || src[i - 1] == '\n')) {
        final Match? d = RegExp(
          r'(import|export|part|library)\b',
        ).matchAsPrefix(src, i);
        if (d != null) {
          final int j = src.indexOf(';', i);
          i = j < 0 ? n : j + 1;
          continue;
        }
      }
      String c = src[i];
      if (untilBrace) {
        if (c == '{') {
          depth++;
        } else if (c == '}') {
          if (depth == 0) return i + 1;
          depth--;
        }
      }
      bool raw = false;
      if ((c == 'r' || c == 'R') &&
          i + 1 < n &&
          (src[i + 1] == "'" || src[i + 1] == '"') &&
          (i == 0 || !_wordChar(src[i - 1]))) {
        raw = true;
        i++;
        c = src[i];
      }
      if (c == "'" || c == '"') {
        final int start = raw ? i - 1 : i;
        final String quote = src.startsWith(c * 3, i) ? c * 3 : c;
        i += quote.length;
        final StringBuffer text = StringBuffer();
        while (i < n && !src.startsWith(quote, i)) {
          final String ch = src[i];
          if (!raw && ch == r'\' && i + 1 < n) {
            text.write(src.substring(i, i + 2));
            i += 2;
            continue;
          }
          if (!raw && ch == r'$' && i + 1 < n && src[i + 1] == '{') {
            i = code(i + 2, untilBrace: true);
            text.write(' ');
            continue;
          }
          if (!raw && ch == r'$') {
            final Match? m = RegExp(
              r'\$[A-Za-z_][A-Za-z0-9_]*',
            ).matchAsPrefix(src, i);
            if (m != null) {
              text.write(' ');
              i = m.end;
              continue;
            }
          }
          // A one-quote string cannot cross a line.
          if (quote.length == 1 && ch == '\n') break;
          text.write(ch);
          i++;
        }
        if (src.startsWith(quote, i)) i += quote.length;
        final int? prevEnd = lastEnd;
        final int? prevIndex = lastIndex;
        if (prevEnd != null &&
            prevIndex != null &&
            src.substring(prevEnd, start).trim().isEmpty) {
          final (int line, String before) = out[prevIndex];
          out[prevIndex] = (line, '$before$text');
        } else {
          out.add((_lineOf(start), text.toString()));
          lastIndex = out.length - 1;
        }
        lastEnd = i;
        continue;
      }
      i++;
    }
    return i;
  }
}
