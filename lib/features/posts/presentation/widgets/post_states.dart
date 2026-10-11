import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// The loading list — five card-shaped placeholders, the same count the web
/// renders (`[...Array(5)]` in `app/(dashboard)/posts/page.tsx`).
///
/// The cards occupy the space their content will, so the layout does not
/// jump when the data lands, and one [ZaveShimmer] sweep crosses all five —
/// the wrapper is here, at the list, rather than on each card, so the five
/// read as one thing arriving.
class PostListSkeleton extends StatelessWidget {
  const PostListSkeleton({this.rows = 5, super.key});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return ZaveShimmer(
      child: Column(
        children: <Widget>[
          for (int i = 0; i < rows; i++) ...<Widget>[
            const PostCardSkeleton(),
            SizedBox(height: ZaveSpace.md),
          ],
        ],
      ),
    );
  }
}

/// One placeholder row. Its bars stand in for the meta line, the title and the
/// two-line excerpt, at roughly the widths the real content takes.
class PostCardSkeleton extends StatelessWidget {
  const PostCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const ZaveSkeleton.bar(width: 90),
              SizedBox(width: ZaveSpace.md),
              const ZaveSkeleton.bar(width: 70),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          const ZaveSkeleton.bar(widthFactor: 0.75, height: 18),
          SizedBox(height: ZaveSpace.md),
          const ZaveSkeleton.bar(widthFactor: 1),
          SizedBox(height: ZaveSpace.sm),
          const ZaveSkeleton.bar(widthFactor: 0.6),
        ],
      ),
    );
  }
}

/// "No posts found" — the web's empty state, restated in Zave.
class PostsEmpty extends StatelessWidget {
  const PostsEmpty({required this.message, this.action, super.key});

  final String message;

  /// The web offers "Create your first post" here. Null when the list is empty
  /// only because a filter or a search excluded everything — offering to create
  /// a post in that case answers a question the user did not ask.
  final Widget? action;

  @override
  Widget build(BuildContext context) =>
      ZaveEmptyState(title: message, action: action);
}

/// The load-failed state.
///
/// Amber, not red: **Zave has no red at all**, and a fetch that failed is a
/// "needs attention" state rather than a destructive one.
class PostsError extends StatelessWidget {
  const PostsError({
    required this.title,
    required this.onRetry,
    this.detail,
    super.key,
  });

  final String title;
  final String? detail;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const ZaveDot(ZaveColors.amber),
              SizedBox(width: ZaveSpace.sm),
              Text('COULD NOT LOAD', style: ZaveType.kicker),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(title, style: ZaveType.h3),
          if (detail != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(detail!, style: ZaveType.bodyMuted),
          ],
          SizedBox(height: ZaveSpace.lg),
          ZaveButton(label: 'Try again', onPressed: onRetry),
        ],
      ),
    );
  }
}
