import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_text_theme.dart';
import '../../domain/timeline_era.dart';

/// Fade/slide-animated era label ("Prehistory", "Classical Era", …) shown
/// above the Global Timeline viewport, keyed on the current scroll year.
///
/// Ports Wonderous's `_AnimatedEraText`
/// (`lib/ui/screens/timeline/widgets/_animated_era_text.dart`) verbatim: the
/// era string is re-derived from [eraForYear] (`../../domain/timeline_era.dart`,
/// era boundaries -600 / 476 / 1450 unchanged) on every rebuild, and a fresh
/// [ValueKey] on that string re-triggers the fade-in + slide-up whenever the
/// era actually changes (not on every year tick within the same era).
///
/// Wonderous's original used `Text(...).maybeAnimate(key: ..., ...)
/// .fadeIn().slide(begin: Offset(0, .2))` (a package extension chain); this
/// port uses `flutter_animate`'s `Animate` widget directly with an explicit
/// `effects` list — the same visual result, and the same construct already
/// used by `event_popup_card.dart` elsewhere in this slice.
///
/// Text style: Wonderous used `$styles.text.body.copyWith(color:
/// $styles.colors.offWhite)`. Plexaverse's [SkinColors] has no dedicated
/// "offWhite" token (its greys — `subtitleGrey` #8E9BB5, `dateGrey` #8A8FA8 —
/// are cool mid-greys meant for secondary copy on navy, not an off-white
/// display color), so `Colors.white70` is used here as the closest match to
/// Wonderous's near-white era label.
class AnimatedEraText extends StatelessWidget {
  const AnimatedEraText(this.year, {super.key});

  /// The raw (unrounded) year the timeline is currently scrolled to.
  final int year;

  @override
  Widget build(BuildContext context) {
    final era = eraForYear(year);
    final style = AppTextTheme.bodyLarge.copyWith(color: Colors.white70);
    return Semantics(
      liveRegion: true,
      child: Animate(
        key: ValueKey(era),
        effects: const [
          FadeEffect(),
          SlideEffect(begin: Offset(0, .2)),
        ],
        child: Text(era, style: style),
      ),
    );
  }
}
