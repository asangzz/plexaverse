import 'package:flutter/material.dart';

import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../contest_kit.dart';

/// The frame a LinkedIn task level is drawn in: the contest's ground, a
/// column of blocks, the way back at the top. A port of the web's
/// `SheetShell` (`components/contest/tasks/TaskSheet.tsx`).
///
/// One frame for the comment level's quiet screens and the feed comments, so
/// they read as one product and do not drift a pixel apart.
class TaskSheet extends StatelessWidget {
  const TaskSheet({required this.children, this.gap = 24, super.key});

  /// The blocks, top to bottom. The [gap] goes between them.
  final List<Widget> children;

  /// The web's `space-y-6` (24) or `space-y-8` (32).
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ContestColors.groundTop,
      body: ContestGround(
        child: SafeArea(
          // A column, not a lazy list: a sheet is a few blocks long, and a
          // form scrolled out of a list's cache would lose what was typed.
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 64.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < children.length; i++) ...<Widget>[
                  if (i > 0) SizedBox(height: gap.h),
                  children[i],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A task level's kicker, title, what it pays, and its lead line. The web's
/// `SheetHeader`.
class TaskSheetHeader extends StatelessWidget {
  const TaskSheetHeader({
    required this.eyebrow,
    required this.title,
    this.points,
    this.lead,
    this.beside,
    super.key,
  });

  final String eyebrow;
  final String title;

  /// What the task pays. Shown only above zero: a sheet that pays nothing,
  /// or a removed day, names no figure.
  final int? points;
  final String? lead;

  /// Plexa, at the right of the kicker and title. The lead goes under the
  /// row at full width: beside her on a phone it would be a column a few
  /// words wide.
  final Widget? beside;

  @override
  Widget build(BuildContext context) {
    final int? pays = points;
    final Widget top = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ContestKicker(eyebrow),
        SizedBox(height: ZaveSpace.md),
        Semantics(
          header: true,
          child: Text(title, style: ContestType.pageTitle),
        ),
        if (pays != null && pays > 0) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          XpTag(points: pays),
        ],
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (beside case final Widget plexa)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(child: top),
              SizedBox(width: ZaveSpace.md),
              plexa,
            ],
          )
        else
          top,
        if (lead != null) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Text(lead!, style: ContestType.lead),
        ],
      ],
    );
  }
}

/// "Could not load …" — a read that failed, with its sentence and a way to
/// ask again. The web's error panel says "Refresh the page"; a phone has no
/// page to refresh, so it has the button instead.
class TaskLoadError extends StatelessWidget {
  const TaskLoadError({
    required this.title,
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: ContestPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ContestDot(tone: ContestTone.idle, label: title),
            SizedBox(height: ZaveSpace.sm),
            Text(message, style: ContestType.meta),
            SizedBox(height: ZaveSpace.lg),
            ContestGhostPill(label: 'Try again', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

/// The post the comment answers: its author and its first line. The web's
/// `PostCard`.
class CommentPostCard extends StatelessWidget {
  const CommentPostCard({
    required this.author,
    required this.firstLine,
    super.key,
  });

  final String author;
  final String firstLine;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'The post',
      container: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: const Color(0x08FFFFFF),
          border: Border.all(color: const Color(0x1AFFFFFF), width: 2),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              author,
              style: ZaveType.body.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0x99FFFFFF),
              ),
            ),
            SizedBox(height: ZaveSpace.sm),
            Text(
              firstLine,
              style: ZaveType.body.copyWith(
                fontSize: 15.sp,
                height: 1.6,
                color: const Color(0xFFD4D8EA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
