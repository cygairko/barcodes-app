// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(barcodeRepository)
const barcodeRepositoryProvider = BarcodeRepositoryProvider._();

final class BarcodeRepositoryProvider
    extends
        $FunctionalProvider<
          BarcodeRepository,
          BarcodeRepository,
          BarcodeRepository
        >
    with $Provider<BarcodeRepository> {
  const BarcodeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barcodeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barcodeRepositoryHash();

  @$internal
  @override
  $ProviderElement<BarcodeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BarcodeRepository create(Ref ref) {
    return barcodeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BarcodeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BarcodeRepository>(value),
    );
  }
}

String _$barcodeRepositoryHash() => r'9c73fcdd40549ecf34f86f66ab39c3b5ab37bc47';

@ProviderFor(barcodesStream)
const barcodesStreamProvider = BarcodesStreamProvider._();

final class BarcodesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BarcodeEntry>>,
          List<BarcodeEntry>,
          Stream<List<BarcodeEntry>>
        >
    with
        $FutureModifier<List<BarcodeEntry>>,
        $StreamProvider<List<BarcodeEntry>> {
  const BarcodesStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barcodesStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barcodesStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<BarcodeEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BarcodeEntry>> create(Ref ref) {
    return barcodesStream(ref);
  }
}

String _$barcodesStreamHash() => r'c0bd3932abe84cfebe627cce1139cbdc35e5dd7d';

@ProviderFor(barcodeStream)
const barcodeStreamProvider = BarcodeStreamFamily._();

final class BarcodeStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<BarcodeEntry?>,
          BarcodeEntry?,
          Stream<BarcodeEntry?>
        >
    with $FutureModifier<BarcodeEntry?>, $StreamProvider<BarcodeEntry?> {
  const BarcodeStreamProvider._({
    required BarcodeStreamFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'barcodeStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$barcodeStreamHash();

  @override
  String toString() {
    return r'barcodeStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<BarcodeEntry?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<BarcodeEntry?> create(Ref ref) {
    final argument = this.argument as int;
    return barcodeStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BarcodeStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$barcodeStreamHash() => r'866a82c5060266c11e38230cef098a2ab5b5e852';

final class BarcodeStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<BarcodeEntry?>, int> {
  const BarcodeStreamFamily._()
    : super(
        retry: null,
        name: r'barcodeStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BarcodeStreamProvider call(int entryId) =>
      BarcodeStreamProvider._(argument: entryId, from: this);

  @override
  String toString() => r'barcodeStreamProvider';
}
