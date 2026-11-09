import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/allowance.dart';

/// "What every plan includes" — one row per AI feature, with its allowance.
///
/// Replaced the "Daily XP Budget" card when wallet XP was retired. The rows
/// come from `GET /user/allowances`, the same table the server's gates count
/// against, so this cannot promise more than the product allows. When that
/// read fails the static defaults stand in, and the "left today" line is
/// dropped because the fallback knows nothing about this user.
class AllowancesCard extends StatelessWidget {
  const AllowancesCard({required this.table, super.key});

  final AllowanceTable table;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('WHAT EVERY PLAN INCLUDES', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          // India time for everyone: the server counts on IST so a user
          // cannot reset their own limits by changing their timezone.
          Text(
            'Daily allowances reset at midnight India time (IST). Monthly ones '
            'reset on the 1st.',
            style: ZaveType.bodyMuted,
          ),
          SizedBox(height: ZaveSpace.lg),
          for (int i = 0; i < table.rows.length; i++) ...<Widget>[
            if (i > 0) Container(height: 1, color: ZaveColors.rule),
            _AllowanceRow(allowance: table.rows[i], showRemaining: table.live),
          ],
        ],
      ),
    );
  }
}

class _AllowanceRow extends StatelessWidget {
  const _AllowanceRow({required this.allowance, required this.showRemaining});

  final Allowance allowance;
  final bool showRemaining;

  @override
  Widget build(BuildContext context) {
    final String? left = showRemaining ? allowance.remainingLabel : null;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ZaveSpace.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: Text(allowance.label, style: ZaveType.label)),
          SizedBox(width: ZaveSpace.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                allowance.amountLabel,
                style: ZaveType.label.copyWith(color: ZaveColors.white),
              ),
              if (left != null) ...<Widget>[
                SizedBox(height: ZaveSpace.xs),
                Text(left, style: ZaveType.caption),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
