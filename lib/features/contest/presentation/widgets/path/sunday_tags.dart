import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../domain/levels_words.dart';
import '../contest_kit.dart';

/// The tags above the day that holds this week's Sunday levels — "Open all
/// week", "Set up your week", "0 XP" (25 Nov 2026). A port of the web's
/// `SundayTags` in `PathView.tsx`.
///
/// What the orange levels below are, in words — never colour alone — and
/// only above the one day that holds them. Small orange chips that wrap on a
/// narrow phone; a screen reader hears the group's name, then each tag.
class SundayLevelTags extends StatelessWidget {
  const SundayLevelTags({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: kSundayLevelTagsLabel,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 6,
        runSpacing: 6,
        children: <Widget>[
          for (final String tag in kSundayLevelTags) _Tag(tag),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: text,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        decoration: BoxDecoration(
          color: ContestColors.sundayTint,
          borderRadius: ZaveRadius.pillBr,
          border: Border.all(color: ContestColors.sunday),
        ),
        child: Text(
          text.toUpperCase(),
          maxLines: 1,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            height: 1.5,
            color: ContestColors.sundayInk,
          ),
        ),
      ),
    );
  }
}
