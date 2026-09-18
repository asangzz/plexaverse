/// Zave — the Plexaverse design system, ported from the web app.
///
/// Import this barrel rather than the individual token files:
///
/// ```dart
/// import 'package:plexaverse/core/theme/zave/zave.dart';
/// ```
///
/// ## What Zave is
///
/// Zave is the visual language of the Plexaverse web app, defined in
/// `app/globals.css` (the `--zv-*` custom properties and `.zv-*` classes) and
/// specimened at `/zave-style-guide`. This package is a faithful Dart port of
/// it, so the mobile app and the web app are the same product rather than two
/// products that share a name.
///
/// ## The four rules
///
/// 1. **Colour only ever names a status.** Green is done, amber is waiting,
///    blue is the XP path. Nothing is tinted for decoration. — [ZaveColors]
/// 2. **Depth is a fill step, never a shadow.** rest → hover → now. There are
///    three and only three. — [ZaveGlass], [ZaveSurface]
/// 3. **Manrope names, Urbanist reads.** Headings, nav and buttons are heavy
///    tight Manrope; everything you actually read is Urbanist. — [ZaveType]
/// 4. **Motion is short and physical. Nothing bounces.** — [ZaveMotion]
///
/// ## Two things that are easy to get wrong
///
/// • **Sizes here are the web's MOBILE sizes.** The web is responsive and its
///   `@media (max-width: 899px)` branch is what a phone renders, so that branch
///   is what this app matches. Do not port a desktop figure.
///
/// • **Every pressable is a full pill.** Buttons, chips, tabs — no rounded
///   rectangles. A selected chip inverts to solid white with ink text; it is
///   never merely tinted.
library;

export 'zave_colors.dart';
export 'zave_geometry.dart';
export 'zave_motion.dart';
export 'zave_surfaces.dart';
export 'zave_typography.dart';
