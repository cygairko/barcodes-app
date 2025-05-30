// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get counterAppBarTitle => 'Contador';

  @override
  String get navigationLabelHome => 'Inicio';

  @override
  String get navigationLabelBarcodes => 'Códigos de Barras';

  @override
  String get navigationLabelProfile => 'Perfil';

  @override
  String get navigationLabelSettings => 'Ajustes';

  @override
  String get appBarTitleBarcodes => 'Códigos de Barras';

  @override
  String get appBarTitleSettings => 'Ajustes';

  @override
  String get appBarTitleBarcodeScreen => 'Información del Código';

  @override
  String get appBarTitleAddBarcodeScreen => 'Crear Código de Barras';

  @override
  String get noContentFound => 'No se encontró contenido';

  @override
  String get buttonSubmit => 'Enviar';

  @override
  String get buttonCancel => 'Cancelar';

  @override
  String get labelAddFormEntryName => 'Nombre de la entrada';

  @override
  String get labelAddFormEntryComment => 'Comentario adicional';

  @override
  String get labelAddFormEntryData => 'Datos';

  @override
  String get labelAddFormEntryTypeDropdown => 'Tipo de código de barras';

  @override
  String get textBarcodeInfoNoContentTitle => 'Sin datos';

  @override
  String get textBarcodeInfoNoContentMessage => 'para esta entrada de código de barras';

  @override
  String get settingsAutomaticBrightnessTitle => 'Brillo automático de pantalla';

  @override
  String get settingsAutomaticBrightnessSubtitle =>
      'Ajustar brillo automáticamente al mostrar un código. Alternativa: Doble toque.';

  @override
  String get settingsMaxAutomaticBrightnessTitle => 'Nivel máximo de brillo automático';

  @override
  String get settingsMaxAutomaticBrightnessSubtitleDisabled =>
      'Habilite el brillo automático para establecer el nivel.';

  @override
  String get settingsMaxAutomaticBrightnessSubtitleEnabled => 'Nivel máximo al que se iluminará la pantalla.';

  @override
  String get settingsMaxAutomaticBrightnessSubtitleLoading => 'Nivel máximo al que se iluminará la pantalla.';

  @override
  String get settingsMaxAutomaticBrightnessSubtitleError => 'Nivel máximo al que se iluminará la pantalla.';

  @override
  String get settingsAppVersionTitle => 'Versión de la aplicación';

  @override
  String get categoryManagementPageTitle => 'Gestionar Categorías';

  @override
  String get addCategoryDialogTitle => 'Añadir Categoría';

  @override
  String get editCategoryDialogTitle => 'Editar Categoría';

  @override
  String get confirmDeleteDialogTitle => 'Confirmar Eliminación';

  @override
  String get categoryNameHint => 'Nombre de la categoría';

  @override
  String get buttonSave => 'Guardar';

  @override
  String get buttonEdit => 'Editar';

  @override
  String get buttonDelete => 'Eliminar';

  @override
  String errorFailedToLoadCategories(String error) {
    return 'Error al cargar categorías: $error';
  }

  @override
  String get errorCategoryNameEmpty => 'El nombre no puede estar vacío';

  @override
  String errorFailedToSaveCategory(String error) {
    return 'Error al guardar categoría: $error';
  }

  @override
  String infoCategoryDeleted(String categoryName) {
    return 'Categoría \'\'$categoryName\'\' eliminada.';
  }

  @override
  String errorFailedToDeleteCategory(String error) {
    return 'Error al eliminar categoría: $error';
  }

  @override
  String confirmDeleteCategoryMessage(String categoryName) {
    return '¿Estás seguro de que quieres eliminar la categoría \'\'$categoryName\'\'?';
  }
}
