import 'package:flutter/widgets.dart';

import '../../theme/zave/zave.dart';
import '../app_icons.dart';

/// Which third party a mark stands for.
enum ZaveBrand { google, linkedIn, slack }

/// A third party's real logo, at icon size.
///
/// ## Why this is the one place colour does not name a status
///
/// Zave's first rule is that colour only ever names a status — green is done,
/// amber needs you, and nothing is tinted for decoration. A vendor logo is the
/// single thing on screen that names nothing, which is why these buttons
/// originally drew the letter "G" and the letters "in" in Manrope rather than
/// the marks themselves.
///
/// That was a defensible reading of the rule and the wrong call in practice,
/// for two reasons. A letterform in the app's own typeface is not a logo: it
/// reads as a text label that happens to be one character, and a user scanning
/// for the Google button looks for the Google mark. And Google's own sign-in
/// branding guidance requires their actual mark on the button — a substitute
/// glyph is a compliance problem, not a style choice.
///
/// So this is a deliberate, bounded exception: a logo is allowed to be its own
/// colour, because the thing it names is the brand. The exception stops here.
/// Nothing else in the app gets a colour that is not a status.
///
/// ## Light and dark treatments
///
/// Every one of these brands publishes a monochrome treatment for dark
/// surfaces, and this app is dark everywhere. [onColor] takes it: the mark is
/// drawn in the surrounding foreground instead of its brand colour, which is
/// what a ghost button wants — a saturated blue "in" on a dark ghost button
/// fights the label beside it and fails contrast on the small sizes.
///
/// Use [onColor] inside buttons. Leave it off where the mark IS the subject —
/// a connected-account row, an integration tile — because there the colour is
/// doing identification work.
class ZaveBrandMark extends StatelessWidget {
  const ZaveBrandMark(this.brand, {this.size, this.onColor = false, super.key});

  final ZaveBrand brand;

  /// Defaults to the ambient [IconTheme] size, so a mark dropped into a button
  /// matches the icons around it without being told.
  final double? size;

  /// Draw in the ambient foreground rather than the brand colour.
  final bool onColor;

  /// The real marks, from Font Awesome's brand face.
  ///
  /// `fa-brands-400.ttf`, which the package licenses separately — the solid
  /// face has no codepoint at these positions at all and renders tofu, which
  /// is what the LinkedIn mark on Open Plexa's chip once was.
  IconData get _glyph => switch (brand) {
    ZaveBrand.google => AppIcons.google,
    // The bare "in", not the tile: a button already is the tile.
    ZaveBrand.linkedIn => AppIcons.linkedInIn,
    ZaveBrand.slack => AppIcons.slack,
  };

  /// Each brand's published primary, used only where the mark identifies.
  ///
  /// Static so a caller that draws the mark itself — a row that takes a bare
  /// [IconData] rather than a widget — can take the colour from here instead
  /// of pasting the hex. Three rows in Settings had pasted it.
  static Color colorOf(ZaveBrand brand) => switch (brand) {
    // Google's multi-colour G cannot be a font glyph — one codepoint carries
    // one colour. Their guidance covers this: on a dark surface the mark is
    // drawn in white, which is what [onColor] gives. Blue is the fallback for
    // a light surface this app does not currently have.
    ZaveBrand.google => const Color(0xFF4285F4),
    ZaveBrand.linkedIn => const Color(0xFF0A66C2),
    ZaveBrand.slack => const Color(0xFF611F69),
  };

  @override
  Widget build(BuildContext context) {
    final IconThemeData theme = IconTheme.of(context);
    return Icon(
      _glyph,
      size: size ?? theme.size,
      color: onColor ? (theme.color ?? ZaveColors.white) : colorOf(brand),
      // The mark is decorative wherever it appears: every call site puts the
      // brand's name in text beside it, so announcing it again is noise.
      semanticLabel: null,
    );
  }
}
