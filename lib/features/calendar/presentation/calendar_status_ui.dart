import 'package:flutter/widgets.dart' show Color;

import '../../../core/theme/zave/zave.dart';
import '../domain/calendar_post.dart';

/// Maps a post's status onto a Zave signal colour.
///
/// Zave's first rule is that **colour only ever names a status**, so this is the
/// single place the calendar decides what each state looks like. Every other
/// file asks this function rather than picking a colour.
///
/// ## The web's palette, restated in Zave
///
/// The web calendar carries its own five-colour `STATUS_META` map. None of those
/// hexes exist in Zave, so each is mapped to the token that names the same
/// thing:
///
/// | web           | hex       | Zave token              | why |
/// |---------------|-----------|-------------------------|-----|
/// | `scheduled`   | `#5761EB` | [ZaveColors.scheduled]  | the queued/scheduled token, and the nearest hue |
/// | `approved`    | `#06B6D4` | [ZaveColors.mint]       | past the human gate; the nearest cool-bright token |
/// | `published`   | `#00DC82` | [ZaveColors.green]      | exact match — green is "done" in both systems |
/// | `pending_…`   | `#F59E0B` | [ZaveColors.amber]      | exact meaning — amber is "waiting" in both |
/// | `failed`      | `#EF4444` | [ZaveColors.amber]      | **Zave has no red.** See below. |
/// | `draft`       | `#94A3B8` | [ZaveColors.ink35]      | inert, not a status colour at all |
///
/// **Failed is amber, not red, because Zave has no red.** A failed publish is
/// "this needs you", which is what amber means here; it shares the colour with
/// an awaiting-approval post and is told apart by its label and by the failure
/// reason under it. Introducing a red for this one state would break the
/// palette's only rule to recover a distinction the label already carries.
({Color color, String label, String description}) calendarSignal(
  CalendarPostStatus status,
) => (
  color: switch (status) {
    CalendarPostStatus.published => ZaveColors.green,
    CalendarPostStatus.approved => ZaveColors.mint,
    CalendarPostStatus.scheduled => ZaveColors.scheduled,
    CalendarPostStatus.pendingApproval => ZaveColors.amber,
    CalendarPostStatus.failed => ZaveColors.amber,
    CalendarPostStatus.draft => ZaveColors.ink35,
  },
  label: status.label,
  description: status.description,
);
