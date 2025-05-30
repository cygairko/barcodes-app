import 'package:barcodes/features/categories/data/category_repository.dart';
import 'package:barcodes/features/categories/domain/category.dart';
import 'package:barcodes/utils/data_store.dart'; // Added import for DataStore
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart'; // For in-memory database

void main() {
  late CategoryRepository categoryRepository;
  late Database db;
  late DatabaseFactory factory;
  late DataStore testDataStore;

  setUpAll(() async {
    factory = newDatabaseFactoryMemory();
  });

  setUp(() async {
    // Ensure a clean database for each test
    await factory.deleteDatabase('test_categories.db'); 
    db = await factory.openDatabase('test_categories.db');
    testDataStore = DataStore(db); // Create DataStore with the test DB
    // Instantiate CategoryRepository with the test DataStore
    categoryRepository = CategoryRepository(testDataStore); 
  });

  tearDown(() async {
    await db.close();
  });

  final categoryNoId1 = Category(name: 'Electronics');
  final categoryNoId2 = Category(name: 'Books');

  group('CategoryRepository with Sembast', () {
    group('addCategory and getCategories', () {
      test('should add a category and generate an ID, then retrieve it', () async {
        final addedCategory1 = await categoryRepository.addCategory(categoryNoId1);
        expect(addedCategory1.id, isNotNull); // Sembast should generate an ID
        expect(addedCategory1.name, categoryNoId1.name);

        final categories = await categoryRepository.getCategories();
        expect(categories.length, 1);
        expect(categories.first.id, addedCategory1.id);
        expect(categories.first.name, addedCategory1.name);
      });

      test('getCategories should return empty list if no categories are stored', () async {
        final categories = await categoryRepository.getCategories();
        expect(categories, isEmpty);
      });

      test('getCategories should return all previously added categories', () async {
        final added1 = await categoryRepository.addCategory(categoryNoId1);
        final added2 = await categoryRepository.addCategory(categoryNoId2);

        final categories = await categoryRepository.getCategories();
        expect(categories.length, 2);
        // Order might not be guaranteed, so check for presence
        expect(categories.map((c) => c.id), containsAll([added1.id, added2.id]));
        expect(categories.map((c) => c.name), containsAll([added1.name, added2.name]));
      });
    });

    group('updateCategory', () {
      test('should update an existing category', () async {
        final addedCategory = await categoryRepository.addCategory(categoryNoId1);
        expect(addedCategory.id, isNotNull);

        final updatedCategory = Category(id: addedCategory.id, name: 'Gadgets');
        await categoryRepository.updateCategory(updatedCategory);

        final categories = await categoryRepository.getCategories();
        expect(categories.length, 1);
        expect(categories.first.id, addedCategory.id);
        expect(categories.first.name, 'Gadgets');
      });

      test('should throw an exception when updating a category with null ID', () async {
        final categoryWithNullId = Category(name: 'Test Category');
        expect(
          () => categoryRepository.updateCategory(categoryWithNullId),
          throwsA(isA<ArgumentError>()),
        );
      });
      
      test('should throw an exception when updating a non-existent category ID', () async {
        final nonExistentCategory = Category(id: 999, name: 'Non Existent');
        expect(
          () => categoryRepository.updateCategory(nonExistentCategory),
          throwsA(isA<Exception>()), // Expecting the 'not found for update' exception
        );
      });
    });

    group('deleteCategory', () {
      test('should delete an existing category', () async {
        final added1 = await categoryRepository.addCategory(categoryNoId1);
        final added2 = await categoryRepository.addCategory(categoryNoId2);
        expect(added1.id, isNotNull);
        expect(added2.id, isNotNull);


        await categoryRepository.deleteCategory(added1.id);

        final categories = await categoryRepository.getCategories();
        expect(categories.length, 1);
        expect(categories.first.id, added2.id);
      });

      test('should throw an exception when deleting a category with null ID', () async {
        expect(
          () => categoryRepository.deleteCategory(null),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw an exception when deleting a non-existent category ID', () async {
        await categoryRepository.addCategory(categoryNoId1); // Add one to make sure db is not empty
        expect(
          () => categoryRepository.deleteCategory(999), // Non-existent ID
          throwsA(isA<Exception>()), // Expecting the 'not found for delete' exception
        );
      });
    });
  });
}
