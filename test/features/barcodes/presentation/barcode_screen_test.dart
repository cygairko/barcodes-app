import 'package:barcode_widget/barcode_widget.dart'; // Import BarcodeType
import 'package:barcodes/features/barcodes/data/barcode_repository.dart';
import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/features/barcodes/presentation/barcode_screen.dart';
import 'package:barcodes/features/barcodes/presentation/barcodes_list_controller.dart';
import 'package:barcodes/features/settings/data/settings_repository.dart';
import 'package:barcodes/l10n/arb/app_localizations.dart';
import 'package:barcodes/utils/brightness_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate Mocks
@GenerateMocks([
  BrightnessService,
  SettingsRepository, // Re-generating here for completeness if run standalone
  BarcodesListController,
])
import 'barcode_screen_test.mocks.dart';

// Default mock BarcodeEntry
const mockBarcodeEntry = BarcodeEntry(
  id: 1, // Explicitly setting ID, though @Default(-1) exists in source
  name: 'Test Barcode',
  data: '1234567890123', // Ensure this is valid for EAN-13 if verification runs
  type: BarcodeType.CodeEAN13,
  comment: 'A test barcode entry for brightness tests',
);

// Helper function to pump the BarcodeScreen
Future<void> pumpBarcodeScreen(
  WidgetTester tester, {
  required MockBrightnessService mockBrightnessService,
  required bool initialAutoBrightness,
  required double initialMaxBrightnessLevel,
  required BarcodeEntry entry,
  MockBarcodesListController? mockBarcodesListController,
}) async {
  final controller = mockBarcodesListController ?? MockBarcodesListController();
  // Default stub for delete if not provided.
  if (mockBarcodesListController == null) {
    when(controller.delete(any)).thenAnswer((_) async => true);
  }

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        brightnessServiceProvider.overrideWithValue(mockBrightnessService),
        automaticScreenBrightnessProvider.overrideWith(
          (ref) => Future.value(initialAutoBrightness),
        ),
        maxScreenBrightnessLevelProvider.overrideWith(
          (ref) => Future.value(initialMaxBrightnessLevel),
        ),
        barcodeStreamProvider(entry.id).overrideWith((ref) => Stream.value(entry)),
        barcodesListControllerProvider.overrideWith(() => controller), // Corrected override for Notifier
      ],
      child: MaterialApp(
        home: BarcodeScreen(entryId: entry.id),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
      ),
    ),
  );
  // Pump and settle to allow futures (like providers in initState) to complete
  await tester.pumpAndSettle();
}

