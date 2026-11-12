import 'package:flutter/widgets.dart';

import '../../../core/theme/zave/zave.dart';
import '../domain/roadmap_level.dart';

/// How a roadmap status is coloured and named.
///
/// ## The one mapping in this feature that had to be re-decided
///
/// The web roadmap carries a palette of its own — `#acffa4` behind,
/// `#5bffd3` today, `#44484f` ahead — predating Zave and unreachable from it.
/// Zave's governing rule is that **colour only ever names a status**, and it
/// already has a name for each:
///
/// | web        | here                | why                                    |
/// |------------|---------------------|----------------------------------------|
/// | `#acffa4`  | [ZaveColors.green]  | done — a day travelled                 |
/// | `#5bffd3`  | [ZaveColors.mint]   | green that stays legible on dark        |
/// | `#44484f`  | [ZaveColors.ink35]  | the faintest legible step; inert        |
///
/// There used to be a fourth, a missed day, painted amber because Zave has
/// no red. It went with the daily missions (12 Nov 2026): a status now comes
/// from the date alone, and a date cannot be missed.
///
/// The planets themselves are exempt from this table — a planet is a depiction
/// of a planet, not UI chrome, and Mars is allowed to be red. See
/// `presentation/widgets/planet_node.dart`.
Color roadmapStatusColor(LevelStatus status) => switch (status) {
  LevelStatus.completed => ZaveColors.green,
  LevelStatus.active => ZaveColors.mint,
  LevelStatus.locked => ZaveColors.ink35,
};

/// The status word beside a day row. Copy is the web's, exactly.
///
/// A day ahead says nothing — the web renders no label for it, because a day
/// you have not reached has no state worth naming.
String? roadmapStatusLabel(LevelStatus status) => switch (status) {
  LevelStatus.completed => 'Travelled',
  LevelStatus.active => 'Today',
  LevelStatus.locked => null,
};

/// How prominent a day row reads. The web's `labelOpacity`, unchanged: a day
/// ahead recedes, today is full strength, a day behind sits between.
double roadmapRowOpacity(LevelStatus status) => switch (status) {
  LevelStatus.locked => 0.38,
  LevelStatus.active => 1,
  LevelStatus.completed => 0.65,
};
