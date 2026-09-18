import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/pricing.dart';

/// "Daily XP Budget" — how 11,000 XP maps to about 34 days of automation.
///
/// Static content on the web too; nothing here is fetched. The web lays the
/// four costs out as a 2x2 / 4-up grid of small cards and this does the same
/// with a [Wrap], so a narrow phone falls to a single column instead of
/// squeezing four columns into 320pt.
///
/// The web's per-item emoji are dropped: Zave names things in Manrope, and the
/// numbers are what this block is for.
class XpBudgetCard extends StatelessWidget {
  const XpBudgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('DAILY XP BUDGET', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          Text(
            'How 11,000 XP maps to ~34 days of full automation',
            style: ZaveType.bodyMuted,
          ),
          SizedBox(height: ZaveSpace.lg),
          ZavePill(
            label: '66-Day Roadmap is FREE',
            color: ZaveColors.peri,
            leading: const ZaveDot(ZaveColors.peri),
          ),
          SizedBox(height: ZaveSpace.xl),

          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // Two per row where there is room, one where there is not. The
              // web's four-across only ever happens at `sm:` and above.
              final double gap = ZaveSpace.md;
              final double width = constraints.maxWidth >= 320
                  ? (constraints.maxWidth - gap) / 2
                  : constraints.maxWidth;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: <Widget>[
                  for (final XpBudgetItem item in XpBudgetItem.all)
                    SizedBox(
                      width: width,
                      child: _BudgetTile(item: item),
                    ),
                ],
              );
            },
          ),

          SizedBox(height: ZaveSpace.xl),
          Container(height: 1, color: ZaveColors.rule),
          SizedBox(height: ZaveSpace.lg),

          _BudgetLine(
            label: 'Daily total',
            value: '~285–385 XP',
            valueColor: ZaveColors.white,
          ),
          SizedBox(height: ZaveSpace.sm),
          _BudgetLine(
            label: '11,000 XP ÷ 320 avg',
            value: '~34 days',
            valueColor: ZaveColors.mint,
          ),
          SizedBox(height: ZaveSpace.sm),
          _BudgetLine(
            label: 'Connect-LinkedIn bonus',
            value: '2,500 XP (~1 week free)',
            valueColor: ZaveColors.amber,
          ),
        ],
      ),
    );
  }
}

class _BudgetTile extends StatelessWidget {
  const _BudgetTile({required this.item});

  final XpBudgetItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ZaveSurface.row,
      padding: ZaveSpace.rowPad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(item.task.toUpperCase(), style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.xs),
          // Amber: XP is points, and points are amber everywhere in Zave.
          Text(
            '−${item.cost}',
            style: ZaveType.h3.copyWith(color: ZaveColors.amber),
          ),
          SizedBox(height: ZaveSpace.xs),
          Text(item.note, style: ZaveType.caption),
        ],
      ),
    );
  }
}

class _BudgetLine extends StatelessWidget {
  const _BudgetLine({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: Text(label, style: ZaveType.bodyMuted)),
        SizedBox(width: ZaveSpace.md),
        Text(
          value,
          style: ZaveType.label.copyWith(color: valueColor),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
