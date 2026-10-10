import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/festive_controller.dart';
import '../../domain/festive_template.dart';
import 'ai_tool_image.dart';
import 'ai_tool_note.dart';
import 'ai_tool_sheet.dart';

/// **Customize poster** — the web's `FestiveCustomizer`.
///
/// Collect a company name, an occasion, a date, a message and a brand colour,
/// spend 800 XP, and get a composited poster back. The web lays this out as a
/// two-column modal that stacks below 1024px; a phone only ever renders the
/// stacked form, so that is all this is.
///
/// ## Three deliberate departures
///
/// • **The logo is uploaded, not inlined.** The web reads the file into a
///   data URI with `FileReader` and posts that inline as `logoUrl`. A phone
///   photo is still megabytes after the picker downscales it, and base64 adds
///   a third on top, so sending it with the generate call would park that
///   upload in front of the 800 XP round-trip. The pick uploads to storage
///   immediately instead — while the user is still typing — and generate
///   sends the short URL it returned. Nothing about that upload is kept here:
///   it is [FestivePosterController]'s, because its in-flight flag and
///   Generate's have to be the same gate.
/// • **Preset swatches instead of a colour wheel.** The app ships no
///   colour-picker package. The presets are Zave's signal colours plus white,
///   and a hex field takes anything else. Note the swatch renders the chosen
///   value: this is the one place in the app where a colour is DATA rather
///   than chrome, so it is not bound by "colour only names a status".
/// • **"Save to my images" instead of "Use as post".** The web stashes the
///   poster in `sessionStorage` and pushes `/create?source=festive`. There is
///   no sessionStorage on a phone and the composer is another slice's; the
///   endpoint-backed equivalent is `POST /upload/image`, which turns the
///   inline data URI into a link the user can paste anywhere — including the
///   composer.
class FestiveCustomizerSheet extends ConsumerStatefulWidget {
  const FestiveCustomizerSheet({required this.template, super.key});

  final FestiveTemplate template;

  @override
  ConsumerState<FestiveCustomizerSheet> createState() =>
      _FestiveCustomizerSheetState();
}

