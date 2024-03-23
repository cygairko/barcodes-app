// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$barcodeRepositoryHash() => r'e5a0c345ffb435471411e78f65bec2173d2fc2a1';

/// See also [barcodeRepository].
@ProviderFor(barcodeRepository)
final barcodeRepositoryProvider = Provider<BarcodeRepository>.internal(
  barcodeRepository,
  name: r'barcodeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$barcodeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BarcodeRepositoryRef = ProviderRef<BarcodeRepository>;
String _$barcodesStreamHash() => r'1e43601806c1e2a58d3d8eb36f6645b22c82842b';

/// See also [barcodesStream].
@ProviderFor(barcodesStream)
final barcodesStreamProvider =
    AutoDisposeStreamProvider<List<BarcodeEntry>>.internal(
  barcodesStream,
  name: r'barcodesStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$barcodesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BarcodesStreamRef = AutoDisposeStreamProviderRef<List<BarcodeEntry>>;
String _$barcodeStreamHash() => r'5e807cff1a059ec68ca65568b352ee32d941470c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [barcodeStream].
@ProviderFor(barcodeStream)
const barcodeStreamProvider = BarcodeStreamFamily();

/// See also [barcodeStream].
class BarcodeStreamFamily extends Family<AsyncValue<BarcodeEntry?>> {
  /// See also [barcodeStream].
  const BarcodeStreamFamily();

  /// See also [barcodeStream].
  BarcodeStreamProvider call(
    int entryId,
  ) {
    return BarcodeStreamProvider(
      entryId,
    );
  }

  @override
  BarcodeStreamProvider getProviderOverride(
    covariant BarcodeStreamProvider provider,
  ) {
    return call(
      provider.entryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'barcodeStreamProvider';
}

/// See also [barcodeStream].
class BarcodeStreamProvider extends AutoDisposeStreamProvider<BarcodeEntry?> {
  /// See also [barcodeStream].
  BarcodeStreamProvider(
    int entryId,
  ) : this._internal(
          (ref) => barcodeStream(
            ref as BarcodeStreamRef,
            entryId,
          ),
          from: barcodeStreamProvider,
          name: r'barcodeStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$barcodeStreamHash,
          dependencies: BarcodeStreamFamily._dependencies,
          allTransitiveDependencies:
              BarcodeStreamFamily._allTransitiveDependencies,
          entryId: entryId,
        );

  BarcodeStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.entryId,
  }) : super.internal();

  final int entryId;

  @override
  Override overrideWith(
    Stream<BarcodeEntry?> Function(BarcodeStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BarcodeStreamProvider._internal(
        (ref) => create(ref as BarcodeStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        entryId: entryId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<BarcodeEntry?> createElement() {
    return _BarcodeStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BarcodeStreamProvider && other.entryId == entryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, entryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BarcodeStreamRef on AutoDisposeStreamProviderRef<BarcodeEntry?> {
  /// The parameter `entryId` of this provider.
  int get entryId;
}

class _BarcodeStreamProviderElement
    extends AutoDisposeStreamProviderElement<BarcodeEntry?>
    with BarcodeStreamRef {
  _BarcodeStreamProviderElement(super.provider);

  @override
  int get entryId => (origin as BarcodeStreamProvider).entryId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
