import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added import
import '../domain/category.dart';
import '../data/category_repository.dart'; // Provides categoryRepositoryProvider

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load categories: ${e.toString()}')),
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
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Category' : 'Add Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Category name'),
                  autofocus: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Name cannot be empty')),
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
                    SnackBar(content: Text('Failed to save category: ${e.toString()}')),
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
    // Get repository using ref.read as this is part of an action
    final categoryRepository = ref.read(categoryRepositoryProvider);

    if (!mounted) return; 
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete category "${category.name}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
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
          SnackBar(content: Text('Category "${category.name}" deleted.')),
        );
        await _fetchCategories(); 
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete category: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
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
                        child: const Text('Edit'),
                      ),
                      TextButton(
                        onPressed: () {
                          _confirmDeleteCategory(category);
                        },
                        child: const Text('Delete'),
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
