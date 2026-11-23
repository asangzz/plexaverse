import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/links/plexaverse.dart';
import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/ui/app_icons.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../application/contest_controllers.dart';
import '../../../application/shoutout_controllers.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/linkedin_profile_url.dart';
import '../../../domain/shoutout_words.dart';
import '../contest_kit.dart';
import '../web_link.dart';

/// "Feature me if I make it" — the `contest_shoutout` consent, asked in
/// context on the contest page. The web's `ShoutoutCard`.
///
/// ## The box starts empty, and ticking it is not yet a yes
///
/// It is drawn from the server's record, so for anyone who has not agreed it
/// is un-ticked (DPDP s6: a pre-ticked box is not an affirmative act).
/// Ticking it opens the one thing the yes needs — the public LinkedIn
/// profile link, pre-filled with the one on record to confirm — and the yes
/// is the "Feature me" press that sends it. The words agreed to are the
/// web's, verbatim ([kShoutoutConsentText]), the same ones Settings lists.
///
/// ## Un-ticking is the whole withdrawal
///
/// One tap, no form, no confirmation: withdrawing has to be as easy as
/// agreeing. The server hides the learner on its next read and erases the
/// link.
///
/// The link is checked here with the server's own rule
/// ([isLinkedInProfileUrl]), so a wrong paste is flagged in its field before
/// anything is sent.
///
/// ## 18 or older
///
/// Being featured shows a person to every learner, and the app's own sign-up
/// and join never ask for the 18+ declaration — so this card does: with no
/// declaration on record (`adultDeclared` false, or an ADULT_REQUIRED
/// refusal) it shows an un-ticked "I am 18 or older" box beside the link, and
/// sends it with the yes. Nothing is sent until it is ticked.
///
/// ## Featured with no link
///
/// A consent can be on with no link on record (an older path granted it
/// without one). The card then asks for the link straight away instead of
/// saying "You're in" over a "View on LinkedIn" that will never show.
class ShoutoutCard extends ConsumerStatefulWidget {
  const ShoutoutCard({this.padding = EdgeInsets.zero, super.key});

  /// Around the card when it draws — nothing while the choice is loading or
  /// could not be read, as on the web.
  final EdgeInsetsGeometry padding;

  @override
  ConsumerState<ShoutoutCard> createState() => _ShoutoutCardState();
}

class _ShoutoutCardState extends ConsumerState<ShoutoutCard> {
  final TextEditingController _link = TextEditingController();

  /// The box was ticked and the link field is open — not yet a yes.
  bool _open = false;

  /// "Feature me" was pressed: the field is judged only from then on.
  bool _tried = false;

  /// "I am 18 or older" — un-ticked until the learner ticks it.
  bool _adultTick = false;

  @override
  void dispose() {
    _link.dispose();
    super.dispose();
  }

  void _toggle(bool next, ShoutoutSettings settings) {
    final ContestShoutoutActions actions = ref.read(
      contestShoutoutActionsProvider.notifier,
    );
    actions.reset();
    if (next) {
      setState(() {
        _open = true;
        _tried = false;
        _link.text = settings.linkedinUrl ?? '';
      });
      return;
    }
    setState(() {
      _open = false;
      _tried = false;
      _adultTick = false;
      _link.clear();
    });
    if (settings.featured) unawaited(actions.save(featured: false));
  }