void main() {
  late MockBrightnessService mockBrightnessService;
  // SettingsRepository related providers are overridden directly with values,
  // so a full mock instance of SettingsRepository might not be needed for all tests,
  // but can be created if direct interaction with its methods is required.

  setUp(() {
    mockBrightnessService = MockBrightnessService();
    // Default stubs for BrightnessService
    when(mockBrightnessService.getCurrentBrightness()).thenAnswer((_) async => 0.5); // Default current brightness
    when(mockBrightnessService.setBrightness(any)).thenAnswer((_) async {});
    when(mockBrightnessService.resetBrightness()).thenAnswer((_) async {});
  });

  group('BarcodeScreen Brightness Tests', () {
    testWidgets('Double-tap on BarcodeWidget calls setBrightness(1.0)', (WidgetTester tester) async {
      await pumpBarcodeScreen(
        tester,
        mockBrightnessService: mockBrightnessService,
        initialAutoBrightness: false, // Does not affect this test directly
        initialMaxBrightnessLevel: 0.8, // Does not affect this test directly
        entry: mockBarcodeEntry,
      );

      // Find the BarcodeWidget
      final barcodeWidgetFinder = find.byKey(const Key('barcodeWidget'));
      expect(barcodeWidgetFinder, findsOneWidget);

      // Simulate a double-tap
      await tester.tap(barcodeWidgetFinder);
      await tester.pump(kDoubleTapMinTime);
      await tester.tap(barcodeWidgetFinder);
      await tester.pumpAndSettle(); // Allow any potential state changes

      // Verify that setBrightness(1.0) was called
      verify(mockBrightnessService.setBrightness(1)).called(1);
    });

    testWidgets('Automatic Brightening Disabled: no increase/restore calls for brightness', (
      WidgetTester tester,
    ) async {
      await pumpBarcodeScreen(
        tester,
        mockBrightnessService: mockBrightnessService,
        initialAutoBrightness: false, // Feature disabled
        initialMaxBrightnessLevel: 0.9, // A potential max level
        entry: mockBarcodeEntry,
      );

      // initState calls getCurrentBrightness.
      verify(mockBrightnessService.getCurrentBrightness()).called(1);
      // setBrightness should NOT be called to increase to 0.9.
      verifyNever(mockBrightnessService.setBrightness(0.9));
      // Clear interactions that happened during setup (like the above getCurrentBrightness)
      // before checking behavior on dispose.
      clearInteractions(mockBrightnessService);
      // Re-stub because clearInteractions removes them.
      when(mockBrightnessService.getCurrentBrightness()).thenAnswer((_) async => 0.5);
      when(mockBrightnessService.setBrightness(any)).thenAnswer((_) async {});

      // Pop the screen to test dispose
      Navigator.of(tester.element(find.byType(BarcodeScreen))).pop();
      await tester.pumpAndSettle();

      // On dispose, setBrightness should NOT be called to restore anything,
      // as _brightnessWasAdjustedByThisScreen should be false.
      verifyNever(mockBrightnessService.setBrightness(any));
    });

    testWidgets('Automatic Brightening Enabled: Brightness Increased and Restored', (WidgetTester tester) async {
      const initialBrightness = 0.5;
      const targetMaxBrightness = 0.9;
      when(mockBrightnessService.getCurrentBrightness()).thenAnswer((_) async => initialBrightness);
      // setBrightness will be called multiple times, capture them.
      final setBrightnessCalls = <double>[];
      when(mockBrightnessService.setBrightness(any)).thenAnswer((invocation) async {
        setBrightnessCalls.add(invocation.positionalArguments.first as double);
      });

      await pumpBarcodeScreen(
        tester,
        mockBrightnessService: mockBrightnessService,
        initialAutoBrightness: true,
        initialMaxBrightnessLevel: targetMaxBrightness,
        entry: mockBarcodeEntry,
      );

      // Verification on entry
      verify(mockBrightnessService.getCurrentBrightness()).called(1);
      expect(setBrightnessCalls, contains(targetMaxBrightness)); // Increased to target

      // Pop the screen
      Navigator.of(tester.element(find.byType(BarcodeScreen))).pop();
      await tester.pumpAndSettle();

      // Verification on dispose: should restore to the original initialBrightness
      expect(setBrightnessCalls, contains(initialBrightness));
      // Ensure the last call was to restore original brightness
      expect(setBrightnessCalls.last, initialBrightness);
    });

    testWidgets('Automatic Brightening Enabled: Brightness NOT Increased (already bright)', (
      WidgetTester tester,
    ) async {
      const currentBrightness = 0.8;
      const targetMaxBrightness = 0.7; // Target max (lower than current)
      when(mockBrightnessService.getCurrentBrightness()).thenAnswer((_) async => currentBrightness);

      final setBrightnessCalls = <double>[];
      when(mockBrightnessService.setBrightness(any)).thenAnswer((invocation) async {
        setBrightnessCalls.add(invocation.positionalArguments.first as double);
      });

      await pumpBarcodeScreen(
        tester,
        mockBrightnessService: mockBrightnessService,
        initialAutoBrightness: true,
        initialMaxBrightnessLevel: targetMaxBrightness,
        entry: mockBarcodeEntry,
      );

      // Verification on entry
      verify(mockBrightnessService.getCurrentBrightness()).called(1);
      // Crucially, setBrightness should NOT have been called to adjust to targetMaxBrightness.
      expect(setBrightnessCalls, isNot(contains(targetMaxBrightness)));
      // In fact, for this path, setBrightnessCalls should be empty after initState.
      expect(setBrightnessCalls, isEmpty);

      // Pop the screen
      Navigator.of(tester.element(find.byType(BarcodeScreen))).pop();
      await tester.pumpAndSettle();

      // Verification on dispose: setBrightness should NOT have been called to restore,
      // as _brightnessWasAdjustedByThisScreen should be false.
      // So, setBrightnessCalls should still be empty.
      expect(setBrightnessCalls, isEmpty);
    });
  });
}
