import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/compose_context.dart';
import '../../domain/compose_draft.dart';
import '../../domain/linkedin_account.dart';
import 'compose_image_view.dart';

/// LinkedIn's own feed chrome.
///
/// **These are deliberately not Zave tokens, and they must not be replaced by
/// any.** Every other surface in this app is Plexaverse; this one is a
/// simulation of somebody else's product, and its whole job is to answer "what
/// will this look like on LinkedIn?". Mapping LinkedIn's feed grey to
/// [ZaveGlass.rest] or its body ink to [ZaveColors.ink85] would make the
/// preview look like Plexaverse — which is precisely the question it exists to
/// not answer.
///
/// Taken verbatim from the web composer's preview column, which uses the same
/// literals for the same reason. The Zave frame around it (the [ZaveCard] this
/// widget is placed in, its heading and its padding) is all tokens.
class _LinkedInChrome {
  const _LinkedInChrome._();

  /// The feed background the card floats on.
  static const Color stage = Color(0xFFF4F2EE);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE0DFDC);

  /// LinkedIn's body ink and its secondary text.
  static const Color ink = Color(0xFF191919);
  static const Color inkMuted = Color(0xFF666666);

  /// The brand blue used for the reaction pip and poll options.
  static const Color brand = Color(0xFF0A66C2);

  /// The personal avatar gradient.
  static const Color avatarFrom = Color(0xFF0077B5);
  static const Color avatarTo = Color(0xFF00A0DC);

  /// The company avatar gradient — green into LinkedIn blue, as the web mock
  /// distinguishes a page from a person.
  static const Color companyAvatarFrom = Color(0xFF00DC82);
  static const Color companyAvatarTo = Color(0xFF0077B5);

  /// The card's own corner. LinkedIn's, not Zave's — this is 8px because
  /// LinkedIn's feed card is 8px.
  static const double radius = 8;
}

/// The "LinkedIn Preview" — what the post will look like in the feed.
///
/// A faithful port of the web composer's preview column
/// (`components/automate/PostEditor.tsx`, §4.2.5 of the recon). The web shows
/// it side by side with the editor at `lg` and up and behind an Editor/Preview
/// toggle below that; a phone always gets the toggle, which is the web's own
/// mobile rendering rather than a mobile-specific invention.
///
/// Two details are hardcoded on the web and hardcoded here for the same reason:
/// the "247" reactions and "32 comments" are placeholders that make the card
/// read as a real feed post. They are not wired to anything and must not be —
/// showing a real number next to a post that does not exist yet would be a lie.
class LinkedInPreviewCard extends StatelessWidget {
  const LinkedInPreviewCard({
    required this.draft,
    required this.brandContext,
    super.key,
  });

  final ComposeDraft draft;

  /// Who is publishing. Null while the accounts call is still in flight — the
  /// preview then falls back to neutral placeholder copy rather than guessing
  /// a name, because a preview showing the wrong author is worse than one
  /// showing none.
  final ComposeContextState? brandContext;

  @override
  Widget build(BuildContext context) {
    final bool isCompany = brandContext?.isCompanyBrand ?? false;
    final LinkedinAccount? account = brandContext?.activeAccount(
      draft.accountId,
    );

    final String name = isCompany
        ? (brandContext?.companyPageLabel ?? 'Company Page')
        : (account?.displayName ?? 'Your name');
    final String headline = isCompany
        ? 'LinkedIn Company Page'
        : (account?.profileHeadline?.trim().isNotEmpty == true
              ? account!.profileHeadline!.trim()
              : 'Your professional headline');
    final String suffix = isCompany ? '• Company' : '• 1st';

    final DateTime? when = draft.scheduledFor;
    final String meta = when == null
        ? 'Just now'
        : 'Scheduled for ${_monthShort(when.month)} ${when.day}';

    return Container(
      color: _LinkedInChrome.stage,
      padding: EdgeInsets.all(ZaveSpace.lg),
      child: Container(
        decoration: BoxDecoration(
          color: _LinkedInChrome.card,
          border: Border.all(color: _LinkedInChrome.border, width: 1),
          borderRadius: BorderRadius.circular(_LinkedInChrome.radius),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _Header(
              name: name,
              suffix: suffix,
              headline: headline,
              meta: meta,
              isCompany: isCompany,
              initial: isCompany
                  ? (name.isEmpty ? 'C' : name[0].toUpperCase())
                  : (account?.initial ?? 'Y'),
            ),
            _Body(content: draft.content),
            if (draft.image?.hasPreview ?? false)
              ConstrainedBox(
                // The web caps the feed image at 512px tall.
                constraints: const BoxConstraints(maxHeight: 512),
                child: ComposeImageView(image: draft.image!),
              ),
            const _SocialBar(),
            const _ActionRow(),
          ],
        ),
      ),
    );
  }

  static String _monthShort(int month) => const <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][month - 1];
}

