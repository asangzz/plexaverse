import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/studio_repositories.dart';
import '../domain/studio_design.dart';

part 'studio_controller.g.dart';

/// Whether Studio is unlocked.
///
/// Every Studio surface watches this, so it is the one place the XP gate is
/// decided. Kept as its own controller rather than folded into the library so
/// that unlocking re-renders the gate without re-fetching the design list —
/// and so the list's own failure cannot be mistaken for "you don't have
/// access", which is the confusing failure this split exists to prevent.
@riverpod
class StudioAccessController extends _$StudioAccessController {
  @override
  Future<StudioAccess> build() =>
      ref.watch(studioRepositoryProvider).fetchAccess();

  /// Spends the XP and re-reads.
  ///
  /// Not optimistic: this one costs the user something, and a gate that opens
  /// before the server agreed is the wrong kind of confident. The screen falls
  /// back to its loading state for the round trip rather than holding the
  /// stale balance under a spinner — a one-time purchase is the wrong place to
  /// show a number that is about to change.
  Future<void> unlock() async {
    state = const AsyncLoading<StudioAccess>();
    state = await AsyncValue.guard(() async {
      await ref.read(studioRepositoryProvider).unlock();
      return ref.read(studioRepositoryProvider).fetchAccess();
    });
  }
}

/// The user's saved designs.
@riverpod
class StudioDesignsController extends _$StudioDesignsController {
  @override
  Future<List<StudioDesign>> build() =>
      ref.watch(studioRepositoryProvider).listDesigns();

  /// Deletes a design and drops it from the list.
  ///
  /// Optimistic, because the confirmation sheet has already asked. A failure
  /// puts the server's truth back rather than leaving a row that looks gone.
  Future<void> delete(String id) async {
    final List<StudioDesign>? current = state.value;
    if (current == null) return;
    state = AsyncData<List<StudioDesign>>(
      current.where((StudioDesign d) => d.id != id).toList(growable: false),
    );
    try {
      await ref.read(studioRepositoryProvider).deleteDesign(id);
    } on Object {
      ref.invalidateSelf();
    }
  }

  /// Creates an empty design of [canvas]'s shape and returns it.
  ///
  /// An empty design is not a dead end on a phone: the AI Designer writes a
  /// whole poster into it. That is the mobile equivalent of the web's "+
  /// Project", which opens a blank vector canvas the phone does not have.
  Future<StudioDesign> create({
    required String name,
    required StudioCanvas canvas,
  }) async {
    final StudioDesign created = await ref
        .read(studioRepositoryProvider)
        .createDesign(name: name, canvas: canvas);
    ref.invalidateSelf();
    return created;
  }

  /// Renames a design in place.
  Future<void> rename(String id, String name) async {
    try {
      await ref.read(studioRepositoryProvider).updateDesign(id, name: name);
    } finally {
      ref.invalidateSelf();
    }
  }

  void refresh() => ref.invalidateSelf();
}

/// Templates the user may start from — public designs plus their own.
///
/// Separate from the design list because it is a different question ("what
/// could I start from") asked against a different endpoint, and because a
/// template fetch failing must not empty the user's own work.
@riverpod
class StudioTemplatesController extends _$StudioTemplatesController {
  @override
  Future<List<StudioDesign>> build() =>
      ref.watch(studioRepositoryProvider).listTemplates();

  /// Copies a template into the user's designs and returns the new row.
  ///
  /// The copy is never itself a template and never public — the server
  /// enforces that regardless of the source's flags, so the client does not
  /// need to (and must not be trusted to) pass those through.
  Future<StudioDesign> use(String templateId, {String? name}) async {
    final StudioDesign copy = await ref
        .read(studioRepositoryProvider)
        .copyDesign(sourceId: templateId, name: name);
    ref.invalidate(studioDesignsControllerProvider);
    return copy;
  }
}
