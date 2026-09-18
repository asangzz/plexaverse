import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/network/internet_monitor.dart';
import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../../../core/ui/skin/page_background.dart';
import '../../../../core/ui/widgets/network_error_view.dart';
import '../../application/global_timeline_controller.dart';
import '../widgets/animated_era_text.dart';
import '../widgets/bottom_scrubber.dart';
import '../widgets/scrolling_viewport.dart';

/// Global Timeline tab — the zoomable/scrollable world-history timeline
/// (Wonderous's `TimelineScreen`, `lib/ui/screens/timeline/timeline_screen.dart`).
///
/// deepNavy background; fixed "Global Timeline" 28sp Sora-bold header
/// (matching [VideosPage] / [AvatarsPage]'s own header treatment); below it
/// the [GlobalScrollingViewport] (Expanded, so it fills all remaining
/// vertical space), the current-year [AnimatedEraText], and a centered,
/// width-clamped [TimelineBottomScrubber] row — the same three-part Column
/// Wonderous's `_TimelineScreenState.build` assembles.
///
/// `AsyncValue` drives the designed states: loading → a centered spinner
/// (see [_TimelineLoading] for why this diverges from [AvatarsPage] /
/// [VideosPage]'s row-mirroring `SkeletonBox` skeletons), error → the shared
/// [NetworkErrorView] (online-first; auto-reloads when connectivity
/// returns), data → the assembled viewport + era text + scrubber, fed by the
/// resolved [GlobalTimelineOverview] (`events` for the year-axis
/// markers/popups, `wonders` for the wonder tracks) and
/// [kTimelineStartYear] / [kTimelineEndYear].
class GlobalTimelinePage extends ConsumerWidget {
  const GlobalTimelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Online-first recovery: if the load failed and connectivity returns,
    // re-fire it without requiring a manual retry.
    ref.listen<InternetStatus>(internetMonitorProvider, (previous, next) {
      final wasOffline = previous?.isOffline ?? false;
      if (wasOffline &&
          !next.isOffline &&
          ref.read(globalTimelineControllerProvider).hasError) {
        ref.invalidate(globalTimelineControllerProvider);
      }
    });

