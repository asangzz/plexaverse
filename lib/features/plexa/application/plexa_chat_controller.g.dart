// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plexa_chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Builds the sheet's conversation, wired to its dependencies.
///
/// ## Why a factory and not a Notifier
///
/// [PlexaChatController] is a ChangeNotifier on purpose: the conversation is
/// per-sheet, it is driven by a typing script rather than by state
/// replacement, and twenty-odd tests construct it directly against a fake
/// repository. Rewriting it as a Notifier to satisfy the annotation rule
/// would change all of that to remove one import.
///
/// What was actually wrong is that the SHEET built it, and therefore had to
/// read `plexaRepositoryProvider` itself — presentation importing data/,
/// which is the dependency arrow backwards and the last such import in the
/// app. The construction belongs here, where reaching for a repository is
/// this layer's job.
///
/// autoDispose, so the lifetime still matches the sheet exactly: created when
/// the sheet first watches it, disposed when the sheet closes and the last
/// listener goes. Reopening deals a fresh conversation, which is what it did
/// before.

@ProviderFor(plexaChat)
final plexaChatProvider = PlexaChatProvider._();

/// Builds the sheet's conversation, wired to its dependencies.
///
/// ## Why a factory and not a Notifier
///
/// [PlexaChatController] is a ChangeNotifier on purpose: the conversation is
/// per-sheet, it is driven by a typing script rather than by state
/// replacement, and twenty-odd tests construct it directly against a fake
/// repository. Rewriting it as a Notifier to satisfy the annotation rule
/// would change all of that to remove one import.
///
/// What was actually wrong is that the SHEET built it, and therefore had to
/// read `plexaRepositoryProvider` itself — presentation importing data/,
/// which is the dependency arrow backwards and the last such import in the
/// app. The construction belongs here, where reaching for a repository is
/// this layer's job.
///
/// autoDispose, so the lifetime still matches the sheet exactly: created when
/// the sheet first watches it, disposed when the sheet closes and the last
/// listener goes. Reopening deals a fresh conversation, which is what it did
/// before.

final class PlexaChatProvider
    extends
        $FunctionalProvider<
          PlexaChatController,
          PlexaChatController,
          PlexaChatController
        >
    with $Provider<PlexaChatController> {
  /// Builds the sheet's conversation, wired to its dependencies.
  ///
  /// ## Why a factory and not a Notifier
  ///
  /// [PlexaChatController] is a ChangeNotifier on purpose: the conversation is
  /// per-sheet, it is driven by a typing script rather than by state
  /// replacement, and twenty-odd tests construct it directly against a fake
  /// repository. Rewriting it as a Notifier to satisfy the annotation rule
  /// would change all of that to remove one import.
  ///
  /// What was actually wrong is that the SHEET built it, and therefore had to
  /// read `plexaRepositoryProvider` itself — presentation importing data/,
  /// which is the dependency arrow backwards and the last such import in the
  /// app. The construction belongs here, where reaching for a repository is
  /// this layer's job.
  ///
  /// autoDispose, so the lifetime still matches the sheet exactly: created when
  /// the sheet first watches it, disposed when the sheet closes and the last
  /// listener goes. Reopening deals a fresh conversation, which is what it did
  /// before.
  PlexaChatProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plexaChatProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plexaChatHash();

  @$internal
  @override
  $ProviderElement<PlexaChatController> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlexaChatController create(Ref ref) {
    return plexaChat(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlexaChatController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlexaChatController>(value),
    );
  }
}

String _$plexaChatHash() => r'959f483b599d2db73dd302dcc51572f27b2f1f66';
