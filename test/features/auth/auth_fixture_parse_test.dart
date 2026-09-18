import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/auth/domain/auth_tokens.dart';
import 'package:plexaverse/features/auth/domain/auth_user.dart';

/// Verifies the bundled mock auth fixtures under `assets/mock/auth/`
/// deserialise through the real [AuthTokens.fromJson] / [AuthUser.fromJson]
/// after the `field_rename: snake` → `none` migration.
///
/// The fixtures are read exactly as `MockAuthRepository` reads them: the token
/// fields sit at the top level (`AuthTokens.fromJson(json)`) and the user is a
/// nested object (`AuthUser.fromJson(json['user'])`). No envelope — the real
/// `DioClient` unwraps `{ data: ... }` before the repo sees it, and the mock
/// stores the already-unwrapped shape.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const fixtures = <String>[
    'assets/mock/auth/login_success.json',
    'assets/mock/auth/register_success.json',
    'assets/mock/auth/refresh_success.json',
  ];

  Future<Map<String, dynamic>> load(String path) async =>
      jsonDecode(await rootBundle.loadString(path)) as Map<String, dynamic>;

  for (final path in fixtures) {
    test('$path parses through AuthTokens + AuthUser', () async {
      final json = await load(path);

      final tokens = AuthTokens.fromJson(json);
      expect(tokens.accessToken, isNotEmpty);
      expect(tokens.refreshToken, isNotEmpty);
      // Both fixtures carry the optional expiry fields.
      expect(tokens.expiresIn, isNotNull);
      expect(tokens.refreshExpiresIn, isNotNull);

      final user = AuthUser.fromJson(json['user'] as Map<String, dynamic>);
      expect(user.id, isNotEmpty);
      expect(user.name, isNotEmpty);
      expect(user.email, contains('@'));
      // `image` wire key is aliased to avatarUrl via @JsonKey(name: 'image').
      expect(user.avatarUrl, (json['user'] as Map)['image']);
      expect(user.role, isNotEmpty);
      // xpBalance / createdAt round-trip without throwing.
      expect(user.xpBalance, isA<int>());
    });
  }

  test('login_success carries the demo identity end-to-end', () async {
    final json = await load('assets/mock/auth/login_success.json');
    final user = AuthUser.fromJson(json['user'] as Map<String, dynamic>);
    expect(user.email, 'demo@plexaverse.com');
    expect(user.avatarUrl, isNotNull);
    expect(user.xpBalance, 1280);
    expect(user.createdAt, isNotNull);
  });

  test('register_success tolerates a null avatar (image: null)', () async {
    final json = await load('assets/mock/auth/register_success.json');
    final user = AuthUser.fromJson(json['user'] as Map<String, dynamic>);
    expect(user.avatarUrl, isNull);
    expect(user.xpBalance, 0);
  });
}
