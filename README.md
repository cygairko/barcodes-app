# Barcodes

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A Flutter application for storing and managing a collection of your barcodes. Easily save, view, and organize various types of barcodes like QR codes, EAN, Code128, and more, right on your device.

## Features

*   **Add & Store Barcodes:** Save new barcodes by entering a name, the barcode data, selecting the barcode type, and adding an optional comment.
*   **Barcode Listing:** View all your saved barcodes in a clear, organized list.
*   **Barcode Display:** Tap on any entry to view its details and see the generated barcode image.
*   **Edit & Delete:** Modify existing barcode entries or remove ones you no longer need.
*   **Local Storage:** Your barcode data is stored securely on your device.
*   **Multiple Barcode Types:** Supports a wide range of barcode symbologies (e.g., QR Code, Code 39, Code 128, EAN-8, EAN-13, UPC-A, etc.).
*   **Multi-language Support:** Available in multiple languages.

## Getting Started 🚀

This project is built with Flutter and supports multiple flavors:

*   development
*   staging
*   production

To run the desired flavor, you can use the launch configuration in your IDE (VS Code/Android Studio) or use the following commands:

```sh
# Development
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

_\*Barcodes works on iOS, Android, Web, and Windows._

## Running Tests 🧪

To run all unit and widget tests:

```sh
flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report (requires [lcov](https://github.com/linux-test-project/lcov)):

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

## Working with Translations 🌐

This project uses `flutter_localizations` and follows the [official Flutter internationalization guide][internationalization_link].

### Adding Strings & Translations

1.  **Define Strings:** Add new localizable strings to `lib/l10n/arb/app_en.arb`.
    ```arb
    {
        "@@locale": "en",
        "newStringKey": "Your new string value",
        "@newStringKey": {
            "description": "Description of your new string"
        }
    }
    ```
2.  **Add Translations:** For each supported locale (e.g., `app_es.arb`), add the translated string.
3.  **Update iOS Locales:** If adding a new language, update `CFBundleLocalizations` in `ios/Runner/Info.plist`.

### Generating Translations

Run the following command to generate/update translation files:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```
Alternatively, `flutter run` will also trigger code generation.

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
