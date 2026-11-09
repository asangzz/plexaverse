import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/network/dio_client.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';
import 'package:plexaverse/features/aitools/data/ai_tools_repositories.dart';
import 'package:plexaverse/features/aitools/domain/ai_tool_failure.dart';
import 'package:plexaverse/features/aitools/domain/headshot_session.dart';
import 'package:plexaverse/features/compose/data/compose_repositories.dart';
import 'package:plexaverse/features/compose/domain/compose_draft.dart';
import 'package:plexaverse/features/compose/domain/compose_repository.dart';
import 'package:plexaverse/features/engagement/data/engagement_repositories.dart';
import 'package:plexaverse/features/engagement/domain/engagement_repository.dart';
import 'package:plexaverse/features/planner/data/planner_repositories.dart';
import 'package:plexaverse/features/planner/domain/planner_repository.dart';
import 'package:plexaverse/features/studio/application/title_controller.dart';
import 'package:plexaverse/features/studio/application/title_creator_state.dart';
import 'package:plexaverse/features/studio/data/title_repositories.dart';
import 'package:plexaverse/features/studio/domain/title_creator.dart';

/// Every AI slice routes the plan's two 402s through `PlanRefusal`, and each
/// keeps its own failure type. Pinned per slice because each one used to
/// read `INSUFFICIENT_XP` as "top up your XP" — wallet XP is retired, and a
/// limit's reset time lives in `details`, which the interceptor drops.
class _Canned implements HttpClientAdapter {
  _Canned(this.body);

  final Object body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    jsonEncode(body),
    402,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

DioClient _client(Map<String, dynamic> error) => DioClient(
  Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = _Canned(<String, dynamic>{
      'data': null,
      'error': error,
    })
    ..interceptors.add(ErrorInterceptor()),
);

final Map<String, dynamic> _noPlan = <String, dynamic>{
  'code': 'INSUFFICIENT_XP',
  'message': 'This needs a Plexaverse plan.',
  'details': <String, dynamic>{
    'reason': 'NOT_ENTITLED',
    'upgradeUrl': '/pricing',
  },
};

Map<String, dynamic> _limit() => <String, dynamic>{
  'code': 'LIMIT_REACHED',
  'message': "You've used today's limit.",
  'details': <String, dynamic>{
    'key': 'ai_generate_post',
    'limit': 3,
    'period': 'day',
    'used': 3,
    'resetsAt': DateTime.now()
        .add(const Duration(hours: 2))
        .toUtc()
        .toIso8601String(),
  },
};

void main() {
  group('planner', () {
    Future<PlannerGenerateFailure> generate(Map<String, dynamic> e) async {
      try {
        await ApiPlannerRepository(
          _client(e),
        ).generateSlotPost(planId: 'p', slotIndex: 0);
      } on PlannerGenerateFailure catch (f) {
        return f;
      }
      fail('generateSlotPost should have thrown');
    }

    test('no plan → needsPlan', () async {
      final PlannerGenerateFailure f = await generate(_noPlan);
      expect(f.kind, PlannerGenerateFailureKind.needsPlan);
      expect(f.refusal?.needsPlan, isTrue);
      expect(f.message, 'This needs a Plexaverse plan.');
    });

    test('limit → limitReached, saying when it is back', () async {
      final PlannerGenerateFailure f = await generate(_limit());
      expect(f.kind, PlannerGenerateFailureKind.limitReached);
      expect(f.message, contains('Back'));
      expect(f.message, isNot(contains('XP')));
    });
  });

  group('compose', () {
    Future<ComposeFailure> generate(Map<String, dynamic> e) async {
      try {
        await ApiComposeRepository(_client(e)).generatePost(
          topic: 't',
          tone: ComposeTone.values.first,
          length: ComposeLength.values.first,
        );
      } on ComposeFailure catch (f) {
        return f;
      }
      fail('generatePost should have thrown');
    }

    test('no plan is a refusal, not a retryable error', () async {
      final ComposeFailure f = await generate(_noPlan);
      expect(f.refusedByPlan, isTrue);
      expect(f.refusal!.needsPlan, isTrue);
    });

    test('limit carries the reset time into the message', () async {
      final ComposeFailure f = await generate(_limit());
      expect(f.refusal!.isLimit, isTrue);
      expect(f.message, contains('Back'));
    });
  });

  group('ai tools', () {
    Future<AiToolFailure> headshots(Map<String, dynamic> e) async {
      try {
        await ApiAiToolsRepository(_client(e)).generateHeadshots(
          photos: const <String>['a', 'b', 'c'],
          style: HeadshotStyle.values.first,
          background: HeadshotBackground.values.first,
        );
      } on AiToolFailure catch (f) {
        return f;
      }
      fail('generateHeadshots should have thrown');
    }

    test('no plan and limit both stop the retry', () async {
      final AiToolFailure plan = await headshots(_noPlan);
      expect(plan.refusedByPlan, isTrue);
      expect(plan.refusal!.needsPlan, isTrue);

      final AiToolFailure limit = await headshots(_limit());
      expect(limit.refusal!.isLimit, isTrue);
      expect(limit.message, contains('Back'));
    });
  });

  group('engagement', () {
    Future<EngagementFailure> comments(Map<String, dynamic> e) async {
      try {
        await ApiEngagementRepository(_client(e)).generateComments();
      } on EngagementFailure catch (f) {
        return f;
      }
      fail('generateComments should have thrown');
    }

    test('no plan → needsPlan', () async {
      final EngagementFailure f = await comments(_noPlan);
      expect(f.kind, EngagementBlock.needsPlan);
    });

    test('limit → limitReached with its reset time', () async {
      final EngagementFailure f = await comments(_limit());
      expect(f.kind, EngagementBlock.limitReached);
      expect(f.refusal?.resetsAt, isNotNull);
    });
  });

  group('studio title creator', () {
    Future<TitleCreatorState> choose(Map<String, dynamic> e) async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          titleRepositoryProvider.overrideWithValue(
            ApiTitleRepository(_client(e)),
          ),
        ],
      );
      addTearDown(container.dispose);
      // The provider is auto-dispose; without a listener it is torn down
      // while `choose` awaits the network.
      container.listen(titleCreatorControllerProvider, (_, _) {});
      final TitleCreatorController c = container.read(
        titleCreatorControllerProvider.notifier,
      );
      c.setHeadline('Product manager at a SaaS startup');
      await c.choose(TitlePriority.values.first);
      return container.read(titleCreatorControllerProvider);
    }

    test('limit says when it is back, never "Try again"', () async {
      final TitleCreatorState s = await choose(_limit());
      expect(s.refusal?.isLimit, isTrue);
      expect(s.error, contains("You've used today's limit."));
      // "Back at" / "Back tomorrow at" — the reset is 2h out, which can
      // cross local midnight.
      expect(s.error, contains('Back'));
      expect(s.error, isNot(contains('Try again')));
      expect(s.error, isNot(contains('XP')));
    });

    test('no plan carries the refusal for the plan sheet', () async {
      final TitleCreatorState s = await choose(_noPlan);
      expect(s.refusal?.needsPlan, isTrue);
      expect(s.error, 'This needs a Plexaverse plan.');
    });
  });
}
