// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsRepository)
const settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  const SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'49ad17730608151ac0ace54ab7b0875c4103f589';

@ProviderFor(automaticScreenBrightness)
const automaticScreenBrightnessProvider = AutomaticScreenBrightnessProvider._();

final class AutomaticScreenBrightnessProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const AutomaticScreenBrightnessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'automaticScreenBrightnessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$automaticScreenBrightnessHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return automaticScreenBrightness(ref);
  }
}

String _$automaticScreenBrightnessHash() =>
    r'56f4c6664049c468ea1130887ec8b91285742458';

@ProviderFor(maxScreenBrightnessLevel)
const maxScreenBrightnessLevelProvider = MaxScreenBrightnessLevelProvider._();

final class MaxScreenBrightnessLevelProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  const MaxScreenBrightnessLevelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maxScreenBrightnessLevelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maxScreenBrightnessLevelHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return maxScreenBrightnessLevel(ref);
  }
}

String _$maxScreenBrightnessLevelHash() =>
    r'130c3b84cead305df15e202c0b236e1aa5f6d9df';

@ProviderFor(barcodeDisplayMode)
const barcodeDisplayModeProvider = BarcodeDisplayModeProvider._();

final class BarcodeDisplayModeProvider
    extends
        $FunctionalProvider<
          AsyncValue<BarcodeDisplayMode>,
          BarcodeDisplayMode,
          FutureOr<BarcodeDisplayMode>
        >
    with
        $FutureModifier<BarcodeDisplayMode>,
        $FutureProvider<BarcodeDisplayMode> {
  const BarcodeDisplayModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barcodeDisplayModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barcodeDisplayModeHash();

  @$internal
  @override
  $FutureProviderElement<BarcodeDisplayMode> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BarcodeDisplayMode> create(Ref ref) {
    return barcodeDisplayMode(ref);
  }
}

String _$barcodeDisplayModeHash() =>
    r'd34d4ba243dc97cc395186fd912e3114ad160823';
