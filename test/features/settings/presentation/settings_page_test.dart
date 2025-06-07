import 'package:barcodes/features/settings/data/settings_repository.dart';
import 'package:barcodes/features/settings/presentation/settings_page.dart';
import 'package:barcodes/l10n/generated/app_localizations.dart';
import 'package:barcodes/utils/package_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';
// Import for AppLocalizations - try direct import

// Generate mocks for SettingsRepository
@GenerateMocks([SettingsRepository])
import 'settings_page_test.mocks.dart'; // Import generated mocks

// Helper function to pump the SettingsPage with necessary providers
Future<void> pumpSettingsPage(
  WidgetTester tester, {
  required MockSettingsRepository mockSettingsRepository,
  bool initialAutoBrightness = false,
  double initialMaxBrightnessLevel = 0.8,
}) async {
  // Mock the repository methods
  when(mockSettingsRepository.getAutomaticScreenBrightness()).thenAnswer((_) async => initialAutoBrightness);
  when(mockSettingsRepository.getMaxScreenBrightnessLevel()).thenAnswer((_) async => initialMaxBrightnessLevel);

  // Mock the set methods to do nothing or return a completed Future
  when(mockSettingsRepository.setAutomaticScreenBrightness(isAutoBrightness: true)).thenAnswer((_) async {});
  when(mockSettingsRepository.setAutomaticScreenBrightness(isAutoBrightness: false)).thenAnswer((_) async {});
  when(mockSettingsRepository.setMaxScreenBrightnessLevel(any)).thenAnswer((_) async {});

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        // Override the main repository provider
        settingsRepositoryProvider.overrideWithValue(mockSettingsRepository),
        // Override individual value providers to call the mocked repository.
        // This allows them to pick up changes in the mock when invalidated.
        automaticScreenBrightnessProvider.overrideWith(
          (ref) => ref.watch(settingsRepositoryProvider).getAutomaticScreenBrightness(),
        ),
        maxScreenBrightnessLevelProvider.overrideWith(
          (ref) => ref.watch(settingsRepositoryProvider).getMaxScreenBrightnessLevel(),
        ),
        // Provide a mock for packageInfoProvider as it's used in SettingsPage
        packageInfoProvider.overrideWith(
          (ref) => Future.value(
            PackageInfo(
              appName: 'TestApp',
              packageName: 'com.example.testapp',
              version: '1.0.0',
              buildNumber: '1',
            ),
          ),
        ),
        // REMOVE EXTRA PARENTHESIS THAT WAS HERE
      ],
      child: const MaterialApp(
        home: SettingsPage(),
        // Add localization delegates if your page uses context.l10n
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'), // Explicitly set a locale for testing
      ),
    ),
  );
  // Pump and settle to allow futures (like providers) to complete
  await tester.pumpAndSettle();
}

