import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_analytics.freezed.dart';
part 'company_analytics.g.dart';

/// LinkedIn's follower split for one bucket — organic vs paid.
///
/// The web sums BOTH into the headline "Total Followers" figure
/// (`app/(dashboard)/company-analytics/page.tsx`), so [total] is the number
/// the tile shows, not `organicFollowerCount` alone.
@freezed
abstract class FollowerCounts with _$FollowerCounts {
  const FollowerCounts._();

  const factory FollowerCounts({
    @Default(0) int organicFollowerCount,
    @Default(0) int paidFollowerCount,
  }) = _FollowerCounts;

  factory FollowerCounts.fromJson(Map<String, dynamic> json) =>
      _$FollowerCountsFromJson(json);

  int get total => organicFollowerCount + paidFollowerCount;
}

/// One row of `followerCountsByGeoCountry`.
///
/// The country itself is never rendered — the screen only sums this list —
/// but the field is kept so the shape matches the wire and a future
/// geography breakdown does not need a migration.
@freezed
abstract class GeoFollowerBucket with _$GeoFollowerBucket {
  const factory GeoFollowerBucket({
    String? geo,
    @Default(FollowerCounts()) FollowerCounts followerCounts,
  }) = _GeoFollowerBucket;

  factory GeoFollowerBucket.fromJson(Map<String, dynamic> json) =>
      _$GeoFollowerBucketFromJson(json);
}

/// One row of `followerCountsByStaffCountRange` — "how big are the companies
/// my followers work at".
@freezed
abstract class StaffCountBucket with _$StaffCountBucket {
  const StaffCountBucket._();

  const factory StaffCountBucket({
    String? staffCountRange,
    @Default(FollowerCounts()) FollowerCounts followerCounts,
  }) = _StaffCountBucket;

  factory StaffCountBucket.fromJson(Map<String, dynamic> json) =>
      _$StaffCountBucketFromJson(json);

  /// The bar ranks on ORGANIC followers only — paid followers are bought, so
  /// including them would make the audience read better than it is. This
  /// matches the web's sort key exactly.
  int get organic => followerCounts.organicFollowerCount;

  /// `SIZE_11_TO_50` → `11 - 50`. Transcribed from the web's chain:
  /// strip `SIZE_`, `_`→space, the FIRST `TO`→`-`, lowercase. `replaceFirst`
  /// rather than `replaceAll` because JS `String.replace(string, …)` only
  /// replaces the first occurrence — `SIZE_10001_OR_MORE` must survive intact.
  String get label {
    final String raw = staffCountRange ?? '';
    if (raw.isEmpty) return 'Unknown';
    return raw
        .replaceFirst('SIZE_', '')
        .replaceAll('_', ' ')
        .replaceFirst('TO', '-')
        .toLowerCase();
  }
}

/// One `pageStats.views.*` entry.
@freezed
abstract class PageViewCount with _$PageViewCount {
  const factory PageViewCount({
    @Default(0) int pageViews,
    @Default(0) int uniquePageViews,
  }) = _PageViewCount;

  factory PageViewCount.fromJson(Map<String, dynamic> json) =>
      _$PageViewCountFromJson(json);
}

/// A destination row on the "Page Destinations" card. Not a wire type — the
/// web derives these five from the views map, so they are derived here too.
class PageDestination {
  const PageDestination({required this.label, required this.views});

  final String label;
  final int views;
}

/// Tolerant reader for the `views` map.
///
/// The map is LinkedIn's, not ours: the key set changes between API versions
/// and a value that is not an object must not take the whole analytics screen
/// down with it. Unparseable entries are dropped rather than thrown on.
Map<String, PageViewCount> _viewsFromJson(Map<String, dynamic>? raw) {
  if (raw == null) return const <String, PageViewCount>{};
  final Map<String, PageViewCount> out = <String, PageViewCount>{};
  raw.forEach((String key, dynamic value) {
    if (value is Map<String, dynamic>) {
      out[key] = PageViewCount.fromJson(value);
    }
  });
  return out;
}

Map<String, dynamic> _viewsToJson(Map<String, PageViewCount> views) =>
    views.map(
      (String k, PageViewCount v) => MapEntry<String, dynamic>(k, v.toJson()),
    );

/// `organizationPageStatistics.totalPageStatistics`.
@freezed
abstract class CompanyPageStats with _$CompanyPageStats {
  const CompanyPageStats._();

  const factory CompanyPageStats({
    @JsonKey(fromJson: _viewsFromJson, toJson: _viewsToJson)
    @Default(<String, PageViewCount>{})
    Map<String, PageViewCount> views,
  }) = _CompanyPageStats;

  factory CompanyPageStats.fromJson(Map<String, dynamic> json) =>
      _$CompanyPageStatsFromJson(json);

