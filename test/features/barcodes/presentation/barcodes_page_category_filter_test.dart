import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/features/barcodes/presentation/barcodes_list.dart';
import 'package:barcodes/features/barcodes/presentation/barcodes_page.dart';
import 'package:barcodes/features/categories/domain/category.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helpers/pump_app.dart';
import '../../categories/data/mock_category_repository.dart';
import '../data/mock_barcode_repository.dart';

void main() {
  group('BarcodesPage - Category Filters', () {
    final mockCategories = [
      Category(id: 'cat1', name: 'Electronics', color: 0xFF0000FF),
      Category(id: 'cat2', name: 'Books', color: 0xFF00FF00),
    ];

    final mockBarcodes = [
      BarcodeEntry(id: 1, name: 'Laptop', data: '123', type: BarcodeType.Code128, categoryId: 'cat1'),
      BarcodeEntry(id: 2, name: 'Novel', data: '456', type: BarcodeType.QrCode, categoryId: 'cat2'),
      BarcodeEntry(id: 3, name: 'Keyboard', data: '789', type: BarcodeType.DataMatrix, categoryId: 'cat1'),
      BarcodeEntry(id: 4, name: 'Charger', data: 'ABC', type: BarcodeType.Code39, categoryId: 'cat1'),
      BarcodeEntry(id: 5, name: 'Dictionary', data: 'DEF', type: BarcodeType.CodeEAN13, categoryId: 'cat2'),
      BarcodeEntry(id: 6, name: 'Uncategorized', data: 'GHI', type: BarcodeType.CodeEAN8),
    ];

    late MockCategoryRepository mockCategoryRepo;
    late MockBarcodeRepository mockBarcodeRepo;

    Future<void> pumpBarcodesPage(WidgetTester tester) async {
      mockCategoryRepo = MockCategoryRepository(initialCategories: List.from(mockCategories));
      mockBarcodeRepo = MockBarcodeRepository(initialEntries: List.from(mockBarcodes));

      await tester.pumpApp(
        ProviderScope(
          overrides: [
            categoryRepositoryProvider.overrideWithValue(mockCategoryRepo),
            categoriesProvider.overrideWith((ref) => mockCategoryRepo.watchCategories()),
            barcodeRepositoryProvider.overrideWithValue(mockBarcodeRepo),
            barcodesStreamProvider.overrideWith((ref) => mockBarcodeRepo.watchBarcodes()),
          ],
          child: const BarcodesPage(),
        ),
      );
      await tester.pumpAndSettle(); // Allow streams to emit and UI to build
    }

    testWidgets('displays "All" and category filter chips', (WidgetTester tester) async {
      await pumpBarcodesPage(tester);
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));


      expect(find.widgetWithText(FilterChip, appLocalizations.generalAll), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Electronics'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Books'), findsOneWidget);

      // Check "All" is selected by default
      final allChip = tester.widget<FilterChip>(find.widgetWithText(FilterChip, appLocalizations.generalAll));
      expect(allChip.selected, isTrue);
    });

    testWidgets('selecting a category chip deselects "All" and filters list', (WidgetTester tester) async {
      await pumpBarcodesPage(tester);
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      // Initially, all barcodes are shown (or those matching default filter if any)
      expect(find.text('Laptop'), findsOneWidget); // cat1
      expect(find.text('Novel'), findsOneWidget);   // cat2
      expect(find.text('Uncategorized'), findsOneWidget); // no category

      // Tap 'Electronics' chip
      await tester.tap(find.widgetWithText(FilterChip, 'Electronics'));
      await tester.pumpAndSettle();

      // Verify "All" is deselected and "Electronics" is selected
      final allChip = tester.widget<FilterChip>(find.widgetWithText(FilterChip, appLocalizations.generalAll));
      expect(allChip.selected, isFalse);
      final electronicsChip = tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'Electronics'));
      expect(electronicsChip.selected, isTrue);

      // Verify BarcodesList receives correct filter
      final barcodesListWidget = tester.widget<BarcodesList>(find.byType(BarcodesList));
      expect(barcodesListWidget.selectedCategoryIds, equals({'cat1'}));
      
      // Verify filtered list in UI
      expect(find.text('Laptop'), findsOneWidget);     // cat1
      expect(find.text('Keyboard'), findsOneWidget);   // cat1
      expect(find.text('Charger'), findsOneWidget);    // cat1
      expect(find.text('Novel'), findsNothing);      // cat2
      expect(find.text('Dictionary'), findsNothing); // cat2
      expect(find.text('Uncategorized'), findsNothing); // no category
    });

    testWidgets('selecting "All" chip deselects category chips and shows all', (WidgetTester tester) async {
      await pumpBarcodesPage(tester);
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      // First, select 'Electronics'
      await tester.tap(find.widgetWithText(FilterChip, 'Electronics'));
      await tester.pumpAndSettle();
      expect(tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'Electronics')).selected, isTrue);
      expect(find.text('Novel'), findsNothing); // Novel (cat2) should be filtered out

      // Then, tap 'All' chip
      await tester.tap(find.widgetWithText(FilterChip, appLocalizations.generalAll));
      await tester.pumpAndSettle();

      // Verify "Electronics" is deselected and "All" is selected
      expect(tester.widget<FilterChip>(find.widgetWithText(FilterChip, appLocalizations.generalAll)).selected, isTrue);
      expect(tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'Electronics')).selected, isFalse);
      
      // Verify BarcodesList receives empty set for "All"
      final barcodesListWidget = tester.widget<BarcodesList>(find.byType(BarcodesList));
      expect(barcodesListWidget.selectedCategoryIds, isEmpty);

      // Verify all items are back
      expect(find.text('Laptop'), findsOneWidget);
      expect(find.text('Novel'), findsOneWidget);
      expect(find.text('Uncategorized'), findsOneWidget);
    });

    testWidgets('selecting multiple category chips works', (WidgetTester tester) async {
      await pumpBarcodesPage(tester);
      
      // Tap 'Electronics'
      await tester.tap(find.widgetWithText(FilterChip, 'Electronics'));
      await tester.pumpAndSettle();
      // Tap 'Books'
      await tester.tap(find.widgetWithText(FilterChip, 'Books'));
      await tester.pumpAndSettle();

      // Verify both are selected
      expect(tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'Electronics')).selected, isTrue);
      expect(tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'Books')).selected, isTrue);

      // Verify BarcodesList receives correct filter
      final barcodesListWidget = tester.widget<BarcodesList>(find.byType(BarcodesList));
      expect(barcodesListWidget.selectedCategoryIds, equals({'cat1', 'cat2'}));

      // Verify filtered list
      expect(find.text('Laptop'), findsOneWidget);       // cat1
      expect(find.text('Novel'), findsOneWidget);        // cat2
      expect(find.text('Keyboard'), findsOneWidget);     // cat1
      expect(find.text('Charger'), findsOneWidget);      // cat1
      expect(find.text('Dictionary'), findsOneWidget);   // cat2
      expect(find.text('Uncategorized'), findsNothing); // no category
    });

    testWidgets('deselecting all category chips selects "All"', (WidgetTester tester) async {
      await pumpBarcodesPage(tester);
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      // Select 'Electronics'
      await tester.tap(find.widgetWithText(FilterChip, 'Electronics'));
      await tester.pumpAndSettle();
      expect(tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'Electronics')).selected, isTrue);

      // Deselect 'Electronics'
      await tester.tap(find.widgetWithText(FilterChip, 'Electronics'));
      await tester.pumpAndSettle();
      
      // Verify "All" is now selected
      expect(tester.widget<FilterChip>(find.widgetWithText(FilterChip, appLocalizations.generalAll)).selected, isTrue);
      expect(tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'Electronics')).selected, isFalse);
      
      final barcodesListWidget = tester.widget<BarcodesList>(find.byType(BarcodesList));
      expect(barcodesListWidget.selectedCategoryIds, isEmpty);
    });

    testWidgets('filter bar is hidden if no categories exist', (WidgetTester tester) async {
      mockCategoryRepo = MockCategoryRepository(initialCategories: []); // No categories
      mockBarcodeRepo = MockBarcodeRepository(initialEntries: List.from(mockBarcodes));
      final dynamic appLocalizations = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.pumpApp(
        ProviderScope(
          overrides: [
            categoryRepositoryProvider.overrideWithValue(mockCategoryRepo),
            categoriesProvider.overrideWith((ref) => mockCategoryRepo.watchCategories()),
            barcodeRepositoryProvider.overrideWithValue(mockBarcodeRepo),
            barcodesStreamProvider.overrideWith((ref) => mockBarcodeRepo.watchBarcodes()),
          ],
          child: const BarcodesPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(FilterChip, appLocalizations.generalAll), findsNothing);
      expect(find.byType(FilterChip), findsNothing);
    });
  });
}
