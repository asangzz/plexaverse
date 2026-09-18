import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// The chrome every Settings section shares: a heading, an optional lead, and
/// a glass panel.
///
/// The web renders each section as an `h2` (Manrope 800 / 24px) above a
/// `.zv-panel` (r22). Zave's phone scale has no 24px heading and no r22 card,
/// so this maps to the nearest tokens — [ZaveType.h3] (20px Manrope 800) and
/// [ZaveCardSize.medium] (r24) — rather than inventing a size. Sections are
/// separated by [SettingsSection.gap]; the web's figure is 34px and
/// [ZaveSpace.xxl] (32) is the nearest token.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.title,
    required this.child,
    this.lead,
    this.padded = true,
    super.key,
  });

  final String title;

  /// The sentence under the heading. Renders at [ZaveType.caption] — a lead at
  /// full [ZaveType.lead] size competes with the heading at phone width.
  final String? lead;

  final Widget child;

  /// False lets the section's content own its own padding — used where the
  /// panel holds full-bleed rows with dividers between them.
  final bool padded;

  /// The vertical gap between two sections. See the class doc for why it is 32
  /// and not the web's 34.
  static double get gap => ZaveSpace.xxl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: ZaveType.h3),
        if (lead != null) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Text(lead!, style: ZaveType.caption),
        ],
        SizedBox(height: ZaveSpace.md),
        ZaveCard(
          padding: padded ? null : EdgeInsets.zero,
          child: child,
        ),
      ],
    );
  }
}

/// Shows [text] as a snack bar.
///
/// The web keeps a single `message` state pinned inside the Profile Details
/// panel and every handler on the page writes to it, so a save at the bottom of
/// a 1700-line form reports itself at the top where nobody is looking. A phone
/// has a better answer, and it is the platform's: the toast comes to the user.
/// The strings are the web's, verbatim.
void showSettingsMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text, style: ZaveType.body)));
}

/// What a connection row is currently saying.
///
/// Three states, and the colour is the whole message — Zave's first rule is
/// that colour only ever names a status.
enum ConnectionStatus {
  /// Connected and able to publish.
  live,

  /// A row exists but its token is dead. **Amber, not red: Zave has no red.**
  /// The web paints this `orange-500`, which is the nearest thing its older
  /// palette had to the same meaning.
  attention,

  /// Nothing connected.
  absent,
}

extension ConnectionStatusX on ConnectionStatus {
  Color get color => switch (this) {
    ConnectionStatus.live => ZaveColors.green,
    // Zave has NO RED. A failed / expired / missed state is amber.
    ConnectionStatus.attention => ZaveColors.amber,
    ConnectionStatus.absent => ZaveColors.ink35,
  };
}

/// One integration row: a glass tile, a name, a line of status copy, and a
/// control.
///
/// **Deliberate departure from the web.** The web tints each tile with the
/// vendor's brand colour (`#0077B5/20` for LinkedIn, `#4A154B/20` for Slack,
/// `#4285F4/20` for Google). Zave forbids that outright — colour names a
/// status and nothing else — so every tile here is plain glass and the status
/// lives in the [ZaveDot] and the trailing control, which is where a user
/// looks for it anyway.
class ConnectionRow extends StatelessWidget {
  const ConnectionRow({
    required this.name,
    required this.status,
    required this.detail,
    required this.icon,
    this.badge,
    this.trailing,
    this.secondary,
    super.key,
  });

  final String name;
  final ConnectionStatus status;

  /// The sub-line. The web's exact strings per state — see each caller.
  final String detail;

  final IconData icon;

  /// `Personal` / `Company` on the LinkedIn rows, so a user who is mid-
  /// onboarding (and therefore sees both) can tell them apart.
  final String? badge;

  /// The primary control — Connect / Reconnect / a "Connected" pill.
  final Widget? trailing;

