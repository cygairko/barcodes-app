import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/features/barcodes/presentation/add_entry_screen.dart';
import 'package:barcodes/features/barcodes/presentation/add_entry_form.dart';
import 'package:barcodes/features/categories/domain/category.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_widget/barcode_widget.dart'; // For BarcodeType
import '../../../helpers/pump_app.dart';
import '../../categories/data/mock_category_repository.dart';
import '../data/mock_barcode_repository.dart';

void main() {
  group('AddEntryScreen - Category Selection', () {
    final mockCategories = [
      Category(id: 'cat1', name: 'Electronics', color: 0xFF0000FF),
      Category(id: 'cat2', name: 'Books', color: 0xFF00FF00),
    ];

    final barcodeToEditWithCategory = BarcodeEntry(
      id: 1,
      name: 'Laptop',
      data: '12345',
      type: BarcodeType.Code128,
      categoryId: 'cat1',
    );

    final barcodeToEditWithoutCategory = BarcodeEntry(
      id: 2,
      name: 'Uncat Item',
      data: '67890',
      type: BarcodeType.QrCode,
    );

    late MockCategoryRepository mockCategoryRepo;
    late MockBarcodeRepository mockBarcodeRepo;

    Future<void> pumpAddEntryScreen(WidgetTester tester, {BarcodeEntry? barcodeEntry}) async {
      mockCategoryRepo = MockCategoryRepository(initialCategories: List.from(mockCategories));
      mockBarcodeRepo = MockBarcodeRepository(initialEntries: barcodeEntry != null ? [barcodeEntry] : []);

      await tester.pumpApp(
        ProviderScope(
          overrides: [
            categoryRepositoryProvider.overrideWithValue(mockCategoryRepo),
            categoriesProvider.overrideWith((ref) => mockCategoryRepo.watchCategories()),
            barcodeRepositoryProvider.overrideWithValue(mockBarcodeRepo),
            barcodesStreamProvider.overrideWith((ref) => mockBarcodeRepo.watchBarcodes()),
            // Ensure the controller provider is also potentially mocked or a real one is fine if it doesn't have complex dependencies
          ],
          child: AddEntryScreen(barcodeEntry: barcodeEntry),
        ),
      );
      await tester.pumpAndSettle(); // Allow streams to emit, and UI to build
    }

    testWidgets('category dropdown is present and populated', (WidgetTester tester) async {
      await pumpAddEntryScreen(tester);
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      // Find the dropdown
      final categoryDropdownFinder = find.widgetWithText(DropdownButtonFormField<String?>, appLocalizations.labelAddFormEntryCategoryDropdown);
      expect(categoryDropdownFinder, findsOneWidget);

      // Tap to open dropdown items
      await tester.tap(categoryDropdownFinder);
      await tester.pumpAndSettle(); // Wait for items to appear

      // Check for "No Category" and actual categories
      expect(find.text(appLocalizations.labelAddFormEntryCategoryNone).last, findsOneWidget); // .last because hint might also match
      expect(find.text('Electronics').last, findsOneWidget);
      expect(find.text('Books').last, findsOneWidget);
    });

    testWidgets('selecting a category updates the form state and saves on submit (new entry)', (WidgetTester tester) async {
      await pumpAddEntryScreen(tester);
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      // Fill other required fields
      await tester.enterText(find.widgetWithText(TextFormField, appLocalizations.labelAddFormEntryName), 'New Gadget');
      await tester.enterText(find.widgetWithText(TextFormField, appLocalizations.labelAddFormEntryData), 'XYZ123');
      // BarcodeType is pre-selected (Code128 by default in form)

      // Find and tap the category dropdown
      final categoryDropdownFinder = find.widgetWithText(DropdownButtonFormField<String?>, appLocalizations.labelAddFormEntryCategoryDropdown);
      await tester.tap(categoryDropdownFinder);
      await tester.pumpAndSettle();

      // Select 'Electronics'
      await tester.tap(find.text('Electronics').last);
      await tester.pumpAndSettle(); // Let selection update

      // Submit the form
      await tester.tap(find.text(appLocalizations.buttonSubmit));
      await tester.pumpAndSettle(); // Wait for submission and pop

      // Verify the barcode was added to the mock repo with the correct categoryId
      final addedBarcodes = mockBarcodeRepo.currentEntries;
      expect(addedBarcodes.length, 1);
      expect(addedBarcodes.first.name, 'New Gadget');
      expect(addedBarcodes.first.categoryId, 'cat1');
    });

    testWidgets('dropdown is pre-filled when editing a barcode with a category', (WidgetTester tester) async {
      await pumpAddEntryScreen(tester, barcodeEntry: barcodeToEditWithCategory);
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      // Find the dropdown
      final categoryDropdown = tester.widget<DropdownButtonFormField<String?>>(
        find.widgetWithText(DropdownButtonFormField<String?>, appLocalizations.labelAddFormEntryCategoryDropdown)
      );
      // The value of DropdownButtonFormField should be the categoryId
      expect(categoryDropdown.initialValue, isNull); // initialValue is not how we check current value after initState
      // Instead, check the actual value property of the DropdownButtonFormField itself.
      // This requires getting the state of the widget or checking the displayed text.
      // For simplicity, we'll check that 'Electronics' is displayed as the selected value.
      // This implies that the Dropdown's current value is 'cat1'.
      expect(find.descendant(of: find.widgetWithText(DropdownButtonFormField<String?>, appLocalizations.labelAddFormEntryCategoryDropdown), matching: find.text('Electronics')), findsOneWidget);
    });

    testWidgets('dropdown shows "No Category" when editing a barcode without a category', (WidgetTester tester) async {
      await pumpAddEntryScreen(tester, barcodeEntry: barcodeToEditWithoutCategory);
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));
      
      final categoryDropdown = tester.widget<DropdownButtonFormField<String?>>(
        find.widgetWithText(DropdownButtonFormField<String?>, appLocalizations.labelAddFormEntryCategoryDropdown)
      );
      // Check that "No Category" is displayed as the selected value.
      expect(find.descendant(of: find.widgetWithText(DropdownButtonFormField<String?>, appLocalizations.labelAddFormEntryCategoryDropdown), matching: find.text(appLocalizations.labelAddFormEntryCategoryNone)), findsOneWidget);
    });

    testWidgets('changing category and saving updates the barcode (editing)', (WidgetTester tester) async {
      await pumpAddEntryScreen(tester, barcodeEntry: barcodeToEditWithCategory); // Starts with 'cat1' (Electronics)
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      // Change category to 'Books'
      final categoryDropdownFinder = find.widgetWithText(DropdownButtonFormField<String?>, appLocalizations.labelAddFormEntryCategoryDropdown);
      await tester.tap(categoryDropdownFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Books').last);
      await tester.pumpAndSettle();

      // Submit the form (button text should be 'Save' when editing)
      await tester.tap(find.text(appLocalizations.buttonSave));
      await tester.pumpAndSettle();

      // Verify the barcode in the mock repo is updated
      final updatedBarcode = await mockBarcodeRepo.fetchEntry(barcodeToEditWithCategory.id);
      expect(updatedBarcode, isNotNull);
      expect(updatedBarcode!.categoryId, 'cat2');
    });

    testWidgets('setting category to "No Category" and saving updates the barcode (editing)', (WidgetTester tester) async {
      await pumpAddEntryScreen(tester, barcodeEntry: barcodeToEditWithCategory); // Starts with 'cat1' (Electronics)
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      // Change category to "No Category"
      final categoryDropdownFinder = find.widgetWithText(DropdownButtonFormField<String?>, appLocalizations.labelAddFormEntryCategoryDropdown);
      await tester.tap(categoryDropdownFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.text(appLocalizations.labelAddFormEntryCategoryNone).last);
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.text(appLocalizations.buttonSave));
      await tester.pumpAndSettle();

      final updatedBarcode = await mockBarcodeRepo.fetchEntry(barcodeToEditWithCategory.id);
      expect(updatedBarcode, isNotNull);
      expect(updatedBarcode!.categoryId, isNull);
    });

    testWidgets('if a category is deleted, dropdown defaults to "No Category" when editing', (WidgetTester tester) async {
      // Barcode has 'cat-deleted' which won't be in mockCategories
      final barcodeWithDeletedCategory = BarcodeEntry(
        id: 3, name: 'Orphan', data: 'XYZ', type: BarcodeType.Code128, categoryId: 'cat-deleted'
      );
      await pumpAddEntryScreen(tester, barcodeEntry: barcodeWithDeletedCategory);
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      // Verify dropdown shows "No Category" because 'cat-deleted' is not in mockCategories
      final categoryDropdown = tester.widget<DropdownButtonFormField<String?>>(
        find.widgetWithText(DropdownButtonFormField<String?>, appLocalizations.labelAddFormEntryCategoryDropdown)
      );
      expect(find.descendant(of: find.widgetWithText(DropdownButtonFormField<String?>, appLocalizations.labelAddFormEntryCategoryDropdown), matching: find.text(appLocalizations.labelAddFormEntryCategoryNone)), findsOneWidget);
      
      // Also check that the actual value in the form state is null
      final formState = tester.state<ConsumerState<AddEntryForm>>(find.byType(AddEntryForm));
      // This requires AddEntryForm's state to expose _selectedCategoryId or test via submission.
      // For now, visual check is primary. Let's test submission.

      // Fill other required fields
      await tester.enterText(find.widgetWithText(TextFormField, appLocalizations.labelAddFormEntryName), barcodeWithDeletedCategory.name); // Keep name
      await tester.enterText(find.widgetWithText(TextFormField, appLocalizations.labelAddFormEntryData), barcodeWithDeletedCategory.data); // Keep data
      
      // Submit
      await tester.tap(find.text(appLocalizations.buttonSave));
      await tester.pumpAndSettle();

      final updatedBarcode = await mockBarcodeRepo.fetchEntry(barcodeWithDeletedCategory.id);
      expect(updatedBarcode, isNotNull);
      expect(updatedBarcode!.categoryId, isNull); // Should be saved as null
    });

  });
}
