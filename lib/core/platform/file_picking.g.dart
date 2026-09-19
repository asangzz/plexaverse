// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_picking.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(filePicking)
final filePickingProvider = FilePickingProvider._();

final class FilePickingProvider
    extends
        $FunctionalProvider<
          FilePickingService,
          FilePickingService,
          FilePickingService
        >
    with $Provider<FilePickingService> {
  FilePickingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filePickingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filePickingHash();

  @$internal
  @override
  $ProviderElement<FilePickingService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FilePickingService create(Ref ref) {
    return filePicking(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FilePickingService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FilePickingService>(value),
    );
  }
}

String _$filePickingHash() => r'6f713cc5eb5ea2ba4539dd0e813637cf6a95897a';
