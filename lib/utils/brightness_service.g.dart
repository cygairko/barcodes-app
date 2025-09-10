// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brightness_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(brightnessService)
const brightnessServiceProvider = BrightnessServiceProvider._();

final class BrightnessServiceProvider
    extends
        $FunctionalProvider<
          BrightnessService,
          BrightnessService,
          BrightnessService
        >
    with $Provider<BrightnessService> {
  const BrightnessServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brightnessServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brightnessServiceHash();

  @$internal
  @override
  $ProviderElement<BrightnessService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BrightnessService create(Ref ref) {
    return brightnessService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrightnessService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrightnessService>(value),
    );
  }
}

String _$brightnessServiceHash() => r'e3d32e70837dc353320cbd04622e7979c8f9fb53';
