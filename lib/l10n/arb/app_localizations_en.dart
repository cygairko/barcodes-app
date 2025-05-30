// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get counterAppBarTitle => 'Counter';

  @override
  String get navigationLabelHome => 'Home';

  @override
  String get navigationLabelBarcodes => 'Barcodes';

  @override
  String get navigationLabelProfile => 'Profile';

  @override
  String get navigationLabelSettings => 'Settings';

  @override
  String get appBarTitleBarcodes => 'Barcodes';

  @override
  String get appBarTitleSettings => 'Settings';

  @override
  String get appBarTitleBarcodeScreen => 'Barcode info';

  @override
  String get appBarTitleAddBarcodeScreen => 'Create barcode';

  @override
  String get noContentFound => 'No content found';

  @override
  String get buttonSubmit => 'Submit';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get labelAddFormEntryName => 'Entry name';

  @override
  String get labelAddFormEntryComment => 'Additional comment';

  @override
  String get labelAddFormEntryData => 'Data';

  @override
  String get labelAddFormEntryTypeDropdown => 'Barcode type';

  @override
  String get textBarcodeInfoNoContentTitle => 'No data';

  @override
  String get textBarcodeInfoNoContentMessage => 'for this barcode entry';

  @override
  String get settingsAutomaticBrightnessTitle => 'Automatic screen brightness';

  @override
  String get settingsAutomaticBrightnessSubtitle =>
      'Adjust brightness automatically when a barcode is shown. Alternative: Double-tap.';

  @override
  String get settingsMaxAutomaticBrightnessTitle => 'Maximum brightness level';

  @override
  String get settingsMaxAutomaticBrightnessSubtitleDisabled =>
      'Enable automatic brightness to set level.';

  @override
  String get settingsMaxAutomaticBrightnessSubtitleEnabled =>
      'Maximum level to which the screen will brighten up.';

  @override
  String get settingsMaxAutomaticBrightnessSubtitleLoading =>
      'Maximum level to which the screen will brighten up.';

  @override
  String get settingsMaxAutomaticBrightnessSubtitleError =>
      'Maximum level to which the screen will brighten up.';

  @override
  String get settingsAppVersionTitle => 'App version';
}