  Future<void> _submit({required bool needAdult}) async {
    setState(() => _tried = true);
    if (!isLinkedInProfileUrl(_link.text)) return;
    if (needAdult && !_adultTick) return;
    final bool saved = await ref
        .read(contestShoutoutActionsProvider.notifier)
        .save(
          featured: true,
          linkedinUrl: _link.text.trim(),
          adult: needAdult,
        );
    if (!saved || !mounted) return;
    setState(() {
      _open = false;
      _tried = false;
      _adultTick = false;
      _link.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ShoutoutSettings? settings = ref.watch(contestShoutoutProvider).value;
    if (settings == null) return const SizedBox.shrink();
    final ShoutoutSave save = ref.watch(contestShoutoutActionsProvider);
    final bool featured = settings.featured;
    final String? onRecord = profileHref(settings.linkedinUrl);
    // On, but with no link to show: ask for it now.
    final bool missingLink = featured && onRecord == null;
    final bool asking = (_open && !featured) || missingLink;
    final bool needAdult = !settings.adultDeclared || save.adultRequired;
    final String? fieldProblem = _tried && !isLinkedInProfileUrl(_link.text)
        ? kShoutoutBadLink
        : (asking && save.badLink ? save.error : null);
    final String? adultProblem = _tried && needAdult && !_adultTick
        ? kShoutoutNeedsAdult
        : (asking && save.adultRequired ? save.error : null);
    final String? serverProblem =
        (save.badLink || save.adultRequired) && asking ? null : save.error;

    return Padding(
      padding: widget.padding,
      child: ContestPanel(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Semantics(
              header: true,
              child: Text(
                'The prize is a shoutout',
                style: ContestType.cardTitle,
              ),
            ),
            SizedBox(height: ZaveSpace.xs),
            Text(
              'The contest’s winners and each week’s top learners can be '
              'featured to every Plexaverse learner — only if they agree.',
              style: ContestType.meta.copyWith(height: 1.6),
            ),
            SizedBox(height: ZaveSpace.lg),
            _ConsentBox(
              checked: featured || _open,
              onChanged: save.saving
                  ? null
                  : (bool next) => _toggle(next, settings),
            ),
            if (asking) ...<Widget>[
              if (missingLink) ...<Widget>[
                SizedBox(height: ZaveSpace.lg),
                Text(
                  'You agreed to be featured, but we have no profile link for '
                  'you yet. Add it so others can find you.',
                  style: ContestType.meta.copyWith(height: 1.6),
                ),
              ],
              SizedBox(height: ZaveSpace.lg),
              Text(
                'Your public LinkedIn profile link',
                style: ZaveType.body.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: ZaveColors.ink85,
                ),
              ),
              SizedBox(height: ZaveSpace.sm),
              _ProfileField(
                controller: _link,
                problem: fieldProblem,
                enabled: !save.saving,
                onChanged: (_) {
                  ref.read(contestShoutoutActionsProvider.notifier).reset();
                  // Re-judged as it changes once "Feature me" was pressed:
                  // the line must not keep naming a problem just fixed.
                  if (_tried) setState(() {});
                },
                onSubmitted: (_) => _submit(needAdult: needAdult),
              ),
              if (needAdult) ...<Widget>[
                SizedBox(height: ZaveSpace.md),
                _ConsentBox(
                  checked: _adultTick,
                  title: kAdultDeclarationLabel,
                  body: kAdultDeclarationReason,
                  label: '$kAdultDeclarationLabel $kAdultDeclarationReason',
                  onChanged: save.saving
                      ? null
                      : (bool next) => setState(() => _adultTick = next),
                ),
                if (adultProblem != null) ...<Widget>[
                  SizedBox(height: 6.h),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      adultProblem,
                      style: ContestType.meta.copyWith(
                        fontSize: 13.sp,
                        color: ContestColors.wrongText,
                      ),
                    ),
                  ),
                ],
              ],
              SizedBox(height: ZaveSpace.lg),
              Wrap(
                spacing: ZaveSpace.md,
                runSpacing: ZaveSpace.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  ContestGhostPill(
                    label: save.saving
                        ? 'Saving…'
                        : (missingLink ? 'Add my link' : 'Feature me'),
                    onPressed: save.saving
                        ? null
                        : () => _submit(needAdult: needAdult),
                  ),
                  if (!missingLink)
                    ContestTextLink(
                      label: 'Not now',
                      fontSize: 15,
                      onTap: save.saving
                          ? null
                          : () => _toggle(false, settings),
                    ),
                ],
              ),
            ],
            if (featured && !missingLink) ...<Widget>[
              SizedBox(height: ZaveSpace.lg),
              const ContestDot(
                tone: ContestTone.live,
                label: 'You’re in if you make it',
              ),
              if (onRecord != null)
                ContestWebLink(
                  before: 'Your link: ',
                  label: onRecord.replaceFirst('https://', ''),
                  url: onRecord,
                ),
            ],
            if (serverProblem != null) ...<Widget>[
              SizedBox(height: ZaveSpace.md),
              Semantics(
                liveRegion: true,
                child: Text(
                  serverProblem,
                  style: ContestType.meta.copyWith(
                    color: ContestColors.wrongText,
                  ),
                ),
              ),
            ],
            SizedBox(height: ZaveSpace.lg),
            Text(
              kShoutoutWithdrawLine,
              style: ContestType.meta.copyWith(height: 1.6),
            ),
            const ContestWebLink(
              label: 'How featuring works',
              url: '$plexaverseContestRulesUrl#featured',
            ),
          ],
        ),
      ),
    );
  }
}

