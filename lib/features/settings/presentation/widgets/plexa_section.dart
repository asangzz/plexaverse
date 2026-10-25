import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import 'settings_section.dart';

/// **Plexa** — the way into the Duolingo-style Plexaverse while it is being
/// built (`/plexa`, [ZaveRoutes.plexa]).
///
/// Shown to everyone. On the web the same screen is still admin-only in the
/// sidebar; the app opened it up first, deliberately, so it can be tried on
/// real accounts while the rest of the experience is built.
class PlexaSection extends StatelessWidget {
  const PlexaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Plexa',
      lead: 'The new Plexaverse, being built here first.',
      child: Semantics(
        button: true,
        child: ZavePress(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.push(ZaveRoutes.plexa),
            child: Row(
              children: <Widget>[
                Container(
                  height: ZaveSpace.minTapTarget,
                  width: ZaveSpace.minTapTarget,
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: ZaveGlass.controlFill,
                    border: Border.all(
                      color: ZaveGlass.controlBorder,
                      width: 1,
                    ),
                    borderRadius: ZaveRadius.inputBr,
                  ),
                  child: const Image(
                    image: AssetImage('assets/branding/logo_mark.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: ZaveSpace.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Meet Plexa',
                        style: ZaveType.label.copyWith(color: ZaveColors.white),
                      ),
                      SizedBox(height: ZaveSpace.xs),
                      Text(
                        'Open the new experience',
                        style: ZaveType.caption.copyWith(
                          color: ZaveColors.ink50,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  AppIcons.chevronRight,
                  color: ZaveColors.ink50,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
