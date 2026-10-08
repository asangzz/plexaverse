import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../preferences/domain/user_preferences.dart';
import '../../application/settings_controllers.dart';
import '../widgets/connections_section.dart';
import '../widgets/settings_section.dart';
import '../../../preferences/application/preferences_controller.dart';

/// **Accounts** — the web's `/accounts`.
///
/// ## Why this is the Settings connections block and not a second design
///
/// On the web, `/accounts` and the Connected Accounts block of `/settings` show
/// the same connections in two different visual languages: `/settings` is Zave
/// (glass panels, Manrope headings), `/accounts` is the older system
/// (`#111111` cards, Urbanist headings, solid indigo avatars). `/accounts` is
/// also a strict SUBSET — it renders only `linkedinAccounts[0]`, so it has no
/// personal-vs-company split and no company-page linking, and it drops Google
/// Calendar entirely.
///
/// Porting both looks would ship the divergence into a product that is supposed
/// to read as one thing, and porting the subset would mean a company-brand user
/// opening Accounts and not seeing their company connection. So this route
/// renders the superset, in Zave. It is the one deliberate structural departure
/// on this screen.
///
/// The route is kept rather than dropped because it is admin-visible navigation
/// on the web and a deep link (`/accounts`) that must resolve to the same place
/// on both platforms.
class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserPreferences> preferences = ref.watch(
      preferencesControllerProvider,
    );

    return ZaveScaffold(
      largeTitle: 'Accounts',
      subtitle: 'Manage your connected accounts',
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref
            ..invalidate(linkedinAccountsControllerProvider)
            ..invalidate(slackControllerProvider)
            ..invalidate(calendarControllerProvider);
          await ref.read(linkedinAccountsControllerProvider.future);
        },
        child: ZaveScrollView(
          children: <Widget>[
            // The brand type only decides which LinkedIn rows show. While it is
            // still loading it is passed as null, which is the web's own "show
            // both, badged" state — not a guess.
            ConnectionsSection(brandType: preferences.value?.brandType),

            SizedBox(height: SettingsSection.gap),
            ZaveCard(
              child: Text(
                'Linked the wrong account? Disconnect it in the web app, then '
                'connect again here. If LinkedIn signs you in automatically, '
                'sign out of LinkedIn first so you can choose a different '
                'account.',
                style: ZaveType.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
