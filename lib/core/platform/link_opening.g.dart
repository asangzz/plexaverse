// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_opening.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(linkOpening)
final linkOpeningProvider = LinkOpeningProvider._();

final class LinkOpeningProvider
    extends
        $FunctionalProvider<
          LinkOpeningService,
          LinkOpeningService,
          LinkOpeningService
        >
    with $Provider<LinkOpeningService> {
  LinkOpeningProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkOpeningProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkOpeningHash();

  @$internal
  @override
  $ProviderElement<LinkOpeningService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LinkOpeningService create(Ref ref) {
    return linkOpening(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LinkOpeningService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LinkOpeningService>(value),
    );
  }
}

String _$linkOpeningHash() => r'79344fa23c357addcbb69246b23d88f9deb1566b';