class _FestiveCustomizerSheetState
    extends ConsumerState<FestiveCustomizerSheet> {
  final TextEditingController _company = TextEditingController();
  final TextEditingController _event = TextEditingController();
  final TextEditingController _message = TextEditingController();
  late final TextEditingController _hex = TextEditingController(
    text: const FestiveCustomizations().primaryColor,
  );

  DateTime? _date;

  /// The sheet's whole part in the logo flow: say what came back.
  ///
  /// The pick, the upload and the flag that gates the form are the
  /// controller's — see [FestivePosterController.pickLogo]. Only the snackbar
  /// is left here, because a `ScaffoldMessenger` needs a `BuildContext` and
  /// that is the one thing application/ cannot hold.
  Future<void> _pickLogo(FestivePosterController controller) async {
    final String? message = await controller.pickLogo();
    if (message == null || !mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message, style: ZaveType.body)));
  }

  /// `RRGGBB`, already upper-cased by the caller.
  static final RegExp _hexPattern = RegExp(r'^[0-9A-F]{6}$');

  /// The presets: the web's default plus Zave's own signal colours and white.
  /// A brand colour the user has not thought about is better served by a
  /// palette that already belongs to the product than by an arbitrary rainbow,
  /// and the hex field below takes anything else.
  static const List<String> _swatches = <String>[
    '#7000FF',
    '#2F3AF7',
    '#AEB4FF',
    '#00DC82',
    '#FFD166',
    '#FFFFFF',
  ];

  @override
  void dispose() {
    _company.dispose();
    _event.dispose();
    _message.dispose();
    _hex.dispose();
    super.dispose();
  }

  /// What the user typed, and only that. `logoUrl` is filled in by the
  /// controller on its way out — see [FestivePosterController.generate].
  FestiveCustomizations get _values => FestiveCustomizations(
    companyName: _company.text,
    eventName: _event.text,
    additionalText: _message.text,
    date: _date,
    primaryColor: _normalisedHex,
  );

  /// `#RRGGBB`, upper-cased, with the `#` restored if the user dropped it.
  /// Falls back to the default rather than sending something the server's
  /// compositor cannot parse.
  String get _normalisedHex {
    String raw = _hex.text.trim().toUpperCase();
    if (raw.startsWith('#')) raw = raw.substring(1);
    final bool valid = raw.length == 6 && _hexPattern.hasMatch(raw);
    return valid ? '#$raw' : const FestiveCustomizations().primaryColor;
  }

  /// The chosen colour as a [Color], for the swatch preview. Never a token:
  /// this is the user's value being shown back to them.
  Color get _previewColor {
    final String hex = _normalisedHex.substring(1);
    return Color(int.parse('FF$hex', radix: 16));
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      // A poster is for an occasion, which can be behind or ahead. A year
      // either way covers every festival the template set carries.
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    // The sheet is dismissible while the picker is up, so it can be gone by
    // the time this returns.
    if (!mounted || picked == null) return;
    setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final FestiveCustomizerState customizer = ref.watch(
      festivePosterControllerProvider(widget.template.id),
    );
    final FestivePosterController controller = ref.read(
      festivePosterControllerProvider(widget.template.id).notifier,
    );

    return AiToolSheet(
      children: <Widget>[
        Text('FESTIVE POSTER', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        Text(widget.template.name, style: ZaveType.h2),
        SizedBox(height: ZaveSpace.xl),

        // ── Preview ───────────────────────────────────────────────────────
        ClipRRect(
          borderRadius: ZaveRadius.cardSmBr,
          child: Stack(
            children: <Widget>[
              AiToolImage(
                source: customizer.run.hasPoster
                    ? customizer.run.poster!.imageUrl
                    : widget.template.previewUrl,
                aspectRatio: 1,
                label: customizer.run.hasPoster ? null : 'Preview',
              ),
              if (customizer.run.busy == FestivePosterBusy.generating)
                const Positioned.fill(child: _GeneratingVeil()),
            ],
          ),
        ),
        SizedBox(height: ZaveSpace.xl),

        if (customizer.run.error != null) ...<Widget>[
          AiToolNoteRow(
            title: customizer.run.insufficientXp
                ? 'Not enough XP'
                : 'That did not work',
            message: customizer.run.error!,
          ),
          SizedBox(height: ZaveSpace.lg),
        ],

        if (customizer.run.hasPoster)
          _Result(
            savedUrl: customizer.run.savedUrl,
            saving: customizer.run.busy == FestivePosterBusy.saving,
            onSave: controller.save,
            onRegenerate: controller.reset,
          )
        else
          ..._form(controller),
      ],
    );
  }

  List<Widget> _form(FestivePosterController controller) {
    final FestiveCustomizerState customizer = ref.watch(
      festivePosterControllerProvider(widget.template.id),
    );
    // One gate for the whole form, and it is now one field rather than an
    // `||` of two. The half that used to live on this widget — the logo
    // upload's in-flight flag — was invisible to the other: Generate stayed
    // live through an upload, the tap read a `logoUrl` that was still null,
    // and the user was charged 800 XP for a poster missing the logo they had
    // just picked.
    final bool busy = customizer.busy;

    return <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: Text(
              customizer.logoUrl == null
                  ? 'Add your logo (optional)'
                  : 'Logo added — it will be composited onto the poster.',
              style: ZaveType.caption,
            ),
          ),
          SizedBox(width: ZaveSpace.md),
          ZaveButton(
            label: customizer.logoUrl == null ? 'Choose' : 'Replace',
            busy: customizer.uploadingLogo,
            onPressed: busy ? null : () => _pickLogo(controller),
          ),
        ],
      ),
      SizedBox(height: ZaveSpace.xl),

      ZaveField(
        controller: _company,
        label: 'Company / brand name',
        hint: 'Your company name',
        textInputAction: TextInputAction.next,
        enabled: !busy,
      ),
      SizedBox(height: ZaveSpace.lg),

      ZaveField(
        controller: _event,
        label: 'Event name',
        hint: 'e.g. Happy ${widget.template.name}',
        helper: 'Optional. Replaces the poster headline.',
        textInputAction: TextInputAction.next,
        enabled: !busy,
      ),
      SizedBox(height: ZaveSpace.lg),

      Text('DATE', style: ZaveType.kicker),
      SizedBox(height: ZaveSpace.sm),
      ZaveButton(
        label: _date == null
            ? 'Pick a date'
            : _values.formattedDate ?? 'Pick a date',
        icon: const Icon(Icons.calendar_today_outlined),
        expand: true,
        onPressed: busy ? null : _pickDate,
      ),
      SizedBox(height: ZaveSpace.lg),

      ZaveField(
        controller: _message,
        label: 'Additional message',
        hint: 'Any extra line to include',
        helper: 'Optional. Replaces the poster subtitle.',
        maxLines: 2,
        minLines: 2,
        enabled: !busy,
      ),
      SizedBox(height: ZaveSpace.lg),

      Text('BRAND COLOUR', style: ZaveType.kicker),
      SizedBox(height: ZaveSpace.sm),
      Wrap(
        spacing: ZaveSpace.sm,
        runSpacing: ZaveSpace.sm,
        children: <Widget>[
          for (final String swatch in _swatches)
            _Swatch(
              hex: swatch,
              selected: _normalisedHex == swatch,
              onTap: busy ? null : () => setState(() => _hex.text = swatch),
            ),
        ],
      ),
      SizedBox(height: ZaveSpace.md),
      ZaveField(
        controller: _hex,
        hint: '#RRGGBB',
        pill: true,
        enabled: !busy,
        maxLength: 7,
        onChanged: (String _) => setState(() {}),
        prefix: Container(
          height: ZaveSpace.dot * 2,
          width: ZaveSpace.dot * 2,
          decoration: BoxDecoration(
            color: _previewColor,
            shape: BoxShape.circle,
            border: Border.all(color: ZaveColors.rule, width: 1),
          ),
        ),
      ),
      SizedBox(height: ZaveSpace.xl),

      const XpCostRow(
        cost: '800 XP per poster',
        detail:
            'Charged only when a poster comes back. A failed composite costs '
            'nothing, so you can retry on another template.',
      ),
      SizedBox(height: ZaveSpace.lg),

      // Two different halves of `busy`, deliberately, because they want
      // different faces. While the POSTER is being made or saved, the spinner
      // stops the dispatch on its own and `onPressed` stays non-null — a null
      // one would dim the button to 50% and make its own spinner nearly
      // invisible. While the LOGO is uploading the button must still refuse
      // the tap, but it must not spin: the spinner here means "your poster is
      // being made", the preview veil keys off `generating` alone, and a
      // button claiming to generate while nothing is generating is a lie the
      // user would wait on. `generate` refuses on either half regardless —
      // this only decides which refusal the user sees.
      ZaveButton(
        label: 'Generate poster',
        kind: ZaveButtonKind.primary,
        expand: true,
        busy: customizer.run.isBusy,
        onPressed: customizer.uploadingLogo
            ? null
            : () => controller.generate(_values),
      ),
    ];
  }
}

