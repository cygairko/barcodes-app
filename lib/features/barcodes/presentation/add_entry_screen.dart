import 'package:barcodes/common_widgets/async_value_widget.dart';
import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/features/barcodes/presentation/add_entry_form.dart';
import 'package:barcodes/features/categories/data/category_repository.dart';
import 'package:barcodes/features/categories/domain/category.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEntryScreen extends ConsumerWidget {
  final BarcodeEntry? barcodeEntry; // For editing existing entries
  const AddEntryScreen({super.key, this.barcodeEntry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);
    final l10n = L10n.of(context);
    // Assuming you will add 'appBarTitleEditBarcodeScreen' to your L10n files
    // If not, you can use: final title = barcodeEntry == null ? l10n.appBarTitleAddBarcodeScreen : 'Edit Barcode';
    final title = barcodeEntry == null
        ? l10n.appBarTitleAddBarcodeScreen
        : l10n.translate.appBarTitleEditBarcodeScreen;


    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: AsyncValueWidget<List<Category>>(
        value: categoriesAsyncValue,
        data: (categories) => AddEntryForm(
          categories: categories,
          barcodeEntry: barcodeEntry,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading categories: $e')),
      ),
    );
  }
}
