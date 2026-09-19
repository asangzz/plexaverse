import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/festive_controller.dart';
import '../../domain/festive_template.dart';
import 'ai_tool_image.dart';
import 'ai_tool_note.dart';
import 'ai_tool_sheet.dart';
import '../../../../core/platform/image_picking.dart';
import '../../data/ai_tools_repositories.dart';

/// **Customize poster** — the web's `FestiveCustomizer`.
///
/// Collect a company name, an occasion, a date, a message and a brand colour,
/// spend 800 XP, and get a composited poster back. The web lays this out as a
/// two-column modal that stacks below 1024px; a phone only ever renders the
/// stacked form, so that is all this is.
///
/// ## Three deliberate departures
///
/// • **No logo upload.** The web reads a file into a data URI with
///   `FileReader`. This app ships no image-picker package and `pubspec.yaml`
///   is not this slice's to edit, so the control states the position instead
///   of opening nothing. Everything else on the form works, and the poster
///   generates without a logo — `logoUrl` is optional server-side.
/// • **Preset swatches instead of a colour wheel.** There is no colour-picker
///   package either. The presets are Zave's own signal colours plus white, and
///   a hex field takes anything else. Note that the swatch renders the chosen
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

  /// The uploaded logo's URL, once the user has picked one. Uploaded on pick
  /// rather than on submit so a slow upload does not sit in front of the
  /// generate button.
  String? _logoUrl;
  bool _uploadingLogo = false;

  Future<void> _pickLogo() async {
    setState(() => _uploadingLogo = true);
    String? note;
    try {
      final ImagePickResult picked = await ref
          .read(imagePickingProvider)
          .pick(ImageSourceKind.gallery);
      switch (picked) {
        case PickedImage(:final String dataUri):
          final String url = await ref
              .read(aiToolsRepositoryProvider)
              .uploadDataUri(dataUri);
          if (!mounted) return;
          setState(() => _logoUrl = url);
        // Closing the picker is a decision.
        case ImagePickCancelled():
          break;
        case ImagePickFailure(:final String? message):
          note = message ?? 'Could not open your photos.';
      }
    } on Object {
      note = "That logo didn't upload. Try again.";
    } finally {
      if (mounted) setState(() => _uploadingLogo = false);
    }
    if (note == null || !mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(note, style: ZaveType.body)));
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

  FestiveCustomizations get _values => FestiveCustomizations(
    logoUrl: _logoUrl,
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
    final FestivePosterState poster = ref.watch(
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
                source: poster.hasPoster
                    ? poster.poster!.imageUrl
                    : widget.template.previewUrl,
                aspectRatio: 1,
                label: poster.hasPoster ? null : 'Preview',
              ),
              if (poster.busy == FestivePosterBusy.generating)
                const Positioned.fill(child: _GeneratingVeil()),
            ],
          ),
        ),
        SizedBox(height: ZaveSpace.xl),

        if (poster.error != null) ...<Widget>[
          AiToolNoteRow(
            title: poster.insufficientXp
                ? 'Not enough XP'
                : 'That did not work',
            message: poster.error!,
          ),
          SizedBox(height: ZaveSpace.lg),
        ],

        if (poster.hasPoster)
          _Result(
            savedUrl: poster.savedUrl,
            saving: poster.busy == FestivePosterBusy.saving,
            onSave: controller.save,
            onRegenerate: controller.reset,
          )
        else
          ..._form(controller),
      ],
    );
  }

  List<Widget> _form(FestivePosterController controller) {
    final FestivePosterState poster = ref.watch(
      festivePosterControllerProvider(widget.template.id),
    );
    final bool busy = poster.isBusy;

    return <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: Text(
              _logoUrl == null
                  ? 'Add your logo (optional)'
                  : 'Logo added — it will be composited onto the poster.',
              style: ZaveType.caption,
            ),
          ),
          SizedBox(width: ZaveSpace.md),
          ZaveButton(
            label: _logoUrl == null ? 'Choose' : 'Replace',
            busy: _uploadingLogo,
            onPressed: busy || _uploadingLogo ? null : _pickLogo,
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

      // `busy` blocks the tap on its own (ZaveButton stops dispatching while
      // it spins), so `onPressed` stays non-null — a null one would dim the
      // button to 50% and make its own spinner nearly invisible.
      ZaveButton(
        label: 'Generate poster',
        kind: ZaveButtonKind.primary,
        expand: true,
        busy: busy,
        onPressed: () => controller.generate(_values),
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
