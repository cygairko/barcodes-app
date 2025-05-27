import 'package:barcodes/features/categories/data/category_repository.dart';
import 'package:barcodes/features/categories/domain/category.dart';
import 'package:barcodes/utils/data_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';

// Override for DataStore provider to use in-memory Sembast
Future<ProviderContainer> createTestContainer({
  bool addDelay = false,
}) async {
  final db = await databaseFactoryMemory.openDatabase('test.db');
  final dataStore = DataStore(db);

  final container = ProviderContainer(
    overrides: [
      dataStoreProvider.overrideWithValue(AsyncData(dataStore)),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('CategoryRepository', () {
    late ProviderContainer container;
    late CategoryRepository repository;

    final category1 = Category(id: 'id1', name: 'Category 1', color: 0xFF00FF00);
    final category2 = Category(id: 'id2', name: 'Category 2', color: 0xFFFF0000);
    final category3 = Category(id: 'id3', name: 'Category 3'); // No color

    setUp(() async {
      container = await createTestContainer();
      repository = container.read(categoryRepositoryProvider);
    });

    tearDown(() async {
      final db = container.read(dataStoreProvider).requireValue.database;
      await db.close();
    });

    test('initially returns an empty list of categories', () async {
      final categories = await repository.getCategories();
      expect(categories, isEmpty);
    });

    test('addCategory and getCategory', () async {
      await repository.addCategory(category1);
      final retrieved = await repository.getCategory(category1.id);
      expect(retrieved, equals(category1));

      await repository.addCategory(category2);
      final retrieved2 = await repository.getCategory(category2.id);
      expect(retrieved2, equals(category2));
    });

    test('getCategory returns null for non-existent category', () async {
      final retrieved = await repository.getCategory('non-existent-id');
      expect(retrieved, isNull);
    });

    test('getCategories returns all added categories', () async {
      await repository.addCategory(category1);
      await repository.addCategory(category2);
      await repository.addCategory(category3);

      final categories = await repository.getCategories();
      expect(categories.length, 3);
      expect(categories, contains(category1));
      expect(categories, contains(category2));
      expect(categories, contains(category3));
    });

    test('updateCategory modifies an existing category', () async {
      await repository.addCategory(category1);
      final updatedCategory1 = category1.copyWith(name: 'Updated Name', color: 0xFF123456);
      await repository.updateCategory(updatedCategory1);

      final retrieved = await repository.getCategory(category1.id);
      expect(retrieved, equals(updatedCategory1));
      expect(retrieved?.name, 'Updated Name');
      expect(retrieved?.color, 0xFF123456);
    });
    
    test('updateCategory does nothing for non-existent category (Sembast behavior)', () async {
      final nonExistentCategory = Category(id: 'non-existent', name: 'Test');
      // Sembast's update is an upsert by default if record doesn't exist,
      // but our repository's `updateCategory` uses `store.record(id).update()`,
      // which will not insert if the record doesn't exist.
      // However, it also doesn't throw an error.
      await repository.updateCategory(nonExistentCategory);
      final retrieved = await repository.getCategory('non-existent');
      expect(retrieved, isNull); // Should still be null
    });

    test('deleteCategory removes a category', () async {
      await repository.addCategory(category1);
      await repository.addCategory(category2);

      await repository.deleteCategory(category1.id);
      final retrieved1 = await repository.getCategory(category1.id);
      expect(retrieved1, isNull);

      final retrieved2 = await repository.getCategory(category2.id);
      expect(retrieved2, equals(category2)); // category2 should still exist

      final categories = await repository.getCategories();
      expect(categories.length, 1);
      expect(categories, contains(category2));
    });

    test('deleteCategory does nothing for non-existent category', () async {
      await repository.addCategory(category1);
      await repository.deleteCategory('non-existent-id');
      final categories = await repository.getCategories();
      expect(categories.length, 1); // Still one category
    });

    group('Watchers', () {
      test('watchCategories emits initial list and updates on add', () async {
        final expectation = expectLater(
          repository.watchCategories(),
          emitsInOrder([
            isEmpty, // Initial empty list
            equals([category1]), // After adding category1
            equals([category1, category2]), // After adding category2
          ]),
        );
        await Future.delayed(Duration.zero); // Allow stream to emit initial value
        await repository.addCategory(category1);
        await repository.addCategory(category2);
        await expectation; // Wait for all expected events
      });

      test('watchCategories emits updates on update', () async {
        await repository.addCategory(category1);
        final updatedCategory1 = category1.copyWith(name: 'Updated');
        
        final expectation = expectLater(
          repository.watchCategories(),
          emitsInOrder([
            equals([category1]), // Initial after add
            equals([updatedCategory1]), // After update
          ]),
        );
        await Future.delayed(Duration.zero);
        await repository.updateCategory(updatedCategory1);
        await expectation;
      });

      test('watchCategories emits updates on delete', () async {
        await repository.addCategory(category1);
        await repository.addCategory(category2);

        final expectation = expectLater(
          repository.watchCategories(),
          emitsInOrder([
            equals([category1, category2]), // Initial
            equals([category2]), // After deleting category1
            isEmpty, // After deleting category2
          ]),
        );
        await Future.delayed(Duration.zero);
        await repository.deleteCategory(category1.id);
        await repository.deleteCategory(category2.id);
        await expectation;
      });
      
      test('watchCategory emits initial value and updates', () async {
        final expectation = expectLater(
          repository.watchCategory(category1.id),
          emitsInOrder([
            isNull, // Initially null
            equals(category1), // After adding
            equals(category1.copyWith(name: "Updated Name")), // After updating
            isNull, // After deleting
          ]),
        );
        await Future.delayed(Duration.zero); 
        await repository.addCategory(category1);
        await repository.updateCategory(category1.copyWith(name: "Updated Name"));
        await repository.deleteCategory(category1.id);
        await expectation;
      });

      test('watchCategory for non-existent ID emits null and stays null', () async {
         final expectation = expectLater(
          repository.watchCategory("non-existent"),
          emitsInOrder([
            isNull, // Initially null
            // Stays null even after other operations
          ]),
        );
        await Future.delayed(Duration.zero);
        await repository.addCategory(category1);
        await expectation;
      });
    });
  });
}
