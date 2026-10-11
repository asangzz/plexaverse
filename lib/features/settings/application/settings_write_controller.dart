import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/platform/image_picking.dart';
import '../../auth/application/google_link_controller.dart';
import '../../auth/domain/auth_repository.dart';
import '../../preferences/application/preferences_controller.dart';
import '../domain/settings_repository.dart';
import 'settings_controllers.dart';

part 'settings_write_controller.g.dart';

/// The keys [SettingsWriteController] raises while a write is open.
///
/// Named constants rather than inline strings because the key is the only
/// thing joining a button's disabled state to the operation that disabled it;
/// a typo would silently produce a button that never goes busy, which is the
/// failure this whole file exists to make impossible.
abstract final class SettingsWrite {
  static const String profile = 'profile';
  static const String brandType = 'brand_type';
  static const String missionTime = 'mission_time';
  static const String approvalChannel = 'approval_channel';
  static const String companyBrand = 'company_brand';
  static const String companyLogo = 'company_logo';
  static const String companyPage = 'company_page';
  static const String googleLink = 'google_link';

  /// Per-row, so connecting the personal account cannot grey out the company
  /// row's button. `'personal'` | `'company'`.
  static String linkedin(String type) => 'linkedin:$type';
}

/// Every write the Settings screen can start, and which of them are open.
///
/// ## Why the flags are here and not on the sections
///
/// Each of these used to be a `_saving` / `_busy` / `_connecting` field on the
/// widget that owned the button. ARCHITECTURE.md's rule — "if the widget were
/// disposed mid-operation, or a second screen asked the same question, would
/// the answer be wrong?" — answers yes for all of them: the PATCH keeps
/// running after a back-swipe, but the flag that said so died with the screen,
/// so a user who left and came back found a Save button that was enabled while
/// their previous save was still in flight.
///
/// ## Why one controller rather than one per section
///
/// [settings_controllers.dart] splits the READS deliberately — a combined
/// fetch makes Slack being down take the whole page with it. In-flight flags
/// have no such blast radius: there is nothing for them to fail at
/// independently. What they do need is to say WHICH operation is open, which
/// is why the state is a set of keys and not a single bool. A screen-wide
/// `_busy` is the defect behind "pausing one schedule greyed out every other
/// row", and collapsing these eight into one flag would reintroduce it here.
///
/// ## Why it is `autoDispose`
///
/// The flag is worth losing when the screen goes; the WORK is not, and it is
/// not lost — every method below delegates to a controller that outlives this
/// one ([PreferencesController] is held by the router's onboarding gate), so a
/// write that started keeps running and its result still lands. Only the
/// "is it open" answer goes, and by then nobody is asking. Each section
/// watches its own key, which is also what keeps this element alive for the
/// length of its own write.
@riverpod
class SettingsWriteController extends _$SettingsWriteController {
  @override
  Set<String> build() => const <String>{};

  /// Whether [key] is open. Call through `.select` so a section rebuilds for
  /// its own write and not for a sibling's.
  bool isBusy(String key) => state.contains(key);

  /// Profile Details.
  Future<String?> saveProfile({
    required String profession,
    required String headline,
  }) => _write(
    SettingsWrite.profile,
    () => ref
        .read(preferencesControllerProvider.notifier)
        .saveProfile(profession: profession, headline: headline),
    'Failed to update profile.',
  );

  /// Personal or company. Re-shapes the navigation and half the page, so a
  /// second screen very much does ask this question.
  Future<String?> saveBrandType(String brandType) => _write(
    SettingsWrite.brandType,
    () => ref
        .read(preferencesControllerProvider.notifier)
        .saveBrandType(brandType),
    'Failed to update profile.',
  );

  /// Mission Schedule — `HH:mm` in the user's own timezone.
  Future<String?> saveMissionTime(String preferredTime) => _write(
    SettingsWrite.missionTime,
    () => ref
        .read(preferencesControllerProvider.notifier)
        .saveMissionTime(preferredTime),
    'Failed to update profile.',
  );

  /// Where approval requests are delivered.
  Future<String?> saveApprovalChannel(String channel) => _write(
    SettingsWrite.approvalChannel,
    () => ref
        .read(preferencesControllerProvider.notifier)
        .saveApprovalChannel(channel),
    'Failed to update profile.',
  );

