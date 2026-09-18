import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'posts_dao.g.dart';

/// Drift accessor for the posts + post_metrics product tables. Lives in
/// `core/storage/dao/` alongside the single [AppDatabase] — ProHealth keeps
/// ALL database code in `core/storage` (see notes / feature-orders-products),
/// so DAOs stay in core rather than moving into feature slices.
@DriftAccessor(tables: [PostsTable, PostMetricsTable])
class PostsDao extends DatabaseAccessor<AppDatabase> with _$PostsDaoMixin {
  PostsDao(super.db);

  // -- Queries ---------------------------------------------------------------

  /// Watch all posts ordered by most recently updated.
  Stream<List<PostsTableData>> watchAll() =>
      (select(postsTable)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  /// Watch posts filtered by status.
  Stream<List<PostsTableData>> watchByStatus(String status) =>
      (select(postsTable)
            ..where((t) => t.status.equals(status))
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  /// Watch the N most recent posts (for the dashboard).
  Stream<List<PostsTableData>> watchRecent(int limit) =>
      (select(postsTable)
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
            ..limit(limit))
          .watch();

  /// Get a single post by its local id.
  Future<PostsTableData?> getById(int id) =>
      (select(postsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Fetch metrics for a post.
  Future<PostMetricsTableData?> getMetrics(int postId) =>
      (select(postMetricsTable)..where((t) => t.postId.equals(postId)))
          .getSingleOrNull();

  // -- Counts ----------------------------------------------------------------

  Future<int> countByStatus(String status) async {
    final count = postsTable.id.count();
    final query = selectOnly(postsTable)
      ..addColumns([count])
      ..where(postsTable.status.equals(status));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Future<Map<String, int>> countAll() async {
    const statuses = ['draft', 'scheduled', 'published', 'failed'];
    final result = <String, int>{};
    for (final s in statuses) {
      result[s] = await countByStatus(s);
    }
    return result;
  }

  // -- Mutations -------------------------------------------------------------

  Future<int> insertPost(PostsTableCompanion post) =>
      into(postsTable).insert(post);

  Future<void> updatePost(PostsTableCompanion post) =>
      (update(postsTable)..where((t) => t.id.equals(post.id.value)))
          .write(post);

  Future<void> upsertPost(PostsTableCompanion post) =>
      into(postsTable).insertOnConflictUpdate(post);

  Future<void> deletePost(int id) =>
      (delete(postsTable)..where((t) => t.id.equals(id))).go();

  Future<void> upsertMetrics(PostMetricsTableCompanion metrics) =>
      into(postMetricsTable).insertOnConflictUpdate(metrics);

  // -- Seeding ---------------------------------------------------------------

  /// Seeds realistic demo posts on first launch.
  Future<void> seedIfEmpty() async {
    final existing = await (select(postsTable)..limit(1)).getSingleOrNull();
    if (existing != null) return;

    final now = DateTime.now();

    final seeds = [
      PostsTableCompanion(
        content: const Value(
          'The future of B2B SaaS is community-led growth.\n\n'
          'Here\'s why I believe the next wave of successful SaaS companies '
          'won\'t be built on product-led growth alone...\n\n'
          '1/ Community creates stickiness that no feature can replicate\n'
          '2/ Your users become your best sales team\n'
          '3/ Support costs drop as the community answers each other\n\n'
          '#SaaS #GrowthStrategy #LinkedIn',
        ),
        hookLine:
            const Value('The future of B2B SaaS is community-led growth.'),
        status: const Value('published'),
        platform: const Value('linkedin'),
        publishedAt: Value(now.subtract(const Duration(days: 5))),
        updatedAt: Value(now.subtract(const Duration(days: 5))),
      ),
      PostsTableCompanion(
        content: const Value(
          '5 lessons I learned after 6 months of consistent LinkedIn posting:\n\n'
          '1. Consistency beats perfection every time\n'
          '2. Stories outperform tips 3:1 in engagement\n'
          '3. The first line is everything — 80% don\'t expand the post\n'
          '4. Reply to every comment in the first hour\n'
          '5. Your audience wants to see you fail, not just succeed\n\n'
          'What\'s your biggest LinkedIn posting lesson?',
        ),
        hookLine: const Value(
            '5 lessons I learned after 6 months of consistent LinkedIn posting.'),
        status: const Value('published'),
        platform: const Value('linkedin'),
        publishedAt: Value(now.subtract(const Duration(days: 2))),
        updatedAt: Value(now.subtract(const Duration(days: 2))),
      ),
      PostsTableCompanion(
        content: const Value(
          'We just hit 2,000 followers 🎉\n\n'
          'Here\'s the exact strategy that worked:\n'
          '→ Post every weekday at 9AM\n'
          '→ Lead with a bold hook\n'
          '→ Use numbered lists for readability\n'
          '→ End with a question\n'
          '→ Engage with comments for 30 minutes after posting\n\n'
          'The algorithm rewards engagement velocity. Give it what it wants.',
        ),
        hookLine: const Value('We just hit 2,000 followers 🎉'),
        status: const Value('published'),
        platform: const Value('linkedin'),
        publishedAt: Value(now.subtract(const Duration(hours: 48))),
        updatedAt: Value(now.subtract(const Duration(hours: 48))),
      ),
      PostsTableCompanion(
        content: const Value(
          'AI is changing content creation forever.\n\n'
          'But not in the way most people think.\n\n'
          'Thread on what I\'ve learned using AI tools for LinkedIn content over the past 6 months...',
        ),
        hookLine: const Value('AI is changing content creation forever.'),
        status: const Value('scheduled'),
        platform: const Value('linkedin'),
        scheduledAt: Value(now.add(const Duration(days: 1, hours: 2))),
        updatedAt: Value(now.subtract(const Duration(hours: 1))),
      ),
      PostsTableCompanion(
        content: const Value(
          'Hot take: most LinkedIn content is just polished mediocrity.\n\n'
          'Everyone is posting the same 5-point listicles.\n'
          'The same "I failed and learned" stories.\n'
          'The same humble brags disguised as lessons.\n\n'
          'What actually stands out? Raw honesty. Real numbers. Uncomfortable truths.\n\n'
          'What do you think?',
        ),
        hookLine: const Value(
            'Hot take: most LinkedIn content is just polished mediocrity.'),
        status: const Value('draft'),
        platform: const Value('linkedin'),
        updatedAt: Value(now.subtract(const Duration(minutes: 30))),
      ),
    ];

    for (final seed in seeds) {
      final postId = await into(postsTable).insert(seed);
      // Add metrics to published posts.
      if (seed.status.value == 'published') {
        final metrics = [
          const PostMetricsTableCompanion(
            impressions: Value(2100),
            engagements: Value(124),
            likes: Value(98),
            comments: Value(18),
            reposts: Value(8),
          ),
          const PostMetricsTableCompanion(
            impressions: Value(5400),
            engagements: Value(312),
            likes: Value(241),
            comments: Value(47),
            reposts: Value(24),
          ),
          const PostMetricsTableCompanion(
            impressions: Value(8700),
            engagements: Value(641),
            likes: Value(512),
            comments: Value(89),
            reposts: Value(40),
          ),
        ];
        // Pick metrics based on postId index (1-3 are the published seeds).
        final metricsIdx = postId - 1;
        if (metricsIdx < metrics.length) {
          await into(postMetricsTable)
              .insert(metrics[metricsIdx].copyWith(postId: Value(postId)));
        }
      }
    }
  }
}
