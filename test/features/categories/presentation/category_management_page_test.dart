import 'package:barcodes/features/categories/data/category_repository.dart';
import 'package:barcodes/features/categories/domain/category.dart';
import 'package:barcodes/features/categories/presentation/category_management_page.dart';
import 'package:barcodes/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockCategoryRepository extends Mock implements CategoryRepository {}

// Helper to pump the widget with necessary providers and MaterialApp
Widget createTestableWidget(Widget child, MockCategoryRepository mockRepo) {
  return ProviderScope(
    overrides: [
      categoryRepositoryProvider.overrideWithValue(mockRepo),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'), // Ensure a locale is set for l10n
      home: child,
    ),
  );
}

void main() {
  late MockCategoryRepository mockCategoryRepository;
  late AppLocalizations l10n;

  setUpAll(() async {
    // Load l10n once for all tests
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    // Default stub for getCategories to prevent errors in unrelated tests
    when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []);
  });

  group('CategoryManagementPage', () {
    testWidgets('shows loading indicator and fetches categories on init', (tester) async {
      final categories = [const Category(id: 1, name: 'Test Category 1')]; // ID is int
      when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50)); // Simulate network delay
        return categories;
      });

      await tester.pumpWidget(createTestableWidget(const CategoryManagementPage(), mockCategoryRepository));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Category 1'), findsNothing);

      await tester.pumpAndSettle(); // Wait for futures to complete

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Test Category 1'), findsOneWidget);
      verify(() => mockCategoryRepository.getCategories()).called(1);
    });

    testWidgets('shows error SnackBar if fetching categories fails', (tester) async {
      final exception = Exception('Failed to load');
      when(() => mockCategoryRepository.getCategories()).thenThrow(exception);

      await tester.pumpWidget(createTestableWidget(const CategoryManagementPage(), mockCategoryRepository));
      await tester.pumpAndSettle(); // For initState and _fetchCategories

      expect(find.text(l10n.errorFailedToLoadCategories(exception.toString())), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    group('Add Category', () {
      testWidgets('opens add category dialog and adds a category successfully', (tester) async {
        const newCategoryName = 'New Category';
        const addedCategory = Category(id: 2, name: newCategoryName); // Changed 'newId' to int

        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []); // Initial empty list
        when(
          () => mockCategoryRepository.addCategory(any(that: predicate<Category>((c) => c.name == newCategoryName))),
        ).thenAnswer((_) async => addedCategory);

        await tester.pumpWidget(createTestableWidget(const CategoryManagementPage(), mockCategoryRepository));
        await tester.pumpAndSettle(); // Initial fetch

        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(find.text(l10n.addCategoryDialogTitle), findsOneWidget);
        await tester.enterText(find.widgetWithText(TextField, l10n.categoryNameHint), newCategoryName);

        // Mock getCategories for the refresh call
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => [addedCategory]);

        await tester.tap(find.text(l10n.buttonSave));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
        verify(
          () => mockCategoryRepository.addCategory(any(that: predicate<Category>((c) => c.name == newCategoryName))),
        ).called(1);
        verify(() => mockCategoryRepository.getCategories()).called(2); // Initial + refresh
        expect(find.text(newCategoryName), findsOneWidget);
      });

      testWidgets('shows error SnackBar in dialog if adding category fails', (tester) async {
        const newCategoryName = 'Faulty Category';
        final exception = Exception('Save failed');

        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []);
        when(
          () => mockCategoryRepository.addCategory(any(that: predicate<Category>((c) => c.name == newCategoryName))),
        ).thenThrow(exception);

        await tester.pumpWidget(createTestableWidget(const CategoryManagementPage(), mockCategoryRepository));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        await tester.enterText(find.widgetWithText(TextField, l10n.categoryNameHint), newCategoryName);
        await tester.tap(find.text(l10n.buttonSave));
        await tester.pumpAndSettle();

        expect(find.text(l10n.errorFailedToSaveCategory(exception.toString())), findsOneWidget);
        expect(find.byType(AlertDialog), findsOneWidget); // Dialog still open
      });

      testWidgets('shows error SnackBar in dialog if category name is empty when adding', (tester) async {
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []);
        await tester.pumpWidget(createTestableWidget(const CategoryManagementPage(), mockCategoryRepository));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        await tester.tap(find.text(l10n.buttonSave)); // Tap Save without entering text
        await tester.pumpAndSettle();

        expect(find.text(l10n.errorCategoryNameEmpty), findsOneWidget);
        expect(find.byType(AlertDialog), findsOneWidget);
        verifyNever(() => mockCategoryRepository.addCategory(any()));
      });

      testWidgets('cancels add category dialog', (tester) async {
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []);
        await tester.pumpWidget(createTestableWidget(const CategoryManagementPage(), mockCategoryRepository));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        await tester.tap(find.text(l10n.buttonCancel));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
        verifyNever(() => mockCategoryRepository.addCategory(any()));
      });
    });

    group('Edit Category', () {
      const initialCategory = Category(id: 1, name: 'Old Name'); // ID is int
      const updatedName = 'Updated Name';
      const updatedCategory = Category(id: 1, name: updatedName); // ID is int

      Finder findEditButtonForItem(String itemName) {
        final listTileFinder = find.ancestor(of: find.text(itemName), matching: find.byType(ListTile));
        return find.descendant(of: listTileFinder, matching: find.widgetWithText(TextButton, l10n.buttonEdit));
      }

      testWidgets('opens edit dialog, pre-fills name, and updates category successfully', (tester) async {
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => [initialCategory]);
        when(
          () => mockCategoryRepository.updateCategory(
            any(that: predicate<Category>((c) => c.id == 1 && c.name == updatedName)), // Changed '1' to 1
          ),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(createTestableWidget(const CategoryManagementPage(), mockCategoryRepository));
        await tester.pumpAndSettle();
        expect(find.text('Old Name'), findsOneWidget);

        await tester.tap(findEditButtonForItem('Old Name'));
        await tester.pumpAndSettle();

        expect(find.text(l10n.editCategoryDialogTitle), findsOneWidget);
        expect(find.widgetWithText(TextField, 'Old Name'), findsOneWidget);

        await tester.enterText(find.byType(TextField), updatedName);

        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => [updatedCategory]); // For refresh

        await tester.tap(find.text(l10n.buttonSave));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
        verify(() => mockCategoryRepository.updateCategory(updatedCategory)).called(1);
        verify(() => mockCategoryRepository.getCategories()).called(2);
        expect(find.text(updatedName), findsOneWidget);
        expect(find.text('Old Name'), findsNothing);
      });

      testWidgets('shows error SnackBar in dialog if updating category fails', (tester) async {
        final exception = Exception('Update failed');
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => [initialCategory]);
        when(
          () => mockCategoryRepository.updateCategory(
            any(that: predicate<Category>((c) => c.id == 1 && c.name == updatedName)), // Changed '1' to 1
          ),
        ).thenThrow(exception);

        await tester.pumpWidget(createTestableWidget(const CategoryManagementPage(), mockCategoryRepository));
        await tester.pumpAndSettle();

        await tester.tap(findEditButtonForItem('Old Name'));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), updatedName);
        await tester.tap(find.text(l10n.buttonSave));
        await tester.pumpAndSettle();

        expect(find.text(l10n.errorFailedToSaveCategory(exception.toString())), findsOneWidget);
        expect(find.byType(AlertDialog), findsOneWidget);
      });

      testWidgets('shows error SnackBar in dialog if category name is empty when editing', (tester) async {
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => [initialCategory]);
        await tester.pumpWidget(createTestableWidget(const CategoryManagementPage(), mockCategoryRepository));
        await tester.pumpAndSettle();

        await tester.tap(findEditButtonForItem('Old Name'));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), ''); // Clear text
        await tester.tap(find.text(l10n.buttonSave));
        await tester.pumpAndSettle();

        expect(find.text(l10n.errorCategoryNameEmpty), findsOneWidget);
        expect(find.byType(AlertDialog), findsOneWidget);
        verifyNever(() => mockCategoryRepository.updateCategory(any()));
      });

      testWidgets('cancels edit category dialog', (tester) async {
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => [initialCategory]);
        await tester.pumpWidget(createTestableWidget(const CategoryManagementPage(), mockCategoryRepository));
        await tester.pumpAndSettle();

        await tester.tap(findEditButtonForItem('Old Name'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        await tester.tap(find.text(l10n.buttonCancel));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
        verifyNever(() => mockCategoryRepository.updateCategory(any()));
      });
    });

    group('Delete Category', () {
      const categoryToDelete = Category(id: 3, name: 'To Delete'); // Changed 'delId' to int

      Finder findDeleteButtonInList(String itemName) {
        final listTileFinder = find.ancestor(of: find.text(itemName), matching: find.byType(ListTile));
        return find.descendant(of: listTileFinder, matching: find.widgetWithText(TextButton, l10n.buttonDelete));
      }

      Finder findDeleteButtonInDialog() {
        // Assumes only one "Delete" button is visible in a dialog context, or it's the last one.
        return find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(TextButton, l10n.buttonDelete),
        );
      }

      Finder findCancelButtonInDialog() {
        return find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(TextButton, l10n.buttonCancel),
        );
      }

      testWidgets('confirms and deletes a category successfully', (tester) async {
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => [categoryToDelete]);
        when(
          () => mockCategoryRepository.deleteCategory(categoryToDelete.id),
        ).thenAnswer((_) async {}); // id is now int

        await tester.pumpWidget(createTestableWidget(const CategoryManagementPage(), mockCategoryRepository));
        await tester.pumpAndSettle();
        expect(find.text('To Delete'), findsOneWidget);

        await tester.tap(findDeleteButtonInList('To Delete'));
        await tester.pumpAndSettle();

        expect(find.text(l10n.confirmDeleteDialogTitle), findsOneWidget);
        expect(find.text(l10n.confirmDeleteCategoryMessage(categoryToDelete.name)), findsOneWidget);

        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []); // For refresh

        await tester.tap(findDeleteButtonInDialog());
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
        verify(() => mockCategoryRepository.deleteCategory(categoryToDelete.id)).called(1);
        expect(find.text(l10n.infoCategoryDeleted(categoryToDelete.name)), findsOneWidget);
        verify(() => mockCategoryRepository.getCategories()).called(2);
        expect(find.text('To Delete'), findsNothing);
      });

      testWidgets('cancels delete category confirmation', (tester) async {
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => [categoryToDelete]);
        await tester.pumpWidget(createTestableWidget(const CategoryManagementPage(), mockCategoryRepository));
        await tester.pumpAndSettle();

        await tester.tap(findDeleteButtonInList('To Delete'));
        await tester.pumpAndSettle();
        expect(find.text(l10n.confirmDeleteDialogTitle), findsOneWidget);

        await tester.tap(findCancelButtonInDialog());
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
        verifyNever(() => mockCategoryRepository.deleteCategory(any()));
        expect(find.text('To Delete'), findsOneWidget); // Still there
      });

      testWidgets('shows error SnackBar if deleting category fails', (tester) async {
        final exception = Exception('Delete failed');
        when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => [categoryToDelete]);
        when(() => mockCategoryRepository.deleteCategory(categoryToDelete.id)).thenThrow(exception); // id is now int

        await tester.pumpWidget(createTestableWidget(const CategoryManagementPage(), mockCategoryRepository));
        await tester.pumpAndSettle();

        await tester.tap(findDeleteButtonInList('To Delete'));
        await tester.pumpAndSettle();

        await tester.tap(findDeleteButtonInDialog());
        await tester.pumpAndSettle();

        expect(find.text(l10n.errorFailedToDeleteCategory(exception.toString())), findsOneWidget);
        expect(find.byType(AlertDialog), findsNothing); // Dialog should be closed
        expect(find.text('To Delete'), findsOneWidget); // Still there as delete failed
        verify(() => mockCategoryRepository.getCategories()).called(1); // No refresh on error
      });
    });

    testWidgets('FloatingActionButton triggers _showCategoryDialog without arguments', (tester) async {
      // This test verifies that tapping the FAB opens the dialog for adding (not editing)

      when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => []);
      await tester.pumpWidget(createTestableWidget(const CategoryManagementPage(), mockCategoryRepository));
      await tester.pumpAndSettle();

      // Verify no dialog is present initially
      expect(find.byType(AlertDialog), findsNothing);

      // Tap the FloatingActionButton
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(); // Allow dialog to appear

      // Verify the "Add Category" dialog is shown
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(l10n.addCategoryDialogTitle), findsOneWidget);

      // Verify the text field is empty (not pre-filled for editing)
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('ListTile Edit button triggers _showCategoryDialog with category argument', (tester) async {
      const categoryToEdit = Category(id: 4, name: 'Editable Category'); // Changed 'editId' to int
      when(() => mockCategoryRepository.getCategories()).thenAnswer((_) async => [categoryToEdit]);

      await tester.pumpWidget(createTestableWidget(const CategoryManagementPage(), mockCategoryRepository));
      await tester.pumpAndSettle();

      expect(find.text(categoryToEdit.name), findsOneWidget);

      // Find the Edit button for the specific category
      final listTileFinder = find.ancestor(of: find.text(categoryToEdit.name), matching: find.byType(ListTile));
      final editButtonFinder = find.descendant(
        of: listTileFinder,
        matching: find.widgetWithText(TextButton, l10n.buttonEdit),
      );

      await tester.tap(editButtonFinder);
      await tester.pumpAndSettle();

      // Verify the "Edit Category" dialog is shown
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(l10n.editCategoryDialogTitle), findsOneWidget);

      // Verify the text field is pre-filled with the category's name
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, categoryToEdit.name);
    });
  });
}
