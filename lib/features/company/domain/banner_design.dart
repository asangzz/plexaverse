import '../../studio/domain/studio_design.dart';

/// Pure transforms applied to a banner template before it is rendered.
///
/// Both are direct ports of the web's `/company-banner` page helpers. They are
/// pure functions rather than methods on [StudioDesignData] because they are
/// editorial decisions about a template, not properties of a design — the
/// Studio editor must never apply them.
///
/// They edit the TYPED tree only, which leaves [StudioDesignData.rawElements]
/// holding the server's original. That is safe here and nowhere else: the
/// banner is rendered and rasterised, never PATCHed back to `/studio/designs`.
/// Applying these to a design that WILL be saved would write the user's name
/// into the shared template.

// ── personalizeDesign ─────────────────────────────────────────────────────

const List<String> _nameTexts = <String>['your name'];
const List<String> _nameFragments = <String>['name', 'user'];

const List<String> _positionTexts = <String>[
  'position',
  'your position',
  'job title',
  'founder & ceo',
];
const List<String> _positionFragments = <String>[
  'position',
  'role',
  'title',
  'designation',
];

bool _matchesName(StudioElement el) {
  final String text = (el.text ?? '').toLowerCase();
  final String name = el.name.toLowerCase();
  return _nameTexts.contains(text) ||
      _nameFragments.any((String f) => name.contains(f));
}

bool _matchesPosition(StudioElement el) {
  final String text = (el.text ?? '').toLowerCase();
  final String name = el.name.toLowerCase();
  return _positionTexts.contains(text) ||
      text.contains('placeholder') ||
      _positionFragments.any((String f) => name.contains(f));
}

List<StudioElement> _personalizeElements(
  List<StudioElement> elements,
  String nameUpper,
  String positionUpper,
) {
  return <StudioElement>[
    for (final StudioElement el in elements)
      el.copyWith(
        // Position is evaluated AFTER name and wins when both match, exactly
        // as the web's two sequential `if`s do. An element called
        // "job-title-name" is a title, not a name — and that ordering is the
        // only thing that decides it.
        text: el.isText
            ? (_matchesPosition(el)
                  ? positionUpper
                  : (_matchesName(el) ? nameUpper : el.text))
            : el.text,
        children: el.children.isEmpty
            ? el.children
            : _personalizeElements(el.children, nameUpper, positionUpper),
      ),
  ];
}

/// Substitutes the signed-in user's name and typed position into a template's
/// placeholder text, UPPERCASED.
///
/// Matching is by literal placeholder text OR by layer name, because Studio
/// templates label their slots inconsistently — some say "Your Name" in the
/// text, others name the layer `user-name` and leave a designer's sample
/// string in it. Both conventions have to be caught or half the templates
/// ship someone else's name.
StudioDesignData personalizeDesign(
  StudioDesignData data,
  String name,
  String position,
) {
  final String nameUpper = (name.trim().isEmpty ? 'USER' : name.trim())
      .toUpperCase();
  final String positionUpper =
      (position.trim().isEmpty ? 'POSITION' : position.trim()).toUpperCase();

  return data.copyWith(
    elements: _personalizeElements(data.elements, nameUpper, positionUpper),
  );
}

// ── normalizeDesign ───────────────────────────────────────────────────────

class _Bounds {
  double minX = double.infinity;
  double minY = double.infinity;
  double maxX = double.negativeInfinity;
  double maxY = double.negativeInfinity;

  bool get isEmpty => minX == double.infinity;
}

void _accumulate(
  List<StudioElement> elements,
  _Bounds b, [
  double px = 0,
  double py = 0,
]) {
  for (final StudioElement el in elements) {
    final double gx = px + el.x;
    final double gy = py + el.y;
    if (gx < b.minX) b.minX = gx;
    if (gy < b.minY) b.minY = gy;
    if (gx + el.width > b.maxX) b.maxX = gx + el.width;
    if (gy + el.height > b.maxY) b.maxY = gy + el.height;
    if (el.children.isNotEmpty) _accumulate(el.children, b, gx, gy);
  }
}

/// Crops a design to its own content: shifts every top-level element so the
/// tightest bounding box starts at (0, 0) and resizes the canvas to that box.
///
/// Studio designs are authored on a canvas larger than the artwork, so an
/// un-normalised template renders as a small graphic floating in a sea of
/// background. Only TOP-LEVEL elements are shifted — children are positioned
/// relative to their parent, so moving them too would shift them twice.
///
/// A design with no elements is returned untouched; there is no box to crop to.
StudioDesignData normalizeDesign(StudioDesignData data) {
  final _Bounds b = _Bounds();
  _accumulate(data.elements, b);
  if (b.isEmpty) return data;

  return data.copyWith(
    canvas: data.canvas.copyWith(
      width: b.maxX - b.minX,
      height: b.maxY - b.minY,
    ),
    elements: <StudioElement>[
      for (final StudioElement el in data.elements)
        el.copyWith(x: el.x - b.minX, y: el.y - b.minY),
    ],
  );
}

/// The two transforms in the order the web applies them: personalise, then
/// crop. Reversing them would compute bounds against the sample text rather
/// than the user's, and a long job title would then overflow the crop.
StudioDesignData prepareBanner(
  StudioDesignData data,
  String name,
  String position,
) => normalizeDesign(personalizeDesign(data, name, position));
