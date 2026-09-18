// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutation_dispatcher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mutationDispatcher)
final mutationDispatcherProvider = MutationDispatcherProvider._();

final class MutationDispatcherProvider
    extends
        $FunctionalProvider<
          MutationDispatcher,
          MutationDispatcher,
          MutationDispatcher
        >
    with $Provider<MutationDispatcher> {
  MutationDispatcherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mutationDispatcherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mutationDispatcherHash();

  @$internal
  @override
  $ProviderElement<MutationDispatcher> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MutationDispatcher create(Ref ref) {
    return mutationDispatcher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MutationDispatcher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MutationDispatcher>(value),
    );
  }
}

String _$mutationDispatcherHash() =>
    r'576baaf58c7408c28bc43a14971f7de4d1354390';