/// What the sheet becomes once a poster exists.
///
/// One white button, and it is "Save to my images" rather than "Download":
/// saving is the action that produces something the user can actually use.
class _Result extends StatelessWidget {
  const _Result({
    required this.savedUrl,
    required this.saving,
    required this.onSave,
    required this.onRegenerate,
  });

  final String? savedUrl;
  final bool saving;
  final Future<void> Function() onSave;
  final VoidCallback onRegenerate;

  @override
  Widget build(BuildContext context) {
    if (savedUrl != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const ZaveDot(ZaveColors.green),
              SizedBox(width: ZaveSpace.sm),
              Text(
                'SAVED',
                style: ZaveType.kicker.copyWith(color: ZaveColors.green),
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Container(
            padding: ZaveSpace.rowPad,
            decoration: ZaveSurface.codeBlock,
            child: Text(savedUrl!, style: ZaveType.mono),
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveButton(
            label: 'Copy link',
            kind: ZaveButtonKind.primary,
            icon: const Icon(Icons.link),
            expand: true,
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: savedUrl!));
            },
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveButton(
            label: 'Start over',
            expand: true,
            onPressed: onRegenerate,
          ),
          SizedBox(height: ZaveSpace.lg),
          const AiToolNoteRow(
            title: 'Attaching it to a post',
            message:
                'The web hands the poster straight to the composer. That '
                'hand-off is not wired on mobile yet, so paste the link into '
                'a post for now.',
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ZaveButton(
          label: 'Save to my images',
          kind: ZaveButtonKind.primary,
          icon: const Icon(Icons.cloud_upload_outlined),
          expand: true,
          busy: saving,
          onPressed: () => onSave(),
        ),
        SizedBox(height: ZaveSpace.md),
        ZaveButton(
          label: 'Regenerate',
          icon: const Icon(Icons.refresh),
          expand: true,
          onPressed: saving ? null : onRegenerate,
        ),
        SizedBox(height: ZaveSpace.lg),
        const AiToolNoteRow(
          title: 'The poster is not stored yet',
          message:
              'It came back inline with the response. Saving puts it in your '
              'image storage and gives you a link you can use anywhere.',
        ),
      ],
    );
  }
}

/// The "working on it" veil over the preview.
///
/// The web's spinner is `border-purple-500`; there is no purple in Zave and a
/// spinner is not a status, so it is plain white on a dim of the ground.
class _GeneratingVeil extends StatelessWidget {
  const _GeneratingVeil();

  @override
  Widget build(BuildContext context) => ColoredBox(
    // Midnight at 78% — the same veil the sticky header uses, reused rather
    // than a new opacity invented for this one overlay.
    color: ZaveGlass.headerFill,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: ZaveSpace.xxl,
          width: ZaveSpace.xxl,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: ZaveColors.white,
          ),
        ),
        SizedBox(height: ZaveSpace.lg),
        Text('Generating your poster', style: ZaveType.label),
        SizedBox(height: ZaveSpace.xs),
        Text('This takes a few seconds', style: ZaveType.caption),
      ],
    ),
  );
}

/// One brand-colour preset.
///
/// Selected inverts to a white ring, the same "selected is white" language as
/// [ZaveChip] — the fill cannot carry the selection here because the fill IS
/// the value being chosen.
class _Swatch extends StatelessWidget {
  const _Swatch({required this.hex, required this.selected, this.onTap});

  final String hex;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = Color(int.parse('FF${hex.substring(1)}', radix: 16));

    return Semantics(
      button: true,
      selected: selected,
      label: hex,
      child: ZavePress(
        enabled: onTap != null,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: ZaveSpace.minTapTarget,
            width: ZaveSpace.minTapTarget,
            child: Center(
              child: AnimatedContainer(
                duration: ZaveMotion.fast,
                curve: ZaveMotion.curve,
                height: ZaveSpace.iconBtn,
                width: ZaveSpace.iconBtn,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? ZaveColors.white : ZaveColors.rule,
                    width: selected ? 3 : 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
