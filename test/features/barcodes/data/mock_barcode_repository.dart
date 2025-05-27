import 'dart:async';
import 'package:barcodes/features/barcodes/data/barcode_repository.dart';
import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/utils/data_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';

class MockBarcodeRepository implements BarcodeRepository {
  final List<BarcodeEntry> _entries = [];
  final _entriesStreamController = StreamController<List<BarcodeEntry>>.broadcast();
  final Map<int, StreamController<BarcodeEntry?>> _entryStreamControllers = {};

  // Helper to easily set mock data
  static List<BarcodeEntry> mockBarcodes = [
    BarcodeEntry(id: 1, name: 'Barcode 1', data: '123', type: BarcodeType.Code128, categoryId: 'cat1'),
    BarcodeEntry(id: 2, name: 'Barcode 2', data: '456', type: BarcodeType.QrCode, categoryId: 'cat2'),
    BarcodeEntry(id: 3, name: 'Barcode 3', data: '789', type: BarcodeType.DataMatrix, categoryId: 'cat1'),
    BarcodeEntry(id: 4, name: 'Barcode 4', data: '000', type: BarcodeType.Code39), // No category
  ];

  MockBarcodeRepository({List<BarcodeEntry>? initialEntries}) {
    if (initialEntries != null) {
      _entries.addAll(initialEntries);
    }
    Future.delayed(Duration.zero, () => _entriesStreamController.add(List.unmodifiable(_entries)));
  }

  @override
  Future<int> addEntry(BarcodeEntry entry) async {
    // Sembast auto-increments ID, mock similar behavior if id is -1
    final newId = entry.id == -1 ? (_entries.map((e) => e.id).fold(0, (max, curr) => curr > max ? curr : max) + 1) : entry.id;
    final newEntry = entry.copyWith(id: newId);
    
    _entries.removeWhere((e) => e.id == newEntry.id); // Remove if exists (though add usually means new)
    _entries.add(newEntry);
    _entriesStreamController.add(List.unmodifiable(_entries));
    _getEntryStreamController(newEntry.id).add(newEntry);
    return newEntry.id;
  }

  @override
  Future<int?> deleteEntry(int entryId) async {
    final removed = _entries.remove((entry) => entry.id == entryId);
    if (removed.isNotEmpty) {
        _entriesStreamController.add(List.unmodifiable(_entries));
        _getEntryStreamController(entryId).add(null);
        _entryStreamControllers.remove(entryId)?.close();
        return entryId;
    }
    return null;
  }

  @override
  Future<BarcodeEntry?> fetchEntry(int entryId) async {
    return _entries.firstWhere((e) => e.id == entryId, orElse: () => null);
  }

  @override
  Future<void> updateEntry(BarcodeEntry entry) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
      _entriesStreamController.add(List.unmodifiable(_entries));
      _getEntryStreamController(entry.id).add(entry);
    }
  }
  
  StreamController<BarcodeEntry?> _getEntryStreamController(int entryId) {
    return _entryStreamControllers.putIfAbsent(
        entryId, () => StreamController<BarcodeEntry?>.broadcast(
          onListen: () {
            final current = _entries.firstWhere((e) => e.id == entryId, orElse: () => null);
             _entryStreamControllers[entryId]!.add(current);
          }
        ));
  }


  @override
  Stream<BarcodeEntry?> watchEntry(int entryId) {
     return _getEntryStreamController(entryId).stream;
  }

  @override
  Stream<List<BarcodeEntry>> watchBarcodes() {
    return _entriesStreamController.stream;
  }

  void dispose() {
    _entriesStreamController.close();
     _entryStreamControllers.values.forEach((controller) => controller.close());
    _entryStreamControllers.clear();
  }
  
  // Not part of the interface, but useful for testing
  List<BarcodeEntry> get currentEntries => List.unmodifiable(_entries);

  @override
  DataStore get datastore => throw UnimplementedError('datastore getter not implemented in mock');

  @override
  StoreRef<int, Map<String, Object?>> get storeRef => throw UnimplementedError('storeRef getter not implemented in mock');
}

// Provider overrides for tests
final mockBarcodeRepositoryProvider = Provider<MockBarcodeRepository>((ref) {
  final repo = MockBarcodeRepository(initialEntries: MockBarcodeRepository.mockBarcodes);
  ref.onDispose(repo.dispose);
  return repo;
});

final barcodesStreamProviderOverride = barcodesStreamProvider.overrideWith((ref) {
  return ref.watch(mockBarcodeRepositoryProvider).watchBarcodes();
});

// If you have a specific provider for a single barcode stream:
// final barcodeStreamProviderFamilyOverride = barcodeStreamProvider.overrideWithProvider(...)
// For this test, we primarily need `barcodesStreamProviderOverride`.
