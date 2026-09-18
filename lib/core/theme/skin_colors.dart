import 'package:flutter/material.dart';

/// HeyGen-style re-skin design tokens — sampled from the reference
/// screenshots in `/attachments` (see `migration-map/heygen-ui-spec.md`,
/// which is ground truth for every hex below).
///
/// Screenshot map:
///  * 2353/2371 — Home "Make video" tab (navy cards, cyan title gradient)
///  * 2372 — Home "Translate video" tab (green titles + green glow thumbs)
///  * 2373 — Home "Video tools" tab (magenta titles + purple glow thumbs)
///  * 2354/2370 — Videos tab (outline chips, gold badges, date greys)
///  * 2369 — Avatars tab (Add-look green→cyan gradient, voice bar)
///  * 2374 — Account page (row cards, cyan section labels, logout red)
///  * 2375 — Subscription sheet (blue gradient card, quota bars)
///  * 2376 — Video Translation sheet (dark rows, purple icon tiles)
///  * 2377 — Create sheet (teal avatar rows + olive video rows, cyan
///    line glyphs / lime→green gradient glyphs)
///
/// These are raw skin constants (dark-only screens), deliberately kept
/// separate from the M3 `ColorScheme` / `PlexaverseColors` extension: the
/// re-skinned screens are pixel-matched to the screenshots and never react
/// to theme-mode switches.
abstract class SkinColors {
  // ---- Canvas & header (2353) ----
  /// App background behind every re-skinned screen.
  static const Color deepNavy = Color(0xFF05061A);

  /// Home header gradient stops — violet (top) fading through indigo and
  /// deep blue into [deepNavy] over the top ~30% of the screen.
  static const Color headerViolet = Color(0xFF7838B2);
  static const Color headerIndigo = Color(0xFF4D2DA3);
  static const Color headerDeepBlue = Color(0xFF0E0F61);

  // ---- Home feature cards (2353) ----
  /// Navy shimmer/placeholder tones (legacy card gradient — the card FILL
  /// itself is now [glassCardBlue]; these remain for thumbnail shimmers and
  /// the Avatars-tab placeholders).
  static const Color cardNavyStart = Color(0xFF0E1A41);
  static const Color cardNavyEnd = Color(0xFF081841);

  /// Home feature-card fill — translucent steel-blue glass (#0D3753 at
  /// alpha 0.29) over the fitted page background. Least-squares fit over
  /// 8 sampled points across all 4 card positions in 2353/2372/2373
  /// (meanErr 8.9). The cards read darker toward the bottom of the screen
  /// because the background shows through — NOT a fixed gradient.
  static const Color glassCardBlue = Color(0x4A0D3753);

  /// Brand cyan — play buttons, progress fills, section labels, links.
  static const Color brandCyan = Color(0xFF00C4FF);

  /// "Make video" card title gradient (ShaderMask over bold 17sp) — also
  /// the thumbnail's hairline border + inner-shadow accent
  /// ([AccentBorderCard]).
  static const Color titleGradStart = Color(0xFF3FC0E7);
  static const Color titleGradEnd = Color(0xFF149CC5);

  /// "Translate video" tab: title text AND the thumbnail's hairline
  /// border + inner-shadow accent (2372) — same color, no outer glow.
  static const Color translateGreen = Color(0xFF85E8A1);

  /// "Video tools" tab: title text AND the thumbnail's hairline border +
  /// inner-shadow accent (2373) — same color, no outer glow.
  static const Color toolsMagenta = Color(0xFFEE7FFF);

  // ---- Text greys ----
  /// Card subtitle / body grey on navy (15sp).
  static const Color subtitleGrey = Color(0xFF8E9BB5);

  /// Date / metadata grey ("July 04, 2026") and secondary labels.
  static const Color dateGrey = Color(0xFF8A8FA8);

  /// Inactive home pill-tab label (2353).
  static const Color pillInactiveText = Color(0xFF8B87A8);

  /// Kebab (3-dot) menu icon on video rows (2354).
  static const Color kebabGrey = Color(0xFF9AA0B5);

  /// Caps section labels in the Create sheet, 12sp ls1.2 (2377).
  static const Color capsLabelGrey = Color(0xFF7A7A7A);

  // ---- Gold badge ("Avatar IV", "Draft", "Seedance 2.0") ----
  static const Color badgeGold = Color(0xFFE8B54B);
  static const Color badgeGoldBg = Color(0xFF3A3123);

