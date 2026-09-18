import '../../domain/studio_design.dart';

/// The page sizes a design can be, transcribed verbatim from
/// `CANVAS_PRESETS` in the web's `/template-creator`.
///
/// The same eight are offered by the new-design sheet in Studio, so they live
/// here rather than twice: a size that exists in one place and not the other
/// is exactly the kind of drift that makes two platforms feel like two
/// products.
///
/// The web pairs each with an emoji. Zave does not use emoji as iconography —
/// colour and type carry meaning here — so the dimensions do the work instead,
/// which is also what a user actually picks on.
class CanvasPreset {
  const CanvasPreset(this.name, this.width, this.height);

  final String name;
  final double width;
  final double height;

  StudioCanvas get canvas => StudioCanvas(width: width, height: height);

  String get dimensions => '${width.round()} × ${height.round()}';

  static const List<CanvasPreset> all = <CanvasPreset>[
    CanvasPreset('Instagram Post', 1080, 1080),
    CanvasPreset('Instagram Story', 1080, 1920),
    CanvasPreset('LinkedIn Post', 1200, 628),
    CanvasPreset('Twitter/X Post', 1600, 900),
    CanvasPreset('Facebook Cover', 1640, 624),
    CanvasPreset('YouTube Thumbnail', 1280, 720),
    CanvasPreset('Poster (A4)', 2480, 3508),
    CanvasPreset('Presentation', 1920, 1080),
  ];

  /// The web's default, and the right one here too — a square poster is what
  /// the auto-post pipeline produces.
  static const CanvasPreset instagramPost = CanvasPreset(
    'Instagram Post',
    1080,
    1080,
  );
}

/// The visual register a generated template takes, from `STYLES` on the web.
///
/// `copy_original` is the web's default and stays the default here.
class TemplateStyle {
  const TemplateStyle(this.id, this.name, this.description);

  final String id;
  final String name;
  final String description;

  static const List<TemplateStyle> all = <TemplateStyle>[
    TemplateStyle(
      'copy_original',
      'Match Reference',
      'Replicate original style & layout closely',
    ),
    TemplateStyle('minimal', 'Minimal', 'Clean, simple, lots of white space'),
    TemplateStyle('vibrant', 'Vibrant', 'Bold colors, energetic, modern'),
    TemplateStyle('corporate', 'Corporate', 'Professional, business-oriented'),
    TemplateStyle('creative', 'Creative', 'Artistic, unique, expressive'),
  ];
}

/// Template categories, from `CATEGORIES` on the web.
///
/// The web renders the SAME enum under two different label sets (its Edit
/// modal says "Social Media", its Save modal says "Social Engine"). That is
/// almost certainly unintentional, so one label set is used here — the plain
/// one, title-cased from the stored value, which is also what
/// [StudioDesign.categoryLabel] produces so a category reads the same in the
/// library as in the picker.
const List<String> kTemplateCategories = <String>[
  'social_media',
  'automate_posts_personal',
  'automate_posts_company',
  'marketing',
  'presentation',
  'banner',
  'infographic',
  'general',
];

/// `automate_posts_company` → "Automate Posts Company".
String categoryLabel(String raw) => raw
    .split('_')
    .where((String w) => w.isNotEmpty)
    .map((String w) => '${w[0].toUpperCase()}${w.substring(1)}')
    .join(' ');
