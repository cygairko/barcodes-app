// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dataStore)
const dataStoreProvider = DataStoreProvider._();

final class DataStoreProvider
    extends
        $FunctionalProvider<
          AsyncValue<DataStore>,
          DataStore,
          FutureOr<DataStore>
        >
    with $FutureModifier<DataStore>, $FutureProvider<DataStore> {
  const DataStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataStoreHash();

  @$internal
  @override
  $FutureProviderElement<DataStore> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<DataStore> create(Ref ref) {
    return dataStore(ref);
  }
}

String _$dataStoreHash() => r'fe2107a035cbdc3e46d3b7010d5a64599dfbeb4c';
