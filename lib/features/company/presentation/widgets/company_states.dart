import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/company_repository.dart';

/// The one skeleton block every company screen builds its loading state from.
///
/// A plain rest-fill card at the height of the thing it stands in for. There
/// is no shimmer: Zave's motion rule is "short and physical, nothing bounces",
/// and a looping gradient sweep across six cards is neither.
class CompanySkeleton extends StatelessWidget {
  const CompanySkeleton({required this.height, super.key});

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: DecoratedBox(decoration: ZaveSurface.card),
  );
}

/// A column of [CompanySkeleton]s at one height.
class CompanySkeletonList extends StatelessWidget {
  const CompanySkeletonList({
    required this.count,
    required this.height,
    super.key,
  });

  final int count;
  final double height;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      for (int i = 0; i < count; i++) ...<Widget>[
        CompanySkeleton(height: height),
        if (i != count - 1) SizedBox(height: ZaveSpace.md),
      ],
    ],
  );
}

/// The card every company screen shows when it cannot render.
///
/// It says WHICH precondition is missing, because the two that matter are
/// different problems with different fixes: "you have not connected a company
/// LinkedIn account" is a trip to Settings, "you have not chosen which Company
/// Page" is a trip to the company compose screen's one-time setup. The web
/// collapses both into "Access Restricted" plus whatever sentence the server
/// happened to send, and then greps that sentence for the word "linked" to
/// decide which button to show.
///
/// Amber throughout, including the dot: Zave has no red, and none of these is
/// a destructive state — they are all "needs attention".
class CompanyUnavailableCard extends StatelessWidget {
  const CompanyUnavailableCard({
    required this.failure,
    this.onRetry,
    this.onOpenSettings,
    super.key,
  });

  final CompanyUnavailable failure;

  /// Offered for [CompanyPrecondition.upstreamRefused] only — retrying a
  /// missing connection cannot fix it, and a Try-again button that never works
  /// is worse than no button.
  final VoidCallback? onRetry;

  /// Where the user goes to connect the account or link the page.
  final VoidCallback? onOpenSettings;

  String get _headline => switch (failure.reason) {
    CompanyPrecondition.noCompanyAccount => 'No company LinkedIn connected',
    CompanyPrecondition.pageUnlinked => 'No Company Page linked',
    CompanyPrecondition.noPersonalAccount => 'No personal LinkedIn connected',
    CompanyPrecondition.upstreamRefused => 'LinkedIn did not answer',
  };

  String get _explanation => switch (failure.reason) {
    CompanyPrecondition.noCompanyAccount =>
      'Company analytics, the inbox and advocacy all read from a connected '
          'company LinkedIn account. Connect one in Settings to switch them on.',
    CompanyPrecondition.pageUnlinked =>
      'Your company account is connected, but no Company Page is chosen yet. '
          'Pick the page once and everything here starts reporting on it.',
    CompanyPrecondition.noPersonalAccount =>
      'Resharing publishes to your own feed, which is a different connection '
          'from the company one. Connect your personal profile to amplify.',
    CompanyPrecondition.upstreamRefused =>
      'LinkedIn refused the request. This is usually temporary.',
  };

  bool get _canRetry =>
      failure.reason == CompanyPrecondition.upstreamRefused && onRetry != null;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              // Amber, not red: Zave has no red, and a missing connection is
              // "waiting on you", not a failure.
              const ZaveDot(ZaveColors.amber),
              SizedBox(width: ZaveSpace.sm),
              Text('NEEDS ATTENTION', style: ZaveType.kicker),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(_headline, style: ZaveType.h3),
          SizedBox(height: ZaveSpace.md),
          Text(_explanation, style: ZaveType.bodyMuted),
          if (failure.message != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            // The server's own sentence, kept verbatim — it is more specific
            // than anything written here can be.
            Text(failure.message!, style: ZaveType.caption),
          ],
          if (_canRetry || onOpenSettings != null) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            Row(
              children: <Widget>[
                if (_canRetry)
                  ZaveButton(label: 'Try again', onPressed: onRetry),
                if (_canRetry && onOpenSettings != null)
                  SizedBox(width: ZaveSpace.md),
                if (onOpenSettings != null)
                  ZaveButton(
                    label: 'Open settings',
                    kind: ZaveButtonKind.primarySmall,
                    onPressed: onOpenSettings,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// The generic "this did not load" card, for a failure that is not a company
/// precondition.
class CompanyErrorCard extends StatelessWidget {
  const CompanyErrorCard({
    required this.title,
    required this.onRetry,
    super.key,
  });

  final String title;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const ZaveDot(ZaveColors.amber),
            SizedBox(width: ZaveSpace.sm),
            Text('COULD NOT LOAD', style: ZaveType.kicker),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        Text(title, style: ZaveType.h3),
        SizedBox(height: ZaveSpace.lg),
        ZaveButton(label: 'Try again', onPressed: onRetry),
      ],
    ),
  );
}

/// An empty state: a headline, a sentence, and at most one action.
class CompanyEmptyCard extends StatelessWidget {
  const CompanyEmptyCard({
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            // Inert, not waiting: nothing is wrong, there is simply nothing
            // here yet.
            const ZaveDot(ZaveColors.ink35),
            SizedBox(width: ZaveSpace.sm),
            Text('NOTHING HERE YET', style: ZaveType.kicker),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        Text(title, style: ZaveType.h3),
        SizedBox(height: ZaveSpace.md),
        Text(body, style: ZaveType.bodyMuted),
        if (actionLabel != null && onAction != null) ...<Widget>[
          SizedBox(height: ZaveSpace.lg),
          ZaveButton(
            label: actionLabel!,
            kind: ZaveButtonKind.primarySmall,
            onPressed: onAction,
          ),
        ],
      ],
    ),
  );
}
