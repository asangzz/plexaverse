// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_write_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every write the Settings screen can start, and which of them are open.
///
/// ## Why the flags are here and not on the sections
///
/// Each of these used to be a `_saving` / `_busy` / `_connecting` field on the
/// widget that owned the button. ARCHITECTURE.md's rule — "if the widget were
/// disposed mid-operation, or a second screen asked the same question, would
/// the answer be wrong?" — answers yes for all of them: the PATCH keeps
/// running after a back-swipe, but the flag that said so died with the screen,
/// so a user who left and came back found a Save button that was enabled while
/// their previous save was still in flight.
///
/// ## Why one controller rather than one per section
///
/// [settings_controllers.dart] splits the READS deliberately — a combined
/// fetch makes Slack being down take the whole page with it. In-flight flags
/// have no such blast radius: there is nothing for them to fail at
/// independently. What they do need is to say WHICH operation is open, which
/// is why the state is a set of keys and not a single bool. A screen-wide
/// `_busy` is the defect behind "pausing one schedule greyed out every other
/// row", and collapsing these eight into one flag would reintroduce it here.
///
/// ## Why it is `autoDispose`
///
/// The flag is worth losing when the screen goes; the WORK is not, and it is
/// not lost — every method below delegates to a controller that outlives this
/// one ([PreferencesController] is held by the router's onboarding gate), so a
/// write that started keeps running and its result still lands. Only the
/// "is it open" answer goes, and by then nobody is asking. Each section
/// watches its own key, which is also what keeps this element alive for the
/// length of its own write.

@ProviderFor(SettingsWriteController)
final settingsWriteControllerProvider = SettingsWriteControllerProvider._();

/// Every write the Settings screen can start, and which of them are open.
///
/// ## Why the flags are here and not on the sections
///
/// Each of these used to be a `_saving` / `_busy` / `_connecting` field on the
/// widget that owned the button. ARCHITECTURE.md's rule — "if the widget were
/// disposed mid-operation, or a second screen asked the same question, would
/// the answer be wrong?" — answers yes for all of them: the PATCH keeps
/// running after a back-swipe, but the flag that said so died with the screen,
/// so a user who left and came back found a Save button that was enabled while
/// their previous save was still in flight.
///
/// ## Why one controller rather than one per section
///
/// [settings_controllers.dart] splits the READS deliberately — a combined
/// fetch makes Slack being down take the whole page with it. In-flight flags
/// have no such blast radius: there is nothing for them to fail at
/// independently. What they do need is to say WHICH operation is open, which
/// is why the state is a set of keys and not a single bool. A screen-wide
/// `_busy` is the defect behind "pausing one schedule greyed out every other
/// row", and collapsing these eight into one flag would reintroduce it here.
///
/// ## Why it is `autoDispose`
///
/// The flag is worth losing when the screen goes; the WORK is not, and it is
/// not lost — every method below delegates to a controller that outlives this
/// one ([PreferencesController] is held by the router's onboarding gate), so a
/// write that started keeps running and its result still lands. Only the
/// "is it open" answer goes, and by then nobody is asking. Each section
/// watches its own key, which is also what keeps this element alive for the
/// length of its own write.
final class SettingsWriteControllerProvider
    extends $NotifierProvider<SettingsWriteController, Set<String>> {
  /// Every write the Settings screen can start, and which of them are open.
  ///
  /// ## Why the flags are here and not on the sections
  ///
  /// Each of these used to be a `_saving` / `_busy` / `_connecting` field on the
  /// widget that owned the button. ARCHITECTURE.md's rule — "if the widget were
  /// disposed mid-operation, or a second screen asked the same question, would
  /// the answer be wrong?" — answers yes for all of them: the PATCH keeps
  /// running after a back-swipe, but the flag that said so died with the screen,
  /// so a user who left and came back found a Save button that was enabled while
  /// their previous save was still in flight.
  ///
  /// ## Why one controller rather than one per section
  ///
  /// [settings_controllers.dart] splits the READS deliberately — a combined
  /// fetch makes Slack being down take the whole page with it. In-flight flags
  /// have no such blast radius: there is nothing for them to fail at
  /// independently. What they do need is to say WHICH operation is open, which
  /// is why the state is a set of keys and not a single bool. A screen-wide
  /// `_busy` is the defect behind "pausing one schedule greyed out every other
  /// row", and collapsing these eight into one flag would reintroduce it here.
  ///
  /// ## Why it is `autoDispose`
  ///
  /// The flag is worth losing when the screen goes; the WORK is not, and it is
  /// not lost — every method below delegates to a controller that outlives this
  /// one ([PreferencesController] is held by the router's onboarding gate), so a
  /// write that started keeps running and its result still lands. Only the
  /// "is it open" answer goes, and by then nobody is asking. Each section
  /// watches its own key, which is also what keeps this element alive for the
  /// length of its own write.
  SettingsWriteControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsWriteControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsWriteControllerHash();

  @$internal
  @override
  SettingsWriteController create() => SettingsWriteController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$settingsWriteControllerHash() =>
    r'fd4f6aeb20eb356a37207867b2d0787155d43ec8';

/// Every write the Settings screen can start, and which of them are open.
///
/// ## Why the flags are here and not on the sections
///
/// Each of these used to be a `_saving` / `_busy` / `_connecting` field on the
/// widget that owned the button. ARCHITECTURE.md's rule — "if the widget were
/// disposed mid-operation, or a second screen asked the same question, would
/// the answer be wrong?" — answers yes for all of them: the PATCH keeps
/// running after a back-swipe, but the flag that said so died with the screen,
/// so a user who left and came back found a Save button that was enabled while
/// their previous save was still in flight.
///
/// ## Why one controller rather than one per section
///
/// [settings_controllers.dart] splits the READS deliberately — a combined
/// fetch makes Slack being down take the whole page with it. In-flight flags
/// have no such blast radius: there is nothing for them to fail at
/// independently. What they do need is to say WHICH operation is open, which
/// is why the state is a set of keys and not a single bool. A screen-wide
/// `_busy` is the defect behind "pausing one schedule greyed out every other
/// row", and collapsing these eight into one flag would reintroduce it here.
///
/// ## Why it is `autoDispose`
///
/// The flag is worth losing when the screen goes; the WORK is not, and it is
/// not lost — every method below delegates to a controller that outlives this
/// one ([PreferencesController] is held by the router's onboarding gate), so a
/// write that started keeps running and its result still lands. Only the
/// "is it open" answer goes, and by then nobody is asking. Each section
/// watches its own key, which is also what keeps this element alive for the
/// length of its own write.

abstract class _$SettingsWriteController extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
