import 'package:dio/dio.dart' show DioException, Response;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure.dart';
import '../domain/advocacy_post.dart';
import '../domain/banner_template.dart';
import '../domain/company_analytics.dart';
import '../domain/company_post.dart';
import '../domain/company_repository.dart';
import '../domain/inbox_comment.dart';

/// Dio-backed [CompanyRepository].
///
/// [DioClient] already unwraps the `{data, error, meta}` envelope, so every
/// method below sees the inner payload directly. `dio` is imported only here,
/// and only for the [DioException] this class translates away and the
/// [Response] type its helpers name.
class ApiCompanyRepository implements CompanyRepository {
  const ApiCompanyRepository(this._client);

  final DioClient _client;

  // ── Failure translation ────────────────────────────────────────────────

  /// Reads the envelope's `error.code` off the raw response.
  ///
  /// It is NOT read from [Failure.errorCode]. `ErrorInterceptor` looks for
  /// `code` at the TOP level of the body, and the mobile envelope nests it
  /// under `error`, so `Failure.errorCode` is null for every 4xx this API
  /// returns. Branching on it would silently treat "you have not connected a
  /// company page" as a generic server error on every company screen. Fixing
  /// the interceptor is core work and is reported separately; until then this
  /// reads the code where the server actually puts it.
  static String? _envelopeCode(Response<Object?>? response) {
    final Object? body = response?.data;
    if (body is! Map) return null;
    final Object? error = body['error'];
    if (error is! Map) return null;
    final Object? code = error['code'];
    return code is String && code.isNotEmpty ? code : null;
  }

