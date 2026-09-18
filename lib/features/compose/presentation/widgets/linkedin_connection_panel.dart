import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/compose_context.dart';
import '../../domain/linkedin_account.dart';

/// "LinkedIn Account" / "Company Page" — where this post is going.
///
/// A port of the web composer's connection panel (recon §4.2.2). It is the
/// first thing on the screen for a reason: a user who writes a post and only
/// then discovers it has nowhere to go has wasted the whole session.
///
/// **Two deliberate departures from the web.**
///
/// 1. The web tints the 40×40 icon tile with LinkedIn blue (`#0077B5/20`) for a
///    personal connection and green for a company one. Zave's first rule is
///    that colour only ever names a status, and "which platform" is not a
///    status — so the tile is plain glass and the status lives where Zave puts
///    it: in a [ZaveDot] and the colour of the line beside it. Mint is
///    connected, amber is "needs your attention", ink-35 is inert.
/// 2. The web has no account picker here — it reads a selection made on the
///    accounts screen (`useLinkedinAccounts().selectedAccountId`). Mobile has
///    no such stored selection, so when more than one personal connection
///    exists this panel asks. With one account it shows no picker at all, which
///    is the common case and matches the web exactly.
class LinkedInConnectionPanel extends StatelessWidget {
  const LinkedInConnectionPanel({
    required this.state,
    required this.selectedAccountId,
    required this.onSelectAccount,
    this.onOpenSettings,
    super.key,
  });

  final ComposeContextState state;
  final String? selectedAccountId;
  final ValueChanged<String> onSelectAccount;

  /// Routes to the settings screen. Null hides the action and leaves only the
  /// instruction, which is the honest rendering until the shell wires the
  /// settings route.
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final bool isCompany = state.isCompanyBrand;
    final LinkedinAccount? active = state.activeAccount(selectedAccountId);
    final (Color, String) signal = _signal(isCompany, active);
    final List<LinkedinAccount> choices = state.selectableAccounts;

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: ZaveGlass.controlFill,
                  border: Border.all(color: ZaveGlass.controlBorder, width: 1),
                  borderRadius: ZaveRadius.inputBr,
                ),
                child: Icon(
                  isCompany ? Icons.business_outlined : Icons.person_outline,
                  size: 20,
                  color: ZaveColors.white,
                ),
              ),
              SizedBox(width: ZaveSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isCompany ? 'Company Page' : 'LinkedIn Account',
                      style: ZaveType.h3,
                    ),
                    SizedBox(height: ZaveSpace.xs),
                    Row(
                      children: <Widget>[
                        ZaveDot(signal.$1),
                        SizedBox(width: ZaveSpace.sm),
                        Expanded(
                          child: Text(
                            signal.$2,
                            style: ZaveType.caption.copyWith(color: signal.$1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (!state.canPublish && onOpenSettings != null) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            ZaveButton(
              label: 'Open settings',
              onPressed: onOpenSettings,
              icon: const Icon(Icons.settings_outlined),
            ),
          ],

          // One account is the common case and needs no picker — showing a
          // single chip that cannot be deselected would be a control that does
          // nothing.
          if (choices.length > 1) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            Text('PUBLISH AS', style: ZaveType.kicker),
            SizedBox(height: ZaveSpace.md),
            Wrap(
              spacing: ZaveSpace.sm,
              runSpacing: ZaveSpace.sm,
              children: <Widget>[
                for (final LinkedinAccount account in choices)
                  ZaveChip(
                    label: account.displayName,
                    selected: account.id == active?.id,
                    onTap: () => onSelectAccount(account.id),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// The status colour and the line beside it.
  ///
  /// The four states are the web's four, restated in Zave signals. Note the
  /// third one: a company brand with no company connection is the one case
  /// where the editor renders fully but cannot publish, and amber is exactly
  /// right for it — it is waiting on the user, not broken.
  (Color, String) _signal(bool isCompany, LinkedinAccount? active) {
    if (isCompany) {
      if (state.companyAccount == null) {
        return (
          ZaveColors.amber,
          'Connect a Company LinkedIn account in Settings to publish',
        );
      }
      return (ZaveColors.mint, 'Publishing to ${state.companyPageLabel}');
    }
    if (active == null) {
      return (ZaveColors.ink35, 'Not connected');
    }
    if (active.needsReconnect) {
      // Amber, not red: Zave has no red, and an expired token is a thing the
      // user can fix rather than a destructive state.
      return (
        ZaveColors.amber,
        'Reconnect ${active.displayName} — its access expired',
      );
    }
    return (ZaveColors.mint, 'Connected as ${active.displayName}');
  }
}
