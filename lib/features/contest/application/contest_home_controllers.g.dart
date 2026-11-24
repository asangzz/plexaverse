// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_home_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The path level whose card is open, or null. One card at a time: opening a
/// level closes the last one, and a second tap on the same level closes it.
///
/// Dies with the path, so the page opens with every card shut — as the web's
/// does on each visit.

@ProviderFor(ContestOpenNode)
final contestOpenNodeProvider = ContestOpenNodeProvider._();

/// The path level whose card is open, or null. One card at a time: opening a
/// level closes the last one, and a second tap on the same level closes it.
///
/// Dies with the path, so the page opens with every card shut — as the web's
/// does on each visit.
final class ContestOpenNodeProvider
    extends $NotifierProvider<ContestOpenNode, String?> {
  /// The path level whose card is open, or null. One card at a time: opening a
  /// level closes the last one, and a second tap on the same level closes it.
  ///
  /// Dies with the path, so the page opens with every card shut — as the web's
  /// does on each visit.
  ContestOpenNodeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contestOpenNodeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contestOpenNodeHash();

  @$internal
  @override
  ContestOpenNode create() => ContestOpenNode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$contestOpenNodeHash() => r'469d0724c2ee5cd15aa0cf1c33618c7318d489a6';

/// The path level whose card is open, or null. One card at a time: opening a
/// level closes the last one, and a second tap on the same level closes it.
///
/// Dies with the path, so the page opens with every card shut — as the web's
/// does on each visit.

abstract class _$ContestOpenNode extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
