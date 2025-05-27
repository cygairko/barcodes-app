import 'package:barcodes/features/categories/data/category_repository.dart';
import 'package:barcodes/features/categories/domain/category.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock CategoryRepository
class MockCategoryRepository implements CategoryRepository {
  final List<Category> _categories = [];
  final _categoriesStreamController = StreamController<List<Category>>.broadcast();
  final Map<String, StreamController<Category?>> _categoryStreamControllers = {};

  // Helper to easily set mock data for providers
  static List<Category> mockCategories = [
    Category(id: 'cat1', name: 'Electronics', color: 0xFF0000FF),
    Category(id: 'cat2', name: 'Books', color: 0xFF00FF00),
    Category(id: 'cat3', name: 'Groceries'), // No color
  ];

  MockCategoryRepository({List<Category>? initialCategories}) {
    if (initialCategories != null) {
      _categories.addAll(initialCategories);
    }
     Future.delayed(Duration.zero, () => _categoriesStreamController.add(List.unmodifiable(_categories)));
  }

  @override
  Future<void> addCategory(Category category) async {
    _categories.removeWhere((c) => c.id == category.id); // Remove if exists, then add
    _categories.add(category);
    _categoriesStreamController.add(List.unmodifiable(_categories));
    _getCategoryStreamController(category.id).add(category);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    _categories.removeWhere((c) => c.id == categoryId);
    _categoriesStreamController.add(List.unmodifiable(_categories));
    _getCategoryStreamController(categoryId).add(null); // Notify watchers it's gone
     _categoryStreamControllers.remove(categoryId)?.close(); // Clean up controller
  }

  @override
  Future<Category?> getCategory(String categoryId) async {
    return _categories.firstWhere((c) => c.id == categoryId, orElse: () => null);
  }

  @override
  Future<List<Category>> getCategories() async {
    return List.unmodifiable(_categories);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
      _categoriesStreamController.add(List.unmodifiable(_categories));
      _getCategoryStreamController(category.id).add(category);
    }
  }
  
  StreamController<Category?> _getCategoryStreamController(String categoryId) {
    return _categoryStreamControllers.putIfAbsent(
        categoryId, () => StreamController<Category?>.broadcast(
          onListen: () {
            // Emit current value on listen if it exists
            final current = _categories.firstWhere((c) => c.id == categoryId, orElse: () => null);
            _categoryStreamControllers[categoryId]!.add(current);
          }
        ));
  }


  @override
  Stream<Category?> watchCategory(String categoryId) {
     return _getCategoryStreamController(categoryId).stream;
  }

  @override
  Stream<List<Category>> watchCategories() {
    return _categoriesStreamController.stream;
  }

  // Not part of the interface, but useful for testing
  void dispose() {
    _categoriesStreamController.close();
    _categoryStreamControllers.values.forEach((controller) => controller.close());
    _categoryStreamControllers.clear();
  }

  // Required by the interface, but not used in this mock for direct DB access
  @override
  DataStore get datastore => throw UnimplementedError('datastore getter not implemented in mock');

  @override
  StoreRef<String, Map<String, Object?>> get storeRef => throw UnimplementedError('storeRef getter not implemented in mock');
}

// Provider overrides for tests
final mockCategoryRepositoryProvider = Provider<MockCategoryRepository>((ref) {
  final repo = MockCategoryRepository(initialCategories: MockCategoryRepository.mockCategories);
  ref.onDispose(repo.dispose);
  return repo;
});

final mockCategoriesProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(mockCategoryRepositoryProvider).watchCategories();
});

// If you also have a FutureProvider for getCategories:
final mockCategoriesFutureProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(mockCategoryRepositoryProvider).getCategories();
});

// Override for the main repository provider to use the mock
final categoryRepositoryProviderOverride = categoryRepositoryProvider.overrideWithProvider(mockCategoryRepositoryProvider);
// Override for the stream provider if your UI uses it directly
final categoriesProviderOverride = categoriesProvider.overrideWith((ref) {
  return ref.watch(mockCategoryRepositoryProvider).watchCategories();
});
// Override for the future provider if your UI uses it directly
final categoriesFutureProviderOverride = categoriesProvider.overrideWith((ref) { // Note: this is overriding the same `categoriesProvider` as above.
                                                                              // If you have different providers for stream and future, adjust accordingly.
                                                                              // For this example, assuming `categoriesProvider` is the stream one.
  final repo = ref.watch(mockCategoryRepositoryProvider);
  // Create a new stream that emits the future result once
  final controller = StreamController<List<Category>>();
  repo.getCategories().then((value) {
    controller.add(value);
    controller.close();
  }).catchError((e) {
    controller.addError(e);
    controller.close();
  });
  return controller.stream;
});
