import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import 'contest_kit.dart';

/// The running page's sections, in page order.
enum ContestSection {
  path('Path', AppIcons.star, ContestColors.peri),
  leaderboard('Leaderboard', AppIcons.trophy, ContestColors.amber),
  quests('Quests', AppIcons.chest, ContestColors.amber),
  linkedIn('LinkedIn', AppIcons.linkedin, Color(0xFF3AA0FF));

  const ContestSection(this.label, this.icon, this.colour);

  final String label;
  final IconData icon;
  final Color colour;
}

/// Path · Leaderboard · Quests · LinkedIn — a small bar pinned over the
/// running page, each tab bringing its section to the top.
///
/// ## Why it is here
///
/// On a phone the web stacks the rail's cards under the path and reaches
/// them from a fixed bottom tab bar. The app's foot already holds the
/// shell's More and Write buttons, so the same four jumps sit at the top
/// instead. Its fifth tab, Profile, is not repeated: Settings is in More.
///
/// The highlight follows the last tap, as the web's does — it marks where
/// the learner asked to go, not where they have since scrolled.
class ContestSectionBar extends StatefulWidget {
  const ContestSectionBar({required this.onSelect, super.key});

  final ValueChanged<ContestSection> onSelect;

  @override
  State<ContestSectionBar> createState() => _ContestSectionBarState();
}

class _ContestSectionBarState extends State<ContestSectionBar> {
  ContestSection _on = ContestSection.path;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Contest sections',
      explicitChildNodes: true,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ZaveSpace.md,
          vertical: ZaveSpace.xs,
        ),
        decoration: const BoxDecoration(
          color: Color(0xEB050A24),
          border: Border(bottom: BorderSide(color: Color(0x1AFFFFFF))),
        ),
        child: Row(
          children: <Widget>[
            for (final ContestSection s in ContestSection.values)
              Expanded(
                child: _Tab(
                  section: s,
                  on: s == _on,
                  onTap: () {
                    setState(() => _on = s);
                    widget.onSelect(s);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.section, required this.on, required this.onTap});

  final ContestSection section;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const BorderRadius radius = BorderRadius.all(Radius.circular(14));
    return Semantics(
      button: true,
      selected: on,
      label: section.label,
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: Container(
              constraints: const BoxConstraints(
                minHeight: ZaveSpace.minTapTarget,
              ),
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: radius,
                color: on ? const Color(0x2E2F3AF7) : null,
                border: Border.all(
                  color: on ? const Color(0x997A84FF) : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(section.icon, size: 17, color: section.colour),
                  const SizedBox(height: 3),
                  Text(
                    section.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: on ? ZaveColors.white : ZaveColors.ink62,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
