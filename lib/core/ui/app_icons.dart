import 'package:flutter/widgets.dart';

/// The app's single icon vocabulary — **Font Awesome (solid)**.
///
/// Every screen draws its icons from here — `Icon(AppIcons.x)` — so the
/// iconography stays harmonious: one curated set instead of stock Material
/// glyphs. Each entry notes the Material icon it replaced; to restyle an
/// icon app-wide, change it here once. The full set renders in the in-app
/// style guide (`AppIcons.all`).
///
/// These are plain [IconData] constants pointing at the `FontAwesomeSolid`
/// font that the `font_awesome_flutter` package bundles (referenced via
/// [fontPackage]). We deliberately do NOT use that package's
/// `FontAwesomeIcons` API: on this Flutter version `IconData` is a
/// `final class`, so the package exposes its glyphs as a separate
/// `FaIconData` type that only works with the `FaIcon` widget and won't
/// interop with `Icon`, `IconData`-typed params, or `find.byIcon`.
/// Constructing `IconData` directly keeps full interop while still rendering
/// Font Awesome glyphs.
///
/// Ported from the ProHealth reference (`core/ui/app_icons.dart`), re-scoped
/// to the glyphs Plexaverse actually uses (5-tab shell, posts/create,
/// notifications, settings, auth).
class AppIcons {
  const AppIcons._();

  static const String _family = 'FontAwesomeSolid';
  static const String _regularFamily = 'FontAwesomeRegular';

  /// Brand marks (LinkedIn, Google) live in their OWN font, not in solid.
  ///
  /// Font Awesome licenses brand glyphs separately and ships them in
  /// `fa-brands-400.ttf`; the solid face has no codepoint at f08c or f1a0 at
  /// all. Declaring them on [_family] renders the tofu box — which is what
  /// the LinkedIn mark on Open Plexa's "Open and comment" chip was.
  static const String _brandFamily = 'FontAwesomeBrands';

  static const String _pkg = 'font_awesome_flutter';

  /// The Font Awesome **regular (outline)** twin of a solid glyph — same
  /// codepoint, regular font. Use ONLY for glyphs that exist in FA-free
  /// regular (e.g. [home], [posts], [analytics], [person], [bell]); solid-only
  /// glyphs ([odyssey], [lock]) have no outline and would render a missing
  /// box. Used for unselected nav-tab twins.
  static IconData regular(IconData solid) {
    // codePoint comes from a runtime arg, so this IconData can't be const.
    // ignore: non_const_argument_for_const_parameter
    return IconData(
      solid.codePoint,
      fontFamily: _regularFamily,
      fontPackage: _pkg,
    );
  }

