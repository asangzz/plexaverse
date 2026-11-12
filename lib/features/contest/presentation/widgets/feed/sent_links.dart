import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/platform/link_opening.dart';
import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../domain/contest_links.dart';
import '../../../domain/contest_words.dart';
import '../contest_kit.dart';

/// Today's comment links, numbered, each with what it paid. The web's
/// `LinkList`.
///
/// A link opens only if it is one the server's own rule accepts — a comment
/// on linkedin.com or an lnkd.in short link. The server stores nothing else,
/// but a row this app is handed to the OS on a tap gets the same check as a
/// link it sends.
class SentLinks extends ConsumerWidget {
  const SentLinks({
    required this.links,
    this.points,
    this.label = 'Your comment links',
    super.key,
  });

  final List<String> links;

  /// What each link paid; null on a day sent five-at-once, where the links
  /// were paid as one and a "+0 XP" beside each would be false.
  final List<int>? points;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      label: label,
      container: true,
      child: Column(
        children: <Widget>[
          for (int i = 0; i < links.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: ZaveSpace.sm),
            _Row(
              n: i + 1,
              link: links[i],
              paid: points != null && i < points!.length ? points![i] : 0,
              onOpen: isLinkedInCommentUrl(links[i])
                  ? () => ref.read(linkOpeningProvider).open(links[i])
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.n,
    required this.link,
    required this.paid,
    required this.onOpen,
  });

  final int n;
  final String link;
  final int paid;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: onOpen != null,
      label: 'Comment $n: $link${paid > 0 ? ', ${contestXp(paid)}' : ''}',
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0x08FFFFFF),
              border: Border.all(color: const Color(0x0FFFFFFF)),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 24.r,
                  height: 24.r,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0x14FFFFFF),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$n',
                    style: GoogleFonts.manrope(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xB3FFFFFF),
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: ZaveSpace.md),
                Expanded(
                  child: Text(
                    link,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ZaveType.body.copyWith(
                      fontSize: 14.sp,
                      color: ContestColors.peri,
                    ),
                  ),
                ),
                if (paid > 0) ...<Widget>[
                  SizedBox(width: ZaveSpace.md),
                  Text(
                    contestXp(paid),
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: ContestColors.amber,
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
