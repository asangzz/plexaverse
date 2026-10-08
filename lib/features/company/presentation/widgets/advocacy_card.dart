import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/advocacy_post.dart';
import 'company_formats.dart';

/// One post on the advocacy feed.
///
/// The web card carries a purple avatar chip, a hover lift, a sweeping sheen
/// across the button and a shadow-2xl. None of that is ported: Zave has no
/// hover on touch, depth is a fill step rather than a shadow, and the sheen is
/// a pointer-only affordance. What survives is the structure — who posted it,
/// what it says, how it performed, and the one action.
class AdvocacyCard extends StatelessWidget {
  const AdvocacyCard({
    required this.post,
    required this.resharing,
    required this.reshared,
    required this.onReshare,
    super.key,
  });

  final AdvocacyPost post;
  final bool resharing;
  final bool reshared;
  final VoidCallback onReshare;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _Avatar(post: post),
              SizedBox(width: ZaveSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post.companyName.toUpperCase(),
                      style: ZaveType.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: ZaveSpace.xs),
                    Text('FEATURED CONTENT', style: ZaveType.kicker),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.lg),
          Text(
            post.content,
            style: ZaveType.bodyMuted,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ZaveSpace.lg),
          Container(height: 1, color: ZaveColors.rule),
          SizedBox(height: ZaveSpace.lg),
          // Wrap, not Row with a Spacer. Two stats and the badge are wider
          // than a narrow phone leaves, and a Spacer shrinks to nothing long
          // before the things either side of it do. Wrapping drops the badge
          // to its own line instead of overflowing by 87px.
          Wrap(
            spacing: ZaveSpace.xl,
            runSpacing: ZaveSpace.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              _Stat(label: 'Reach', value: post.reach),
              _Stat(label: 'Inquiries', value: post.inquiries),
              // Green is "done / live" in this palette, and a featured post IS
              // live on the page. The web's pulsing dot is dropped — nothing
              // in Zave loops.
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ZaveDot(ZaveColors.green),
                  SizedBox(width: ZaveSpace.sm),
                  Text(
                    'Hot Topic',
                    style: ZaveType.caption.copyWith(color: ZaveColors.green),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.lg),
          if (!post.canReshare)
            // A stub advocacy row has no LinkedIn URN yet, so there is nothing
            // to reshare. Saying so beats a button that always 400s.
            Text(
              'This post has not reached LinkedIn yet, so it cannot be '
              'amplified.',
              style: ZaveType.caption,
            )
          else
            ZaveButton(
              label: reshared ? 'Successfully Shared' : 'Reshare & Earn 50 XP',
              kind: reshared
                  ? ZaveButtonKind.ghost
                  : ZaveButtonKind.primarySmall,
              busy: resharing,
              expand: true,
              onPressed: reshared || resharing ? null : onReshare,
            ),
        ],
      ),
    );
  }
}

/// The company's avatar, or its initials on a glass square.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.post});

  final AdvocacyPost post;

  @override
  Widget build(BuildContext context) {
    final String? image = post.account?.profileImage;
    final double size = ZaveSpace.iconBtn;

    return ClipRRect(
      borderRadius: BorderRadius.circular(ZaveRadius.input),
      child: SizedBox(
        height: size,
        width: size,
        child: image == null || image.isEmpty
            ? _initials(size)
            : CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: (BuildContext _, String _) => _initials(size),
                errorWidget: (BuildContext _, String _, Object _) =>
                    _initials(size),
              ),
      ),
    );
  }

  Widget _initials(double size) => DecoratedBox(
    decoration: const BoxDecoration(color: ZaveGlass.controlFill),
    child: Center(
      child: Text(
        // The web prints a literal 'CO' when there is no image. The company's
        // own initial is at least true of this company.
        post.companyName.trim().isEmpty
            ? 'CO'
            : post.companyName.trim()[0].toUpperCase(),
        style: ZaveType.label,
      ),
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(companyNumber.format(value), style: ZaveType.label),
      SizedBox(height: ZaveSpace.xs),
      Text(label.toUpperCase(), style: ZaveType.kicker),
    ],
  );
}
