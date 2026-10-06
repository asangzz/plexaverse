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
  ); // linkedin (brand)

  /// Every icon in the vocabulary with its semantic name — drives the style
  /// guide's icon gallery so the set stays self-documenting.
  static const Map<String, IconData> all = <String, IconData>{
    'home': home,
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
  };
}
