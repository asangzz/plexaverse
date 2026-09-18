import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../domain/ai_designer.dart';
import '../domain/studio_design.dart';
import '../domain/studio_repository.dart';

/// Dio-backed [StudioRepository].
///
/// [DioClient] already unwraps the `{data, error, meta}` envelope, so on
/// success `response.data` is the inner object. Every `/studio` route wraps
/// its payload one level deeper again (`{designs: […]}`, `{design: {…}}`),
/// which is why each method reaches through a named key rather than parsing
/// `response.data` directly.
class ApiStudioRepository implements StudioRepository {
  const ApiStudioRepository(this._client);

  final DioClient _client;

  @override
  Future<StudioAccess> fetchAccess() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiPaths.studioAccess,
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) return const StudioAccess();
    return StudioAccess.fromJson(data);
  }

  @override
  Future<StudioUnlockResult> unlock() async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.studioAccess,
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) return const StudioUnlockResult();
    return StudioUnlockResult.fromJson(data);
  }

  @override
  Future<List<StudioDesign>> listDesigns() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiPaths.studioDesigns,
    );
    return _designList(response.data?['designs']);
  }

  @override
  Future<List<StudioDesign>> listTemplates({String? category}) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiPaths.studioTemplates,
      queryParameters: <String, dynamic>{'category': ?category},
    );
    return _designList(response.data?['templates']);
  }

  @override
  Future<StudioDesign> fetchDesign(String id) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiPaths.studioDesign(id),
    );
    return _design(response.data?['design']);
  }

  @override
  Future<StudioDesign> createDesign({
    required String name,
    required StudioCanvas canvas,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.studioDesigns,
      data: <String, dynamic>{
        'name': name,
        'data': StudioDesignData(canvas: canvas).toWireJson(),
      },
    );
    return _design(response.data?['design']);
  }

  @override
  Future<StudioDesign> updateDesign(
    String id, {
    String? name,
    String? description,
    StudioDesignData? data,
  }) async {
    // Send only what changed. PATCH merges, so a null we did not mean to send
    // is not merely wasteful — for `data` it would replace a whole design.
    final response = await _client.patch<Map<String, dynamic>>(
      ApiPaths.studioDesign(id),
      data: <String, dynamic>{
        'name': ?name,
        'description': ?description,
        'data': ?data?.toWireJson(),
      },
    );
    return _design(response.data?['design']);
  }

  @override
  Future<void> deleteDesign(String id) =>
      _client.delete<Map<String, dynamic>>(ApiPaths.studioDesign(id));

  @override
  Future<StudioDesign> copyDesign({
    required String sourceId,
    String? name,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.studioCopy,
      data: <String, dynamic>{'sourceId': sourceId, 'name': ?name},
    );
    return _design(response.data?['design']);
  }

  @override
  Future<AiDesignerReply> askDesigner({
    required List<AiDesignerTurn> history,
    required StudioCanvas canvas,
    StudioDesignData? currentDesign,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.studioAiDesigner,
      data: <String, dynamic>{
        // Pending and failed bubbles are client-side states; sending them
        // would feed the model its own spinner text as conversation.
        'messages': history
            .where((AiDesignerTurn t) => !t.pending && !t.failed)
            .map(
              (AiDesignerTurn t) => <String, dynamic>{
                'role': t.role.wire,
                'content': t.content,
              },
            )
            .toList(growable: false),
        'canvas': <String, dynamic>{
          'width': canvas.width,
          'height': canvas.height,
        },
        'currentDesign': ?currentDesign?.toWireJson(),
      },
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw StateError('ai-designer returned no payload');
    }
    return AiDesignerReply.fromJson(data);
  }

  @override
  Future<String> generateImage({
    required String prompt,
    required String aspectRatio,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.aiImage,
      data: <String, dynamic>{
        'prompt': prompt,
        'aspectRatio': aspectRatio,
        'resolution': '1K',
      },
    );
    final Object? url = response.data?['imageUrl'];
    if (url is! String || url.isEmpty) {
      throw StateError('ai/image returned no imageUrl');
    }
    return url;
  }

  static List<StudioDesign> _designList(Object? raw) {
    if (raw is! List) return const <StudioDesign>[];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(StudioDesign.fromJson)
        .toList(growable: false);
  }

  static StudioDesign _design(Object? raw) {
    if (raw is! Map<String, dynamic>) {
      throw StateError('studio design payload missing');
    }
    return StudioDesign.fromJson(raw);
  }
}

/// In-memory [StudioRepository] for the `mock` flavor.
///
/// Shaped like a real library: unlocked, three saved designs and two
/// templates, and one of the designs carries a real element tree so the
/// renderer, the text editor and the image swap are all exercisable without a
/// backend.
class FakeStudioRepository implements StudioRepository {
  FakeStudioRepository();

