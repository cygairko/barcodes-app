import 'package:barcodes/features/categories/data/category_repository.dart';
import 'package:barcodes/features/categories/domain/category.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:barcodes/utils/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_edit_category_dialog.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).translate.settingsCategoriesTitle),
      ),
      body: categoriesAsyncValue.when(
        data: (categories) => ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              leading: category.color != null
                  ? CircleAvatar(
                      backgroundColor: Color(category.color!),
                      radius: 12,
                    )
                  : const Icon(Icons.circle_outlined, size: 24), // Placeholder for no color
              title: Text(category.name),
              onTap: () {
                showAddEditCategoryDialog(context, category: category);
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final confirm = await showAlertDialog(
                    context: context,
                    title: L10n.of(context).translate.settingsCategoriesDeleteTitle,
                    content: L10n.of(context).translate.settingsCategoriesDeleteConfirm(category.name),
                    cancelActionText: L10n.of(context).translate.btnCancel,
                    defaultActionText: L10n.of(context).translate.btnDelete,
                  );
                  if (confirm == true) {
                    await ref
                        .read(categoryRepositoryProvider)
                        .deleteCategory(category.id);
                  }
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddEditCategoryDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
