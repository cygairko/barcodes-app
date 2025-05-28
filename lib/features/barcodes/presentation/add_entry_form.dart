import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcodes/features/barcodes/data/barcode_repository.dart';
import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/features/barcodes/presentation/barcodes_list_controller.dart';
import 'package:barcodes/features/categories/domain/category.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:barcodes/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddEntryForm extends ConsumerStatefulWidget {
  final List<Category> categories;
  final BarcodeEntry? barcodeEntry; // For editing

  const AddEntryForm({
    super.key,
    required this.categories,
    this.barcodeEntry,
  });

  @override
  ConsumerState<AddEntryForm> createState() => _AddEntryFormState();
}

class _AddEntryFormState extends ConsumerState<AddEntryForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dataController;
  late TextEditingController _commentController;
  BarcodeType? _selectedBarcodeType;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    final entry = widget.barcodeEntry;
    _nameController = TextEditingController(text: entry?.name ?? '');
    _dataController = TextEditingController(text: entry?.data ?? '');
    _commentController = TextEditingController(text: entry?.comment ?? '');
    _selectedBarcodeType = entry?.type ?? BarcodeType.Code128;
    _selectedCategoryId = entry?.categoryId;

    // Ensure _selectedCategoryId is valid if categories exist
    if (_selectedCategoryId != null &&
        widget.categories.isNotEmpty &&
        !widget.categories.any((cat) => cat.id == _selectedCategoryId)) {
      // If the category ID from the barcode entry doesn't match any of the available categories,
      // set it to null (no category). This can happen if a category was deleted.
      _selectedCategoryId = null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dataController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final entry = BarcodeEntry(
        id: widget.barcodeEntry?.id ?? -1, // Keep original ID if editing, backend handles new ID
        name: _nameController.text.trim(),
        data: _dataController.text.trim(),
        type: _selectedBarcodeType!,
        comment: _commentController.text.trim(),
        categoryId: _selectedCategoryId,
      );

      try {
        Barcode.fromType(_selectedBarcodeType!)
            .verify(_dataController.text.trim());

        if (widget.barcodeEntry == null) {
          await ref.read(barcodesListControllerProvider.notifier).add(entry);
        } else {
          // Ensure the ID is not -1 if we are updating an existing entry
          if (entry.id == -1) {
             throw Exception("Cannot update entry with ID -1");
          }
          await ref.read(barcodeRepositoryProvider).updateBarcode(entry);
        }
        if (mounted) context.pop();
      } on BarcodeException catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Barcode error: $error')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('An unexpected error occurred: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p12, vertical: Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: l10n.labelAddFormEntryName,
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? l10n.translate.errorAddFormEntryNameEmpty
                  : null,
            ),
            gapH12,
            TextFormField(
              controller: _dataController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: l10n.labelAddFormEntryData,
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? l10n.translate.errorAddFormEntryDataEmpty
                  : null,
            ),
            gapH12,
            DropdownButtonFormField<BarcodeType>(
              decoration: InputDecoration(
                labelText: l10n.labelAddFormEntryTypeDropdown,
                border: const UnderlineInputBorder(),
              ),
              value: _selectedBarcodeType,
              items: BarcodeType.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.name),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedBarcodeType = value;
                  });
                }
              },
              validator: (value) =>
                  value == null ? l10n.translate.errorAddFormEntryTypeEmpty : null,
            ),
            gapH12,
            DropdownButtonFormField<String?>(
              decoration: InputDecoration(
                labelText: l10n.translate.labelAddFormEntryCategoryDropdown,
                border: const UnderlineInputBorder(),
              ),
              value: _selectedCategoryId,
              hint: Text(l10n.translate.labelAddFormEntryCategoryNone),
              isExpanded: true,
              items: [
                DropdownMenuItem<String?>(
                  value: null, // Represents "No Category"
                  child: Text(l10n.translate.labelAddFormEntryCategoryNone),
                ),
                ...widget.categories.map((category) => DropdownMenuItem(
                      value: category.id,
                      child: Row(
                        children: [
                          if (category.color != null)
                            Padding(
                              padding: const EdgeInsets.only(right: Sizes.p8),
                              child: CircleAvatar(
                                backgroundColor: Color(category.color!),
                                radius: 8,
                              ),
                            ),
                          Expanded(child: Text(category.name, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
              // No validator needed for category, as it's optional
            ),
            gapH12,
            TextFormField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.labelAddFormEntryComment,
              ),
            ),
            gapH24,
            OverflowBar(
              alignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.buttonCancel),
                ),
                gapW8,
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(widget.barcodeEntry == null ? l10n.buttonSubmit : l10n.translate.buttonSave),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