  static const StudioDesignData _poster = StudioDesignData(
    canvas: StudioCanvas(width: 1080, height: 1350, background: '#06103a'),
    elements: <StudioElement>[
      StudioElement(
        id: 'bg',
        type: 'rectangle',
        name: 'backdrop',
        width: 1080,
        height: 1350,
        fill: '#0d2a9e',
        opacity: 0.35,
      ),
      StudioElement(
        id: 'hero',
        type: 'image',
        name: 'image',
        x: 90,
        y: 120,
        width: 900,
        height: 600,
        imageUrl: 'https://images.plexaverse.com/mock/hero.jpg',
        borderRadius: 32,
      ),
      StudioElement(
        id: 'title',
        type: 'text',
        name: 'title',
        x: 90,
        y: 790,
        width: 900,
        height: 220,
        fill: '#ffffff',
        text: 'Onboarding is a design problem',
        fontSize: 82,
        fontWeight: 800,
        textAlign: 'left',
      ),
      StudioElement(
        id: 'subtitle',
        type: 'text',
        name: 'subtitle',
        x: 90,
        y: 1030,
        width: 900,
        height: 120,
        fill: '#aeb4ff',
        text: 'Not a documentation problem.',
        fontSize: 44,
        fontWeight: 500,
        textAlign: 'left',
      ),
    ],
  );

  final List<StudioDesign> _designs = <StudioDesign>[
    const StudioDesign(
      id: 'mock-design-1',
      name: 'Week 3 poster',
      width: 1080,
      height: 1350,
      category: 'automate_posts_personal',
      updatedAt: '2026-09-17T09:12:00.000Z',
      data: _poster,
    ),
    const StudioDesign(
      id: 'mock-design-2',
      name: 'Hiring announcement',
      width: 1200,
      height: 628,
      category: 'social_media',
      updatedAt: '2026-09-11T16:40:00.000Z',
    ),
    const StudioDesign(
      id: 'mock-design-3',
      name: 'Quarterly numbers',
      width: 1080,
      height: 1080,
      category: 'infographic',
      updatedAt: '2026-08-30T11:05:00.000Z',
    ),
  ];

  @override
  Future<StudioAccess> fetchAccess() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return const StudioAccess(
      hasAccess: true,
      currentXp: 3200,
      requiredXp: 1500,
    );
  }

  @override
  Future<StudioUnlockResult> unlock() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return const StudioUnlockResult(success: true, newBalance: 1700);
  }

  @override
  Future<List<StudioDesign>> listDesigns() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List<StudioDesign>.unmodifiable(_designs);
  }

  @override
  Future<List<StudioDesign>> listTemplates({String? category}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const <StudioDesign>[
      StudioDesign(
        id: 'mock-template-1',
        name: 'Comparison poster',
        width: 1080,
        height: 1080,
        isTemplate: true,
        category: 'social_media',
        data: _poster,
      ),
      StudioDesign(
        id: 'mock-template-2',
        name: 'Quote card',
        width: 1080,
        height: 1080,
        isTemplate: true,
        category: 'marketing',
      ),
    ];
  }

  @override
  Future<StudioDesign> fetchDesign(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final StudioDesign row = _designs.firstWhere(
      (StudioDesign d) => d.id == id,
      orElse: () => _designs.first,
    );
    return row.data == null ? row.copyWith(data: _poster) : row;
  }

  @override
  Future<StudioDesign> createDesign({
    required String name,
    required StudioCanvas canvas,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final StudioDesign created = StudioDesign(
      id: 'mock-design-${_designs.length + 1}',
      name: name,
      width: canvas.width.round(),
      height: canvas.height.round(),
      data: StudioDesignData(canvas: canvas),
      updatedAt: DateTime.now().toIso8601String(),
    );
    _designs.insert(0, created);
    return created;
  }

  @override
  Future<StudioDesign> updateDesign(
    String id, {
    String? name,
    String? description,
    StudioDesignData? data,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final int index = _designs.indexWhere((StudioDesign d) => d.id == id);
    if (index < 0) throw StateError('no such design');
    final StudioDesign updated = _designs[index].copyWith(
      name: name ?? _designs[index].name,
      description: description ?? _designs[index].description,
      data: data ?? _designs[index].data,
    );
    _designs[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteDesign(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _designs.removeWhere((StudioDesign d) => d.id == id);
  }

  @override
  Future<StudioDesign> copyDesign({
    required String sourceId,
    String? name,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final StudioDesign copy = StudioDesign(
      id: 'mock-design-${_designs.length + 1}',
      name: name ?? 'Copy of template',
      width: 1080,
      height: 1080,
      data: _poster,
      updatedAt: DateTime.now().toIso8601String(),
    );
    _designs.insert(0, copy);
    return copy;
  }

  @override
  Future<AiDesignerReply> askDesigner({
    required List<AiDesignerTurn> history,
    required StudioCanvas canvas,
    StudioDesignData? currentDesign,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return const AiDesignerReply(
      message:
          'Here is a bolder take — the headline carries the whole poster and '
          'the subtitle steps back to periwinkle.',
      design: _poster,
      model: 'mock',
    );
  }

  @override
  Future<String> generateImage({
    required String prompt,
    required String aspectRatio,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return 'https://images.plexaverse.com/mock/generated.jpg';
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors the other slices.
final Provider<StudioRepository> studioRepositoryProvider =
    Provider<StudioRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakeStudioRepository();
      return ApiStudioRepository(ref.watch(dioClientProvider));
    });
