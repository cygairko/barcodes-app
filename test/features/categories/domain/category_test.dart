import 'package:barcodes/features/categories/domain/category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Category Model', () {
    const id1 = 'test-id-1';
    const name1 = 'Test Category 1';
    const color1 = 0xFF00FF00; // Green

    const id2 = 'test-id-2';
    const name2 = 'Test Category 2';
    const color2 = 0xFFFF0000; // Red

    final category1 = Category(id: id1, name: name1, color: color1);
    final category1Clone = Category(id: id1, name: name1, color: color1);
    final category2 = Category(id: id2, name: name2, color: color2);

    test('supports value equality (==)', () {
      expect(category1, equals(category1Clone));
      expect(category1, isNot(equals(category2)));
    });

    test('has a consistent hashCode', () {
      expect(category1.hashCode, equals(category1Clone.hashCode));
      expect(category1.hashCode, isNot(equals(category2.hashCode)));
    });

    test('copyWith creates a new instance with updated values', () {
      final updatedCategory1 = category1.copyWith(name: 'Updated Name', color: null);

      expect(updatedCategory1.id, equals(id1));
      expect(updatedCategory1.name, equals('Updated Name'));
      expect(updatedCategory1.color, isNull);

      // Original should be unchanged
      expect(category1.name, equals(name1));
      expect(category1.color, equals(color1));

      final sameCategory = category1.copyWith();
      expect(sameCategory, equals(category1));
    });

    test('copyWith with no arguments returns an identical instance', () {
      final copiedCategory = category1.copyWith();
      expect(copiedCategory, equals(category1));
      expect(copiedCategory.id, equals(category1.id));
      expect(copiedCategory.name, equals(category1.name));
      expect(copiedCategory.color, equals(category1.color));
    });
    
    test('copyWith only specified fields', () {
      final categoryNoColor = Category(id: 'id3', name: 'No Color');
      final updatedOnlyName = categoryNoColor.copyWith(name: 'New Name Only');
      expect(updatedOnlyName.id, 'id3');
      expect(updatedOnlyName.name, 'New Name Only');
      expect(updatedOnlyName.color, isNull);

      final updatedOnlyColor = categoryNoColor.copyWith(color: 0xFF123456);
      expect(updatedOnlyColor.id, 'id3');
      expect(updatedOnlyColor.name, 'No Color');
      expect(updatedOnlyColor.color, 0xFF123456);
    });


    group('JSON Serialization/Deserialization', () {
      test('toJson returns a valid JSON map', () {
        final json = category1.toJson();
        expect(json, equals({
          'id': id1,
          'name': name1,
          'color': color1,
        }));
      });

      test('toJson handles null color', () {
        final categoryNoColor = Category(id: id1, name: name1);
        final json = categoryNoColor.toJson();
        expect(json, equals({
          'id': id1,
          'name': name1,
          'color': null,
        }));
      });

      test('fromJson creates a valid Category object from JSON map', () {
        final json = {
          'id': id1,
          'name': name1,
          'color': color1,
        };
        final fromJsonCategory = Category.fromJson(json);
        expect(fromJsonCategory, equals(category1));
      });

      test('fromJson handles null color', () {
        final json = {
          'id': id1,
          'name': name1,
          'color': null,
        };
        final categoryNoColor = Category(id: id1, name: name1);
        final fromJsonCategory = Category.fromJson(json);
        expect(fromJsonCategory, equals(categoryNoColor));
      });

      test('toJson and fromJson are symmetric', () {
        final json = category1.toJson();
        final fromJsonCategory = Category.fromJson(json);
        expect(fromJsonCategory, equals(category1));

        final categoryNoColor = Category(id: id2, name: name2);
        final jsonNoColor = categoryNoColor.toJson();
        final fromJsonCategoryNoColor = Category.fromJson(jsonNoColor);
        expect(fromJsonCategoryNoColor, equals(categoryNoColor));
      });
    });

     test('toString() returns a readable string representation', () {
      expect(
        category1.toString(),
        equals('Category(id: $id1, name: $name1, color: $color1)'),
      );
      final categoryNoColor = Category(id: id1, name: name1);
      expect(
        categoryNoColor.toString(),
        equals('Category(id: $id1, name: $name1, color: null)'),
      );
    });
  });
}
