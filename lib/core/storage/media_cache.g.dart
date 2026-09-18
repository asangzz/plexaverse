// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_cache.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mediaCache)
final mediaCacheProvider = MediaCacheProvider._();

final class MediaCacheProvider
    extends
        $FunctionalProvider<
          AsyncValue<MediaCache>,
          MediaCache,
          FutureOr<MediaCache>
        >
    with $FutureModifier<MediaCache>, $FutureProvider<MediaCache> {
  MediaCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaCacheHash();

  @$internal
  @override
  $FutureProviderElement<MediaCache> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<MediaCache> create(Ref ref) {
    return mediaCache(ref);
  }
}

String _$mediaCacheHash() => r'55990bdf874b5841714c6bbb384765a03a3f6c07';
