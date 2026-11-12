/// The frame every LinkedIn task level shares — a port of the web's
/// `components/contest/tasks/TaskSheet.tsx`.
///
/// The contest's ground, the way back to the path, a kicker, the title, what
/// the level pays and a lead line. One frame, so the Saturday, Sunday and
/// post-link levels read as one product and do not drift a pixel apart —
/// the same reason the web gives its three sheets one `SheetShell`.
///
/// ## Why not `ZaveScaffold`
///
/// The contest is drawn on its own navy ground ([ContestGround]), not the
/// app's violet one, and a level's way home is the web's "Back to the
/// contest" link at the top of the sheet rather than a header's arrow. A
/// `ZaveScaffold` would paint the second ground under the first and add a
/// header with nothing to name.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/router/zave_routes.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../domain/contest_dates.dart';
import '../contest_kit.dart';

/// The sheet: the ground, [BackToPath], then [children] with the web's
/// `space-y-8` between them.
class ContestSheet extends StatelessWidget {
  const ContestSheet({required this.children, this.onRefresh, super.key});

  final List<Widget> children;

  /// Pull to refresh: re-read whatever the level is drawn from. Null for a
  /// sheet with nothing to re-read.
  final Future<void> Function()? onRefresh;

  /// The web's `max-w-[720px]`. A phone never reaches it; a tablet keeps a
  /// readable measure instead of a line the width of the screen.
  static const double _measure = 720;

  @override
  Widget build(BuildContext context) {
    final Widget list = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        final double side = math.max(
          ZaveSpace.gutter,
          (c.maxWidth - _measure) / 2,
        );
        // A column, not a lazy list: a sheet is a handful of sections, and
        // all of them built is what lets a field scroll itself into view
        // above the keyboard.
        return SingleChildScrollView(
          // Always scrollable, so pull to refresh works on a short sheet.
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            side,
            ZaveSpace.xxl,
            side,
            ZaveSpace.section,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Align(alignment: Alignment.centerLeft, child: BackToPath()),
              for (final Widget child in children) ...<Widget>[
                SizedBox(height: ZaveSpace.xxl),
                child,
              ],
            ],
          ),
        );
      },
    );
    final Future<void> Function()? refresh = onRefresh;
    return Scaffold(
      backgroundColor: ContestColors.groundFoot,
      body: ContestGround(
        child: SafeArea(
          child: refresh == null
              ? list
              : RefreshIndicator(
                  color: ZaveColors.white,
                  backgroundColor: ZaveColors.deep,
                  onRefresh: refresh,
                  child: list,
                ),
        ),
      ),
    );
  }
}

/// Kicker, title, what the level pays, and the lead. The web's
/// `SheetHeader`.
class ContestSheetHeader extends StatelessWidget {
  const ContestSheetHeader({
    required this.kicker,
    required this.title,
    this.points,
    this.lead,
    super.key,
  });

  final String kicker;
  final String title;

  /// What the level pays. Drawn only above zero: a level that pays nothing
  /// (Sunday's plan) says so by not showing a tag, never with "+0 XP".
  final int? points;
  final String? lead;

  @override
  Widget build(BuildContext context) {
    final int? p = points;
    final String? l = lead;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ContestKicker(kicker),
        SizedBox(height: ZaveSpace.md),
        Semantics(
          header: true,
          child: Text(title, style: ContestType.pageTitle),
        ),
        if (p != null && p > 0) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          XpTag(points: p),
        ],
        if (l != null) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Text(l, style: ContestType.lead),
        ],
      ],
    );
  }
}

/// The body of a sheet whose read has not answered yet: the shape of a
/// panel and its lines, under one sweep. The back link and the header are
/// already real above it — a slow open must never leave someone without a
/// way back. The web's `SheetSkeleton`, with its status label.
class ContestSheetSkeleton extends StatelessWidget {
  const ContestSheetSkeleton({this.label = 'Loading this week', super.key});

  /// What a screen reader hears while it loads.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      liveRegion: true,
      child: ExcludeSemantics(
        child: ZaveShimmer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ContestPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const ZaveSkeleton.bar(widthFactor: 0.45),
                    SizedBox(height: ZaveSpace.lg),
                    const ZaveSkeleton.bar(widthFactor: 1),
                    SizedBox(height: ZaveSpace.sm),
                    const ZaveSkeleton.bar(widthFactor: 0.8),
                    SizedBox(height: ZaveSpace.xl),
                    ZaveSkeleton.bar(width: 180.w, height: 48.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A link in a sentence: periwinkle, Zave's colour for links, with a full
/// tap target.
class SheetLink extends StatelessWidget {
  const SheetLink({
    required this.label,
    required this.onTap,
    this.icon,
    this.size = 15,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: ZaveRadius.pillBr,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: ZaveSpace.minTapTarget),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(
                  label,
                  style: ZaveType.body.copyWith(
                    fontSize: size.sp,
                    color: ContestColors.peri,
                  ),
                ),
              ),
              if (icon != null) ...<Widget>[
                SizedBox(width: ZaveSpace.sm),
                Icon(icon, size: size.sp, color: ContestColors.peri),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A refusal, in red, where the action was — with the way back to the path
/// when the refusal was the gate (409 LOCKED), whose cure is on the path.
class SheetAlert extends StatelessWidget {
  const SheetAlert({required this.message, this.backToPath = false, super.key});

  final String message;
  final bool backToPath;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message,
            style: ZaveType.body.copyWith(
              fontSize: 14.sp,
              color: ContestColors.wrongText,
            ),
          ),
          if (backToPath)
            SheetLink(
              label: 'Back to the path',
              size: 14,
              onTap: () => context.go(ZaveRoutes.contest),
            ),
        ],
      ),
    );
  }
}

/// "Wed 18 Nov" — a day key as the web's plan and claim sheets print it
/// (`toLocaleDateString` with `weekday: 'short'` on UTC), read as a calendar
/// date so no timezone moves it. Empty for anything that is not a day key.
String weekdayDate(String? key) {
  final DateTime? d = dayKeyDate(key);
  if (d == null) return '';
  // shortDate is "18 Nov 2026"; the sheets drop the year.
  final String date = shortDate(d);
  return '${kWeekdayShort[d.weekday % 7]} '
      '${date.substring(0, date.lastIndexOf(' '))}';
}
