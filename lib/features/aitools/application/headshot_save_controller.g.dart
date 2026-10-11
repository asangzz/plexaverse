// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'headshot_save_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which generated portraits are being handed to the share sheet.
///
/// ## Why this is not a `_busy` on the Save button
///
/// It was one, on the `State` of the button beside each portrait. The download
/// keeps running after the results step is rebuilt — and the results step IS
/// rebuilt, every time [HeadshotsController] publishes a new session — so the
/// flag that said a save was open died with the widget that started it and the
/// button came back enabled on top of its own in-flight download.
///
/// ## Why a set of indexes and not one bool
///
/// There are four portraits and four buttons. A single flag would grey out all
/// four because one was saving, which is the "pausing one schedule greyed out
/// every other row" defect at a smaller scale. The index is the key, exactly as
/// settings keys its writes by name.
///
/// ## Why it is not a field on [HeadshotSession]
///
/// [HeadshotSession] models the wizard the SERVER knows about — the step, the
/// photos, the generation, the roadmap credit. A share sheet the user may
/// dismiss is none of those things and has no bearing on what `/ai/headshot`
/// was asked for; folding it in would make a value that is about one request
/// also about something that never leaves the phone.

@ProviderFor(HeadshotSaveController)
final headshotSaveControllerProvider = HeadshotSaveControllerProvider._();

/// Which generated portraits are being handed to the share sheet.
///
/// ## Why this is not a `_busy` on the Save button
///
/// It was one, on the `State` of the button beside each portrait. The download
/// keeps running after the results step is rebuilt — and the results step IS
/// rebuilt, every time [HeadshotsController] publishes a new session — so the
/// flag that said a save was open died with the widget that started it and the
/// button came back enabled on top of its own in-flight download.
///
/// ## Why a set of indexes and not one bool
///
/// There are four portraits and four buttons. A single flag would grey out all
/// four because one was saving, which is the "pausing one schedule greyed out
/// every other row" defect at a smaller scale. The index is the key, exactly as
/// settings keys its writes by name.
///
/// ## Why it is not a field on [HeadshotSession]
///
/// [HeadshotSession] models the wizard the SERVER knows about — the step, the
/// photos, the generation, the roadmap credit. A share sheet the user may
/// dismiss is none of those things and has no bearing on what `/ai/headshot`
/// was asked for; folding it in would make a value that is about one request
/// also about something that never leaves the phone.
final class HeadshotSaveControllerProvider
    extends $NotifierProvider<HeadshotSaveController, Set<int>> {
  /// Which generated portraits are being handed to the share sheet.
  ///
  /// ## Why this is not a `_busy` on the Save button
  ///
  /// It was one, on the `State` of the button beside each portrait. The download
  /// keeps running after the results step is rebuilt — and the results step IS
  /// rebuilt, every time [HeadshotsController] publishes a new session — so the
  /// flag that said a save was open died with the widget that started it and the
  /// button came back enabled on top of its own in-flight download.
  ///
  /// ## Why a set of indexes and not one bool
  ///
  /// There are four portraits and four buttons. A single flag would grey out all
  /// four because one was saving, which is the "pausing one schedule greyed out
  /// every other row" defect at a smaller scale. The index is the key, exactly as
  /// settings keys its writes by name.
  ///
  /// ## Why it is not a field on [HeadshotSession]
  ///
  /// [HeadshotSession] models the wizard the SERVER knows about — the step, the
  /// photos, the generation, the roadmap credit. A share sheet the user may
  /// dismiss is none of those things and has no bearing on what `/ai/headshot`
  /// was asked for; folding it in would make a value that is about one request
  /// also about something that never leaves the phone.
  HeadshotSaveControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'headshotSaveControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$headshotSaveControllerHash();

  @$internal
  @override
  HeadshotSaveController create() => HeadshotSaveController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<int>>(value),
    );
  }
}

String _$headshotSaveControllerHash() =>
    r'0b5d4e6ce8ca943eef3b5e4f55e3b5830cd0dc2f';

/// Which generated portraits are being handed to the share sheet.
///
/// ## Why this is not a `_busy` on the Save button
///
/// It was one, on the `State` of the button beside each portrait. The download
/// keeps running after the results step is rebuilt — and the results step IS
/// rebuilt, every time [HeadshotsController] publishes a new session — so the
/// flag that said a save was open died with the widget that started it and the
/// button came back enabled on top of its own in-flight download.
///
/// ## Why a set of indexes and not one bool
///
/// There are four portraits and four buttons. A single flag would grey out all
/// four because one was saving, which is the "pausing one schedule greyed out
/// every other row" defect at a smaller scale. The index is the key, exactly as
/// settings keys its writes by name.
///
/// ## Why it is not a field on [HeadshotSession]
///
/// [HeadshotSession] models the wizard the SERVER knows about — the step, the
/// photos, the generation, the roadmap credit. A share sheet the user may
/// dismiss is none of those things and has no bearing on what `/ai/headshot`
/// was asked for; folding it in would make a value that is about one request
/// also about something that never leaves the phone.

abstract class _$HeadshotSaveController extends $Notifier<Set<int>> {
  Set<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<int>, Set<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<int>, Set<int>>,
              Set<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
