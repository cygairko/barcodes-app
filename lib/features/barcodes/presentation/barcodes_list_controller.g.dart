// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcodes_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BarcodesListController)
const barcodesListControllerProvider = BarcodesListControllerProvider._();

final class BarcodesListControllerProvider
    extends $AsyncNotifierProvider<BarcodesListController, void> {
  const BarcodesListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barcodesListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barcodesListControllerHash();

  @$internal
  @override
  BarcodesListController create() => BarcodesListController();
}

String _$barcodesListControllerHash() =>
    r'6938aa46315e68b1a9e7a2efd85161ea733eeb3d';

abstract class _$BarcodesListController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
