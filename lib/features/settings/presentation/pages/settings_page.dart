import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../preferences/domain/user_preferences.dart';
import '../../application/settings_controllers.dart';
import '../widgets/account_section.dart';
import '../widgets/approval_channel_section.dart';
import '../widgets/billing_section.dart';
import '../widgets/cadence_section.dart';
import '../widgets/company_brand_section.dart';
import '../widgets/connections_section.dart';
import '../widgets/profile_section.dart';
import '../widgets/settings_section.dart';
import '../widgets/subjects_section.dart';
import '../../../preferences/application/preferences_controller.dart';

/// **Settings** — the web's `/settings`.
///
/// One column of sections, in the web's own order: who you are, what you
/// publish as, what you are connected to, when it goes out, what you pay, and
/// the way out.
///
/// ## What this replaced
///
/// The previous Flutter Settings screen rendered a bundled fixture
/// (`assets/mock/settings/profile.json`) behind a "Digital Twin" quota bar and
/// an Account page cloned verbatim from another product. None of it touched the
/// Plexaverse API and none of it corresponded to anything on the web. Every
/// control below either writes to a route that exists or says, in the UI, that
/// it cannot — see [UnavailableNote].
///
/// ## Why the page-level state is only preferences
///
/// Preferences decide what the page even *contains* (a company brand hides the
/// personal LinkedIn row and reveals the brand-details form), so the page waits
/// on that one read and nothing else. Every other section owns its own loading,
/// error and retry, so Slack being unreachable cannot take the profile form
/// down with it — the same split the web gets from one React Query hook per
/// resource.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserPreferences> preferences = ref.watch(
      preferencesControllerProvider,
    );

    return ZaveScaffold(
      // The large title lives in the bar now. It used to open the scroll view,
      // which left the header holding nothing but a back arrow.
      largeTitle: 'Settings',
      subtitle: 'Manage integrations and preferences',
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref
            ..invalidate(preferencesControllerProvider)
            ..invalidate(accountSnapshotProvider)
            ..invalidate(xpSummaryProvider)
            ..invalidate(linkedinAccountsControllerProvider)
            ..invalidate(slackControllerProvider)
            ..invalidate(calendarControllerProvider)
            ..invalidate(geoPricingProvider);
          await ref.read(preferencesControllerProvider.future);
        },
        child: ZaveScrollView(
          children: <Widget>[
            const _SettingsHeader(),
            SizedBox(height: ZaveSpace.xl),
            switch (preferences) {
              AsyncError<UserPreferences>() => SectionError(
                message: "We couldn't load your settings.",
                onRetry: () => ref.invalidate(preferencesControllerProvider),
              ),
              AsyncData<UserPreferences>(:final UserPreferences value) =>
                _SettingsBody(preferences: value),
              _ => const _SettingsSkeleton(),
            },
          ],
        ),
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody({required this.preferences});

  final UserPreferences preferences;

  @override
  Widget build(BuildContext context) {
    final double gap = SettingsSection.gap;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ProfileSection(preferences: preferences),
        SizedBox(height: gap),
        BrandTypeSection(preferences: preferences),
        SizedBox(height: gap),
        ConnectionsSection(brandType: preferences.brandType),
        // Company-brand identity renders only for a company brand, exactly as
        // the web gates sections 3c–3f on `brandType === 'company'`.
        if (preferences.isCompany) ...<Widget>[
          SizedBox(height: gap),
          CompanyBrandSection(preferences: preferences),
        ],
        SizedBox(height: gap),
        ApprovalChannelSection(preferences: preferences),
        SizedBox(height: gap),
        AutoPostSection(preferences: preferences),
        SizedBox(height: gap),
        CadenceSection(preferences: preferences),
        SizedBox(height: gap),
        // Next to the cadence, because both answer "what does my day look
        // like" rather than "who am I" — and because a user who has just set
        // their posting days is one tap from the only other thing that shapes
        // the daily work.
        SubjectsSection(preferences: preferences),
        SizedBox(height: gap),
        const NotificationsSection(),
        SizedBox(height: gap),
        BillingSection(preferences: preferences),
        SizedBox(height: gap),
        const DataPrivacySection(),
        SizedBox(height: gap),
        const AccountSection(),
      ],
    );
  }
}

/// The first-paint state: section headings with a glass card under each, so the
/// page has its real shape before the data lands and nothing jumps when it
/// does.
class _SettingsSkeleton extends StatelessWidget {
  const _SettingsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < 4; i++) ...<Widget>[
          if (i > 0) SizedBox(height: SettingsSection.gap),
          const SectionSkeleton(lines: 3),
        ],
      ],
    );
  }
}
