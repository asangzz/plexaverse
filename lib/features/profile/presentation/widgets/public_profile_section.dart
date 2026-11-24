import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../contest/domain/shoutout_words.dart'
    show kAdultDeclarationLabel;
import '../../../settings/presentation/widgets/settings_section.dart';
import '../../application/profile_controllers.dart';
import '../../domain/profile_handle.dart';
import '../../domain/public_profile_words.dart';

/// **Public profile** — the handle, the `public_profile` consent in its
/// exact words, "View my page", and the ATS CV (owner, 24 Nov 2026). The
/// web's `PublicProfilePanel`.
///
/// ## The box starts where the server is
///
/// The consent's box is drawn from the server's record — off for anyone who
/// has not published (DPDP s6: never pre-ticked) — and ticking it is not yet
/// a yes: Save is. Un-ticking and saving is the whole withdrawal: the page
/// goes offline at once, the handle is freed and its follows are deleted.
///
/// ## The handle
///
/// Checked here with the shape rule as it is typed, then — once typing
/// pauses — by the server, which also knows the reserved words and who holds
/// a handle. The suggestion from the person's name is only ever pre-filled;
/// nothing is published without the tick.
///
/// ## The CV
///
/// Made by the server from what is on record, on request, never stored; the
/// app hands it to the share sheet to save or send. It works without a
/// public page.
class PublicProfileSection extends ConsumerStatefulWidget {
  const PublicProfileSection({super.key});

  @override
  ConsumerState<PublicProfileSection> createState() =>
      _PublicProfileSectionState();
}

class _PublicProfileSectionState extends ConsumerState<PublicProfileSection> {
  final TextEditingController _handle = TextEditingController();

  /// The box: the server's record until the person touches it.
  bool? _agreed;

  /// "I am 18 or older" — asked only while none is on record.
  bool _adult = false;

  /// The handle the availability check was last asked about — set once
  /// typing pauses.
  String _settled = '';
  Timer? _debounce;

  /// What the form was last filled from — the server's RECORD, not the
  /// object that carried it — so a change on the server (a save, a withdrawal
  /// from Your data) refills it, and a re-read that changed nothing does not.
  /// A refused Save re-reads the settings (PublicProfileActions); comparing
  /// the objects re-seeded on that re-read, wiping the handle the person typed
  /// and unticking the box under the refusal that was about them (review of
  /// 24 Nov 2026).
  (String?, bool, bool)? _seededFrom;

  @override
  void dispose() {
    _debounce?.cancel();
    _handle.dispose();
    super.dispose();
  }

  void _seed(PublicProfileSettings data) {
    final (String?, bool, bool) record = (
      data.handle,
      data.published,
      data.adultDeclared,
    );
    if (_seededFrom == record) return;
    _seededFrom = record;
    _handle.text = data.handle ?? data.suggestedHandle ?? '';
    _settled = normaliseHandle(_handle.text);
    _agreed = null;
    _adult = false;
  }

