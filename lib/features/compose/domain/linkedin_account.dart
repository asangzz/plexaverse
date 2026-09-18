import 'package:freezed_annotation/freezed_annotation.dart';

part 'linkedin_account.freezed.dart';
part 'linkedin_account.g.dart';

/// One connected LinkedIn account, as `GET /linkedin/accounts` returns it.
///
/// Transcribed from `LinkedinAccountSummary` in
/// `lib/services/linkedin-mobile.service.ts`. **Tokens are never on the wire**
/// — the server derives [needsReconnect] from them and returns only that, so
/// there is deliberately nothing here to leak.
///
/// [appType] is the load-bearing field on this screen. A company brand cannot
/// publish through a personal connection: publishing to a page needs a token
/// carrying `w_organization_social`, and only the row with `appType == 'company'`
/// has one. The web composer makes exactly this distinction
/// (`accounts.find(a => a.appType === 'company')`) and so does
/// [ComposeContextState.companyAccount].
@freezed
abstract class LinkedinAccount with _$LinkedinAccount {
  const LinkedinAccount._();

  const factory LinkedinAccount({
    required String id,
    @Default('') String profileId,
    @Default('') String profileName,
    String? profileHeadline,
    String? profileImage,
    String? profileSlug,
    @Default('personal') String appType,

    /// True when the access token has expired AND cannot be refreshed. The
    /// account is listed but cannot publish until the user re-authorises.
    @Default(false) bool needsReconnect,
  }) = _LinkedinAccount;

  factory LinkedinAccount.fromJson(Map<String, dynamic> json) =>
      _$LinkedinAccountFromJson(json);

  bool get isCompany => appType == 'company';

  /// Never empty — a row with no profile name would otherwise render a blank
  /// selector entry the user cannot tell apart from the next one.
  String get displayName =>
      profileName.trim().isEmpty ? 'LinkedIn account' : profileName.trim();

  /// The letter in the preview avatar, mirroring the web mock's single-initial
  /// treatment.
  String get initial => displayName[0].toUpperCase();
}
