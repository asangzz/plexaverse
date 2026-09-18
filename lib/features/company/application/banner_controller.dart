import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../preferences/domain/user_preferences.dart';
import '../../settings/application/settings_controllers.dart';
import '../../settings/domain/settings_entities.dart';
import '../data/company_repositories.dart';
import '../domain/banner_design.dart';
import '../domain/banner_template.dart';
import '../domain/company_repository.dart';

part 'banner_controller.freezed.dart';
part 'banner_controller.g.dart';

/// Where an "apply this banner" attempt is.
enum BannerApplyStatus {
  idle,

  /// The widget is rasterising the selected template.
  rendering,

  /// The PNG is on its way to LinkedIn.
  applying,

  /// LinkedIn accepted it and the company page now carries it.
  done,

  /// It did not land. [BannerState.error] says why.
  failed,
}

/// Everything the banner screen renders from.
@freezed
abstract class BannerState with _$BannerState {
  const BannerState._();

  const factory BannerState({
    @Default(<BannerTemplate>[]) List<BannerTemplate> templates,
    @Default(0) int index,

    /// The position line printed on the banner. Seeded from the user's
    /// headline, then owned by whatever they type.
    @Default('Position') String position,
    @Default('') String userName,

    /// The numeric Company Page id. Null when no page is linked — the banner
    /// can still be previewed, but it cannot be applied to anything.
    String? organizationId,
    @Default(BannerApplyStatus.idle) BannerApplyStatus status,
    String? error,

    /// The page URL the server reports after a successful apply.
    String? pageUrl,
  }) = _BannerState;

  BannerTemplate? get selected =>
      index >= 0 && index < templates.length ? templates[index] : null;

  bool get isBusy =>
      status == BannerApplyStatus.rendering ||
      status == BannerApplyStatus.applying;

  /// Applying needs a linked page AND a template with a design in it.
  bool get canApply =>
      !isBusy && organizationId != null && (selected?.isRenderable ?? false);

  /// The selected template, personalised and cropped.
  ///
  /// Recomputed on every read rather than cached: the position field edits as
  /// the user types, and a cache keyed on anything less than the whole
  /// (template, name, position) triple is a stale-banner bug waiting to ship.
  StudioDesignData? get preparedDesign {
    final BannerTemplate? t = selected;
    if (t?.data == null) return null;
    return prepareBanner(t!.data!, userName, position);
  }
}

/// The company banner screen.
///
/// **This screen departs from the web deliberately.** The web renders the
/// banner to a PNG, downloads it, and then walks the user through uploading it
/// by hand — because a browser page has no way to write a company page's cover
/// image. The mobile API does: `POST /linkedin/company-banner` performs the
/// register-upload / PUT / partial-update dance server-side. So this screen
/// APPLIES the banner instead of asking the user to go and do it, and keeps
/// the web's manual instructions only as the fallback for when it cannot.
@riverpod
class BannerController extends _$BannerController {
  @override
  Future<BannerState> build() async {
    final CompanyRepository repo = ref.watch(companyRepositoryProvider);
    final List<BannerTemplate> templates = await repo.fetchBannerTemplates();

    // The page id and the user's details all fail SOFT. None of them is worth
    // taking the screen down for: without the id the user still gets a
    // preview and an honest reason the apply button is off, and without the
    // profile the template simply keeps its placeholder text.
    String? organizationId;
    try {
      organizationId = await repo.fetchCompanyPageId();
    } on Object {
      organizationId = null;
    }

    String userName = '';
    try {
      final AccountSnapshot account = await ref.watch(
        accountSnapshotProvider.future,
      );
      userName = account.user.name;
    } on Object {
      userName = '';
    }

    String position = 'Position';
    try {
      final UserPreferences prefs = await ref.watch(
        preferencesControllerProvider.future,
      );
      // Headline first, profession second — the same order the web uses. A
      // headline is what the person calls themselves; a profession is what we
      // classified them as, and the banner should carry their own words.
      final String headline = prefs.headline?.trim() ?? '';
      final String profession = prefs.profession?.trim() ?? '';
      if (headline.isNotEmpty) {
        position = headline;
      } else if (profession.isNotEmpty) {
        position = profession;
      }
    } on Object {
      position = 'Position';
    }

    return BannerState(
      templates: templates,
      organizationId: organizationId,
      userName: userName,
      position: position,
    );
  }

  void selectTemplate(int index) {
    final BannerState? now = state.value;
    if (now == null || index == now.index) return;
    state = AsyncData<BannerState>(
      now.copyWith(
        index: index,
        // A new template starts a fresh attempt: leaving "done" on the screen
        // would claim the page carries a banner the user has not applied.
        status: BannerApplyStatus.idle,
        error: null,
        pageUrl: null,
      ),
    );
  }

  void setPosition(String position) {
    final BannerState? now = state.value;
    if (now == null) return;
    state = AsyncData<BannerState>(
      now.copyWith(
        position: position,
        status: BannerApplyStatus.idle,
        error: null,
      ),
    );
  }

  /// Marks the rasterise step, which happens in the widget layer because only
  /// a mounted `RepaintBoundary` can produce the image.
  void beginRender() {
    final BannerState? now = state.value;
    if (now == null) return;
    state = AsyncData<BannerState>(
      now.copyWith(status: BannerApplyStatus.rendering, error: null),
    );
  }

  /// Sends the rendered banner to LinkedIn.
  Future<void> apply({
    required String imageBase64,
    required int width,
    required int height,
  }) async {
    final BannerState? now = state.value;
    if (now == null) return;

    final String? orgId = now.organizationId;
    if (orgId == null) {
      state = AsyncData<BannerState>(
        now.copyWith(
          status: BannerApplyStatus.failed,
          error:
              'No Company Page is linked yet, so there is nothing to apply '
              'the banner to.',
        ),
      );
      return;
    }

    state = AsyncData<BannerState>(
      now.copyWith(status: BannerApplyStatus.applying, error: null),
    );

    try {
      final String pageUrl = await ref
          .read(companyRepositoryProvider)
          .applyCompanyBanner(
            organizationId: orgId,
            imageBase64: imageBase64,
            imageWidth: width,
            imageHeight: height,
          );
      final BannerState? after = state.value;
      if (after == null) return;
      state = AsyncData<BannerState>(
        after.copyWith(status: BannerApplyStatus.done, pageUrl: pageUrl),
      );
    } on Object catch (e) {
      final BannerState? after = state.value;
      if (after == null) return;
      state = AsyncData<BannerState>(
        after.copyWith(status: BannerApplyStatus.failed, error: _message(e)),
      );
    }
  }

  /// Reports a render that never produced an image, so the button does not
  /// sit spinning on a failure the user cannot see.
  void failRender() {
    final BannerState? now = state.value;
    if (now == null) return;
    state = AsyncData<BannerState>(
      now.copyWith(
        status: BannerApplyStatus.failed,
        error: 'Failed to render banner. Please try again.',
      ),
    );
  }

  static String _message(Object error) {
    if (error is CompanyUnavailable) {
      return error.message ?? 'LinkedIn refused the banner. Please try again.';
    }
    return 'Something went wrong applying the banner. Please try again.';
  }
}
