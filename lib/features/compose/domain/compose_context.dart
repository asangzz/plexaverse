import 'package:freezed_annotation/freezed_annotation.dart';

import '../../preferences/domain/user_preferences.dart';
import 'linkedin_account.dart';

part 'compose_context.freezed.dart';

/// The server-owned half of the composer: who the user is publishing as.
///
/// The web reads this from two hooks side by side (`useUserPreferences` +
/// `useLinkedinAccounts`) and derives the same four things from them on every
/// render. Deriving them once, here, is what stops the screen from disagreeing
/// with itself — the connection panel, the preview avatar and the submit
/// guard all have to reach the same answer about which account is publishing,
/// and on the web they each recompute it.
@freezed
abstract class ComposeContextState with _$ComposeContextState {
  const ComposeContextState._();

  const factory ComposeContextState({
    @Default(UserPreferences.empty) UserPreferences preferences,
    @Default(<LinkedinAccount>[]) List<LinkedinAccount> accounts,
  }) = _ComposeContextState;

  /// True when this user runs a company brand AND has a page id saved.
  ///
  /// Both halves matter, and the web checks both
  /// (`brandType === 'company' && !!companyPageId`): a user who switched brand
  /// but never finished the page setup would otherwise get the company editor
  /// with nothing to publish to.
  bool get isCompanyBrand =>
      preferences.isCompany && (preferences.companyPageId?.isNotEmpty ?? false);

  String? get companyPageId => preferences.companyPageId;

  String get companyPageLabel =>
      preferences.companyPageName?.trim().isNotEmpty == true
      ? preferences.companyPageName!.trim()
      : 'Company Page ${preferences.companyPageId ?? ''}'.trim();

  /// The connection that carries `w_organization_social`. Null means the user
  /// has chosen a company brand but has not connected a Company LinkedIn app —
  /// the one state in which the editor renders but cannot publish.
  LinkedinAccount? get companyAccount {
    for (final LinkedinAccount a in accounts) {
      if (a.isCompany) return a;
    }
    return null;
  }

  /// The first personal connection, which is what the web falls back to
  /// (`accounts.find(a => a.id === selectedAccountId) ?? accounts[0]`). Mobile
  /// has no "selected account" preference to read, so the fallback IS the
  /// selection until the user picks another in the selector.
  LinkedinAccount? get personalAccount {
    for (final LinkedinAccount a in accounts) {
      if (!a.isCompany) return a;
    }
    return accounts.isEmpty ? null : accounts.first;
  }

  /// The account a post saved right now would publish through.
  ///
  /// In company mode the personal selection is ignored outright — that is the
  /// web's rule, and it is not a convenience: publishing a company post
  /// through a personal token produces a post on the wrong profile.
  LinkedinAccount? activeAccount(String? selectedId) {
    if (isCompanyBrand) return companyAccount;
    if (selectedId != null) {
      for (final LinkedinAccount a in accounts) {
        if (a.id == selectedId) return a;
      }
    }
    return personalAccount;
  }

  /// The accounts the selector offers. Company mode has exactly one valid
  /// answer, so the selector collapses to it rather than offering a choice
  /// that would publish to the wrong place.
  List<LinkedinAccount> get selectableAccounts => isCompanyBrand
      ? <LinkedinAccount>[?companyAccount]
      : accounts.where((LinkedinAccount a) => !a.isCompany).toList();

  bool get isConnected => accounts.isNotEmpty;

  /// Whether a publish/approval submission can go out at all.
  bool get canPublish => isCompanyBrand ? companyAccount != null : isConnected;
}
