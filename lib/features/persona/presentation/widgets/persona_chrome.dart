import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// One block of the persona screen: a heading, an optional status pill, a line
/// of sub-copy, and a glass panel.
///
/// The web renders these as `rounded-2xl bg-white/[0.03] border-white/[0.07]
/// p-5` cards with an Urbanist `font-black text-base` heading. Zave's nearest
/// equivalents are [ZaveCard] at the default radius and [ZaveType.h3] — a
/// Manrope heading, because in Zave "Manrope names, Urbanist reads" and a
/// section title is a name.
///
/// Deliberately its own widget rather than an import from the Settings slice:
/// the two screens are separate feature slices, and a shared presentation
/// helper reaching across that line is the first step to them changing
/// together for no reason.
class PersonaSection extends StatelessWidget {
  const PersonaSection({
    required this.title,
    required this.child,
    this.lead,
    this.status,
    super.key,
  });

  final String title;

  /// The sentence under the heading. The web's copy is reproduced verbatim at
  /// every call site — several of those sentences are product decisions, not
  /// descriptions.
  final String? lead;

  /// A trailing pill, e.g. the audience's "not set" marker.
  final Widget? status;

  final Widget child;

  /// The gap between two persona blocks. The web uses 24px (`space-y-6`).
  static double get gap => ZaveSpace.xl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: Text(title, style: ZaveType.h3)),
            if (status != null) ...<Widget>[
              SizedBox(width: ZaveSpace.md),
              status!,
            ],
          ],
        ),
        if (lead != null) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Text(lead!, style: ZaveType.caption),
        ],
        SizedBox(height: ZaveSpace.md),
        ZaveCard(child: child),
      ],
    );
  }
}

/// One `label / value` row in "Who you are".
///
/// The web lays these out as a label column fixed at 160px beside the value on
/// a wide screen, and stacked below `sm`. A phone is always below `sm`, so the
/// stacked form is the only one ported — it is the web's own mobile rendering,
/// not a mobile-specific invention.
class PersonaField extends StatelessWidget {
  const PersonaField({required this.label, this.value, this.child, super.key});

  final String label;

  /// The plain-text value, or null for the "not set yet" state.
  final String? value;

  /// A richer value — [PersonaChips], typically. Wins over [value].
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final bool isSet =
        child != null || (value != null && value!.trim().isNotEmpty);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: ZaveSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label.toUpperCase(), style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          if (child != null)
            child!
          else
            Text(
              isSet ? value!.trim() : 'Not set yet',
              style: isSet
                  ? ZaveType.body
                  // Unset is the faintest legible step, not an error — the
                  // screen is a mirror, and a blank field is information.
                  : ZaveType.body.copyWith(
                      color: ZaveColors.ink35,
                      fontStyle: FontStyle.italic,
                    ),
            ),
        ],
      ),
    );
  }
}

/// A run of static pills — expertise, topics, products.
///
/// These are [ZavePill]s, not [ZaveChip]s: nothing here is selectable, and a
/// chip that does not respond to touch reads as a chip whose selected state is
/// broken.
class PersonaChips extends StatelessWidget {
  const PersonaChips({required this.items, super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(
        'Not set yet',
        style: ZaveType.body.copyWith(
          color: ZaveColors.ink35,
          fontStyle: FontStyle.italic,
        ),
      );
    }
    return Wrap(
      spacing: ZaveSpace.sm,
      runSpacing: ZaveSpace.sm,
      children: <Widget>[
        for (final String item in items) ZavePill(label: item),
      ],
    );
  }
}

/// A hairline between two [PersonaField]s.
class PersonaDivider extends StatelessWidget {
  const PersonaDivider({super.key});

  @override
  Widget build(BuildContext context) =>
      const Divider(color: ZaveColors.rule, height: 1, thickness: 1);
}

/// Says that a block the web has is not reachable from the app, and why.
///
/// **This is never rendered as an empty state, and that is a product decision
/// copied straight from the web.** `/persona`'s empty material bank promises
/// "Plexa won't invent a story"; a failed read wearing the same face would make
/// that promise a lie and would push the user to re-add material they already
/// have. The web carries an explicit `unavailable` flag for exactly this. The
/// mobile version of "unavailable" is "there is no endpoint yet", and it gets
/// the same treatment.
///
/// Amber, because Zave has no red and this is a waiting state.
class PersonaUnavailableNote extends StatelessWidget {
  const PersonaUnavailableNote({
    required this.title,
    required this.message,
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: ZaveSpace.xs + 2),
          child: const ZaveDot(ZaveColors.amber),
        ),
        SizedBox(width: ZaveSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: ZaveType.label.copyWith(color: ZaveColors.white),
              ),
              SizedBox(height: ZaveSpace.xs),
              Text(message, style: ZaveType.caption),
            ],
          ),
        ),
      ],
    );
  }
}

/// The loading placeholder for one persona block. No shimmer — Zave's motion
/// rule is "short and physical; nothing bounces".
class PersonaSkeleton extends StatelessWidget {
  const PersonaSkeleton({this.lines = 3, super.key});

  final int lines;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < lines; i++) ...<Widget>[
            if (i > 0) SizedBox(height: ZaveSpace.md),
            Container(
              height: ZaveSpace.lg,
              width: double.infinity,
              margin: EdgeInsets.only(right: i * ZaveSpace.xxl),
              decoration: BoxDecoration(
                color: ZaveGlass.hover,
                borderRadius: ZaveRadius.pillBr,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