class _Header extends StatelessWidget {
  const _Header({
    required this.name,
    required this.suffix,
    required this.headline,
    required this.meta,
    required this.isCompany,
    required this.initial,
  });

  final String name;
  final String suffix;
  final String headline;
  final String meta;
  final bool isCompany;
  final String initial;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ZaveSpace.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isCompany
                    ? const <Color>[
                        _LinkedInChrome.companyAvatarFrom,
                        _LinkedInChrome.companyAvatarTo,
                      ]
                    : const <Color>[
                        _LinkedInChrome.avatarFrom,
                        _LinkedInChrome.avatarTo,
                      ],
              ),
              // A page is a rounded square, a person is a circle — LinkedIn's
              // own distinction, and the fastest way to tell the two previews
              // apart at a glance.
              shape: isCompany ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: isCompany
                  ? BorderRadius.circular(_LinkedInChrome.radius)
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(
                color: _LinkedInChrome.card,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(width: ZaveSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _LinkedInChrome.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      suffix,
                      style: const TextStyle(
                        color: _LinkedInChrome.inkMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  headline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _LinkedInChrome.inkMuted,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: <Widget>[
                    Text(
                      meta,
                      style: const TextStyle(
                        color: _LinkedInChrome.inkMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '•',
                      style: TextStyle(
                        color: _LinkedInChrome.inkMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.public,
                      size: 12,
                      color: _LinkedInChrome.inkMuted,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    final bool empty = content.trim().isEmpty;
    return Padding(
      padding: EdgeInsets.fromLTRB(ZaveSpace.lg, 0, ZaveSpace.lg, ZaveSpace.md),
      child: Text(
        empty ? 'Start typing to see your post preview here...' : content,
        style: TextStyle(
          color: empty ? _LinkedInChrome.inkMuted : _LinkedInChrome.ink,
          fontSize: 14,
          // LinkedIn's feed line-height, to the same three decimals the web
          // uses — it is what makes a long post occupy the right number of
          // lines in the preview.
          height: 1.428,
        ),
      ),
    );
  }
}

/// The reaction / comment count strip.
///
/// The counts are hardcoded placeholders on the web and stay hardcoded here.
/// See the class doc on [LinkedInPreviewCard].
class _SocialBar extends StatelessWidget {
  const _SocialBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ZaveSpace.lg,
        vertical: ZaveSpace.sm,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _LinkedInChrome.border, width: 1),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 16,
            width: 16,
            decoration: const BoxDecoration(
              color: _LinkedInChrome.brand,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.thumb_up,
              size: 9,
              color: _LinkedInChrome.card,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            '247',
            style: TextStyle(color: _LinkedInChrome.inkMuted, fontSize: 12),
          ),
          const Spacer(),
          const Text(
            '32 comments',
            style: TextStyle(color: _LinkedInChrome.inkMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Like / Comment. Inert on purpose — this is a picture of a post, not a post.
class _ActionRow extends StatelessWidget {
  const _ActionRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ZaveSpace.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const <Widget>[
          _Action(icon: Icons.thumb_up_outlined, label: 'Like'),
          _Action(icon: Icons.mode_comment_outlined, label: 'Comment'),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 20, color: _LinkedInChrome.inkMuted),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: _LinkedInChrome.inkMuted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