  /// Company Brand Details — the five fields every company post is written
  /// from, plus the poster style.
  Future<String?> saveCompanyBrand({
    required String companyIndustry,
    required String companyWebsite,
    required String companyTagline,
    required String companyDescription,
    required List<String> companyFeatures,
    required String posterTheme,
    String? posterPrimaryColor,
    String? posterSecondaryColor,
  }) => _write(
    SettingsWrite.companyBrand,
    () => ref
        .read(preferencesControllerProvider.notifier)
        .saveCompanyBrand(
          companyIndustry: companyIndustry,
          companyWebsite: companyWebsite,
          companyTagline: companyTagline,
          companyDescription: companyDescription,
          companyFeatures: companyFeatures,
          posterTheme: posterTheme,
          posterPrimaryColor: posterPrimaryColor,
          posterSecondaryColor: posterSecondaryColor,
        ),
    'Failed to save company brand details.',
  );

  /// Picks a logo, uploads it and saves the URL, as one operation. Returns the
  /// message to show, or null when the user simply closed the picker.
  ///
  /// The picked URL is deliberately NOT returned for the caller to hold.
  /// [PreferencesController.uploadCompanyLogo] saves it, which republishes the
  /// preferences row the section already renders from — a second copy on the
  /// widget would be the same fact in two places, and the widget's copy is the
  /// one that can be wrong.
  Future<String?> pickAndSaveCompanyLogo() =>
      _guard(SettingsWrite.companyLogo, () async {
        try {
          final ImagePickResult picked = await ref
              .read(imagePickingProvider)
              .pick(ImageSourceKind.gallery);
          switch (picked) {
            case PickedImage(:final String dataUri):
              await ref
                  .read(preferencesControllerProvider.notifier)
                  .uploadCompanyLogo(dataUri);
              return 'Logo saved.';
            // Closing the picker is a decision, and silent.
            case ImagePickCancelled():
              return null;
            case ImagePickFailure(:final String? message):
              return message ?? 'Could not open your photos.';
          }
        } on Object {
          return "That logo didn't upload. Try again.";
        }
      });

  /// The LinkedIn browser hand-off for [type] (`personal` | `company`).
  ///
  /// Returns the outcome rather than a message: a CANCELLED hand-off is
  /// silent, and only the caller knows which sentence a success deserves.
  Future<ConnectOutcome> connectLinkedin(String type) => _guard(
    SettingsWrite.linkedin(type),
    () => ref.read(linkedinAccountsControllerProvider.notifier).connect(type),
  );

  /// Saves the chosen company page. Returns the failure message, or null.
  Future<String?> chooseCompanyPage(String orgId) => _guard(
    SettingsWrite.companyPage,
    () => ref.read(companyPagesControllerProvider.notifier).choose(orgId),
  );

  /// Resolves a pasted company URL or numeric id. The answer lands on
  /// [CompanyPagesController]'s own state, which the picker already renders.
  Future<void> lookupCompanyPage(String vanityNameOrId) => _guard(
    SettingsWrite.companyPage,
    () => ref
        .read(companyPagesControllerProvider.notifier)
        .lookup(vanityNameOrId),
  );

  /// Links Google sign-in to this account.
  Future<GoogleLinkResult> linkGoogle() => _guard(
    SettingsWrite.googleLink,
    () => ref.read(googleLinkControllerProvider.notifier).link(),
  );

  Future<GoogleLinkResult> unlinkGoogle() => _guard(
    SettingsWrite.googleLink,
    () => ref.read(googleLinkControllerProvider.notifier).unlink(),
  );

  /// Runs [action] under [key] and turns a throw into [onFailure]. Returns
  /// null on success — the contract the rest of this slice uses, so the caller
  /// keeps its own success copy next to the control that earned it.
  Future<String?> _write(
    String key,
    Future<void> Function() action,
    String onFailure,
  ) => _guard(key, () async {
    try {
      await action();
      return null;
    } on Object {
      return onFailure;
    }
  });

  /// Raises [key] for the length of [action].
  Future<T> _guard<T>(String key, Future<T> Function() action) async {
    state = <String>{...state, key};
    try {
      return await action();
    } finally {
      // Leaving Settings mid-write disposes this provider, and writing `state`
      // on a disposed Ref throws out of the `finally` — which would replace
      // whatever the write actually returned with an unhandled error.
      if (ref.mounted) state = <String>{...state}..remove(key);
    }
  }
}
