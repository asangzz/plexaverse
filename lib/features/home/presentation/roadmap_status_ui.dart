import 'package:flutter/widgets.dart';

import '../../../core/theme/zave/zave.dart';
import '../domain/roadmap_level.dart';

/// How a roadmap status is coloured and named.
///
/// ## The one mapping in this feature that had to be re-decided
///
/// The web roadmap carries a palette of its own — `#acffa4` completed,
/// `#5bffd3` active, `#ff4d4d` missed, `#44484f` locked — predating Zave and
/// unreachable from it. Zave's governing rule is that **colour only ever names
/// a status**, and it already has names for three of these four:
///
/// | web        | here                | why                                    |
/// |------------|---------------------|----------------------------------------|
/// | `#acffa4`  | [ZaveColors.green]  | done, published                        |
/// | `#5bffd3`  | [ZaveColors.mint]   | green that stays legible on dark        |
/// | `#ff4d4d`  | [ZaveColors.amber]  | **Zave has no red** — see below         |
/// | `#44484f`  | [ZaveColors.ink35]  | the faintest legible step; inert        |
///
/// **Zave has no red at all**, deliberately: a missed day is not a failure
/// state, it is an unfinished one, and the system's word for "waiting, needs
/// attention" is amber. Reintroducing red here would be the single loudest
/// thing on the screen and would say something the product does not mean.
///
/// The planets themselves are exempt from this table — a planet is a depiction
/// of a planet, not UI chrome, and Mars is allowed to be red. See
/// `presentation/widgets/planet_node.dart`.
Color roadmapStatusColor(LevelStatus status) => switch (status) {
  LevelStatus.completed => ZaveColors.green,
  LevelStatus.active => ZaveColors.mint,
  // Amber, not red. Zave has no red.
  LevelStatus.missed => ZaveColors.amber,
  LevelStatus.locked => ZaveColors.ink35,
};

/// The status word beside a day row. Copy is the web's, exactly.
///
/// A locked day says nothing — the web renders no label for it, because a day
/// you have not reached has no state worth naming.
String? roadmapStatusLabel(LevelStatus status) => switch (status) {
  LevelStatus.completed => 'Completed',
  LevelStatus.active => 'In Progress',
  LevelStatus.missed => 'Steps Missed',
  LevelStatus.locked => null,
};

/// How prominent a day row reads. The web's `labelOpacity`, unchanged: a locked
/// day recedes, today and a missed day are full strength, everything else sits
/// between.
double roadmapRowOpacity(LevelStatus status) => switch (status) {
  LevelStatus.locked => 0.38,
  LevelStatus.active || LevelStatus.missed => 1,
  LevelStatus.completed => 0.65,
};
