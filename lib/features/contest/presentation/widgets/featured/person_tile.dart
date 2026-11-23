import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/ui/app_icons.dart';
import '../../../../../core/ui/widgets/open_link.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/contest_words.dart';
import '../../../domain/linkedin_profile_url.dart';
import '../contest_kit.dart';

/// One featured person: photo, name, headline, and "View on LinkedIn". The
/// web's `PersonTile`.
///
/// ## The link is re-checked here
///
/// The server sends only `https://www.linkedin.com/in/<slug>` links, and this
/// still runs each through [profileHref] before it can be opened: a link on
/// someone else's card is the one place a bad row would do harm, so it is
/// checked at the last step too. It is handed to the OS, which opens it in
/// LinkedIn's app where there is one — never fetched by this app.
///
/// ## No figure, ever
///
/// No XP and, for the week's learners, no place: the tile has no slot for
/// either. The Hall of Fame passes [rank] for a winner who also agreed to
/// the leaderboard, and null for one who did not.
class PersonTile extends ConsumerWidget {
  const PersonTile({required this.person, this.rank, super.key});

  final FeaturedPerson person;

  /// The place a Hall of Fame winner finished in. Never given for the week's
  /// learners.
  final int? rank;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String name = person.name.trim().isEmpty
        ? 'A Plexaverse learner'
        : person.name.trim();
    final String? headline = person.headline?.trim();
    final String? href = profileHref(person.linkedinUrl);
    final int? place = rank;
    return ContestTile(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Avatar(name: name, image: person.image),
          SizedBox(width: ZaveSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (place != null) ...<Widget>[
                  Semantics(
                    label: 'Place ${formatCount(place)}',
                    excludeSemantics: true,
                    child: Text(
                      '#${formatCount(place)}',
                      style: GoogleFonts.manrope(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: ContestColors.peri,
                        fontFeatures: const <FontFeature>[
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ZaveType.body.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: ZaveColors.ink85,
                  ),
                ),
                if (headline != null && headline.isNotEmpty) ...<Widget>[
                  SizedBox(height: 2.h),
                  Text(
                    headline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ZaveType.body.copyWith(
                      fontSize: 14.sp,
                      height: 1.5,
                      color: ZaveColors.ink62,
                    ),
                  ),
                ],
                if (href != null) _ProfileLink(name: name, href: href),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The photo, round — or the name's first letter where there is none, or
/// where it is not https.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, required this.image});

  final String name;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final String? src = image;
    final double size = 48.r;
    final BoxDecoration ring = BoxDecoration(
      shape: BoxShape.circle,
      color: ZaveGlass.rest,
      border: Border.all(color: ZaveGlass.restBorder),
    );
    if (src != null && src.startsWith('https://')) {
      return ExcludeSemantics(
        child: Container(
          width: size,
          height: size,
          clipBehavior: Clip.antiAlias,
          decoration: ring,
          child: ZaveImage(source: src, tone: ZaveImageTone.quiet),
        ),
      );
    }
    final String initial = name.characters.first.toUpperCase();
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: ring,
        child: Text(
          initial,
          style: GoogleFonts.manrope(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: ZaveColors.ink85,
          ),
        ),
      ),
    );
  }
}

/// "View on LinkedIn" — the checked profile link, handed to the OS.
class _ProfileLink extends ConsumerWidget {
  const _ProfileLink({required this.name, required this.href});

  final String name;
  final String href;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      link: true,
      label: 'View $name on LinkedIn',
      excludeSemantics: true,
      child: InkWell(
        onTap: () => openLinkAndReport(context, ref, href),
        borderRadius: ZaveRadius.pillBr,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: ZaveSpace.minTapTarget),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(
                  'View on LinkedIn',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ZaveType.body.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ContestColors.peri,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                AppIcons.openExternal,
                size: 13.sp,
                color: ContestColors.peri,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
