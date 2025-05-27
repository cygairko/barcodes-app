import 'package:barcodes/features/barcodes/presentation/barcodes_list.dart';
import 'package:barcodes/features/categories/data/category_repository.dart';
import 'package:barcodes/features/categories/domain/category.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:barcodes/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// StateProvider for managing the set of selected category IDs
// An empty set means "All" categories are selected.
final selectedCategoryIdsProvider = StateProvider<Set<String>>((ref) => {});

class BarcodesPage extends ConsumerWidget {
  const BarcodesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final categoriesAsyncValue = ref.watch(categoriesProvider);
    final selectedCategoryIds = ref.watch(selectedCategoryIdsProvider);
    final selectedCategoryIdsNotifier =
        ref.read(selectedCategoryIdsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appBarTitleBarcodes),
      ),
      body: Column(
        children: [
          categoriesAsyncValue.when(
            data: (categories) {
              if (categories.isEmpty) {
                return const SizedBox.shrink(); // No categories, hide filter bar
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    FilterChip(
                      label: Text(l10n.translate.generalAll),
                      selected: selectedCategoryIds.isEmpty,
                      onSelected: (selected) {
                        if (selected) {
                          selectedCategoryIdsNotifier.state = {};
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ...categories.map((category) {
                      final isSelected =
                          selectedCategoryIds.contains(category.id);
                      return FilterChip(
                        label: Text(category.name),
                        avatar: category.color != null
                            ? CircleAvatar(
                                backgroundColor: Color(category.color!),
                                radius: 8,
                              )
                            : null,
                        selected: isSelected,
                        onSelected: (selected) {
                          final currentSelected =
                              Set<String>.from(selectedCategoryIds);
                          if (selected) {
                            currentSelected.add(category.id);
                          } else {
                            currentSelected.remove(category.id);
                          }
                          selectedCategoryIdsNotifier.state = currentSelected;
                        },
                      );
                    }).expand((widget) => [widget, const SizedBox(width: 8)]),
                  ],
                ),
              );
            },
            loading: () => const Center(child: LinearProgressIndicator()),
            error: (error, stack) =>
                Center(child: Text('Error loading categories: $error')),
          ),
          Expanded(
            child: BarcodesList(selectedCategoryIds: selectedCategoryIds),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => const AddEntryRoute().go(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
