import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every `ValueNotifier` a widget owns is disposed.
///
/// ## Why this is a test
///
/// A `ValueNotifier` is a `ChangeNotifier`: it holds its listeners, and an
/// undisposed one holds them after the widget is gone. The leak is silent —
/// nothing fails, nothing logs, the app just keeps a little more of every
/// screen the user has visited.
///
/// Moving state off `setState` and onto notifiers is a rebuild-scope win (see
/// ARCHITECTURE.md), and it trades a mechanism with no cleanup for one that
/// needs it. Nineteen notifiers were introduced in a single pass; the next
/// one will be added by someone who has not read that pass, in a `State` that
/// already has a `dispose()` doing something else.
void main() {
  /// Source with comments removed.
  ///
  /// Load-bearing. The first version of this test searched the raw text for
  /// `_x.dispose()`, and a dispose call that had been COMMENTED OUT still
  /// matched — so the check passed while the notifier leaked. That is the
  /// same failure the layering test's allowlist check had: a guard that reads
  /// prose instead of code cannot fail for the reason it exists.
  String stripComments(String src) => src
      .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
      .replaceAll(RegExp(r'//[^\n]*'), '');

  /// `ValueNotifier<T> _x = ...` and `late final ValueNotifier<T> _x`.
  final RegExp declared = RegExp(
    r'(?:late\s+final\s+)?ValueNotifier<[^>]+>\s+(_\w+)\s*(?:=|;)',
  );

  test('every ValueNotifier field is disposed by its owner', () {
    final List<String> leaked = <String>[];

    for (final FileSystemEntity entity
        in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (entity.path.endsWith('.g.dart') ||
          entity.path.endsWith('.freezed.dart')) {
        continue;
      }

      final String src = stripComments(entity.readAsStringSync());
      for (final Match m in declared.allMatches(src)) {
        final String name = m.group(1)!;
        // Disposed directly, or handed to something that owns it.
        final bool disposed =
            RegExp('${RegExp.escape(name)}\\s*\\.dispose\\(\\)').hasMatch(src);
        if (!disposed) leaked.add('${entity.path}  →  $name');
      }
    }

    expect(
      leaked,
      isEmpty,
      reason:
          'These ValueNotifiers are never disposed. A ValueNotifier is a '
          'ChangeNotifier — it keeps its listeners, so an undisposed one '
          'leaks every screen that ever listened to it. Dispose it in the '
          "owning State's dispose().\n  ${leaked.join("\n  ")}",
    );
  });

  test('the scan sees the notifiers that exist', () {
    // Guards the assertion above: a regex that silently matched nothing would
    // make it pass forever, which is exactly the failure mode the layering
    // test's allowlist check had.
    int found = 0;
    for (final FileSystemEntity entity
        in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      found += declared
          .allMatches(stripComments(entity.readAsStringSync()))
          .length;
    }
    expect(
      found,
      greaterThan(10),
      reason: 'the declaration pattern has stopped matching real code',
    );
  });
}
