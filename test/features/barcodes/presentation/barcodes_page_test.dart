import 'package:barcodes/features/barcodes/presentation/barcodes_list.dart';
import 'package:barcodes/features/barcodes/presentation/barcodes_page.dart';
import 'package:barcodes/features/settings/data/settings_repository.dart';
import 'package:barcodes/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Helper widget to wrap BarcodesPage for testing
class TestBarcodesPageWidget extends StatelessWidget {
  const TestBarcodesPageWidget({super.key, this.overrides = const []});

  final List<Override> overrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: const MaterialApp(
        // Adding localizations delegates for any text that might be in BarcodesPage (e.g., AppBar title)
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BarcodesPage(),
      ),
    );
  }
}

void main() {
  group('BarcodesPage conditional display', () {
    testWidgets('displays BarcodesList when display mode is list', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestBarcodesPageWidget(
          overrides: [
            barcodeDisplayModeProvider.overrideWith((ref) => Future.value(BarcodeDisplayMode.list)),
          ],
        ),
      );

      // Act
      await tester.pumpAndSettle(); // Wait for futures to resolve

      // Assert
      expect(find.byType(BarcodesList), findsOneWidget);
      expect(find.text('Carousel view coming soon!'), findsNothing);
    });

    testWidgets('displays placeholder when display mode is carousel', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestBarcodesPageWidget(
          overrides: [
            barcodeDisplayModeProvider.overrideWith((ref) => Future.value(BarcodeDisplayMode.carousel)),
          ],
        ),
      );

      // Act
      await tester.pumpAndSettle(); // Wait for futures to resolve

      // Assert
      expect(find.byType(BarcodesList), findsNothing);
      expect(find.text('Carousel view coming soon!'), findsOneWidget);
    });

    testWidgets('displays loading indicator when provider is loading, then content', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestBarcodesPageWidget(
          overrides: [
            barcodeDisplayModeProvider.overrideWith(
              (ref) => Future.delayed(const Duration(milliseconds: 100), () => BarcodeDisplayMode.list),
            ),
          ],
        ),
      );

      // Act & Assert for loading state
      // pump() once to show loading state, not pumpAndSettle()
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(BarcodesList), findsNothing); // Should not be there yet

      // Act & Assert for data state
      await tester.pumpAndSettle(); // Wait for the future to complete
      expect(find.byType(CircularProgressIndicator), findsNothing); // Should be gone
      expect(find.byType(BarcodesList), findsOneWidget); // List should now be visible
      expect(find.text('Carousel view coming soon!'), findsNothing);
    });
  });
}
