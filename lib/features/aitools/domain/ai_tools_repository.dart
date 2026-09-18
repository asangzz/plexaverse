import 'festive_template.dart';
import 'headshot_session.dart';
import 'studio_template.dart';

/// The seam between the three AI-tool surfaces and the mobile API.
///
/// Every method maps to exactly one route in `core/network/api_paths.dart`.
/// Where the web calls something mobile does not expose there is deliberately
/// **no method here** and the screen says so instead of rendering a dead
/// control. Three such holes exist in this slice and they are worth naming,
/// because each one is a feature the web has and the app cannot fake:
///
///   • `GET /studio/templates/[id]` and `POST /studio/customize` — the web's
///     `TemplateCustomizer` fills a template's named layers and exports a PNG.
///     Mobile has neither route, so Reimagine offers the copy action only.
///   • `POST /ai/studio-reimagine` — the "AI Spark" re-render inside the
///     Studio canvas. There is no canvas on the phone and no mobile route.
///   • `POST /roadmap/progress` with `{task:'complete_step', levelId, stepId}`
///     is exposed (`ApiPaths.roadmapProgress`), but the roadmap is another
///     slice's; Headshots reports the hand-off rather than reaching into it.
abstract class AiToolsRepository {
  /// `GET /studio/templates` — Reimagine's gallery.
  ///
  /// The category filter is applied client-side even though the route accepts
  /// `?category=`: the web fetches once and filters in memory, so tapping a
  /// chip is instant and costs no request. Passing [category] here is for the
  /// case where a screen wants the server to narrow it.
  Future<List<StudioTemplate>> fetchStudioTemplates({String? category});

  /// `POST /studio/copy` — duplicate a template into the user's own designs.
  ///
  /// The copy is never public and never a template, whatever the source was.
  Future<StudioTemplate> copyStudioTemplate({
    required String sourceId,
    required String name,
  });

  /// `GET /festive/templates`.
  Future<FestiveGallery> fetchFestiveTemplates({String? category});

  /// `POST /festive/generate` — 800 XP. Returns the poster as a data URI.
  Future<FestivePoster> generateFestivePoster({
    required String templateId,
    required FestiveCustomizations customizations,
  });

  /// `POST /ai/headshot` — 1200 XP on mobile (the web's copy still says 1000;
  /// the server's `AI_GENERATE_HEADSHOT` is the number that is actually
  /// charged, so the app quotes the server).
  ///
  /// Needs at least [minHeadshotPhotos] reference photos as data URIs.
  Future<HeadshotResult> generateHeadshots({
    required List<String> photos,
    required HeadshotStyle style,
    required HeadshotBackground background,
  });

  /// `POST /upload/image` — put an inline data URI into storage and get a
  /// durable public URL back.
  ///
  /// This is what makes a generated poster usable anywhere else: LinkedIn
  /// cannot fetch a `data:` URI, and neither can the composer.
  Future<String> uploadDataUri(String dataUri);

  /// `POST /roadmap/progress` — mark a roadmap step complete. Idempotent.
  ///
  /// Headshots is Level 1 Step 5 of the roadmap and "Finish step" is part of
  /// what the page IS, so the call lives here rather than being dropped. The
  /// roadmap's own providers are another slice's and this cannot invalidate
  /// them; the screen therefore says the step is done and lets the dashboard
  /// pick it up on its next read, which it does.
  ///
  /// Note the mobile route takes `{levelId, stepId}` only — the web's
  /// `{task: 'complete_step', …}` field has no counterpart and sending it
  /// would be ignored.
  Future<void> completeRoadmapStep({required int levelId, required int stepId});
}