    final overview = ref.watch(globalTimelineControllerProvider);
    return Scaffold(
      backgroundColor: SkinColors.deepNavy,
      body: Stack(
        children: [
          // Diagonal navy→black background fitted to the reference set
          // (shared with the Videos, Avatars and Account screens — see
          // SkinPageBackground).
          const Positioned.fill(child: SkinPageBackground()),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 12.h, right: 20.w),
                  child: Text(
                    'Global Timeline',
                    style: GoogleFonts.sora(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: overview.when(
                    loading: () => const _TimelineLoading(),
                    error: (_, _) => NetworkErrorView(
                      onRetry: () {
                        ref.read(internetMonitorProvider.notifier).recheck();
                        ref.invalidate(globalTimelineControllerProvider);
                      },
                    ),
                    data: (data) => _GlobalTimelineBody(overview: data),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loading state ───────────────────────────────────────────────────────────

/// A centered spinner rather than a row-mirroring `SkeletonBox` skeleton
/// (contrast [AvatarsPage] / [VideosPage]).
///
/// Those pages' loaded layouts are uniform lists of static rows/cards, so a
/// same-shaped skeleton avoids layout shift for near-zero cost. The Global
/// Timeline's loaded layout is a single interactive, pinch-zoomable/
/// scrollable canvas with no repeating row shape to mirror — approximating
/// it with placeholder boxes would either be misleading (implying a static
/// list) or require re-deriving the whole zoom/track layout just to show a
/// skeleton. The task brief explicitly allows either treatment for this
/// screen; a centered spinner is the simpler, honest choice here.
class _TimelineLoading extends StatelessWidget {
  const _TimelineLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: SkinColors.brandCyan),
    );
  }
}

// ── Data state ──────────────────────────────────────────────────────────────

/// Owns the [ScrollController] shared by the [GlobalScrollingViewport] and
/// [TimelineBottomScrubber], and the current-year [ValueNotifier] fed to
/// [AnimatedEraText] as the viewport scrolls.
///
/// Wonderous's `_TimelineScreenState` holds this same pair of mutable,
/// per-screen-instance values (a `ScrollController` and a `ValueNotifier<int>`)
/// as plain `State` fields. This port keeps that exact shape — a private
/// `StatefulWidget` wrapper around a plain `ValueNotifier<int>` — rather than
/// promoting the current year to a Riverpod `StateProvider`: the value only
/// drives this one screen's own `AnimatedEraText` (and nothing else reads or
/// needs to survive across it, and it must not outlive this widget's own
/// `ScrollController`), so there is no cross-provider sharing need that
/// would justify a app-wide provider.
class _GlobalTimelineBody extends StatefulWidget {
  const _GlobalTimelineBody({required this.overview});

  final GlobalTimelineOverview overview;

  @override
  State<_GlobalTimelineBody> createState() => _GlobalTimelineBodyState();
}

class _GlobalTimelineBodyState extends State<_GlobalTimelineBody> {
  /// Shared by the top scrolling viewport and the bottom scrubber, exactly
  /// like Wonderous's `_TimelineScreenState._scroller`.
  final ScrollController _scroller = ScrollController();

  /// Mirrors Wonderous's `_TimelineScreenState._year`, seeded at
  /// [kTimelineStartYear] (Wonderous seeds at the arbitrary `0`, which also
  /// happens to fall inside its own default era boundaries — starting at the
  /// timeline's actual first year reads slightly better before the first
  /// `onYearChanged` tick lands).
  final ValueNotifier<int> _year = ValueNotifier<int>(kTimelineStartYear);

  /// Content height at zoom `0` — Wonderous's `_TimelineScreenState`'s local
  /// `minSize` (`1200`), ScreenUtil-scaled as a presentational sizing
  /// constant (it sets the pixel scale of the whole zoomable canvas, not a
  /// year-math ratio itself).
  static final double _minSize = 1200.h;

  /// Content height at zoom `1` — Wonderous's local `maxSize` (`5500`),
  /// scaled likewise.
  static final double _maxSize = 5500.h;

  /// Overall height of the bottom scrubber bar — Wonderous's local
  /// `scrubberSize` (`80`), scaled likewise.
  static final double _scrubberSize = 80.h;

  void _handleYearChanged(int value) => _year.value = value;

  @override
  void dispose() {
    _scroller.dispose();
    _year.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Vertically scrolling timeline, manages the shared ScrollController.
        Expanded(
          child: GlobalScrollingViewport(
            scroller: _scroller,
            minSize: _minSize,
            maxSize: _maxSize,
            events: widget.overview.events,
            wonders: widget.overview.wonders,
            onYearChanged: _handleYearChanged,
          ),
        ),

        // Era text (Prehistory, Classical Era, etc).
        ValueListenableBuilder<int>(
          valueListenable: _year,
          builder: (_, value, _) => AnimatedEraText(value),
        ),
        // Wonderous's `Gap($styles.insets.xs)` (base 8) — AppSpacing.sm (8)
        // is the value-matching Plexaverse token.
        SizedBox(height: AppSpacing.sm.h),

        // Mini horizontal timeline, reacts to the state of the larger
        // scrolling timeline and changes its scroll position on drag.
        //
        // Wonderous's `CenteredBox(width: $styles.sizes.maxContentWidth1)`
        // (a raw `800`) forces an *exact* width, which can overflow on
        // narrow phone widths. Per the port manifest's CenteredBox
        // substitution, this is a `Center` + `ConstrainedBox(maxWidth:)`
        // clamp instead — a max, not a forced exact size.
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800.w),
            child: Padding(
              // Wonderous's `insets.lg` (base 32) — AppSpacing.xxl (32) is
              // the value-matching Plexaverse token.
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl.w),
              child: TimelineBottomScrubber(
                scroller: _scroller,
                size: _scrubberSize,
                timelineMinSize: _minSize,
                wonders: widget.overview.wonders,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.xxl.h),
      ],
    );
  }
}
