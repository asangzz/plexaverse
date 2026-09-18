import '../../../core/ui/widgets/status_badge.dart';
import '../domain/post_entity.dart';

/// Presentation-root enum → UI mapping for post status, mirroring the orders
/// feature's `order_status_ui.dart` convention (`feature-orders-products.md`).
/// Maps [PostStatus] to the shared [StatusBadgeVariant] colour pairing so
/// status is always communicated by colour AND text (the badge always renders
/// `status.label` alongside).
StatusBadgeVariant postStatusVariant(PostStatus status) => switch (status) {
      PostStatus.published => StatusBadgeVariant.success,
      PostStatus.scheduled => StatusBadgeVariant.warning,
      PostStatus.failed => StatusBadgeVariant.info,
      PostStatus.draft => StatusBadgeVariant.neutral,
    };
