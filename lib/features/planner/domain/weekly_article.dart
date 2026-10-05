import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_article.freezed.dart';
part 'weekly_article.g.dart';

/// The week's long-form newsletter.
///
/// Thursday's, since the week was rebuilt — it was Sunday's, and
/// Sunday is now a rest day.
///
/// **This is not a post, and it is never published by the app.** LinkedIn's API
/// has no article or newsletter endpoint, and our scope set (`w_member_social`)
/// covers UGC shares only. So the article is PREPARED and handed off: the user
/// copies the body into LinkedIn's own composer (CLAUDE.md §6b).
///
/// That is also why [markPublished] exists as an explicit user action. Every
/// other piece of content in the product closes out by matching a real LinkedIn
/// share URN; an article never receives one, so the user saying "I published
/// it" is the only signal that exists. Without it the status would stay `ready`
/// forever.
@freezed
abstract class WeeklyArticle with _$WeeklyArticle {
  const WeeklyArticle._();

  const factory WeeklyArticle({
    required String id,
    required int weekNumber,
    required int season,

    /// The headline. Chosen by the SEASON plan, not the week — all ten weeks
    /// are titled in one model call so they read as one arc.
    @Default('') String title,

    /// The arguable claim the article defends. A topic says what the week is
    /// ABOUT; a thesis says what it CLAIMS.
    String? thesis,

    /// The body, 1200–1800 words. What the user pastes into LinkedIn.
    ///
    /// **Empty on the summary.** `GET /planner/article` stopped sending it —
    /// it was 6,422 of that response's 7,148 bytes for text the planner screen
    /// never shows. It arrives from `GET /planner/article/body`, fetched when
    /// the sheet opens or Copy is tapped. Check [hasBody] before using it.
    @Default('') String body,
    @Default(<String>[]) List<String> sections,

    /// 'ready' once written; stamped published only by the user.
    /// Reading time, in minutes, as the SERVER counted it.
    ///
    /// It used to be derived here by counting words in [body] — which is
    /// precisely what would have kept the body in the list payload.
    @Default(0) int readingMinutes,
    @Default('ready') String status,
    String? publishedAt,
    String? publishedUrl,
  }) = _WeeklyArticle;

  factory WeeklyArticle.fromJson(Map<String, dynamic> json) =>
      _$WeeklyArticleFromJson(json);

  bool get isPublished => publishedAt != null;

  /// Rough reading time, for the card's meta line.
  int get readMinutes => readingMinutes;

  /// Whether the body has been fetched. The summary arrives without it.
  bool get hasBody => body.trim().isNotEmpty;
}

/// The article endpoint's whole response.
///
/// [isFirstArticle] drives the extra "create a newsletter" step: the user has
/// never made one on LinkedIn, so publishing this article means creating the
/// newsletter first. [newsletterName] is self-reported — nothing syncs it,
/// because nothing can.
@freezed
abstract class ArticleState with _$ArticleState {
  const ArticleState._();

  const factory ArticleState({
    WeeklyArticle? article,
    String? newsletterName,
    String? newsletterCreatedAt,
    @Default(false) bool isFirstArticle,
    @Default(1) int weekNumber,
    @Default(1) int season,
  }) = _ArticleState;

  factory ArticleState.fromJson(Map<String, dynamic> json) =>
      _$ArticleStateFromJson(json);
}
