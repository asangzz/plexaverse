import 'ai_designer.dart';
import 'studio_design.dart';

/// Reads and writes Plexa Studio.
///
/// Backed by `/studio/*` on the mobile API. Every method here corresponds to a
/// route handler that exists under `app/api/mobile/v1/studio/`; there is no
/// method for the web editor's Figma import, SVG export or HTML→design
/// conversion, because those have no mobile route and inventing one would
/// produce a control that 404s behind a `catch`.
abstract class StudioRepository {
  /// Whether Studio is unlocked, and the XP price. Cheap and safe to call on
  /// every Studio render.
  Future<StudioAccess> fetchAccess();

  /// Spends the XP. Idempotent server-side — a second call after unlock
  /// reports `alreadyUnlocked` and charges nothing.
  Future<StudioUnlockResult> unlock();

  /// The user's own designs, newest-updated first. `data` is omitted by the
  /// server to keep the list small, so these are summaries.
  Future<List<StudioDesign>> listDesigns();

  /// Public designs plus the user's own templates.
  Future<List<StudioDesign>> listTemplates({String? category});

  /// One design, with its full `data` tree.
  Future<StudioDesign> fetchDesign(String id);

  /// Creates a design.
  ///
  /// On the web this opens an empty vector canvas. On a phone there is no
  /// canvas, so a blank design exists to be FILLED BY THE AI DESIGNER — which
  /// is why the only thing this takes is a name and a page size.
  Future<StudioDesign> createDesign({
    required String name,
    required StudioCanvas canvas,
  });

  /// Saves an edited design. PATCH, not PUT — the mobile API exposes no PUT,
  /// deliberately, so an omitted field can never blank a column.
  Future<StudioDesign> updateDesign(
    String id, {
    String? name,
    String? description,
    StudioDesignData? data,
  });

  Future<void> deleteDesign(String id);

  /// Copies a template into the user's own designs. The copy is never itself
  /// a template and never public, whatever the source was.
  Future<StudioDesign> copyDesign({required String sourceId, String? name});

  /// One turn of the AI Designer conversation.
  ///
  /// [history] is the whole conversation so far — the route is stateless and
  /// re-reads it every time. [currentDesign] is what the canvas holds now, so
  /// "make it more minimal" has something to be minimal ABOUT.
  Future<AiDesignerReply> askDesigner({
    required List<AiDesignerTurn> history,
    required StudioCanvas canvas,
    StudioDesignData? currentDesign,
  });

  /// Generates a replacement image for an image layer and returns its
  /// `data:image/…;base64,…` URI.
  ///
  /// This is the phone's answer to the web's "swap this image" file picker:
  /// the app ships no photo-library plugin, and an AI image is a better
  /// default on a phone than a URL the user has to find anyway.
  Future<String> generateImage({
    required String prompt,
    required String aspectRatio,
  });
}
