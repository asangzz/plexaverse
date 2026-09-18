import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../domain/timeline_era.dart';
import '../../domain/timeline_event.dart';

/// Debounced popup that slides in from the top of the Global Timeline
/// viewport, showing the [TimelineEvent] currently nearest the scroll
/// position (see `TimelineEventMarkers`'s 10px proximity threshold, which
/// drives the `currentEvent` value this widget receives).
///
/// Ports Wonderous's `_EventPopups`
/// (`lib/ui/screens/timeline/widgets/_event_popups.dart`) verbatim:
///  * a 500ms debounce absorbs rapid-fire `currentEvent` changes while the
///    user is actively scrolling/zooming, only "settling" on an event once
///    updates pause for 500ms;
///  * an `AnimatedSwitcher` cross-fades between the settled events, and the
///    incoming card slides in from `Offset(0, -.1)` via `flutter_animate`.
///
/// Per the porting rules: Wonderous's `Debouncer` utility is replaced with a
/// plain `Timer` field (cancel + restart), and `TopCenter` /
/// `IgnorePointerKeepSemantics` are replaced with `Align` / `IgnorePointer`
/// — both built into Flutter, no extra package needed.
class TimelineEventPopup extends StatefulWidget {
  const TimelineEventPopup({required this.currentEvent, super.key});

  /// The event nearest the current scroll position, or null when nothing is
  /// close enough to surface a popup for.
  final TimelineEvent? currentEvent;

  @override
  State<TimelineEventPopup> createState() => _TimelineEventPopupState();
}

class _TimelineEventPopupState extends State<TimelineEventPopup> {
  Timer? _debounce;
  TimelineEvent? _eventToShow;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TimelineEventPopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _showCardForCurrentYr);
  }

  void _showCardForCurrentYr() {
    if (!mounted) return;
    setState(() => _eventToShow = widget.currentEvent);
  }

  @override
  Widget build(BuildContext context) {
    final evt = _eventToShow;
    return Align(
      alignment: Alignment.topCenter,
      child: ClipRect(
        child: IgnorePointer(
          // Wonderous's `IgnorePointerKeepSemantics`: the popup itself must
          // never intercept scroll/drag gestures meant for the viewport
          // beneath it, but its live-region announcement still needs to
          // reach assistive tech. Since Flutter 3.8, `IgnorePointer` no
          // longer drops semantics by default, so no extra flag is needed
          // here to keep them live.
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: evt == null
                ? const SizedBox.shrink()
                : Semantics(
                    liveRegion: true,
                    child: Animate(
                      key: ValueKey(evt.year),
                      effects: const [SlideEffect(begin: Offset(0, -.1))],
                      child: IntrinsicHeight(
                        child: SizedBox(
                          width: 500.w,
                          child: Padding(
                            padding: EdgeInsets.all(24.w),
                            child: TimelineEventCard(
                              year: evt.year,
                              description: evt.description,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Reusable "year + description" card used both by [TimelineEventPopup] and
/// (in a later phase) any marker-tap popup that needs the same layout.
///
/// Ports Wonderous's `TimelineEventCard`
/// (`lib/ui/common/timeline_event_card.dart`): a dark card with the big year
/// number and its BCE/CE suffix in a fixed-width leading column, a vertical
/// divider, and the event description filling the remaining space.
///
/// Wonderous's card supported a `darkMode` toggle (used with a light/offWhite
/// background on the Wonder Detail screen); this app is dark-only, so that
/// branch is dropped and the card always renders with [SkinColors.sheetDark].
class TimelineEventCard extends StatelessWidget {
  const TimelineEventCard({
    required this.year,
    required this.description,
    super.key,
  });

  /// The event year (negative = BCE), per Wonderous's timeline convention.
  final int year;

  final String description;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: SkinColors.sheetDark,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Date
              SizedBox(
                width: 75.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${year.abs()}',
                      style: AppTextTheme.headlineSmall.copyWith(
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    Text(
                      yearSuffix(year),
                      style: AppTextTheme.bodySmall.copyWith(
                        color: SkinColors.subtitleGrey,
                      ),
                    ),
                  ],
                ),
              ),

              /// Divider
              Container(width: 1, color: Colors.white24),

              SizedBox(width: 16.w),

              /// Text content
              Expanded(
                child: Focus(
                  child: Text(
                    description,
                    style: AppTextTheme.bodyLarge.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