  /// Translates every wire failure into a [CompanyUnavailable], once.
  ///
  /// This is what lets four screens render one honest state instead of each
  /// of them knowing that a 400 with `NO_LINKEDIN_ACCOUNT` means "send them to
  /// Settings" while a 502 means "try again".
  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (e) {
      final Object? inner = e.error;
      final String? message = inner is Failure ? inner.message : null;
      final String? code = _envelopeCode(e.response);

      final CompanyPrecondition reason = switch (code) {
        'NO_LINKEDIN_ACCOUNT' => CompanyPrecondition.noCompanyAccount,
        'COMPANY_PAGE_UNLINKED' => CompanyPrecondition.pageUnlinked,
        'NO_PERSONAL_LINKEDIN_ACCOUNT' => CompanyPrecondition.noPersonalAccount,
        _ => CompanyPrecondition.upstreamRefused,
      };

      return Future<T>.error(CompanyUnavailable(reason, message));
    } on CompanyUnavailable {
      rethrow;
    } on Object {
      return Future<T>.error(
        const CompanyUnavailable(
          CompanyPrecondition.upstreamRefused,
          'Could not reach Plexaverse. Try again.',
        ),
      );
    }
  }

  // ── Analytics ──────────────────────────────────────────────────────────

  /// The `forceRefresh` parameter is only ever SENT when true — its presence
  /// is what bypasses the server's 24-hour cache, so sending `false` would be
  /// a needlessly different request shape for the ordinary read.
  static String? _forceFlag(bool forceRefresh) => forceRefresh ? 'true' : null;

  @override
  Future<CompanyAnalytics> fetchAnalytics({bool forceRefresh = false}) =>
      _guard(() async {
        final String? force = _forceFlag(forceRefresh);
        final Response<Map<String, dynamic>> response = await _client
            .get<Map<String, dynamic>>(
              ApiPaths.linkedInAnalytics,
              queryParameters: <String, dynamic>{'forceRefresh': ?force},
            );
        final Map<String, dynamic>? data = response.data;
        if (data == null) return const CompanyAnalytics();
        return CompanyAnalytics.fromJson(data);
      });

  @override
  Future<List<CompanyPostItem>> fetchPosts({bool forceRefresh = false}) =>
      _guard(() async {
        final String? force = _forceFlag(forceRefresh);
        final Response<Map<String, dynamic>> response = await _client
            .get<Map<String, dynamic>>(
              ApiPaths.linkedInPosts,
              queryParameters: <String, dynamic>{'forceRefresh': ?force},
            );
        return _list(response.data?['posts'], CompanyPostItem.fromJson);
      });

  // ── Inbox ──────────────────────────────────────────────────────────────

  @override
  Future<List<InboxComment>> fetchComments(String postUrn) => _guard(() async {
    final Response<Map<String, dynamic>> response = await _client
        .get<Map<String, dynamic>>(
          ApiPaths.linkedInComments,
          queryParameters: <String, dynamic>{'urn': postUrn},
        );
    return _list(response.data?['comments'], InboxComment.fromJson);
  });

  @override
  Future<List<ReplyOutcome>> replyToComments(Map<String, String> replies) =>
      _guard(() async {
        final Response<Map<String, dynamic>> response = await _client
            .post<Map<String, dynamic>>(
              ApiPaths.linkedInComments,
              data: <String, dynamic>{
                'replies': <Map<String, dynamic>>[
                  for (final MapEntry<String, String> e in replies.entries)
                    <String, dynamic>{'targetUrn': e.key, 'message': e.value},
                ],
              },
            );
        return _list(response.data?['results'], ReplyOutcome.fromJson);
      });

  @override
  Future<bool> reactToComment({
    required String commentUrn,
    required CommentReaction reaction,
  }) => _guard(() async {
    final Response<Map<String, dynamic>> response = await _client
        .post<Map<String, dynamic>>(
          ApiPaths.linkedInCommentsReact,
          data: <String, dynamic>{
            'commentUrn': commentUrn,
            'reactionType': reaction.wire,
          },
        );
    return response.data?['alreadyReacted'] == true;
  });

  // ── Advocacy ───────────────────────────────────────────────────────────

  @override
  Future<bool> setAdvocacy({
    required String postId,
    required bool isAdvocated,
    int? expiryDays,
  }) => _guard(() async {
    final Response<Map<String, dynamic>> response = await _client
        .post<Map<String, dynamic>>(
          ApiPaths.linkedInAdvocacy,
          data: <String, dynamic>{
            'postId': postId,
            'isAdvocated': isAdvocated,
            'expiryDays': ?expiryDays,
          },
        );
    // The server echoes the flag it stored. Trusting the request instead would
    // leave the card lying when the write was coerced.
    return response.data?['isAdvocated'] == true;
  });

  @override
  Future<List<AdvocacyPost>> fetchAdvocacyFeed() => _guard(() async {
    final Response<Map<String, dynamic>> response = await _client
        .get<Map<String, dynamic>>(ApiPaths.linkedInAdvocacy);
    return _list(response.data?['posts'], AdvocacyPost.fromJson);
  });

  @override
  Future<int> reshare({required String postUrn, required String commentary}) =>
      _guard(() async {
        final Response<Map<String, dynamic>> response = await _client
            .post<Map<String, dynamic>>(
              ApiPaths.linkedInReshare,
              data: <String, dynamic>{
                'postUrn': postUrn,
                'commentary': commentary,
              },
            );
        return (response.data?['xpAwarded'] as num?)?.toInt() ?? 0;
      });

  // ── Banner ─────────────────────────────────────────────────────────────

  @override
  Future<String?> fetchCompanyPageId() => _guard(() async {
    final Response<Map<String, dynamic>> response = await _client
        .get<Map<String, dynamic>>(ApiPaths.linkedInOrganizations);
    final List<dynamic> orgs =
        (response.data?['organizations'] as List<dynamic>?) ??
        const <dynamic>[];
    if (orgs.isEmpty) return null;
    final Object? first = orgs.first;
    if (first is! Map) return null;
    final Object? id = first['id'];
    return id is String && id.isNotEmpty ? id : null;
  });

  @override
  Future<List<BannerTemplate>> fetchBannerTemplates() => _guard(() async {
    final Response<Map<String, dynamic>> response = await _client
        .get<Map<String, dynamic>>(
          ApiPaths.studioTemplates,
          queryParameters: <String, dynamic>{
            'category': 'banner',
            // The listing omits the design blob unless asked. This screen
            // renders the design, not the thumbnail, so it always asks.
            'includeData': 'true',
          },
        );
    return _list(response.data?['templates'], BannerTemplate.fromJson);
  });

  @override
  Future<String> applyCompanyBanner({
    required String organizationId,
    required String imageBase64,
    required int imageWidth,
    required int imageHeight,
  }) => _guard(() async {
    final Response<Map<String, dynamic>> response = await _client
        .post<Map<String, dynamic>>(
          ApiPaths.linkedInCompanyBanner,
          data: <String, dynamic>{
            'organizationId': organizationId,
            'imageBase64': imageBase64,
            'imageWidth': imageWidth,
            'imageHeight': imageHeight,
            'mimeType': 'image/png',
          },
        );
    final Object? url = response.data?['pageUrl'];
    return url is String ? url : '';
  });

  // ── Shared parsing ─────────────────────────────────────────────────────

  /// Maps a JSON array, skipping entries that are not objects.
  ///
  /// These lists come from LinkedIn by way of our server, and one malformed
  /// element must not take the whole screen down — an inbox that renders nine
  /// of ten comments is strictly better than one that renders an error.
  static List<T> _list<T>(
    Object? raw,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (raw is! List) return <T>[];
    return <T>[
      for (final Object? item in raw)
        if (item is Map<String, dynamic>) fromJson(item),
    ];
  }
}

