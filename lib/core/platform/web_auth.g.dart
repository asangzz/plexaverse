// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_auth.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(webAuthService)
final webAuthServiceProvider = WebAuthServiceProvider._();

final class WebAuthServiceProvider
    extends $FunctionalProvider<WebAuthService, WebAuthService, WebAuthService>
    with $Provider<WebAuthService> {
  WebAuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webAuthServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webAuthServiceHash();

  @$internal
  @override
  $ProviderElement<WebAuthService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WebAuthService create(Ref ref) {
    return webAuthService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebAuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebAuthService>(value),
    );
  }
}

String _$webAuthServiceHash() => r'8beda632f975c33699bb03af50503a1019ad4e83';
