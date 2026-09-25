/// The Zave widget kit — the components every aligned screen is built from.
///
/// ```dart
/// import 'package:plexaverse/core/ui/zave/zave_kit.dart';
/// ```
///
/// This barrel re-exports the design tokens too, so a screen needs one import.
///
/// ## Use these, not the pre-alignment widgets
///
/// The app still contains its original widget set (`core/ui/widgets/`,
/// `core/ui/skin/`) from the skin this app was cloned from. Those encode a
/// different visual language — most visibly [PressableScale], whose spring
/// overshoots on release, which Zave's motion rule forbids. New and restyled
/// screens use this kit; the old set is removed as its last caller goes.
library;

export '../../theme/zave/zave.dart';
export 'zave_bottom_bar.dart';
export 'zave_button.dart';
export 'zave_card.dart';
export 'zave_chip.dart';
export 'zave_field.dart';
export 'zave_ground.dart';
export 'zave_more_sheet.dart';
export 'zave_press.dart';
export 'zave_switch.dart';
export 'zave_section_header.dart';
export 'zave_stat_card.dart';
export 'zave_row_circle.dart';
export 'zave_task_glyph.dart';