  int viewsFor(String key) => views[key]?.pageViews ?? 0;

  int get allPageViews => viewsFor('allPageViews');
  int get allMobilePageViews => viewsFor('allMobilePageViews');
  int get allDesktopPageViews => viewsFor('allDesktopPageViews');

  /// The five destinations the web lists, in its order, each the sum of its
  /// desktop and mobile counters.
  ///
  /// The web hides a zero row **only past index 1**, so Overview and People
  /// always render even at zero — they are the page's core surfaces and a
  /// missing row would read as "no data" rather than "no visits". Ported as-is.
  List<PageDestination> get destinations {
    const List<(String, String, String)> targets = <(String, String, String)>[
      ('Overview Page', 'desktopOverviewPageViews', 'mobileOverviewPageViews'),
      ('People Page', 'desktopPeoplePageViews', 'mobilePeoplePageViews'),
      ('About Page', 'desktopAboutPageViews', 'mobileAboutPageViews'),
      ('Jobs Page', 'desktopJobsPageViews', 'mobileJobsPageViews'),
      ('Insights Page', 'desktopInsightsPageViews', 'mobileInsightsPageViews'),
    ];

    final List<PageDestination> out = <PageDestination>[];
    for (int i = 0; i < targets.length; i++) {
      final (String label, String desktopKey, String mobileKey) = targets[i];
      final int count = viewsFor(desktopKey) + viewsFor(mobileKey);
      if (count == 0 && i > 1) continue;
      out.add(PageDestination(label: label, views: count));
    }
    return out;
  }

  /// The denominator every destination bar is measured against. Floored at 1
  /// so a page with no traffic divides safely instead of producing NaN.
  int get destinationMax {
    final int total = allDesktopPageViews + allMobilePageViews;
    return total < 1 ? 1 : total;
  }
}

/// `organizationalEntityFollowerStatistics.elements[0]`.
@freezed
abstract class CompanyFollowerStats with _$CompanyFollowerStats {
  const CompanyFollowerStats._();

  const factory CompanyFollowerStats({
    @Default(<GeoFollowerBucket>[])
    List<GeoFollowerBucket> followerCountsByGeoCountry,
    @Default(<StaffCountBucket>[])
    List<StaffCountBucket> followerCountsByStaffCountRange,
  }) = _CompanyFollowerStats;

  factory CompanyFollowerStats.fromJson(Map<String, dynamic> json) =>
      _$CompanyFollowerStatsFromJson(json);

  /// Followers are counted by summing the GEO breakdown, which is what the web
  /// does. LinkedIn exposes no single "total followers" scalar on this
  /// endpoint, so this sum IS the headline number.
  int get totalFollowers => followerCountsByGeoCountry.fold<int>(
    0,
    (int sum, GeoFollowerBucket b) => sum + b.followerCounts.total,
  );

  /// Top five company sizes by organic followers. Sorted on a copy — the
  /// web's in-place `.sort()` on the query cache is a bug we do not reproduce.
  List<StaffCountBucket> get topStaffBuckets {
    final List<StaffCountBucket> sorted =
        List<StaffCountBucket>.of(followerCountsByStaffCountRange)..sort(
          (StaffCountBucket a, StaffCountBucket b) =>
              b.organic.compareTo(a.organic),
        );
    return sorted.take(5).toList(growable: false);
  }

  /// The denominator for the company-size bars.
  int get staffMax {
    int max = 0;
    for (final StaffCountBucket b in followerCountsByStaffCountRange) {
      if (b.organic > max) max = b.organic;
    }
    return max < 1 ? 1 : max;
  }
}

/// `GET /linkedin/analytics` — the whole response.
///
/// **Both halves are best-effort on the server.** `getCompanyAnalytics` in the
/// web's `lib/services/linkedin-content.service.ts` swallows a failed follower
/// or page-stats fetch and returns null for that half, because a fresh company
/// page legitimately has neither yet. So a null [followers] or [pageStats] is
/// an EMPTY state, never an error — the screen renders zeros and says so.
@freezed
abstract class CompanyAnalytics with _$CompanyAnalytics {
  const CompanyAnalytics._();

  const factory CompanyAnalytics({
    String? orgId,
    CompanyFollowerStats? followers,
    CompanyPageStats? pageStats,
    String? timestamp,
  }) = _CompanyAnalytics;

  factory CompanyAnalytics.fromJson(Map<String, dynamic> json) =>
      _$CompanyAnalyticsFromJson(json);

  int get totalFollowers => followers?.totalFollowers ?? 0;
  int get pageViews => pageStats?.allPageViews ?? 0;
  int get mobileViews => pageStats?.allMobilePageViews ?? 0;

  /// Nothing came back from LinkedIn at all — distinct from "came back zero".
  bool get isEmpty => followers == null && pageStats == null;
}