  void _onHandleChanged(String _) {
    ref.read(publicProfileActionsProvider.notifier).reset();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => _settled = normaliseHandle(_handle.text));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<PublicProfileSettings> settings = ref.watch(
      publicProfileSettingsControllerProvider,
    );
    return SettingsSection(
      title: 'Public profile',
      lead:
          'Your page at plexaverse.com/<handle>, and a CV that applicant '
          'tracking systems can read.',
      child: switch (settings) {
        AsyncData<PublicProfileSettings>(:final PublicProfileSettings value) =>
          _body(value),
        AsyncError<PublicProfileSettings>() => SectionError(
          message: 'Could not load your public profile.',
          onRetry: () =>
              ref.invalidate(publicProfileSettingsControllerProvider),
        ),
        _ => const SectionSkeleton(lines: 3),
      },
    );
  }

  Widget _body(PublicProfileSettings data) {
    _seed(data);
    final PublicProfileSave save = ref.watch(publicProfileActionsProvider);
    final String typed = normaliseHandle(_handle.text);
    final HandleCheck local = checkHandle(typed);
    final bool onRecord = typed == (data.handle ?? '');
    final bool needsCheck = local is HandleOk && _settled == typed && !onRecord;
    final AsyncValue<HandleAvailability>? availability = needsCheck
        ? ref.watch(handleAvailabilityProvider(typed))
        : null;
    final HandleAvailability? checked = availability?.value;

    final String? handleProblem = typed.isEmpty
        ? null
        : switch (local) {
            HandleProblem(:final String message) => message,
            HandleOk() when checked != null && !checked.available =>
              checked.message ?? 'That handle is taken. Try another.',
            _ => null,
          };
    final bool handleOk =
        local is HandleOk &&
        (onRecord || (needsCheck && checked?.available == true));
    final String handleLine =
        handleProblem ??
        (handleOk && !onRecord
            ? '$kPublicProfileHost$typed is free.'
            : (needsCheck && availability?.isLoading == true)
            ? 'Checking…'
            : kHandleHint);

    final bool agreed = _agreed ?? data.published;
    final bool needAdult = !data.adultDeclared || save.adultRequired;
    final bool changed =
        agreed != data.published || (agreed && typed != (data.handle ?? ''));
    final bool canSave =
        !save.saving &&
        changed &&
        (!agreed || (handleOk && (!needAdult || _adult)));

    Future<void> onSave() async {
      final PublicProfileActions actions = ref.read(
        publicProfileActionsProvider.notifier,
      );
      if (agreed) {
        await actions.publish(handle: typed, adult: needAdult && _adult);
      } else {
        await actions.unpublish();
      }
    }

    final String? published = data.published ? data.handle : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ZaveField(
          controller: _handle,
          label: 'Your handle',
          prefix: Text(kPublicProfileHost, style: ZaveType.caption),
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.done,
          enabled: !save.saving,
          onChanged: _onHandleChanged,
          error: handleProblem,
          helper: handleProblem == null ? handleLine : null,
        ),
        SizedBox(height: ZaveSpace.lg),
        _Choice(
          value: agreed,
          title: kPublicProfileToggleLabel,
          body: kPublicProfileConsentText,
          onChanged: save.saving
              ? null
              : (bool next) {
                  ref.read(publicProfileActionsProvider.notifier).reset();
                  setState(() => _agreed = next);
                },
        ),
        if (agreed && needAdult) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          _Choice(
            value: _adult,
            title: kAdultDeclarationLabel,
            onChanged: save.saving
                ? null
                : (bool next) => setState(() => _adult = next),
          ),
        ],
        SizedBox(height: ZaveSpace.md),
        Text(kPublicProfileAutomaticLine, style: ZaveType.caption),
        SizedBox(height: ZaveSpace.sm),
        Text(kPublicProfileWithdrawLine, style: ZaveType.caption),
        SizedBox(height: ZaveSpace.lg),
        Wrap(
          spacing: ZaveSpace.md,
          runSpacing: ZaveSpace.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            ZaveButton(
              label: save.saving ? 'Saving…' : 'Save',
              busy: save.saving,
              onPressed: canSave ? onSave : null,
            ),
            if (published != null)
              ZaveButton(
                label: 'View my page',
                icon: const Icon(AppIcons.openExternal),
                onPressed: () => openLinkAndReport(
                  context,
                  ref,
                  publicProfileUrl(published),
                ),
              ),
          ],
        ),
        if (save.saved case final String said) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Semantics(liveRegion: true, child: Text(said, style: ZaveType.body)),
        ],
        if (save.error case final String said) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Semantics(
            liveRegion: true,
            child: Text(
              said,
              style: ZaveType.caption.copyWith(color: ZaveColors.amber),
            ),
          ),
        ],
        const SettingsDivider(),
        _CvBlock(ready: data.cvReady),
      ],
    );
  }
}

/// "Your CV": what it holds, and the download — or why there is none.
class _CvBlock extends ConsumerWidget {
  const _CvBlock({required this.ready});

  final bool ready;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CvDownload cv = ref.watch(cvDownloadActionsProvider);
    final String? error = cv.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Your CV',
          style: ZaveType.body.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: ZaveSpace.xs),
        Text(kCvDownloadLine, style: ZaveType.caption),
        SizedBox(height: ZaveSpace.md),
        if (ready)
          ZaveButton(
            label: 'Download ATS CV',
            icon: const Icon(AppIcons.download),
            busy: cv.busy,
            onPressed: cv.busy
                ? null
                : ref.read(cvDownloadActionsProvider.notifier).download,
          )
        else
          Text(kCvEmptyAppMessage, style: ZaveType.body),
        if (error != null) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Semantics(
            liveRegion: true,
            child: Text(
              error,
              style: ZaveType.caption.copyWith(color: ZaveColors.amber),
            ),
          ),
        ],
      ],
    );
  }
}

/// One choice and its switch: its name, the words agreed to under it.
class _Choice extends StatelessWidget {
  const _Choice({
    required this.value,
    required this.title,
    required this.onChanged,
    this.body,
  });

  final bool value;
  final String title;
  final String? body;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final String? b = body;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: ZaveType.body),
              if (b != null) ...<Widget>[
                SizedBox(height: ZaveSpace.xs),
                Text(b, style: ZaveType.caption),
              ],
            ],
          ),
        ),
        SizedBox(width: ZaveSpace.lg),
        ZaveSwitch(value: value, semanticLabel: title, onChanged: onChanged),
      ],
    );
  }
}
