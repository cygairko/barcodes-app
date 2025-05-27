import 'package:barcodes/features/categories/data/category_repository.dart';
import 'package:barcodes/features/categories/domain/category.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class AddEditCategoryDialog extends ConsumerStatefulWidget {
  final Category? category;

  const AddEditCategoryDialog({super.key, this.category});

  @override
  ConsumerState<AddEditCategoryDialog> createState() =>
      _AddEditCategoryDialogState();
}

class _AddEditCategoryDialogState extends ConsumerState<AddEditCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  Color? _selectedColor;

  // Define a list of selectable colors
  final List<Color> _availableColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.lime,
    Colors.brown,
    Colors.grey,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _selectedColor = widget.category?.color != null
        ? Color(widget.category!.color!)
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final colorValue = _selectedColor?.value;

      final categoryRepository = ref.read(categoryRepositoryProvider);

      try {
        if (widget.category == null) {
          // Add new category
          final newCategory = Category(
            id: const Uuid().v4(), // Generate a unique ID
            name: name,
            color: colorValue,
          );
          await categoryRepository.addCategory(newCategory);
        } else {
          // Update existing category
          final updatedCategory = widget.category!.copyWith(
            name: name,
            color: colorValue,
          );
          await categoryRepository.updateCategory(updatedCategory);
        }
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        // Handle error (e.g., show a snackbar)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final isEditing = widget.category != null;

    return AlertDialog(
      title: Text(isEditing
          ? l10n.translate.settingsCategoriesEditTitle
          : l10n.translate.settingsCategoriesAddTitle),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.translate.settingsCategoriesNameHint,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.translate.settingsCategoriesNameEmpty;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(l10n.translate.settingsCategoriesSelectColor),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _availableColors.map((color) {
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = isSelected ? null : color;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: color,
                      radius: 18,
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.translate.btnCancel),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(isEditing ? l10n.translate.btnSave : l10n.translate.btnAdd),
        ),
      ],
    );
  }
}

// Helper to show the dialog
Future<void> showAddEditCategoryDialog(BuildContext context,
    {Category? category}) {
  return showDialog(
    context: context,
    builder: (context) => AddEditCategoryDialog(category: category),
  );
}
