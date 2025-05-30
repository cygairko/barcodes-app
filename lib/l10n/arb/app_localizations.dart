import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('es')];

  /// Text shown in the AppBar of the Counter Page
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get counterAppBarTitle;

  /// navigationLabelHome
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navigationLabelHome;

  /// navigationLabelBarcodes
  ///
  /// In en, this message translates to:
  /// **'Barcodes'**
  String get navigationLabelBarcodes;

  /// navigationLabelProfile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navigationLabelProfile;

  /// navigationLabelSettings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navigationLabelSettings;

  /// appBarTitleBarcodes
  ///
  /// In en, this message translates to:
  /// **'Barcodes'**
  String get appBarTitleBarcodes;

  /// appBarTitleSettings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get appBarTitleSettings;

  /// appBarTitleBarcodeScreen
  ///
  /// In en, this message translates to:
  /// **'Barcode info'**
  String get appBarTitleBarcodeScreen;

  /// appBarTitleAddBarcodeScreen
  ///
  /// In en, this message translates to:
  /// **'Create barcode'**
  String get appBarTitleAddBarcodeScreen;

  /// noContentFound
  ///
  /// In en, this message translates to:
  /// **'No content found'**
  String get noContentFound;

  /// buttonSubmit
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get buttonSubmit;

  /// buttonCancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// labelAddFormEntryName
  ///
  /// In en, this message translates to:
  /// **'Entry name'**
  String get labelAddFormEntryName;

  /// labelAddFormEntryComment
  ///
  /// In en, this message translates to:
  /// **'Additional comment'**
  String get labelAddFormEntryComment;

  /// labelAddFormEntryData
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get labelAddFormEntryData;

  /// labelAddFormEntryTypeDropdown
  ///
  /// In en, this message translates to:
  /// **'Barcode type'**
  String get labelAddFormEntryTypeDropdown;

  /// textBarcodeInfoNoContentTitle
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get textBarcodeInfoNoContentTitle;

  /// textBarcodeInfoNoContentMessage
  ///
  /// In en, this message translates to:
  /// **'for this barcode entry'**
  String get textBarcodeInfoNoContentMessage;

  /// settingsAutomaticBrightnessTitle
  ///
  /// In en, this message translates to:
  /// **'Automatic screen brightness'**
  String get settingsAutomaticBrightnessTitle;

  /// settingsAutomaticBrightnessSubtitle
  ///
  /// In en, this message translates to:
  /// **'Adjust brightness automatically when a barcode is shown. Alternative: Double-tap.'**
  String get settingsAutomaticBrightnessSubtitle;

  /// settingsMaxBrightnessTitle
  ///
  /// In en, this message translates to:
  /// **'Maximum brightness level'**
  String get settingsMaxAutomaticBrightnessTitle;

  /// settingsMaxAutomaticBrightnessSubtitleDisabled
  ///
  /// In en, this message translates to:
  /// **'Enable automatic brightness to set level.'**
  String get settingsMaxAutomaticBrightnessSubtitleDisabled;

  /// settingsMaxAutomaticBrightnessSubtitleEnabled
  ///
  /// In en, this message translates to:
  /// **'Maximum level to which the screen will brighten up.'**
  String get settingsMaxAutomaticBrightnessSubtitleEnabled;

  /// settingsMaxAutomaticBrightnessSubtitleLoading
  ///
  /// In en, this message translates to:
  /// **'Maximum level to which the screen will brighten up.'**
  String get settingsMaxAutomaticBrightnessSubtitleLoading;

  /// settingsMaxAutomaticBrightnessSubtitleError
  ///
  /// In en, this message translates to:
  /// **'Maximum level to which the screen will brighten up.'**
  String get settingsMaxAutomaticBrightnessSubtitleError;

  /// settingsAppVersionTitle
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get settingsAppVersionTitle;

  /// Title for the Category Management Page
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get categoryManagementPageTitle;

  /// Dialog title for adding a new category
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategoryDialogTitle;

  /// Dialog title for editing an existing category
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategoryDialogTitle;

  /// Dialog title for confirming category deletion
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDeleteDialogTitle;

  /// Hint text for the category name input field
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryNameHint;

  /// Label for the Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonSave;

  /// Label for the Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get buttonEdit;

  /// Label for the Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get buttonDelete;

  /// Error message shown when categories fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories: {error}'**
  String errorFailedToLoadCategories(String error);

  /// Error message shown if category name is submitted empty
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get errorCategoryNameEmpty;

  /// Error message shown when saving a category fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save category: {error}'**
  String errorFailedToSaveCategory(String error);

  /// Info message shown after a category is successfully deleted
  ///
  /// In en, this message translates to:
  /// **'Category \'\'{categoryName}\'\' deleted.'**
  String infoCategoryDeleted(String categoryName);

  /// Error message shown when deleting a category fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete category: {error}'**
  String errorFailedToDeleteCategory(String error);

  /// Confirmation message when attempting to delete a category
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete category \'\'{categoryName}\'\'?'**
  String confirmDeleteCategoryMessage(String categoryName);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