/// In-memory [CompanyRepository] for the `mock` flavor.
///
/// Shaped like a live company page mid-week: real follower spread, a post with
/// outstanding comments and one without, one post already featured for
/// advocacy. Every state the four screens can show is reachable without a
/// LinkedIn connection.
class FakeCompanyRepository implements CompanyRepository {
  FakeCompanyRepository();

  static const Duration _latency = Duration(milliseconds: 350);

  final Map<String, bool> _advocacy = <String, bool>{
    'urn:li:activity:mock-1': true,
    'urn:li:activity:mock-2': false,
    'urn:li:activity:mock-3': false,
  };

  final Set<String> _replied = <String>{};

  @override
  Future<CompanyAnalytics> fetchAnalytics({bool forceRefresh = false}) async {
    await Future<void>.delayed(_latency);
    return const CompanyAnalytics(
      orgId: '12345678',
      followers: CompanyFollowerStats(
        followerCountsByGeoCountry: <GeoFollowerBucket>[
          GeoFollowerBucket(
            geo: 'urn:li:geo:102713980',
            followerCounts: FollowerCounts(
              organicFollowerCount: 2841,
              paidFollowerCount: 96,
            ),
          ),
          GeoFollowerBucket(
            geo: 'urn:li:geo:103644278',
            followerCounts: FollowerCounts(organicFollowerCount: 612),
          ),
        ],
        followerCountsByStaffCountRange: <StaffCountBucket>[
          StaffCountBucket(
            staffCountRange: 'SIZE_11_TO_50',
            followerCounts: FollowerCounts(organicFollowerCount: 1180),
          ),
          StaffCountBucket(
            staffCountRange: 'SIZE_51_TO_200',
            followerCounts: FollowerCounts(organicFollowerCount: 870),
          ),
          StaffCountBucket(
            staffCountRange: 'SIZE_2_TO_10',
            followerCounts: FollowerCounts(organicFollowerCount: 640),
          ),
          StaffCountBucket(
            staffCountRange: 'SIZE_201_TO_500',
            followerCounts: FollowerCounts(organicFollowerCount: 410),
          ),
          StaffCountBucket(
            staffCountRange: 'SIZE_10001_OR_MORE',
            followerCounts: FollowerCounts(organicFollowerCount: 155),
          ),
        ],
      ),
      pageStats: CompanyPageStats(
        views: <String, PageViewCount>{
          'allPageViews': PageViewCount(pageViews: 9420),
          'allMobilePageViews': PageViewCount(pageViews: 5310),
          'allDesktopPageViews': PageViewCount(pageViews: 4110),
          'desktopOverviewPageViews': PageViewCount(pageViews: 2380),
          'mobileOverviewPageViews': PageViewCount(pageViews: 3120),
          'desktopPeoplePageViews': PageViewCount(pageViews: 740),
          'mobilePeoplePageViews': PageViewCount(pageViews: 910),
          'desktopJobsPageViews': PageViewCount(pageViews: 430),
          'mobileJobsPageViews': PageViewCount(pageViews: 520),
        },
      ),
      timestamp: '2026-09-19T04:00:00.000Z',
    );
  }

