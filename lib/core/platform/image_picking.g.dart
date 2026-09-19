// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_picking.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(imagePicking)
final imagePickingProvider = ImagePickingProvider._();

final class ImagePickingProvider
    extends
        $FunctionalProvider<
          ImagePickingService,
          ImagePickingService,
          ImagePickingService
        >
    with $Provider<ImagePickingService> {
  ImagePickingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imagePickingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imagePickingHash();

  @$internal
  @override
  $ProviderElement<ImagePickingService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ImagePickingService create(Ref ref) {
    return imagePicking(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImagePickingService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImagePickingService>(value),
    );
  }
}

String _$imagePickingHash() => r'0a0b5c8cd2ba0911a506bc35188daef6029aff33';
