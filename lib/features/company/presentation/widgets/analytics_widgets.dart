import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/company_post.dart';
import 'company_formats.dart';

/// One headline metric.
///
/// The web gives each of the three tiles its own accent — indigo, green,
/// purple — plus a matching corner glow. **None of that is ported.** Zave's
/// first rule is that colour only ever names a status, and "followers" is not
/// a status; three differently-tinted cards would be the single loudest
/// violation on the screen. The badge, the label and the number are the web's
/// exactly; the tint is a fill step instead, which is to say none.
class CompanyStatTile extends StatelessWidget {
  const CompanyStatTile({
    required this.badge,
    required this.label,
    required this.value,
    super.key,
  });

  /// 'Audience' / 'Traffic' / 'Mobile'.
  final String badge;

  /// 'Total Followers' / 'Page Views (All Time)' / 'Mobile Views'.
  final String label;

  final int value;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(label.toUpperCase(), style: ZaveType.kicker),
              ),
              SizedBox(width: ZaveSpace.md),
              ZavePill(label: badge, color: ZaveColors.ink62),
            ],
          ),
          SizedBox(height: ZaveSpace.lg),
          Text(
            companyNumber.format(value),
            style: ZaveType.h2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// A labelled proportional bar — one row of the company-size or
/// page-destination breakdown.
///
/// The web fills the company-size bars with an indigo→green gradient and the
/// destination bars with flat white-30%. The gradient is decoration, so it
/// goes; both fills are white here, which is Zave's one emphasis, on a rest
/// track. The two cards are told apart by their headings, which is how the
/// rest of this system tells things apart.
class CompanyProportionBar extends StatelessWidget {
  const CompanyProportionBar({
    required this.label,
    required this.value,
    required this.fraction,
    super.key,
  });

  final String label;
  final int value;

  /// 0..1. The caller applies the web's floor (5% for company size, 2% for
  /// destinations) so a non-zero row is always visible as a sliver rather than
  /// as nothing.
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final double clamped = fraction.isFinite ? fraction.clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: EdgeInsets.only(bottom: ZaveSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style: ZaveType.label.copyWith(color: ZaveColors.ink62),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: ZaveSpace.md),
              Text(companyNumber.format(value), style: ZaveType.label),
            ],
          ),
          SizedBox(height: ZaveSpace.sm),
          ClipRRect(
            borderRadius: ZaveRadius.pillBr,
            child: SizedBox(
              height: ZaveSpace.sm,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  const ColoredBox(color: ZaveGlass.rest),
                  // The web animates the fill from 0 over a full second. Zave's
                  // motion is 150–200ms and does not draw attention to itself,
                  // so the growth is kept but shortened to the token.
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: clamped),
                    duration: ZaveMotion.fast,
                    curve: ZaveMotion.curve,
                    builder: (BuildContext context, double t, Widget? _) =>
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: t,
                          child: const ColoredBox(color: ZaveColors.white),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One post in the "Recent Post Performance" grid.
///
/// The web's four stat columns are icon-only, which on a phone reads as four
/// unlabelled numbers. They are labelled here — the icons carried no meaning a
/// first-time reader could recover, and the row is the only place these
/// numbers appear.
class CompanyPostPerformanceCard extends StatelessWidget {
  const CompanyPostPerformanceCard({required this.post, super.key});

  final CompanyPostItem post;

  @override
  Widget build(BuildContext context) {
    final DateTime? published = post.publishedOn;

    return ZaveCard(
      size: ZaveCardSize.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                published == null
                    ? 'UNDATED'
                    : companyShortDate.format(published).toUpperCase(),
                style: ZaveType.kicker,
              ),
              const Spacer(),
              Text(
                '${post.stats.engagementRate.toStringAsFixed(2)}% ER',
                style: ZaveType.caption.copyWith(color: ZaveColors.mint),
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            post.text,
            style: ZaveType.bodyMuted,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ZaveSpace.lg),
          Container(height: 1, color: ZaveColors.rule),
          SizedBox(height: ZaveSpace.lg),
          // Two rows of two, not the web's four columns. Four tracked
          // uppercase labels do not fit a 360px phone without ellipsising all
          // of them, and an ellipsised label is no better than the web's
          // unlabelled icon.
          Row(
            children: <Widget>[
              _Metric(label: 'Impressions', value: post.stats.impressionCount),
              _Metric(label: 'Reactions', value: post.stats.likeCount),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Row(
            children: <Widget>[
              _Metric(label: 'Comments', value: post.stats.commentCount),
              _Metric(label: 'Shares', value: post.stats.shareCount),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          companyNumber.format(value),
          style: ZaveType.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: ZaveSpace.xs),
        Text(
          label.toUpperCase(),
          style: ZaveType.kicker,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
