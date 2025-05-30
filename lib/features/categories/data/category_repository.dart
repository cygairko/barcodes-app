import 'dart:async';
import 'package:sembast/sembast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Ensure this is present for Ref
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:barcodes/utils/data_store.dart'; // Assuming this path is correct
import '../domain/category.dart';

part 'category_repository.g.dart';

class CategoryRepository {
  static const String storeName = 'categories';

  final DataStore _dataStore;
  final _categoryStore = intMapStoreFactory.store(storeName);

  CategoryRepository(this._dataStore);

  Future<Database> get _db async => _dataStore.db;

  Future<Category> addCategory(Category category) async {
    final db = await _db;
    final key = await _categoryStore.add(db, category.toJson());
    return category.copyWith(id: key);
  }

  Future<List<Category>> getCategories() async {
    final db = await _db;
    final snapshots = await _categoryStore.find(db);
    return snapshots.map((snapshot) {
      // First, create a Category instance from the JSON data (which might not have 'id')
      // Then, use copyWith to set the id from Sembast's record key.
      final category = Category.fromJson(snapshot.value);
      return category.copyWith(id: snapshot.key);
    }).toList();
  }

  Future<void> updateCategory(Category category) async {
    final db = await _db;
    if (category.id == null) {
      throw ArgumentError('Category ID cannot be null for update');
    }
    final finder = Finder(filter: Filter.byKey(category.id));
    final count = await _categoryStore.update(db, category.toJson(), finder: finder);
    if (count == 0) {
      throw Exception('Category with ID ${category.id} not found for update.');
    }
  }

  Future<void> deleteCategory(int? categoryId) async {
    final db = await _db;
    if (categoryId == null) {
      throw ArgumentError('Category ID cannot be null for delete');
    }
    final finder = Finder(filter: Filter.byKey(categoryId));
    final count = await _categoryStore.delete(db, finder: finder);
    if (count == 0) {
      throw Exception('Category with ID $categoryId not found for delete.');
    }
  }
}

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(Ref ref) { // Changed to Ref
  // .requireValue is used here assuming DataStoreProvider handles its async states
  // and provides a DataStore object synchronously once ready, or throws if not.
  // If DataStoreProvider can be in an error/loading state that needs specific handling here,
  // this might need to be adjusted (e.g. ref.watch(dataStoreProvider).when(...)).
  // For now, proceeding with .requireValue as per typical usage with a resolved dependency.
  final dataStore = ref.watch(dataStoreProvider).requireValue;
  return CategoryRepository(dataStore);
}
