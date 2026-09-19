// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_sharing.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(imageSharing)
final imageSharingProvider = ImageSharingProvider._();

final class ImageSharingProvider
    extends
        $FunctionalProvider<
          ImageSharingService,
          ImageSharingService,
          ImageSharingService
        >
    with $Provider<ImageSharingService> {
  ImageSharingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageSharingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageSharingHash();

  @$internal
  @override
  $ProviderElement<ImageSharingService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ImageSharingService create(Ref ref) {
    return imageSharing(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageSharingService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageSharingService>(value),
    );
  }
}

String _$imageSharingHash() => r'418c8f42678679668610c0419425920ea5ceca36';
