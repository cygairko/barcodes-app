import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/utils/data_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast.dart';

part 'barcode_repository.g.dart';

@Riverpod(keepAlive: true)
BarcodeRepository barcodeRepository(BarcodeRepositoryRef ref) {
  return BarcodeRepository(ref.read(dataStoreProvider).requireValue);
}

@riverpod
Stream<List<BarcodeEntry>> barcodesStream(BarcodesStreamRef ref) {
  final barcodeRepository = ref.read(barcodeRepositoryProvider);
  return barcodeRepository.watchBarcodes();
}

@riverpod
Stream<BarcodeEntry?> barcodeStream(BarcodeStreamRef ref, int entryId) {
  final barcodeRepository = ref.read(barcodeRepositoryProvider);
  return barcodeRepository.watchEntry(entryId);
}

class BarcodeRepository {
  BarcodeRepository(this.datastore);

  final DataStore datastore;
  final storeRef = intMapStoreFactory.store('barcodes_store');

  Future<int> addEntry(BarcodeEntry entry) => storeRef.add(
        datastore.database,
        entry.toJson(),
      );

  Future<void> updateEntry(BarcodeEntry entry) =>
      storeRef.record(entry.id).update(
            datastore.database,
            entry.toJson(),
          );

  Future<int?> deleteEntry(int entryId) =>
      storeRef.record(entryId).delete(datastore.database);

  Future<BarcodeEntry?> fetchEntry(int entryId) async {
    final entryJson = await storeRef.record(entryId).get(datastore.database);
    return entryJson != null ? BarcodeEntry.fromJson(entryJson) : null;
  }

  Stream<BarcodeEntry?> watchEntry(int entryId) {
    final record = storeRef.record(entryId);
    return record.onSnapshot(datastore.database).map((snapshot) {
      if (snapshot != null) {
        return BarcodeEntry.fromJson(snapshot.value);
      } else {
        return null;
      }
    });
  }

  Stream<List<BarcodeEntry>> watchBarcodes() =>
      storeRef.query().onSnapshots(datastore.database).map(
            (snapshot) => snapshot
                .map(
                  (entry) => BarcodeEntry.fromJson(entry.value)
                      .copyWith(id: entry.key),
                )
                .toList(growable: false),
          );
}