/// "Feature me if I make it" — a checkbox in its tile, the whole tile its
/// tap target, drawn as the join card's leaderboard box is: Zave has a switch
/// but no checkbox, and the web's control is a box that is ticked, not a
/// setting that is on.
class _ConsentBox extends StatelessWidget {
  const _ConsentBox({
    required this.checked,
    required this.onChanged,
    this.title = kShoutoutToggleLabel,
    this.body = '$kShoutoutConsentText.',
    this.label = '$kShoutoutToggleLabel. $kShoutoutConsentText.',
  });

  final bool checked;

  /// Null while a save is in flight: the consent sent is the one shown.
  final ValueChanged<bool>? onChanged;

  /// The box's own name and the words under it — the consent's by default;
  /// the 18+ declaration's for that box.
  final String title;
  final String body;

  /// What a screen reader reads for the whole tile.
  final String label;

  @override
  Widget build(BuildContext context) {
    final ValueChanged<bool>? change = onChanged;
    final BorderRadius radius = ZaveRadius.cardSmBr;
    return Semantics(
      checked: checked,
      enabled: change != null,
      label: label,
      excludeSemantics: true,
      onTap: change == null ? null : () => change(!checked),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: change == null ? null : () => change(!checked),
          borderRadius: radius,
          child: Ink(
            padding: EdgeInsets.all(ZaveSpace.lg),
            decoration: BoxDecoration(
              color: ZaveGlass.rest,
              border: Border.all(color: ZaveGlass.restBorder),
              borderRadius: radius,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(top: 2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: checked ? ZaveColors.white : Colors.transparent,
                    border: Border.all(
                      color: checked ? ZaveColors.white : ZaveColors.ink50,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  child: checked
                      ? const Icon(
                          AppIcons.check,
                          size: 13,
                          color: ContestColors.ink,
                        )
                      : null,
                ),
                SizedBox(width: ZaveSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: ZaveType.body.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: ZaveSpace.xs),
                      Text(
                        body,
                        style: ZaveType.body.copyWith(
                          fontSize: 14,
                          height: 1.6,
                          color: ZaveColors.ink50,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The profile link field, drawn the contest's way: a wrong link turns its
/// border red and says why underneath, in red.
class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.controller,
    required this.problem,
    required this.enabled,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String? problem;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final String? said = problem;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: ZaveGlass.rest,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: said != null
                  ? ContestColors.wrongDot
                  : ZaveGlass.restBorder,
            ),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            enableSuggestions: false,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            cursorColor: ZaveColors.white,
            style: ZaveType.body.copyWith(
              fontSize: 15.sp,
              color: ZaveColors.white,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              semanticCounterText: '',
              hintText: 'https://www.linkedin.com/in/your-name',
              hintStyle: ZaveType.body.copyWith(
                fontSize: 15.sp,
                color: ZaveColors.ink50,
              ),
              hintMaxLines: 1,
            ),
          ),
        ),
        if (said != null) ...<Widget>[
          SizedBox(height: 6.h),
          Semantics(
            liveRegion: true,
            child: Text(
              said,
              style: ContestType.meta.copyWith(
                fontSize: 13.sp,
                color: ContestColors.wrongText,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
