// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_cache_sweeper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mediaCacheSweeper)
final mediaCacheSweeperProvider = MediaCacheSweeperProvider._();

final class MediaCacheSweeperProvider
    extends
        $FunctionalProvider<
          AsyncValue<MediaCacheSweeper>,
          MediaCacheSweeper,
          FutureOr<MediaCacheSweeper>
        >
    with
        $FutureModifier<MediaCacheSweeper>,
        $FutureProvider<MediaCacheSweeper> {
  MediaCacheSweeperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaCacheSweeperProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaCacheSweeperHash();

  @$internal
  @override
  $FutureProviderElement<MediaCacheSweeper> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MediaCacheSweeper> create(Ref ref) {
    return mediaCacheSweeper(ref);
  }
}

String _$mediaCacheSweeperHash() => r'cd1faf46c809f6c3741fa0eaec4d17f3d53c2456';
