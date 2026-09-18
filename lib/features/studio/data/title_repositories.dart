import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../domain/title_creator.dart';
import '../domain/title_repository.dart';

/// Dio-backed [TitleRepository].
class ApiTitleRepository implements TitleRepository {
  const ApiTitleRepository(this._client);

  final DioClient _client;

  @override
  Future<ProfessionAnalysis> analyzeProfession(String headline) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.aiAnalyzeProfession,
      data: <String, dynamic>{'headline': headline},
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) return const ProfessionAnalysis();
    return ProfessionAnalysis.fromJson(data);
  }

  @override
  Future<TitleSuggestion> suggestTitle({
    required String headline,
    required TitlePriority priority,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.aiSuggestTitle,
      data: <String, dynamic>{'headline': headline, 'priority': priority.wire},
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) return const TitleSuggestion();
    return TitleSuggestion.fromJson(data);
  }

  @override
  Future<void> completeRoadmapStep({
    required int levelId,
    required int stepId,
  }) => _client.post<Map<String, dynamic>>(
    ApiPaths.roadmapProgress,
    // The web also sends `task: 'complete_step'`; the mobile route reads only
    // levelId and stepId and ignores the rest, so it is left off rather than
    // carried forward as cargo.
    data: <String, dynamic>{'levelId': levelId, 'stepId': stepId},
  );
}

/// In-memory [TitleRepository] for the `mock` flavor.
class FakeTitleRepository implements TitleRepository {
  const FakeTitleRepository();

  @override
  Future<ProfessionAnalysis> analyzeProfession(String headline) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const ProfessionAnalysis(
      profession: 'Product Manager',
      industry: 'SaaS',
    );
  }

  @override
  Future<TitleSuggestion> suggestTitle({
    required String headline,
    required TitlePriority priority,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return TitleSuggestion(
      suggestedTitle: priority == TitlePriority.personalBrand
          ? 'I help SaaS teams ship onboarding people actually finish'
          : 'Senior Product Manager | Onboarding, Activation, B2B SaaS',
      reasoning: priority == TitlePriority.personalBrand
          ? 'Leads with the outcome you create rather than the title you '
                'hold, which is what makes a headline quotable.'
          : 'Front-loads the keywords a recruiter filters on, then narrows '
                'to the two domains you can defend in an interview.',
      tips:
          'Keep the first 40 characters strong — that is all LinkedIn '
          'shows beside your name in a feed.',
    );
  }

  @override
  Future<void> completeRoadmapStep({
    required int levelId,
    required int stepId,
  }) => Future<void>.delayed(const Duration(milliseconds: 250));
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors the other slices.
final Provider<TitleRepository> titleRepositoryProvider =
    Provider<TitleRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return const FakeTitleRepository();
      return ApiTitleRepository(ref.watch(dioClientProvider));
    });