  @override
  Future<List<CompanyPostItem>> fetchPosts({bool forceRefresh = false}) async {
    await Future<void>.delayed(_latency);
    return <CompanyPostItem>[
      CompanyPostItem(
        id: 'urn:li:activity:mock-1',
        text:
            'Onboarding is a design problem, not a documentation problem. '
            'Here is what changed when we stopped writing more docs.',
        createdAt: DateTime(2026, 9, 16).millisecondsSinceEpoch,
        isAdvocated: _advocacy['urn:li:activity:mock-1'] ?? false,
        stats: const CompanyPostStats(
          impressionCount: 8120,
          clickCount: 210,
          likeCount: 164,
          commentCount: 3,
          shareCount: 22,
          engagementRate: 4.88,
        ),
      ),
      CompanyPostItem(
        id: 'urn:li:activity:mock-2',
        text:
            'Three onboarding metrics nobody tracks, and why week one is '
            'the only one that predicts the year.',
        createdAt: DateTime(2026, 9, 12).millisecondsSinceEpoch,
        isAdvocated: _advocacy['urn:li:activity:mock-2'] ?? false,
        stats: const CompanyPostStats(
          impressionCount: 3940,
          likeCount: 71,
          commentCount: 0,
          shareCount: 6,
          engagementRate: 1.96,
        ),
      ),
      CompanyPostItem(
        id: 'urn:li:activity:mock-3',
        text:
            'We are hiring two platform engineers. The handover problem is '
            'the first thing you would fix.',
        createdAt: DateTime(2026, 9, 8).millisecondsSinceEpoch,
        isAdvocated: _advocacy['urn:li:activity:mock-3'] ?? false,
        stats: const CompanyPostStats(
          impressionCount: 1510,
          likeCount: 28,
          commentCount: 1,
          shareCount: 2,
          engagementRate: 2.05,
        ),
      ),
    ];
  }

  @override
  Future<List<InboxComment>> fetchComments(String postUrn) async {
    await Future<void>.delayed(_latency);
    if (postUrn != 'urn:li:activity:mock-1') return <InboxComment>[];
    final int received = DateTime(2026, 9, 17, 9, 41).millisecondsSinceEpoch;
    final List<InboxComment> all = <InboxComment>[
      InboxComment(
        id: 'urn:li:comment:mock-a',
        text:
            'This matches what we saw exactly. Week one is where it all '
            'goes.',
        createdAt: received,
        suggestedReply:
            'Glad it lands — week one really is where the year is decided.',
        suggestedReaction: 'INTEREST',
      ),
      InboxComment(
        id: 'urn:li:comment:mock-b',
        text: 'Congratulations on shipping this, genuinely impressive work.',
        createdAt: received,
        suggestedReply: 'Thank you! The team put a lot into it.',
        suggestedReaction: 'PRAISE',
      ),
      InboxComment(
        id: 'urn:li:comment:mock-c',
        text: 'Do you have the checklist somewhere public?',
        createdAt: received,
        suggestedReply:
            'We do — it is linked in the article at the top of the page.',
      ),
    ];
    // The live endpoint filters out comments already replied to; the fake has
    // to do the same or a reply appears to do nothing.
    return all
        .where((InboxComment c) => !_replied.contains(c.id))
        .toList(growable: false);
  }

  @override
  Future<List<ReplyOutcome>> replyToComments(
    Map<String, String> replies,
  ) async {
    await Future<void>.delayed(_latency);
    _replied.addAll(replies.keys);
    return <ReplyOutcome>[
      for (final String urn in replies.keys)
        ReplyOutcome(targetUrn: urn, success: true),
    ];
  }