void main() {
  late MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    // It's crucial to set up default mocks for any repository methods
    // that will be called during the initial pumpWidget or subsequent rebuilds.
    // The `initialAutoBrightness` and `initialMaxBrightnessLevel` in `pumpSettingsPage`
    // will be used to configure these mocks for the *first* build.
  });

  group('SettingsPage Widget Tests', () {
    testWidgets('Initial state reflects provider values and slider is disabled', (WidgetTester tester) async {
      // Configure mocks for this specific test's initial state
      when(mockSettingsRepository.getAutomaticScreenBrightness()).thenAnswer((_) async => false);
      when(mockSettingsRepository.getMaxScreenBrightnessLevel()).thenAnswer((_) async => 0.7);
      // Ensure set methods are stubbed if they could possibly be called, though not expected here.
      when(mockSettingsRepository.setAutomaticScreenBrightness(isAutoBrightness: true)).thenAnswer((_) async {});
      when(mockSettingsRepository.setAutomaticScreenBrightness(isAutoBrightness: false)).thenAnswer((_) async {});
      when(mockSettingsRepository.setMaxScreenBrightnessLevel(any)).thenAnswer((_) async {});

      await pumpSettingsPage(
        tester,
        mockSettingsRepository: mockSettingsRepository,
        initialMaxBrightnessLevel: 0.7,
      );

      // Verify switch state
      final switchTile = tester.widget<SwitchListTile>(find.byKey(const Key('automaticBrightnessSwitch')));
      expect(switchTile.value, isFalse);

      // Verify slider value
      final slider = tester.widget<Slider>(find.byKey(const Key('maxBrightnessSlider')));
      expect(slider.value, 0.7);

      // Verify slider is disabled (onChanged is null)
      expect(slider.onChanged, isNull);
      expect(find.text('Enable automatic brightness to set level.'), findsOneWidget);
    });

    testWidgets('Tapping automatic brightness switch calls repository and updates UI', (WidgetTester tester) async {
      // Initial state: switch is OFF
      when(mockSettingsRepository.getAutomaticScreenBrightness()).thenAnswer((_) async => false);
      when(mockSettingsRepository.getMaxScreenBrightnessLevel()).thenAnswer((_) async => 0.8);
      when(mockSettingsRepository.setAutomaticScreenBrightness(isAutoBrightness: true)).thenAnswer((_) async {});
      when(mockSettingsRepository.setAutomaticScreenBrightness(isAutoBrightness: false)).thenAnswer((_) async {});

      await pumpSettingsPage(
        tester,
        mockSettingsRepository: mockSettingsRepository,
      );

      // Verify initial state
      var switchTile = tester.widget<SwitchListTile>(find.byKey(const Key('automaticBrightnessSwitch')));
      expect(switchTile.value, isFalse, reason: 'Switch should initially be off');
      var slider = tester.widget<Slider>(find.byKey(const Key('maxBrightnessSlider')));
      expect(slider.onChanged, isNull, reason: 'Slider should initially be disabled');

      // 1. Update the mock: When getAutomaticScreenBrightness is called next (after invalidation), it should return true.
      when(mockSettingsRepository.getAutomaticScreenBrightness()).thenAnswer((_) async => true);
      // If tapping the switch also affects the initial state of the slider (e.g. if it resets or changes),
      // ensure getMaxScreenBrightnessLevel is also mocked appropriately for the rebuild.
      // For this test, we assume it just enables, and the value remains what it was (0.8 from setUp).
      when(mockSettingsRepository.getMaxScreenBrightnessLevel()).thenAnswer((_) async => 0.8);

      // 2. Tap the switch
      await tester.tap(find.byKey(const Key('automaticBrightnessSwitch')));

      // 3. Rebuild the UI. Providers will be re-evaluated.
      //    The pumpSettingsPage is NOT called again here. We let the existing widget tree rebuild.
      await tester.pumpAndSettle();

      // 4. Verify repository SET method was called
      verify(mockSettingsRepository.setAutomaticScreenBrightness(isAutoBrightness: true)).called(1);

      // 5. Verify UI updates (switch is now on, slider is enabled)
      // Re-fetch the widget after pumpAndSettle
      switchTile = tester.widget(find.byKey(const Key('automaticBrightnessSwitch')));
      slider = tester.widget(find.byKey(const Key('maxBrightnessSlider')));

      expect(
        switchTile.value,
        isTrue,
        reason: 'Switch should be on after tap. Provider may not have updated UI if this fails.',
      );
      expect(slider.onChanged, isNotNull, reason: 'Slider should be enabled when switch is on');
      expect(find.text('Enable automatic brightness to set level.'), findsNothing);
    });

    testWidgets('Changing slider value calls repository when switch is on', (WidgetTester tester) async {
      // Initial state: switch is ON, slider value 0.5
      when(mockSettingsRepository.getAutomaticScreenBrightness()).thenAnswer((_) async => true);
      when(mockSettingsRepository.getMaxScreenBrightnessLevel()).thenAnswer((_) async => 0.5);
      // Ensure setMaxScreenBrightnessLevel is stubbed
      when(mockSettingsRepository.setMaxScreenBrightnessLevel(any)).thenAnswer((_) async {});

      await pumpSettingsPage(
        tester,
        mockSettingsRepository: mockSettingsRepository,
        initialAutoBrightness: true,
        initialMaxBrightnessLevel: 0.5,
      );

      // Verify initial state for slider
      var slider = tester.widget<Slider>(find.byKey(const Key('maxBrightnessSlider')));
      expect(slider.onChanged, isNotNull, reason: 'Slider should be enabled');
      expect(slider.value, 0.5, reason: 'Initial slider value');

      // Clear any interactions that might have happened during setup (e.g. if a provider invalidation caused a set)
      // This is important before verifying the specific call from the drag.
      clearInteractions(mockSettingsRepository);
      // Re-stub setMaxScreenBrightnessLevel because clearInteractions removes stubs.
      when(mockSettingsRepository.setMaxScreenBrightnessLevel(any)).thenAnswer((_) async {});

      // Mock the getMaxScreenBrightnessLevel to return a new value after the set operation,
      // to simulate the provider being invalidated and refetched, updating the slider's UI.
      const newSliderValue = 0.9; // The value we expect the slider to move to visually
      when(mockSettingsRepository.getMaxScreenBrightnessLevel()).thenAnswer((_) async => newSliderValue);

      // Drag the slider.
      // We expect the slider's onChanged to call setMaxScreenBrightnessLevel.
      // The actual value might be tricky with drag, so we'll capture it.
      // Let's assume dragging by a large offset changes it significantly towards newSliderValue.
      await tester.drag(find.byKey(const Key('maxBrightnessSlider')), const Offset(200, 0));
      await tester.pumpAndSettle();

      // Verify setMaxScreenBrightnessLevel was called. Due to drag behavior, it might be called multiple times.
      // We care that it was called, and typically would check the last value or that one of the values is what we expect.
      final captured = verify(mockSettingsRepository.setMaxScreenBrightnessLevel(captureAny)).captured;
      expect(captured, isNotEmpty, reason: 'setMaxScreenBrightnessLevel should be called by the drag');
      // If you need to check the value, you might check the last one:
      // expect(captured.last, closeTo(newSliderValue, 0.1)); // Or some other expected value based on drag

      // Verify that the slider UI updated (reads the new value from the provider)
      slider = tester.widget(find.byKey(const Key('maxBrightnessSlider')));
      expect(slider.value, newSliderValue, reason: 'Slider value should update after interaction and provider refresh');
    });

    testWidgets('Slider is disabled and does not call repository when switch is off', (WidgetTester tester) async {
      // Initial state: switch is OFF
      when(mockSettingsRepository.getAutomaticScreenBrightness()).thenAnswer((_) async => false);
      when(mockSettingsRepository.getMaxScreenBrightnessLevel()).thenAnswer((_) async => 0.8);
      // No set calls expected, but stub them just in case for robustness.
      when(mockSettingsRepository.setAutomaticScreenBrightness(isAutoBrightness: true)).thenAnswer((_) async {});
      when(mockSettingsRepository.setAutomaticScreenBrightness(isAutoBrightness: false)).thenAnswer((_) async {});
      when(mockSettingsRepository.setMaxScreenBrightnessLevel(any)).thenAnswer((_) async {});

      await pumpSettingsPage(
        tester,
        mockSettingsRepository: mockSettingsRepository,
      );

      // Attempt to change the slider value
      await tester.drag(find.byKey(const Key('maxBrightnessSlider')), const Offset(100, 0));
      await tester.pumpAndSettle();

      // Verify repository method was NOT called
      verifyNever(mockSettingsRepository.setMaxScreenBrightnessLevel(any));

      // Verify slider is still disabled
      final slider = tester.widget<Slider>(find.byKey(const Key('maxBrightnessSlider')));
      expect(slider.onChanged, isNull);
    });
  });
}