  /// A second control under the row, e.g. Disconnect.
  final Widget? secondary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: ZaveSpace.minTapTarget,
              width: ZaveSpace.minTapTarget,
              decoration: BoxDecoration(
                color: ZaveGlass.controlFill,
                border: Border.all(color: ZaveGlass.controlBorder, width: 1),
                // The web's tile is `rounded-xl` (12); r16 is the nearest token.
                borderRadius: ZaveRadius.inputBr,
              ),
              child: Icon(icon, color: ZaveColors.ink85, size: 20),
            ),
            SizedBox(width: ZaveSpace.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ZaveDot(status.color),
                      SizedBox(width: ZaveSpace.sm),
                      Flexible(
                        child: Text(
                          name,
                          style: ZaveType.label.copyWith(
                            color: ZaveColors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (badge != null) ...<Widget>[
                        SizedBox(width: ZaveSpace.sm),
                        Text(badge!.toUpperCase(), style: ZaveType.kicker),
                      ],
                    ],
                  ),
                  SizedBox(height: ZaveSpace.xs),
                  Text(
                    detail,
                    style: ZaveType.caption.copyWith(
                      color: status == ConnectionStatus.attention
                          ? ZaveColors.amber
                          : ZaveColors.ink50,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (trailing != null || secondary != null) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          // The controls wrap under the copy rather than sitting beside it.
          // The web does the same below `md` (its rows are `flex-wrap`), and a
          // phone is always below `md`.
          Wrap(
            spacing: ZaveSpace.sm,
            runSpacing: ZaveSpace.sm,
            children: <Widget>[?trailing, ?secondary],
          ),
        ],
      ],
    );
  }
}

/// A hairline between two rows inside one panel.
class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: ZaveSpace.lg),
    child: const Divider(color: ZaveColors.rule, height: 1, thickness: 1),
  );
}

/// Says, in as many words, that a control the web has is not wired here yet —
/// and why.
///
/// This exists because the alternative is worse. The previous version of this
/// app rendered every screen against an invented endpoint map: 85 of 88 routes
/// 404ed and every failure was swallowed, so the app looked online and was not.
/// A row that admits it cannot do something is the honest form of that state.
///
/// Amber, because Zave has no red and this is a "waiting on something" state.
class UnavailableNote extends StatelessWidget {
  const UnavailableNote({required this.message, this.title, super.key});

  /// Optional heading, when the note is the whole content of a panel.
  final String? title;

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          // Nudge the dot onto the first line's optical centre.
          padding: EdgeInsets.only(top: ZaveSpace.xs + 2),
          child: const ZaveDot(ZaveColors.amber),
        ),
        SizedBox(width: ZaveSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (title != null) ...<Widget>[
                Text(
                  title!,
                  style: ZaveType.label.copyWith(color: ZaveColors.white),
                ),
                SizedBox(height: ZaveSpace.xs),
              ],
              Text(message, style: ZaveType.caption),
            ],
          ),
        ),
      ],
    );
  }
}

/// The loading placeholder for one section.
///
/// A glass card at rest with two dim bars in it. No shimmer: Zave's motion rule
/// is "short and physical; nothing bounces", and a looping sweep on half the
/// screen is the opposite of that.
class SectionSkeleton extends StatelessWidget {
  const SectionSkeleton({this.lines = 2, super.key});

  final int lines;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < lines; i++) ...<Widget>[
            if (i > 0) SizedBox(height: ZaveSpace.md),
            Container(
              height: ZaveSpace.lg,
              // Each bar is a little shorter than the last, so the block reads
              // as text rather than as a table.
              width: double.infinity,
              margin: EdgeInsets.only(right: i * ZaveSpace.xxl),
              decoration: BoxDecoration(
                color: ZaveGlass.hover,
                borderRadius: ZaveRadius.pillBr,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The error state for one section, with its own retry.
///
/// Per-section rather than per-page on purpose: Slack being unreachable must
/// not take the profile form down with it.
class SectionError extends StatelessWidget {
  const SectionError({required this.onRetry, this.message, super.key});

  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              // Amber: Zave has no red.
              const ZaveDot(ZaveColors.amber),
              SizedBox(width: ZaveSpace.md),
              Expanded(
                child: Text(
                  message ?? "We couldn't load this.",
                  style: ZaveType.body,
                ),
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveButton(label: 'Try again', onPressed: onRetry),
        ],
      ),
    );
  }
}