  @override
  Future<bool> reactToComment({
    required String commentUrn,
    required CommentReaction reaction,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return false;
  }

  @override
  Future<bool> setAdvocacy({
    required String postId,
    required bool isAdvocated,
    int? expiryDays,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _advocacy[postId] = isAdvocated;
    return isAdvocated;
  }

  @override
  Future<List<AdvocacyPost>> fetchAdvocacyFeed() async {
    await Future<void>.delayed(_latency);
    return const <AdvocacyPost>[
      AdvocacyPost(
        id: 'mock-post-1',
        content:
            'Onboarding is a design problem, not a documentation problem. '
            'Here is what changed when we stopped writing more docs and '
            'started designing the first five days instead.',
        linkedinPostId: 'urn:li:activity:mock-1',
        publishedAt: '2026-09-16T09:00:00.000Z',
        isAdvocated: true,
        account: AdvocacyAccount(profileName: 'Plexaverse'),
        metrics: AdvocacyMetrics(
          impressions: 8120,
          comments: 3,
          shares: 22,
          reactions: 164,
        ),
      ),
      AdvocacyPost(
        id: 'mock-post-2',
        content:
            'We are hiring two platform engineers. The handover problem is '
            'the first thing you would fix.',
        linkedinPostId: 'urn:li:activity:mock-3',
        publishedAt: '2026-09-08T09:00:00.000Z',
        isAdvocated: true,
        account: AdvocacyAccount(profileName: 'Plexaverse'),
        metrics: AdvocacyMetrics(impressions: 1510, comments: 1, reactions: 28),
      ),
    ];
  }

  @override
  Future<int> reshare({
    required String postUrn,
    required String commentary,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return 50;
  }

  @override
  Future<String?> fetchCompanyPageId() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return '12345678';
  }

  @override
  Future<List<BannerTemplate>> fetchBannerTemplates() async {
    await Future<void>.delayed(_latency);
    return <BannerTemplate>[
      _mockTemplate('mock-banner-1', 'Midnight rule', '#050A24', '#2F3AF7'),
      _mockTemplate('mock-banner-2', 'Signal green', '#06103A', '#00DC82'),
      _mockTemplate('mock-banner-3', 'Periwinkle', '#071445', '#AEB4FF'),
    ];
  }

  static BannerTemplate _mockTemplate(
    String id,
    String name,
    String background,
    String accent,
  ) => BannerTemplate(
    id: id,
    name: name,
    data: StudioDesignData(
      canvas: StudioCanvas(width: 1584, height: 396, background: background),
      elements: <StudioElement>[
        StudioElement(
          id: '$id-bar',
          name: 'accent bar',
          x: 80,
          y: 150,
          width: 12,
          height: 120,
          fill: accent,
        ),
        // Named the way a real template names its slots, so the personalise
        // step is actually exercised by the mock flavor.
        StudioElement(
          id: '$id-name',
          type: 'text',
          name: 'user-name',
          text: 'Your Name',
          x: 130,
          y: 150,
          width: 900,
          height: 62,
          fontSize: 54,
          fontWeight: 800,
          fill: '#FFFFFF',
        ),
        StudioElement(
          id: '$id-role',
          type: 'text',
          name: 'position',
          text: 'Position',
          x: 130,
          y: 226,
          width: 900,
          height: 40,
          fontSize: 26,
          fontWeight: 600,
          fill: accent,
        ),
      ],
    ),
  );

  @override
  Future<String> applyCompanyBanner({
    required String organizationId,
    required String imageBase64,
    required int imageWidth,
    required int imageHeight,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return 'https://www.linkedin.com/company/$organizationId/';
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors the other slices.
final Provider<CompanyRepository> companyRepositoryProvider =
    Provider<CompanyRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakeCompanyRepository();
      return ApiCompanyRepository(ref.watch(dioClientProvider));
    });
