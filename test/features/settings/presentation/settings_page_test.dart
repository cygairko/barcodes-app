// ignore_for_file: prefer_const_constructors

import 'package:barcodes/features/settings/data/settings_repository.dart';
import 'package:barcodes/features/settings/presentation/settings_page.dart';
import 'package:barcodes/l10n/l10n.dart'; // Standard import
import 'package:barcodes/l10n/generated/app_localizations.dart'; // Direct import for diagnostics
import 'package:barcodes/routing/app_routes.dart'; // For ManageCategoriesRoute.name
import 'package:barcodes/utils/package_info.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart'; // For GoRouter
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'settings_page_test.mocks.dart';

// Ensure to run: flutter pub run build_runner build --delete-conflicting-outputs
@GenerateNiceMocks([MockSpec<SettingsRepository>()])
void main() {
  late MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
  });

  Future<void> pumpSettingsPage(
    WidgetTester tester, {
    required MockSettingsRepository settingsRepository,
    PackageInfo? packageInfo,
    // For FutureProviders, the override function should return a Future<T>
    // To test AsyncValue states, the Future itself should resolve to data, error, or be delayed for loading.
    Future<bool> Function()? automaticScreenBrightnessFuture,
    Future<double> Function()? maxScreenBrightnessFuture,
    GoRouter? router,
  }) async {
    final defaultPackageInfo = PackageInfo(appName: 'TestApp', packageName: 'com.test', version: '1.0.0', buildNumber: '1');

    final testRouter = router ?? GoRouter(
      initialLocation: '/', // Assuming SettingsPage is the initial route for these tests
      routes: [
        GoRoute(
          path: '/', // Path for SettingsPage
          name: 'settings_test_root', // A unique name for the test's perspective of settings
          builder: (context, state) => const SettingsPage(),
          routes: [
             GoRoute(
              name: ManageCategoriesRoute.name, // Actual name 'manageCategories'
              path: ManageCategoriesRoute.path, // Actual path 'categories'
              builder: (context, state) => const Scaffold(body: Center(child: Text('Manage Categories Page Placeholder'))),
            ),
          ]
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(settingsRepository),
          packageInfoProvider.overrideWith((ref) => Future.value(packageInfo ?? defaultPackageInfo)),
          if (automaticScreenBrightnessFuture != null)
            automaticScreenBrightnessProvider.overrideWith((ref) => automaticScreenBrightnessFuture()),
          if (maxScreenBrightnessFuture != null)
            maxScreenBrightnessLevelProvider.overrideWith((ref) => maxScreenBrightnessFuture()),
        ],
        child: MaterialApp.router(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: testRouter,
        ),
      ),
    );
  }

  group('SettingsPage Initial UI State Tests', () {
    // Remove const, as PackageInfo constructor is not const
    final testPackageInfo = PackageInfo(
      appName: 'Test Barcodes',
      packageName: 'com.example.barcodes.test',
      version: '1.2.3',
      buildNumber: '101',
    );

    testWidgets('renders initial state correctly when providers return data', (WidgetTester tester) async {
      // Arrange
      // SettingsRepository mock is already set up in setUp()
      // For initial state, we assume automatic brightness is off, and a default max brightness.
      final expectedInitialAutoBrightness = false;
      final expectedInitialMaxBrightness = 0.75;

      await pumpSettingsPage(
        tester,
        settingsRepository: mockSettingsRepository,
        packageInfo: testPackageInfo,
        automaticScreenBrightnessFuture: () => Future.value(expectedInitialAutoBrightness),
        maxScreenBrightnessFuture: () => Future.value(expectedInitialMaxBrightness),
      );
      await tester.pumpAndSettle(); // Allow futures to complete

      // Act & Assert
      // 1. Automatic Brightness Switch
      final autoBrightnessSwitchTile = find.byKey(const Key('automaticBrightnessSwitch'));
      expect(autoBrightnessSwitchTile, findsOneWidget);
      final switchWidget = tester.widget<SwitchListTile>(autoBrightnessSwitchTile);
      expect(switchWidget.value, expectedInitialAutoBrightness);
      expect(find.text('Automatic screen brightness'), findsOneWidget); // Key: settingsAutomaticBrightnessTitle
      expect(find.text('Adjust brightness automatically when a barcode is shown. Alternative: Double-tap.'), findsOneWidget); // Key: settingsAutomaticBrightnessSubtitle

      // 2. Max Brightness Slider
      final maxBrightnessSliderTile = find.widgetWithText(ListTile, 'Maximum brightness level'); // Key: settingsMaxAutomaticBrightnessTitle
      expect(maxBrightnessSliderTile, findsOneWidget);
      final sliderWidget = tester.widget<Slider>(find.byKey(const Key('maxBrightnessSlider')));
      expect(sliderWidget.value, expectedInitialMaxBrightness);
      // Slider should be disabled because automatic brightness is off
      expect(sliderWidget.onChanged, isNull);
      expect(find.text('Enable automatic brightness to set level.'), findsOneWidget); // Key: settingsMaxAutomaticBrightnessSubtitleDisabled


      // 3. App Version Display
      expect(find.text('App version'), findsOneWidget);
      expect(find.text(testPackageInfo.version), findsOneWidget);

      // 4. Manage Categories Link
      expect(find.widgetWithText(ListTile, 'Manage Categories'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });

    testWidgets('renders loading state for brightness settings', (WidgetTester tester) async {
      await FakeAsync().run((fakeAsync) async {
        // Arrange
        await pumpSettingsPage(
        tester,
        settingsRepository: mockSettingsRepository,
        packageInfo: testPackageInfo,
        // For loading, use a minimal delay. It won't complete until timers are flushed.
        automaticScreenBrightnessFuture: () => Future.delayed(const Duration(milliseconds: 1), () => false),
        maxScreenBrightnessFuture: () => Future.delayed(const Duration(milliseconds: 1), () => 0.0),
      );
      // Do not pumpAndSettle, check immediate loading state

      // Act & Assert
      // Automatic Brightness Switch should show its default (false) or a spinner if implemented
      final autoBrightnessSwitchTile = find.byKey(const Key('automaticBrightnessSwitch'));
      expect(autoBrightnessSwitchTile, findsOneWidget);
      // Default value is false when loading
      expect(tester.widget<SwitchListTile>(autoBrightnessSwitchTile).value, false);

      // Max Brightness Slider should show loading subtitle
      expect(find.text('Maximum brightness level'), findsOneWidget); // Key: settingsMaxAutomaticBrightnessTitle
      // Slider defaults to 0.8 and is disabled
      final sliderWidget = tester.widget<Slider>(find.byKey(const Key('maxBrightnessSlider')));
      expect(sliderWidget.value, 0.8); // Default value from widget
      expect(sliderWidget.onChanged, isNull);
      // This is the actual text for loading from app_en.arb's settingsMaxAutomaticBrightnessSubtitleLoading
      expect(find.text('Maximum level to which the screen will brighten up.'), findsOneWidget);

      // Clean up timers
      fakeAsync.flushTimers();
    });
    });

     testWidgets('renders error state for brightness settings', (WidgetTester tester) async {
      // Arrange
      final error = Exception('Failed to load settings');
      await pumpSettingsPage(
        tester,
        settingsRepository: mockSettingsRepository,
        packageInfo: testPackageInfo,
        automaticScreenBrightnessFuture: () => Future.error(error),
        maxScreenBrightnessFuture: () => Future.error(error),
      );
      await tester.pumpAndSettle(); // Allow futures to complete with error

      // Act & Assert
      // Automatic Brightness Switch
      final autoBrightnessSwitchTile = find.byKey(const Key('automaticBrightnessSwitch'));
      expect(autoBrightnessSwitchTile, findsOneWidget);
      expect(tester.widget<SwitchListTile>(autoBrightnessSwitchTile).value, false); // Default on error

      // Max Brightness Slider should show error subtitle
      expect(find.text('Maximum brightness level'), findsOneWidget); // Key: settingsMaxAutomaticBrightnessTitle
      final sliderWidget = tester.widget<Slider>(find.byKey(const Key('maxBrightnessSlider')));
      expect(sliderWidget.value, 0.8); // Default value from widget
      expect(sliderWidget.onChanged, isNull); // Disabled on error
      // This is the actual text for error from app_en.arb's settingsMaxAutomaticBrightnessSubtitleError
      // The error message itself from the exception will be appended by the app code.
      expect(find.textContaining('Maximum level to which the screen will brighten up.'), findsOneWidget);
      expect(find.textContaining(error.toString()), findsOneWidget); // Check if the actual error is also shown
    });

    // TODO: Add more tests for interactions (tapping switch, moving slider)
    // TODO: Add tests for navigation to Manage Categories page
  });

  group('SettingsPage Interactions', () {
    final testPackageInfo = PackageInfo(
      appName: 'Test App',
      packageName: 'com.example.test',
      version: '1.0',
      buildNumber: '1',
    );
    const initialSliderValue = 0.7;

    testWidgets('toggles automatic brightness switch ON', (WidgetTester tester) async {
      // Arrange: Start with switch OFF
      // The automaticScreenBrightnessProvider will initially return a future that resolves to false.
      // The maxScreenBrightnessLevelProvider will return a future resolving to initialSliderValue.
      // These are one-time futures. The providers will be invalidated and re-fetch.
      when(mockSettingsRepository.getAutomaticScreenBrightness()).thenAnswer((_) async => false);
      when(mockSettingsRepository.getMaxScreenBrightnessLevel()).thenAnswer((_) async => initialSliderValue);

      await pumpSettingsPage(
        tester,
        settingsRepository: mockSettingsRepository,
        packageInfo: testPackageInfo,
        // Initial state for providers (will be called once before invalidation)
        automaticScreenBrightnessFuture: () => mockSettingsRepository.getAutomaticScreenBrightness(),
        maxScreenBrightnessFuture: () => mockSettingsRepository.getMaxScreenBrightnessLevel(),
      );
      await tester.pumpAndSettle(); // Settle initial provider states

      // Verify initial state: Switch is OFF, Slider is disabled
      expect(tester.widget<SwitchListTile>(find.byKey(const Key('automaticBrightnessSwitch'))).value, false);
      expect(tester.widget<Slider>(find.byKey(const Key('maxBrightnessSlider'))).onChanged, isNull);
      expect(find.text('Enable automatic brightness to set level.'), findsOneWidget);

      // Setup mocks for interaction:
      // 1. When set is called, it should succeed.
      when(mockSettingsRepository.setAutomaticScreenBrightness(isAutoBrightness: true)).thenAnswer((_) async {});
      // 2. After invalidation, the getAutomaticScreenBrightness provider should return true.
      when(mockSettingsRepository.getAutomaticScreenBrightness()).thenAnswer((_) async => true);
      // 3. Max brightness can remain the same or be fetched again.
      //    SettingsPage invalidates maxScreenBrightnessLevelProvider too.
      when(mockSettingsRepository.getMaxScreenBrightnessLevel()).thenAnswer((_) async => initialSliderValue);


      // Act
      await tester.tap(find.byKey(const Key('automaticBrightnessSwitch')));
      await tester.pumpAndSettle(); // Allow providers to invalidate, futures to complete, and UI to rebuild

      // Assert
      // 1. Repository method was called
      verify(mockSettingsRepository.setAutomaticScreenBrightness(isAutoBrightness: true)).called(1);

      // 2. Switch UI updated to ON
      expect(tester.widget<SwitchListTile>(find.byKey(const Key('automaticBrightnessSwitch'))).value, true);

      // 3. Slider becomes enabled
      final slider = tester.widget<Slider>(find.byKey(const Key('maxBrightnessSlider')));
      expect(slider.onChanged, isNotNull);
      expect(slider.value, initialSliderValue); // Value should still be what the provider returned

      // 4. Slider subtitle updates
      // Key: settingsMaxAutomaticBrightnessSubtitleEnabled / settingsMaxAutomaticBrightnessSubtitleLoading (if still loading)
      // The actual key used in the app for "enabled" is settingsMaxAutomaticBrightnessSubtitleEnabled
      expect(find.text('Maximum level to which the screen will brighten up.'), findsOneWidget);
    });

    testWidgets('toggles automatic brightness switch OFF', (WidgetTester tester) async {
      // Arrange: Start with switch ON
      when(mockSettingsRepository.getAutomaticScreenBrightness()).thenAnswer((_) async => true);
      when(mockSettingsRepository.getMaxScreenBrightnessLevel()).thenAnswer((_) async => initialSliderValue);

      await pumpSettingsPage(
        tester,
        settingsRepository: mockSettingsRepository,
        packageInfo: testPackageInfo,
        automaticScreenBrightnessFuture: () => mockSettingsRepository.getAutomaticScreenBrightness(),
        maxScreenBrightnessFuture: () => mockSettingsRepository.getMaxScreenBrightnessLevel(),
      );
      await tester.pumpAndSettle();

      // Verify initial state: Switch is ON, Slider is enabled
      expect(tester.widget<SwitchListTile>(find.byKey(const Key('automaticBrightnessSwitch'))).value, true);
      expect(tester.widget<Slider>(find.byKey(const Key('maxBrightnessSlider'))).onChanged, isNotNull);
      expect(find.text('Maximum level to which the screen will brighten up.'), findsOneWidget);


      // Setup mocks for interaction:
      when(mockSettingsRepository.setAutomaticScreenBrightness(isAutoBrightness: false)).thenAnswer((_) async {});
      when(mockSettingsRepository.getAutomaticScreenBrightness()).thenAnswer((_) async => false); // New state after invalidation
      when(mockSettingsRepository.getMaxScreenBrightnessLevel()).thenAnswer((_) async => initialSliderValue);


      // Act
      await tester.tap(find.byKey(const Key('automaticBrightnessSwitch')));
      await tester.pumpAndSettle();

      // Assert
      verify(mockSettingsRepository.setAutomaticScreenBrightness(isAutoBrightness: false)).called(1);
      expect(tester.widget<SwitchListTile>(find.byKey(const Key('automaticBrightnessSwitch'))).value, false);
      expect(tester.widget<Slider>(find.byKey(const Key('maxBrightnessSlider'))).onChanged, isNull);
      expect(find.text('Enable automatic brightness to set level.'), findsOneWidget); // Key: settingsMaxAutomaticBrightnessSubtitleDisabled
    });

    testWidgets('changes slider value when enabled', (WidgetTester tester) async {
      // Arrange: Switch ON, Slider enabled
      const currentSliderValue = 0.5;
      const newSliderValue = 0.8;

      // Initial provider states
      when(mockSettingsRepository.getAutomaticScreenBrightness()).thenAnswer((_) async => true);
      when(mockSettingsRepository.getMaxScreenBrightnessLevel()).thenAnswer((_) async => currentSliderValue);

      await pumpSettingsPage(
        tester,
        settingsRepository: mockSettingsRepository,
        packageInfo: testPackageInfo,
        automaticScreenBrightnessFuture: () => mockSettingsRepository.getAutomaticScreenBrightness(),
        maxScreenBrightnessFuture: () => mockSettingsRepository.getMaxScreenBrightnessLevel(),
      );
      await tester.pumpAndSettle();

      // Verify initial slider state
      var sliderWidget = tester.widget<Slider>(find.byKey(const Key('maxBrightnessSlider')));
      expect(sliderWidget.value, currentSliderValue);
      expect(sliderWidget.onChanged, isNotNull); // Enabled
      expect(find.text('Maximum level to which the screen will brighten up.'), findsOneWidget);


      // Setup mocks for interaction:
      // 1. When setMaxScreenBrightnessLevel is called, it should succeed.
      when(mockSettingsRepository.setMaxScreenBrightnessLevel(any)).thenAnswer((_) async {});
      // 2. After invalidation, getMaxScreenBrightnessLevel should return the new value.
      when(mockSettingsRepository.getMaxScreenBrightnessLevel()).thenAnswer((_) async => newSliderValue);

      // Act: Drag the slider to a new value.
      // The slider has min 0.1, max 1.0 (default), divisions 9.
      // Values are 0.1, 0.2, ..., 1.0.
      // To change from 0.5 to 0.8, we need to move it 3 divisions to the right.
      // Slider width can be approximated or we can tap. Tapping might be more precise.
      // Let's find the slider and tap on the point corresponding to 0.8
      final sliderFinder = find.byKey(const Key('maxBrightnessSlider'));
      // Dragging from current value (0.5) to new value (0.8)
      // Offset is (newValue - currentValue) * sliderWidth / (max - min)
      // For now, a simple drag should suffice to trigger onChanged.
      // A more precise way: calculate the position.
      // (newValue - min) / (max - min) gives the percentage position.
      // 0.8 is the 8th value if 0.1 is 1st (0.1, 0.2 ... 0.8) so ((8-1)/(10-1)) = 7/9 of the width
      // Target position for 0.8: (0.8 - 0.1) / (1.0 - 0.1) = 0.7 / 0.9 = 7/9 of the track width.
      // We'll use a drag offset that should reliably change the value.
      await tester.drag(sliderFinder, const Offset(100.0, 0.0)); // Arbitrary drag right
      await tester.pumpAndSettle();


      // Assert
      // 1. Repository method was called with the new value.
      //    Due to drag inaccuracy, we capture the argument.
      final capturedValue = verify(mockSettingsRepository.setMaxScreenBrightnessLevel(captureAny)).captured.single as double;
      // Check if it's close to one of the discrete values. Here, we expect it to trigger an update.
      // The actual value might not be exactly 0.8 due to drag behavior.
      // For simplicity, we'll check that it was called, and then check the UI.
      // A better check would be to ensure capturedValue is one of 0.1, 0.2 ... 1.0
      expect(capturedValue, isNotNull, reason: "setMaxScreenBrightnessLevel should be called");


      // 2. Slider UI updated
      sliderWidget = tester.widget<Slider>(find.byKey(const Key('maxBrightnessSlider')));
      // The UI should reflect the value returned by getMaxScreenBrightnessLevel after invalidation (newSliderValue = 0.8)
      expect(sliderWidget.value, newSliderValue);
      expect(sliderWidget.label, newSliderValue.toStringAsFixed(1));

      // 3. Subtitle remains for enabled state
      expect(find.text('Maximum level to which the screen will brighten up.'), findsOneWidget);
    });

    testWidgets('slider interaction does not call repository when disabled', (WidgetTester tester) async {
      // Arrange: Switch OFF, Slider disabled
      const initialSliderVal = 0.6;
      when(mockSettingsRepository.getAutomaticScreenBrightness()).thenAnswer((_) async => false);
      when(mockSettingsRepository.getMaxScreenBrightnessLevel()).thenAnswer((_) async => initialSliderVal);


      await pumpSettingsPage(
        tester,
        settingsRepository: mockSettingsRepository,
        packageInfo: testPackageInfo,
        automaticScreenBrightnessFuture: () => mockSettingsRepository.getAutomaticScreenBrightness(),
        maxScreenBrightnessFuture: () => mockSettingsRepository.getMaxScreenBrightnessLevel(),
      );
      await tester.pumpAndSettle();

      // Verify initial slider state
      var sliderWidget = tester.widget<Slider>(find.byKey(const Key('maxBrightnessSlider')));
      expect(sliderWidget.value, initialSliderVal);
      expect(sliderWidget.onChanged, isNull); // Disabled
      expect(find.text('Enable automatic brightness to set level.'), findsOneWidget);

      // Act: Attempt to drag the slider
      await tester.drag(find.byKey(const Key('maxBrightnessSlider')), const Offset(100.0, 0.0));
      await tester.pumpAndSettle();

      // Assert
      // 1. Repository method was NOT called
      verifyNever(mockSettingsRepository.setMaxScreenBrightnessLevel(any));

      // 2. Slider UI remains unchanged
      sliderWidget = tester.widget<Slider>(find.byKey(const Key('maxBrightnessSlider')));
      expect(sliderWidget.value, initialSliderVal); // Value should not change

      // 3. Subtitle remains for disabled state
      expect(find.text('Enable automatic brightness to set level.'), findsOneWidget);
    });
  });

  group('SettingsPage Navigation Tests', () {
    final testPackageInfo = PackageInfo(
      appName: 'Test Nav App',
      packageName: 'com.example.navtest',
      version: '1.0',
      buildNumber: '1',
    );

    testWidgets('navigates to Manage Categories page when ListTile is tapped', (WidgetTester tester) async {
      // Arrange
      // Mock basic getters for providers to avoid null/error states during initial build
      // if SettingsPage tries to access them before navigation.
      when(mockSettingsRepository.getAutomaticScreenBrightness()).thenAnswer((_) async => false);
      when(mockSettingsRepository.getMaxScreenBrightnessLevel()).thenAnswer((_) async => 0.5);

      await pumpSettingsPage(
        tester,
        settingsRepository: mockSettingsRepository,
        packageInfo: testPackageInfo,
        automaticScreenBrightnessFuture: () => mockSettingsRepository.getAutomaticScreenBrightness(),
        maxScreenBrightnessFuture: () => mockSettingsRepository.getMaxScreenBrightnessLevel(),
        // The default router created in pumpSettingsPage will be used.
      );
      await tester.pumpAndSettle(); // Initial page load of SettingsPage

      // Verify SettingsPage is present
      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.text('Manage Categories Page Placeholder'), findsNothing);

      // Act
      final manageCategoriesTile = find.widgetWithText(ListTile, 'Manage Categories');
      expect(manageCategoriesTile, findsOneWidget, reason: "Manage Categories ListTile should be present");
      await tester.tap(manageCategoriesTile);
      await tester.pumpAndSettle(); // Process navigation

      // Assert
      // After navigation, the placeholder for Manage Categories page should be visible
      expect(find.text('Manage Categories Page Placeholder'), findsOneWidget);
      // And the original SettingsPage might be gone or not visible depending on router stack behavior
      // For a simple push, the original page might still be in the widget tree but not visible.
      // A more robust check is that the new page's content is there.
    });
  });
}
