import 'package:barcodes/features/categories/domain/category.dart';
import 'package:barcodes/utils/data_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast.dart';

part 'category_repository.g.dart';

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  return CategoryRepository(ref.read(dataStoreProvider).requireValue);
}

@riverpod
Future<List<Category>> categories(CategoriesRef ref) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return categoryRepository.getCategories();
}

class CategoryRepository {
  CategoryRepository(this.datastore);

  final DataStore datastore;
  final storeRef = stringMapStoreFactory.store('categories_store');

  Future<void> addCategory(Category category) async {
    await storeRef.record(category.id).put(
          datastore.database,
          category.toJson(),
        );
  }

  Future<void> updateCategory(Category category) async {
    await storeRef.record(category.id).update(
          datastore.database,
          category.toJson(),
        );
  }

  Future<void> deleteCategory(String categoryId) async {
    await storeRef.record(categoryId).delete(datastore.database);
  }

  Future<Category?> getCategory(String categoryId) async {
    final categoryJson =
        await storeRef.record(categoryId).get(datastore.database);
    return categoryJson != null ? Category.fromJson(categoryJson) : null;
  }

  Future<List<Category>> getCategories() async {
    final snapshots = await storeRef.find(datastore.database);
    return snapshots
        .map((snapshot) => Category.fromJson(snapshot.value))
        .toList(growable: false);
  }

  Stream<List<Category>> watchCategories() =>
      storeRef.query().onSnapshots(datastore.database).map(
            (snapshot) => snapshot
                .map(
                  (category) => Category.fromJson(category.value)
                      .copyWith(id: category.key),
                )
                .toList(growable: false),
          );

  Stream<Category?> watchCategory(String categoryId) {
    final record = storeRef.record(categoryId);
    return record.onSnapshot(datastore.database).map((snapshot) {
      if (snapshot != null) {
        return Category.fromJson(snapshot.value);
      } else {
        return null;
      }
    });
  }
}
