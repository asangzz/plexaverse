import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// Loads bundled dummy JSON for the mock repositories, simulating network
/// latency so loading states are observable during development.
///
/// The JSON under `assets/mock/<feature>/` mirrors the real API response
/// shapes and is deserialised through the actual model `fromJson`. When a
/// real endpoint ships, only the repository swaps from this loader to the
/// Dio client — the models and UI are unchanged.
///
/// Ported verbatim from the ProHealth reference (`core/mock/mock_api.dart`).
/// This is a SHARED file: every `Fake*Repository` reads its fixture through
/// [loadObject] / [loadArray]. It is created here by the first feature agent
/// that needs it (home); other feature agents import it, they do not rebuild
/// it.
class MockApi {
  const MockApi._();

  /// Default simulated round-trip latency.
  static const Duration defaultDelay = Duration(milliseconds: 600);

  /// Loads a JSON object asset (a single resource / response envelope).
  static Future<Map<String, dynamic>> loadObject(
    String assetPath, {
    Duration delay = defaultDelay,
  }) async {
    final decoded = await _load(assetPath, delay);
    if (decoded is! Map<String, dynamic>) {
      throw FormatException('Expected a JSON object at $assetPath');
    }
    return decoded;
  }

  /// Loads a JSON array asset (a list response).
  static Future<List<dynamic>> loadArray(
    String assetPath, {
    Duration delay = defaultDelay,
  }) async {
    final decoded = await _load(assetPath, delay);
    if (decoded is! List) {
      throw FormatException('Expected a JSON array at $assetPath');
    }
    return decoded;
  }

  static Future<Object?> _load(String assetPath, Duration delay) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    final raw = await rootBundle.loadString(assetPath);
    return jsonDecode(raw);
  }
}
