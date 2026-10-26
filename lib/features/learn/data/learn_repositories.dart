import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure.dart';
import '../domain/learn_repository.dart';
import '../domain/learn_unit.dart';

/// Dio-backed [LearnRepository].
///
/// [DioClient] already unwraps the `{data, error, meta}` envelope, so on
/// success `response.data` is the inner payload.
///
/// ## The two response shapes are not the same, and that is the server's
///
/// `/learn/level` answers `{ unit, results }`; `/learn/action` answers the
/// bare unit. Normalising one into the other here would hide a real
/// difference — the level route has verdicts to report and the action route
/// has none — so each is parsed as it arrives.
class ApiLearnRepository implements LearnRepository {
  const ApiLearnRepository(this._client);

  final DioClient _client;

  @override
  Future<LearnPath> fetchPath({int? week}) async {
    try {
      final Response<Map<String, dynamic>> response = await _client
          .get<Map<String, dynamic>>(
            ApiPaths.learn,
            queryParameters: <String, dynamic>{'week': ?week},
          );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const LearnNoPlan();
      return LearnPath.fromJson(data);
    } on DioException catch (e) {
      throw _mapped(e) ?? e;
    }
  }

  @override
  Future<LearnUnit> fetchUnit({required int week, required int day}) async {
    try {
      final Response<Map<String, dynamic>> response = await _client
          .get<Map<String, dynamic>>(
            ApiPaths.learnUnit,
            queryParameters: <String, dynamic>{'week': week, 'day': day},
          );
      return _unit(response.data);
    } on DioException catch (e) {
      throw _mapped(e) ?? e;
    }
  }

  @override
  Future<SubmitResult> submitLevel({
    required String unitId,
    required int levelIndex,
    required List<LevelAnswer> answers,
  }) async {
    try {
      final Response<Map<String, dynamic>> response = await _client
          .post<Map<String, dynamic>>(
            ApiPaths.learnLevel,
            data: <String, dynamic>{
              'unitId': unitId,
              'levelIndex': levelIndex,
              // Only what the user gave. `correct` is the server's to decide
              // and is deliberately not sent back to it.
              'answers': answers
                  .map(
                    (LevelAnswer a) => <String, dynamic>{
                      'exerciseId': a.exerciseId,
                      'value': a.value,
                    },
                  )
                  .toList(),
            },
          );
      final Map<String, dynamic>? data = response.data;
      if (data == null) {
        throw const LearnGenerationFailed('No answer came back.');
      }
      return SubmitResult.fromJson(data);
    } on DioException catch (e) {
      throw _mapped(e) ?? e;
    }
  }

  @override
  Future<LearnUnit> runDraft(String unitId) => _action(unitId, 'draft');

  @override
  Future<LearnUnit> checkVisual(String unitId) => _action(unitId, 'visual');

  @override
  Future<LearnUnit> completeReview(String unitId) => _action(unitId, 'review');

  Future<LearnUnit> _action(String unitId, String action) async {
    try {
      final Response<Map<String, dynamic>> response = await _client
          .post<Map<String, dynamic>>(
            ApiPaths.learnAction,
            data: <String, dynamic>{'unitId': unitId, 'action': action},
          );
      return _unit(response.data);
    } on DioException catch (e) {
      throw _mapped(e) ?? e;
    }
  }

  static LearnUnit _unit(Map<String, dynamic>? data) {
    if (data == null) throw const LearnGenerationFailed('No unit came back.');
    return LearnUnit.fromJson(data);
  }

  /// Turns the server's own `code` into something the UI can branch on.
  ///
  /// The codes matter more here than usual because two of them are not
  /// failures: `IMAGE_MISSING` means the poster is not made YET, and
  /// `REST_DAY` means there is deliberately nothing to do. Rendering either as
  /// "something went wrong" would be a lie about the product.
  ///
  /// Returns null for anything unrecognised, so the original DioException
  /// reaches the controller with its mapped [Failure] intact.
  static Exception? _mapped(DioException e) {
    final Object? err = e.error;
    final String? code = err is Failure ? err.errorCode : null;
    final String? message = err is Failure && (err.message?.isNotEmpty ?? false)
        ? err.message
        : null;

    return switch (code) {
      'NO_PLAN' => message == null ? const LearnNoPlan() : LearnNoPlan(message),
      'IMAGE_MISSING' =>
        message == null
            ? const LearnImageMissing()
            : LearnImageMissing(message),
      'REST_DAY' =>
        message == null ? const LearnRestDay() : LearnRestDay(message),
      'GENERATION_FAILED' =>
        message == null
            ? const LearnGenerationFailed()
            : LearnGenerationFailed(message),
      _ => null,
    };
  }
}

final Provider<LearnRepository> learnRepositoryProvider =
    Provider<LearnRepository>(
      (Ref ref) => ApiLearnRepository(ref.watch(dioClientProvider)),
    );