  // ── Shell tabs (home / posts / odyssey / analytics / settings) ─────────
  static const IconData home = IconData(
    0xf015,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // house
  static const IconData posts = IconData(
    0xf5fd,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // layerGroup
  static const IconData odyssey = IconData(
    0xf135,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // rocket
  static const IconData analytics = IconData(
    0xf080,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // chartBar
  static const IconData settings = IconData(
    0xf013,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // gear

  // ── Navigation & chrome ───────────────────────────────────────────────
  static const IconData menu = IconData(
    0xf0c9,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // bars
  static const IconData close = IconData(
    0xf00d,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // xmark
  static const IconData chevronLeft = IconData(
    0xf053,
    fontFamily: _family,
    fontPackage: _pkg,
  );
  static const IconData chevronRight = IconData(
    0xf054,
    fontFamily: _family,
    fontPackage: _pkg,
  );
  static const IconData chevronDown = IconData(
    0xf078,
    fontFamily: _family,
    fontPackage: _pkg,
  );
  static const IconData back = IconData(
    0xf060,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // arrowLeft
  static const IconData search = IconData(
    0xf002,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // magnifyingGlass

  // ── Actions ───────────────────────────────────────────────────────────
  static const IconData add = IconData(
    0x2b,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // plus (FAB)
  static const IconData remove = IconData(
    0xf068,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // minus
  static const IconData check = IconData(
    0xf00c,
    fontFamily: _family,
    fontPackage: _pkg,
  );
  static const IconData edit = IconData(
    0xf044,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // penToSquare
  static const IconData delete = IconData(
    0xf2ed,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // trashCan
  static const IconData attach = IconData(
    0xf0c6,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // paperclip
  static const IconData send = IconData(
    0xf1d8,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // paperPlane
  static const IconData share = IconData(
    0xf1e0,
    fontFamily: _family,
    fontPackage: _pkg,
  );
  static const IconData logout = IconData(
    0xf2f5,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // rightFromBracket
  static const IconData refresh = IconData(
    0xf021,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // arrowsRotate
  static const IconData skip = IconData(
    0xf051,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // forwardStep — "not this one"

  /// Dictation, idle. Verified against font_awesome_flutter 10.8.0's own
  /// `microphone` (0xf130) rather than from memory — FA codepoints move
  /// between major versions and a wrong one renders tofu, not a fallback.
  static const IconData mic = IconData(
    0xf130,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // microphone

  /// Dictation, live. A different glyph and not just a different colour:
  /// colour alone is the one difference a colour-blind user may not get.
  static const IconData micOn = IconData(
    0xf3c9,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // microphoneLines

  // ── Status & feedback ─────────────────────────────────────────────────
  static const IconData checkCircle = IconData(
    0xf058,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // circleCheck
  static const IconData error = IconData(
    0xf06a,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // circleExclamation
  static const IconData info = IconData(
    0xf05a,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // circleInfo
  static const IconData warning = IconData(
    0xf071,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // triangleExclamation
  static const IconData star = IconData(
    0xf005,
    fontFamily: _family,
    fontPackage: _pkg,
  );
  static const IconData schedule = IconData(
    0xf017,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // clock
  static const IconData inProgress = IconData(
    0xf252,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // hourglassHalf
  static const IconData offline = IconData(
    0xe560,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // plugCircleXmark
  static const IconData online = IconData(
    0xf1eb,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // wifi
  static const IconData lock = IconData(
    0xf023,
    fontFamily: _family,
    fontPackage: _pkg,
  );
  static const IconData sessionExpired = IconData(
    0xf4fd,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // userClock
  static const IconData eye = IconData(
    0xf06e,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // reveal
  static const IconData eyeSlash = IconData(
    0xf070,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // hide
  static const IconData empty = IconData(
    0xf49e,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // boxOpen (empty state)

  // ── Domain (posts / studio / schedule / odyssey) ──────────────────────
  static const IconData create = IconData(
    0xf303,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // penClip (compose)
  static const IconData studio = IconData(
    0xf5fd,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // layerGroup
  static const IconData calendar = IconData(
    0xf783,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // calendarDay
  static const IconData image = IconData(
    0xf03e,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // image
  static const IconData photoLibrary = IconData(
    0xf302,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // images
  static const IconData camera = IconData(
    0xf030,
    fontFamily: _family,
    fontPackage: _pkg,
  );
  static const IconData like = IconData(
    0xf004,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // heart
  static const IconData comment = IconData(
    0xf075,
    fontFamily: _family,
    fontPackage: _pkg,
  );
  static const IconData trophy = IconData(
    0xf091,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // odyssey milestones

  // ── Comms & profile ───────────────────────────────────────────────────
  static const IconData email = IconData(
    0xf0e0,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // envelope
  static const IconData notifications = IconData(
    0xf0f3,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // bell
  static const IconData person = IconData(
    0xf007,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // user
  static const IconData fingerprint = IconData(
    0xf577,
    fontFamily: _family,
    fontPackage: _pkg,
  );
  static const IconData palette = IconData(
    0xf53f,
    fontFamily: _family,
    fontPackage: _pkg,
  );
  static const IconData language = IconData(
    0xf0ac,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // globe
  static const IconData google = IconData(
    0xf1a0,
    fontFamily: _brandFamily,
    fontPackage: _pkg,
  ); // google (brand)
  static const IconData linkedin = IconData(
    0xf08c,
    fontFamily: _brandFamily,
    fontPackage: _pkg,
  ); // linkedin (brand) — the squared tile

  /// The bare "in" mark, without LinkedIn's rounded tile.
  ///
  /// The right one inside a button or a chip, where the surrounding shape IS
  /// the tile and nesting a second one reads as a logo inside a logo.
  static const IconData linkedInIn = IconData(
    0xf0e1,
    fontFamily: _brandFamily,
    fontPackage: _pkg,
  ); // linkedin-in (brand)

  static const IconData slack = IconData(
    0xf198,
    fontFamily: _brandFamily,
    fontPackage: _pkg,
  ); // slack (brand)

  /// Codepoint read off the resolved font_awesome_flutter (10.12.0), not from
  /// memory — FA moves brand codepoints between majors and a wrong one renders
  /// tofu rather than falling back to anything.
  static const IconData whatsapp = IconData(
    0xf232,
    fontFamily: _brandFamily,
    fontPackage: _pkg,
  ); // whatsapp (brand)

  // ── The glyphs the screens kept reaching past this file for ───────────
  //
  // Every entry below replaced a stock Material icon that was being drawn
  // beside Font Awesome ones. Font Awesome solid is a heavy, geometric face;
  // Material's default set is a thin outline face. Mixed in one row they do
  // not read as one product, and the mix was in 86 files.
  //
  // Codepoints are read off the bundled `font_awesome_flutter` 10.12.0
  // (Font Awesome 7.1.0), not from memory — `wand-magic-sparkles` is 0xe2ca
  // in FA7 and 0xf72b in FA6, and a wrong one renders tofu, not a fallback.

  /// AI, generation, "make me one". Replaces Material's `auto_awesome`.
  static const IconData sparkle = IconData(
    0xe2ca,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // wandMagicSparkles

  /// Leaves the app. Replaces Material's `open_in_new`.
  static const IconData openExternal = IconData(
    0xf08e,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // arrowUpRightFromSquare

  /// Replaces Material's `copy_all_outlined` / `copy_rounded`.
  static const IconData copy = IconData(
    0xf0c5,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // copy

  /// An overflow menu. Replaces Material's `more_horiz`.
  static const IconData more = IconData(
    0xf141,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // ellipsis

  /// Audience and reach — LinkedIn's own "anyone" control is a globe.
  ///
  /// Shares its codepoint with [language] on purpose: Font Awesome draws one
  /// globe and the two meanings are told apart by what sits beside them, not
  /// by a second glyph.
  static const IconData public = IconData(
    0xf0ac,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // globe

  /// Referrals. Replaces Material's `card_giftcard_outlined`.
  static const IconData gift = IconData(
    0xf06b,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // gift

  static const IconData upload = IconData(
    0xf093,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // upload

  static const IconData download = IconData(
    0xf019,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // download

  static const IconData link = IconData(
    0xf0c1,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // link

  /// A repeating schedule. Replaces Material's `event_repeat_outlined`.
  static const IconData repeat = IconData(
    0xf363,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // repeat

  static const IconData play = IconData(
    0xf04b,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // play

  /// XP, streaks, energy. Replaces Material's `bolt_rounded`.
  static const IconData bolt = IconData(
    0xf0e7,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // bolt

  /// The long-form article — the one thing we write and never publish.
  static const IconData article = IconData(
    0xf15c,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // fileLines

  /// A company page, as opposed to a person. Replaces Material's `business_outlined`.
  static const IconData business = IconData(
    0xf1ad,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // building

  static const IconData brush = IconData(
    0xf1fc,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // paintbrush

  /// A season finished. Replaces Material's `celebration_outlined`.
  static const IconData celebrate = IconData(
    0xf79f,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // champagneGlasses

  /// Advocacy — asking the team to amplify. Replaces Material's `campaign_outlined`.
  static const IconData campaign = IconData(
    0xf0a1,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // bullhorn

  static const IconData flag = IconData(
    0xf024,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // flag

  /// A headshot / the user's own face. Replaces Material's `face_outlined`.
  static const IconData face = IconData(
    0xf118,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // faceSmile

  /// A thread, as opposed to a single [comment].
  static const IconData forum = IconData(
    0xf086,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // comments

  /// A gallery or board. Replaces Material's `grid_view_outlined`.
  static const IconData grid = IconData(
    0xf00a,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // tableCells

  /// Trend over time, as opposed to [analytics]' bars. Replaces Material's
  /// `insights_outlined` and `bar_chart_rounded`.
  static const IconData insights = IconData(
    0xf201,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // chartLine

  /// An experiment or a preview feature. Replaces Material's `science_rounded`.
  static const IconData science = IconData(
    0xf0c3,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // flask

  static const IconData crop = IconData(
    0xf125,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // crop

  static const IconData bookmark = IconData(
    0xf02e,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // bookmark

  /// Replaces Material's `person_add_alt_outlined`.
  static const IconData personAdd = IconData(
    0xf234,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // userPlus

  /// Replaces Material's `person_remove_outlined`.
  static const IconData personRemove = IconData(
    0xf503,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // userMinus

  /// All of them handled. Replaces Material's `done_all_rounded`.
  static const IconData doneAll = IconData(
    0xf560,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // checkDouble

  /// Forward, as a direction. The twin of [back].
  static const IconData forward = IconData(
    0xf061,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // arrowRight

  // ── Learn: the levels of a day's climb ────────────────────────────────
  //
  // Only three are new. The other four levels reuse glyphs the app already
  // has — a draft is [create], a poster is [image], a read-back is [eye] —
  // because a level is one of those things, not a new kind of thing.

  /// The vocabulary level: terms this week's topic needs.
  static const IconData book = IconData(
    0xf02d,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // book

  /// The hook level: the opening line.
  static const IconData quote = IconData(
    0xf10d,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // quoteLeft

  /// The substance level: what the user actually did at work.
  static const IconData briefcase = IconData(
    0xf0b1,
    fontFamily: _family,
    fontPackage: _pkg,
  ); // briefcase

  /// Every icon in the vocabulary with its semantic name — drives the style
  /// guide's icon gallery so the set stays self-documenting.
  static const Map<String, IconData> all = <String, IconData>{
    'home': home,
    'slack': slack,
    'whatsapp': whatsapp,
    'linkedInIn': linkedInIn,
    'posts': posts,
    'odyssey': odyssey,
    'analytics': analytics,
    'settings': settings,
    'menu': menu,
    'close': close,
    'chevronLeft': chevronLeft,
    'chevronRight': chevronRight,
    'chevronDown': chevronDown,
    'back': back,
    'search': search,
    'add': add,
    'remove': remove,
    'check': check,
    'edit': edit,
    'delete': delete,
    'attach': attach,
    'send': send,
    'share': share,
    'logout': logout,
    'refresh': refresh,
    'skip': skip,
    'checkCircle': checkCircle,
    'error': error,
    'mic': mic,
    'micOn': micOn,
    'info': info,
    'warning': warning,
    'star': star,
    'schedule': schedule,
    'inProgress': inProgress,
    'offline': offline,
    'online': online,
    'lock': lock,
    'sessionExpired': sessionExpired,
    'eye': eye,
    'eyeSlash': eyeSlash,
    'empty': empty,
    'create': create,
    'studio': studio,
    'calendar': calendar,
    'image': image,
    'photoLibrary': photoLibrary,
    'camera': camera,
    'like': like,
    'comment': comment,
    'trophy': trophy,
    'email': email,
    'notifications': notifications,
    'person': person,
    'fingerprint': fingerprint,
    'palette': palette,
    'language': language,
    'google': google,
    'linkedin': linkedin,
    'sparkle': sparkle,
    'openExternal': openExternal,
    'copy': copy,
    'more': more,
    'public': public,
    'gift': gift,
    'upload': upload,
    'download': download,
    'link': link,
    'repeat': repeat,
    'play': play,
    'bolt': bolt,
    'article': article,
    'business': business,
    'brush': brush,
    'celebrate': celebrate,
    'campaign': campaign,
    'flag': flag,
    'face': face,
    'forum': forum,
    'grid': grid,
    'insights': insights,
    'science': science,
    'crop': crop,
    'bookmark': bookmark,
    'personAdd': personAdd,
    'personRemove': personRemove,
    'doneAll': doneAll,
    'forward': forward,
    'book': book,
    'quote': quote,
    'briefcase': briefcase,
  };
}
