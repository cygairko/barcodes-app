import 'package:barcodes/features/categories/domain/category.dart';
import 'package:barcodes/features/settings/presentation/categories/add_edit_category_dialog.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../features/categories/data/mock_category_repository.dart'; // Adjust path as needed

void main() {
  group('AddEditCategoryDialog', () {
    final existingCategory = Category(id: 'cat-edit', name: 'To Be Edited', color: 0xFF123456);

    // Helper to pump AddEditCategoryDialog
    Future<void> pumpDialog(WidgetTester tester, {Category? category}) async {
      final mockRepo = MockCategoryRepository(initialCategories: category != null ? [category] : []);
      
      await tester.pumpApp(
        ProviderScope(
          overrides: [
            categoryRepositoryProvider.overrideWithValue(mockRepo),
          ],
          // Wrap the dialog in a MaterialApp and Scaffold to provide context like Navigator
          child: MaterialApp(
            locale: const Locale('en'), // Ensure L10n is available
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  // Button to launch the dialog
                  return ElevatedButton(
                    onPressed: () => showAddEditCategoryDialog(context, category: category),
                    child: const Text('Show Dialog'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Tap the button to show the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle(); // Dialog shows
    }

    testWidgets('Adding a new category - successful submission', (WidgetTester tester) async {
      await pumpDialog(tester);
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      // Verify dialog title for adding
      expect(find.text(appLocalizations.settingsCategoriesAddTitle), findsOneWidget);

      // Enter category name
      await tester.enterText(find.widgetWithText(TextFormField, appLocalizations.settingsCategoriesNameHint), 'New Test Category');
      
      // Select a color (tap the first color chip, assuming it's Colors.red)
      // This is a bit brittle if color order changes. A better way might be to find by color value.
      final colorChip = find.byWidgetPredicate((widget) => widget is CircleAvatar && widget.backgroundColor == Colors.red);
      expect(colorChip, findsOneWidget);
      await tester.tap(colorChip);
      await tester.pump(); // Rebuild for selection state

      // Tap 'Add' button
      await tester.tap(find.text(appLocalizations.btnAdd));
      await tester.pumpAndSettle(); // Dialog closes

      // Verify dialog is closed
      expect(find.byType(AddEditCategoryDialog), findsNothing);

      // Verify repository interaction (this requires accessing the mock from the test's ProviderScope)
      final container = tester.element(find.byType(ProviderScope)).readProviderScope();
      final repo = container.read(categoryRepositoryProvider) as MockCategoryRepository;
      final categories = await repo.getCategories();
      expect(categories.length, 1);
      expect(categories.first.name, 'New Test Category');
      expect(categories.first.color, Colors.red.value); // Check selected color
      expect(Uuid.isValidUUID(fromString: categories.first.id), isTrue); // Check if ID is a valid UUID
    });

    testWidgets('Editing an existing category - successful submission', (WidgetTester tester) async {
      await pumpDialog(tester, category: existingCategory);
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      // Verify dialog title for editing
      expect(find.text(appLocalizations.settingsCategoriesEditTitle), findsOneWidget);

      // Verify name is pre-filled
      expect(find.widgetWithText(TextFormField, existingCategory.name), findsOneWidget);
      // Verify color is pre-selected (CircleAvatar with check mark)
      final selectedColorWidget = find.byWidgetPredicate((widget) {
        if (widget is CircleAvatar && widget.backgroundColor == Color(existingCategory.color!)) {
          final parent = tester.element(find.byWidget(widget)).findAncestorWidgetOfExactType<GestureDetector>();
          if (parent != null) {
             // Check if it has a check mark (means it's selected)
            return find.descendant(of: find.byWidget(widget), matching: find.byIcon(Icons.check)).evaluate().isNotEmpty;
          }
        }
        return false;
      });
      expect(selectedColorWidget, findsOneWidget);


      // Change category name
      await tester.enterText(find.widgetWithText(TextFormField, existingCategory.name), 'Updated Category Name');
      // Change color (select a different one, e.g. Colors.green)
      final newColorChip = find.byWidgetPredicate((widget) => widget is CircleAvatar && widget.backgroundColor == Colors.green);
      expect(newColorChip, findsOneWidget);
      await tester.tap(newColorChip);
      await tester.pump();


      // Tap 'Save' button
      await tester.tap(find.text(appLocalizations.btnSave));
      await tester.pumpAndSettle();

      expect(find.byType(AddEditCategoryDialog), findsNothing);

      final container = tester.element(find.byType(ProviderScope)).readProviderScope();
      final repo = container.read(categoryRepositoryProvider) as MockCategoryRepository;
      final updatedCat = await repo.getCategory(existingCategory.id);
      expect(updatedCat, isNotNull);
      expect(updatedCat!.name, 'Updated Category Name');
      expect(updatedCat.color, Colors.green.value);
    });

    testWidgets('Form validation - empty name shows error', (WidgetTester tester) async {
      await pumpDialog(tester);
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      // Tap 'Add' button without entering name
      await tester.tap(find.text(appLocalizations.btnAdd));
      await tester.pump(); // Rebuild for validation error

      expect(find.text(appLocalizations.settingsCategoriesNameEmpty), findsOneWidget);
      expect(find.byType(AddEditCategoryDialog), findsOneWidget); // Dialog should still be visible
    });

    testWidgets('Pressing cancel closes the dialog', (WidgetTester tester) async {
      await pumpDialog(tester);
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.tap(find.text(appLocalizations.btnCancel));
      await tester.pumpAndSettle();

      expect(find.byType(AddEditCategoryDialog), findsNothing);
    });
    
    testWidgets('Deselecting a color works', (WidgetTester tester) async {
      await pumpDialog(tester, category: existingCategory); // Start with a color selected
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      // Verify initial color is selected
      final initialSelectedColorWidget = find.byWidgetPredicate((widget) {
        if (widget is CircleAvatar && widget.backgroundColor == Color(existingCategory.color!)) {
           return find.descendant(of: find.byWidget(widget), matching: find.byIcon(Icons.check)).evaluate().isNotEmpty;
        }
        return false;
      });
      expect(initialSelectedColorWidget, findsOneWidget);

      // Tap the same color again to deselect it
      await tester.tap(initialSelectedColorWidget);
      await tester.pump();

      // Verify the check mark is gone
      final deselectedColorWidget = find.byWidgetPredicate((widget) {
        if (widget is CircleAvatar && widget.backgroundColor == Color(existingCategory.color!)) {
           return find.descendant(of: find.byWidget(widget), matching: find.byIcon(Icons.check)).evaluate().isEmpty;
        }
        return false;
      });
      // This check is a bit tricky. The CircleAvatar itself will still be there. We need to ensure its child (the check icon) is NOT there.
      // The previous predicate might not work as expected for "is empty". Let's find the avatar and then check its children.
      final colorAvatar = tester.widget<CircleAvatar>(find.byWidgetPredicate((widget) => widget is CircleAvatar && widget.backgroundColor == Color(existingCategory.color!)));
      expect(find.descendant(of: find.byWidget(colorAvatar), matching: find.byIcon(Icons.check)), findsNothing);


      // Save
      await tester.tap(find.text(appLocalizations.btnSave));
      await tester.pumpAndSettle();

      final container = tester.element(find.byType(ProviderScope)).readProviderScope();
      final repo = container.read(categoryRepositoryProvider) as MockCategoryRepository;
      final updatedCat = await repo.getCategory(existingCategory.id);
      expect(updatedCat, isNotNull);
      expect(updatedCat!.color, isNull); // Color should be null
    });
  });
}