  // ---- Bottom nav + FAB (2353) ----
  static const Color navBg = Color(0xFF151515);
  static const Color navInactive = Color(0xFF8A8A8A);

  // ---- Sheets (2375 / 2376 / 2377) ----
  /// Subscription-sheet grouped inner card (#212121, sampled in 2375).
  static const Color sheetDark = Color(0xFF212121);

  /// Subscription (2375) + Create (2377) sheet background (#151515).
  static const Color sheetDarkest = Color(0xFF151515);

  /// Sheet drag handle (32×4 r2).
  static const Color dragHandle = Color(0xFF4A4A4A);

  /// Video Translation sheet background (#161616, sampled in 2376).
  static const Color vtSheetBg = Color(0xFF161616);

  /// Video Translation sheet row cards (#202020 r~24 h72, sampled in 2376).
  static const Color vtRowBg = Color(0xFF202020);

  /// Purple-tinted icon tile inside Video Translation rows (44 r12, 2376).
  static const Color vtTilePurpleBg = Color(0xFF2B2233);

  /// Magenta/purple line-icon glyph inside Video Translation tiles (2376).
  static const Color vtIconPurple = Color(0xFFE081FF);

  /// Recent-activity thumb placeholder in the Subscription sheet (2375).
  static const Color recentThumbBg = Color(0xFF3A3A3C);

  /// Quota / progress bar unfilled track in the Subscription sheet (2375).
  static const Color quotaTrackGrey = Color(0xFF454545);

  // ---- Create sheet rows & tiles (2377) ----
  /// Dark-teal row card behind the two avatar rows (Clone Yourself /
  /// Design an Avatar), sampled #17242B in 2377.
  static const Color createRowTeal = Color(0xFF17242B);

  /// Dark-olive row card behind the video rows (Photo to Video … UGC Ad),
  /// sampled #222B22 in 2377.
  static const Color createRowGreen = Color(0xFF222B22);

  /// Cyan icon-tile set (avatar rows): teal tile + cyan line glyph.
  static const Color tileCyanBg = Color(0xFF224C59);
  static const Color tileCyanIcon = Color(0xFF39B1E0);

  /// Olive icon-tile fill (video rows) — glyphs carry the lime→green
  /// gradient below, not a solid color.
  static const Color tileGreenBg = Color(0xFF364227);

  /// Lime→green glyph gradient over video-row tile icons (ShaderMask,
  /// filled glyph style, sampled in 2377).
  static const Color limeGradStart = Color(0xFFCFFC58);
  static const Color limeGradEnd = Color(0xFF56D273);

  // ---- Avatars tab (2369) ----
  /// "Add look" card vertical gradient (green → cyan).
  static const Color addLookGradStart = Color(0xFF18C557);
  static const Color addLookGradEnd = Color(0xFF07AFD1);

  /// Floating voice bar fill (used at 92% opacity).
  static const Color voiceBarBg = Color(0xFF1C1C1E);

  // ---- Account page (2374) + Subscription card (2375) ----
  /// Blue subscription card gradient (top-left → bottom-right).
  static const Color subGradStart = Color(0xFF0185C9);
  static const Color subGradEnd = Color(0xFF022255);

  /// Account list row fill — white at 11% over the diagonal page gradient
  /// (least-squares fit, meanErr 1.1 across all 8 rows in 2374: the top
  /// row reads #1F2038, the bottom #1B1B1F — the translucency is what
  /// makes lower rows darker).
  static const Color glassRowWhite = Color(0x1CEBECEF);

  /// Account header back-circle — white at 13% over the page gradient
  /// (sampled #23264D at the top of 2374 ≈ white 13% over the bg there).
  static const Color glassCircleWhite = Color(0x21EBECEF);

  /// Back-chevron / kebab circle on the Avatars tab (fixed fill, 2369).
  static const Color backCircleBg = Color(0xFF23264D);

  /// "Log out" destructive text.
  static const Color logoutRed = Color(0xFFDE1111);

  // ---- Videos tab (2354) ----
  /// Outline filter chips: 1px stadium border + label.
  static const Color chipBorder = Color(0xFF6E7288);
  static const Color chipText = Color(0xFFC9CCD6);

  /// "+ New folder" full-width button fill.
  static const Color newFolderBg = Color(0xFF212444);
}
