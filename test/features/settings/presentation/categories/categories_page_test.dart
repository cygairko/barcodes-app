import 'package:barcodes/features/categories/domain/category.dart';
import 'package:barcodes/features/settings/presentation/categories/add_edit_category_dialog.dart';
import 'package:barcodes/features/settings/presentation/categories/categories_page.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../features/categories/data/mock_category_repository.dart'; // Adjust path as needed

void main() {
  group('CategoriesPage', () {
    final testCategories = [
      Category(id: 'cat1', name: 'Electronics', color: 0xFF0000FF),
      Category(id: 'cat2', name: 'Books', color: 0xFF00FF00),
    ];

    // Helper to pump CategoriesPage with necessary overrides
    Future<void> pumpCategoriesPage(WidgetTester tester, {List<Category>? initialCategories}) async {
      final mockRepo = MockCategoryRepository(initialCategories: initialCategories ?? testCategories);
      await tester.pumpApp(
        ProviderScope(
          overrides: [
            categoryRepositoryProvider.overrideWithValue(mockRepo),
            // If CategoriesPage uses a stream provider (like `categoriesProvider` from the real app)
            // it should be overridden to use the mock's stream.
            categoriesProvider.overrideWith((ref) => mockRepo.watchCategories()),
          ],
          child: const CategoriesPage(),
        ),
      );
    }

    testWidgets('displays categories correctly', (WidgetTester tester) async {
      await pumpCategoriesPage(tester);

      // Let initial stream emission happen
      await tester.pump(); 

      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('Books'), findsOneWidget);

      // Check for color indicators (CircleAvatar)
      final electronicsTile = tester.widget<ListTile>(find.ancestor(of: find.text('Electronics'), matching: find.byType(ListTile)));
      final electronicsLeading = electronicsTile.leading as CircleAvatar;
      expect(electronicsLeading.backgroundColor, Color(0xFF0000FF));

      final booksTile = tester.widget<ListTile>(find.ancestor(of: find.text('Books'), matching: find.byType(ListTile)));
      final booksLeading = booksTile.leading as CircleAvatar;
      expect(booksLeading.backgroundColor, Color(0xFF00FF00));
    });

    testWidgets('displays placeholder icon if category has no color', (WidgetTester tester) async {
      await pumpCategoriesPage(tester, initialCategories: [Category(id: 'cat3', name: 'No Color Cat')]);
      await tester.pump();

      expect(find.text('No Color Cat'), findsOneWidget);
      final tile = tester.widget<ListTile>(find.ancestor(of: find.text('No Color Cat'), matching: find.byType(ListTile)));
      expect(tile.leading, isA<Icon>());
      expect((tile.leading as Icon).icon, Icons.circle_outlined);
    });

    testWidgets('opens AddEditCategoryDialog when FAB is tapped', (WidgetTester tester) async {
      await pumpCategoriesPage(tester);
      await tester.pump(); // Ensure page is settled

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(); // For dialog animation

      expect(find.byType(AddEditCategoryDialog), findsOneWidget);
      // Check for "Add Category" title (assuming l10n key)
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(appLocalizations.settingsCategoriesAddTitle), findsOneWidget);
    });

    testWidgets('opens AddEditCategoryDialog for editing when a category list tile is tapped', (WidgetTester tester) async {
      await pumpCategoriesPage(tester);
      await tester.pump();

      await tester.tap(find.text('Electronics'));
      await tester.pumpAndSettle();

      expect(find.byType(AddEditCategoryDialog), findsOneWidget);
      // Check for "Edit Category" title (assuming l10n key)
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(appLocalizations.settingsCategoriesEditTitle), findsOneWidget);
      // Check if the name field is pre-filled
      expect(find.widgetWithText(TextFormField, 'Electronics'), findsOneWidget);
    });

    testWidgets('deleting a category shows confirmation and removes it from list', (WidgetTester tester) async {
      final mockRepo = MockCategoryRepository(initialCategories: List.from(testCategories)); // Use a modifiable list for the mock
      await tester.pumpApp(
        ProviderScope(
          overrides: [
            categoryRepositoryProvider.overrideWithValue(mockRepo),
            categoriesProvider.overrideWith((ref) => mockRepo.watchCategories()),
          ],
          child: const CategoriesPage(),
        ),
      );
      await tester.pump(); // Initial list

      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('Books'), findsOneWidget);

      // Find the delete button for 'Electronics'
      final deleteButtonFinder = find.descendant(
        of: find.ancestor(of: find.text('Electronics'), matching: find.byType(ListTile)),
        matching: find.byIcon(Icons.delete),
      );
      expect(deleteButtonFinder, findsOneWidget);
      await tester.tap(deleteButtonFinder);
      await tester.pumpAndSettle(); // Show confirmation dialog

      // Check for confirmation dialog
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(appLocalizations.settingsCategoriesDeleteTitle), findsOneWidget);
      expect(find.text(appLocalizations.settingsCategoriesDeleteConfirm('Electronics')), findsOneWidget);
      
      // Tap 'Delete' on confirmation
      await tester.tap(find.text(appLocalizations.btnDelete));
      await tester.pumpAndSettle(); // Wait for UI to update after deletion

      expect(find.text('Electronics'), findsNothing); // Electronics should be gone
      expect(find.text('Books'), findsOneWidget); // Books should still be there
      
      // Verify repository was called
      final cat1 = await mockRepo.getCategory('cat1');
      expect(cat1, isNull); // Should be deleted from mock repo
    });

     testWidgets('displays empty state if no categories', (WidgetTester tester) async {
      final mockRepo = MockCategoryRepository(initialCategories: []);
       await tester.pumpApp(
        ProviderScope(
          overrides: [
            categoryRepositoryProvider.overrideWithValue(mockRepo),
            categoriesProvider.overrideWith((ref) => mockRepo.watchCategories()),
          ],
          child: const CategoriesPage(),
        ),
      );
      await tester.pump(); // Process stream

      expect(find.byType(ListView), findsOneWidget); // ListView is still there
      expect(find.byType(ListTile), findsNothing); // But no ListTiles for categories
      // You might want to add a specific empty state widget in CategoriesPage and test for that
      // For now, just checking no ListTiles is a basic test.
    });
  });
}
