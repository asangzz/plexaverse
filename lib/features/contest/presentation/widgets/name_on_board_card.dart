import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../settings/application/settings_controllers.dart';
import '../../../settings/domain/settings_repository.dart';
import '../../application/name_on_board_controllers.dart';
import '../../domain/levels_words.dart';
import 'contest_kit.dart';

/// "Show my name to other learners" — the `contest_leaderboard` consent,
/// asked in context on the levels page. The web's `NameOnBoardCard`.
///
/// ## Why it is here
///
/// It used to be a box on the join card. There is no join card any more:
/// every learner is entered automatically and anonymously (no consent is
/// recorded for them), and is shown to the others as "Learner". This switch
/// is how a learner chooses to be named instead. Settings → Your data lists
/// the same purpose.
///
/// ## It reflects the server's record, so it starts off
///
/// For anyone who has not switched it on, it is off (DPDP s6: a pre-ticked
/// box is not an affirmative act). A stale yes — taken under a superseded
/// notice — is not a yes: shown off, asked again. Switching it on is the yes,
/// recorded `in_context`; switching it off is the whole withdrawal, one tap.
/// Nothing at all while the ledger loads or could not be read.
class NameOnBoardCard extends ConsumerWidget {
  const NameOnBoardCard({this.padding = EdgeInsets.zero, super.key});

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ConsentLedger? ledger = ref.watch(consentControllerProvider).value;
    if (ledger == null) return const SizedBox.shrink();
    ConsentPurposeState? row;
    for (final ConsentPurposeState p in ledger.purposes) {
      if (p.purpose == kNameTogglePurpose) row = p;
    }
    // A server that does not list the purpose: nothing to switch.
    if (row == null) return const SizedBox.shrink();
    final bool on = row.granted && !row.stale;
    final NameOnBoardSave save = ref.watch(nameOnBoardActionsProvider);
    final String? error = save.error;

    return Padding(
      padding: padding,
      child: ContestPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        kNameToggleLabel,
                        style: ZaveType.body.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: ZaveSpace.xs),
                      Text(
                        kNameToggleDetail,
                        style: ContestType.meta.copyWith(height: 1.6),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ZaveSpace.md),
                ZaveSwitch(
                  value: on,
                  semanticLabel: kNameToggleLabel,
                  onChanged: save.saving
                      ? null
                      : (bool next) => ref
                            .read(nameOnBoardActionsProvider.notifier)
                            .set(on: next),
                ),
              ],
            ),
            if (error != null) ...<Widget>[
              SizedBox(height: ZaveSpace.sm),
              Semantics(
                liveRegion: true,
                child: Text(error, style: ContestType.meta),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
