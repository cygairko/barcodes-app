import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/features/barcodes/presentation/barcode_info.dart';
import 'package:barcodes/l10n/arb/app_localizations.dart';
import 'package:barcodes/l10n/arb/app_localizations_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BarcodeInfo displays entry data correctly in ListTiles', (WidgetTester tester) async {
    // 1. Create a mock BarcodeEntry object
    const mockEntry = BarcodeEntry(
      id: 1,
      name: 'Test Barcode',
      type: BarcodeType.QrCode,
      data: 'test_data',
      comment: 'Test comment',
    );

    // 2. Pump the BarcodeInfo widget
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BarcodeInfo(entry: mockEntry),
        ),
      ),
    );

    // 3. Verify that the ListTile widgets are present
    expect(find.byType(ListTile), findsNWidgets(3));

    // 4. Verify Text widgets within each ListTile display correct data
    expect(find.text('Test Barcode'), findsOneWidget);
    expect(find.text(BarcodeType.QrCode.name), findsOneWidget);
    expect(find.text('Test comment'), findsOneWidget);

    // Verify subtitles (using l10n keys as stand-ins for actual localized strings)
    // This assumes that the AppLocalizations instance will provide the necessary strings.
    // For a more robust test, you might want to mock AppLocalizations or use a real one.
    // However, for this task, we'll find them by the text they'd display if l10n is set up.
    // We need to pump the widget again after a delay for localizations to load.
    await tester.pump();

    // At this point, context.l10n should be available.
    // We'll find the subtitle texts. This is a bit indirect, as we're finding the Text widget
    // that *should* contain the localized string.
    // A better way would be to get the AppLocalizations instance and check its properties,
    // but that's more involved for this test.

    // Find the Text widgets that are used as subtitles.
    // We expect labelAddFormEntryName, labelAddFormEntryTypeDropdown, labelAddFormEntryComment
    // to be found if localization is working.
    // Note: This part of the test might be brittle if the exact string changes frequently
    // or if the localization setup in the test environment is not perfect.
    // For now, we are checking if the Text widgets for subtitles are present.
    // We'll rely on the previous check of BarcodeInfo that used context.l10n.

    // Let's find the Text widgets that are subtitles.
    // The subtitle for Name
    expect(
      find.descendant(
        of: find.widgetWithText(ListTile, 'Test Barcode'),
        matching: find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == AppLocalizationsEn().labelAddFormEntryName,
        ),
      ),
      findsOneWidget,
    );

    // The subtitle for Type
    expect(
      find.descendant(
        of: find.widgetWithText(ListTile, BarcodeType.QrCode.name),
        matching: find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == AppLocalizationsEn().labelAddFormEntryTypeDropdown,
        ),
      ),
      findsOneWidget,
    );

    // The subtitle for Comment
    expect(
      find.descendant(
        of: find.widgetWithText(ListTile, 'Test comment'),
        matching: find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == AppLocalizationsEn().labelAddFormEntryComment,
        ),
      ),
      findsOneWidget,
    );

    // 5. Verify Icon widgets are present
    expect(find.byIcon(Icons.label_outline), findsOneWidget);
    expect(find.byIcon(Icons.settings_overscan), findsOneWidget);
    expect(find.byIcon(Icons.comment_outlined), findsOneWidget);
  });
}
