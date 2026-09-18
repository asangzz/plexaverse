import 'package:flutter/widgets.dart' show Color;

import '../../../core/theme/zave/zave.dart';
import '../domain/library_post.dart';

/// Maps a post's status onto a Zave signal colour and its label.
///
/// This is the one place the library decides what a status looks like, because
/// Zave's first rule is that **colour only ever names a status**.
///
/// The web has TWO disagreeing status palettes for the same statuses — the
/// `statusConfig` object in `app/(dashboard)/posts/page.tsx` (Tailwind
/// `green-400` / `yellow-400` / `blue-400` / `red-400`) and `STATUS_META` in
/// the calendar's `calendar-utils.ts` (`#00DC82` / `#F59E0B` / `#5761EB` /
/// `#EF4444`). Neither is Zave. Restated in Zave, with the meaning preserved
/// rather than the hex:
///
///   • published → green. Done. This is what green means in this system.
///   • approved / scheduled → `scheduled` periwinkle. Queued; it goes out on
///     its own and there is nothing for the user to do.
///   • pending_approval → amber. Waiting on YOU — the only state on this screen
///     that needs a tap.
///   • draft → ink at 50%. Inert. Not a status so much as the absence of one.
///   • failed / rejected → **amber**. Zave has NO RED, at all: a negative or
///     failed state uses amber, which in this system means "waiting" and reads
///     correctly here because a failed post IS waiting on the user to retry it.
///     Do not reach for a red; there is no token to reach for.
({Color color, String label}) postSignal(
  PostLibraryStatus status,
) => switch (status) {
  PostLibraryStatus.published => (color: ZaveColors.green, label: 'Published'),
  PostLibraryStatus.approved => (color: ZaveColors.scheduled, label: 'Ready'),
  PostLibraryStatus.scheduled => (
    color: ZaveColors.scheduled,
    label: 'Scheduled',
  ),
  PostLibraryStatus.pendingApproval => (
    color: ZaveColors.amber,
    label: 'Pending',
  ),
  // Amber, not red — see above.
  PostLibraryStatus.failed => (color: ZaveColors.amber, label: 'Failed'),
  PostLibraryStatus.rejected => (color: ZaveColors.amber, label: 'Rejected'),
  PostLibraryStatus.draft => (color: ZaveColors.ink50, label: 'Draft'),
};
