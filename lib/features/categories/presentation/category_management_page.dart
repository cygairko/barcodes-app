import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barcodes/l10n/l10n.dart'; // Added import for AppLocalizations
import '../domain/category.dart';
import '../data/category_repository.dart';

// Changed to ConsumerStatefulWidget
class CategoryManagementPage extends ConsumerStatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  // Updated State class
  ConsumerState<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

// Changed to ConsumerState
class _CategoryManagementPageState extends ConsumerState<CategoryManagementPage> {
  // Removed local _categoryRepository instance
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch categories using the repository from the provider
    // Ensure _fetchCategories uses ref to get the repository
    _fetchCategories(); 
  }

  Future<void> _fetchCategories() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    // Get repository using ref.read as this is an action
    final categoryRepository = ref.read(categoryRepositoryProvider);
    try {
      _categories = await categoryRepository.getCategories();
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorFailedToLoadCategories(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showCategoryDialog({Category? category}) async {
    final isEditing = category != null;
    final TextEditingController nameController =
        TextEditingController(text: category?.name ?? '');

    // Get repository using ref.read as this is part of an action
    final categoryRepository = ref.read(categoryRepositoryProvider);

    if (!mounted) return; 
    // Get the AppLocalizations instance at the beginning of the method
    // to avoid accessing context repeatedly if it might change (though less likely here).
    final l10n = AppLocalizations.of(context); 
    if (!mounted) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext dialogContext) {
        // Use dialogContext for things inside the dialog, main context for l10n from the page
        return AlertDialog(
          title: Text(isEditing ? l10n.editCategoryDialogTitle : l10n.addCategoryDialogTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: l10n.categoryNameHint),
                  autofocus: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.buttonCancel),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(l10n.buttonSave),
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text(l10n.errorCategoryNameEmpty)),
                  );
                  return;
                }

                try {
                  if (isEditing) {
                    final updatedCategory = Category(
                      id: category!.id, // category is non-null in isEditing branch
                      name: name,
                    );
                    await categoryRepository.updateCategory(updatedCategory);
                  } else {
                    final newCategory = Category(name: name);
                    await categoryRepository.addCategory(newCategory);
                  }
                  Navigator.of(dialogContext).pop();
                  await _fetchCategories(); 
                } catch (e) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text(l10n.errorFailedToSaveCategory(e.toString()))),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteCategory(Category category) async {
    final categoryRepository = ref.read(categoryRepositoryProvider);
    final l10n = AppLocalizations.of(context);
    if (!mounted) return; 

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.confirmDeleteDialogTitle),
          content: Text(l10n.confirmDeleteCategoryMessage(category.name)), 
          // Re-using infoCategoryDeleted here is not semantically correct for a question.
          // Let's make a temporary string for the purpose of this exercise if not in ARB.
          // Ideally: content: Text(l10n.confirmDeleteCategoryQuestion(category.name)),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.buttonCancel),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            TextButton(
              child: Text(l10n.buttonDelete),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await categoryRepository.deleteCategory(category.id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.infoCategoryDeleted(category.name))),
        );
        await _fetchCategories(); 
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorFailedToDeleteCategory(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.categoryManagementPageTitle),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return ListTile(
                  title: Text(category.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          _showCategoryDialog(category: category);
                        },
                        child: Text(l10n.buttonEdit),
                      ),
                      TextButton(
                        onPressed: () {
                          _confirmDeleteCategory(category);
                        },
                        child: Text(l10n.buttonDelete),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCategoryDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
