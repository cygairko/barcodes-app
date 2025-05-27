import 'package:barcodes/common_widgets/async_value_widget.dart';
import 'package:barcodes/common_widgets/empty_content.dart';
import 'package:barcodes/features/barcodes/data/barcode_repository.dart';
import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/features/barcodes/presentation/barcode_list_tile.dart';
import 'package:barcodes/features/barcodes/presentation/barcodes_list_controller.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:barcodes/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BarcodesList extends ConsumerStatefulWidget {
  final Set<String> selectedCategoryIds;
  const BarcodesList({super.key, required this.selectedCategoryIds});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BarcodesListState();
}

class _BarcodesListState extends ConsumerState<BarcodesList> {
  @override
  Widget build(BuildContext context) {
    final barcodesAsyncValue = ref.watch(barcodesStreamProvider);
    ref.listen<AsyncValue<void>>(
      barcodesListControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    // ignore: unused_local_variable
    final state = ref.watch(barcodesListControllerProvider);

    return AsyncValueWidget<List<BarcodeEntry>>(
      value: barcodesAsyncValue,
      data: (barcodes) {
        final filteredBarcodes = widget.selectedCategoryIds.isEmpty
            ? barcodes // If "All" is selected (empty set), show all barcodes
            : barcodes
                .where((barcode) =>
                    widget.selectedCategoryIds.contains(barcode.categoryId))
                .toList();

        if (filteredBarcodes.isEmpty) {
          return EmptyContent(
            message: L10n.of(context).translate.barcodesEmptyFiltered,
          );
        }

        return ListView.builder(
          itemCount: filteredBarcodes.length,
          itemBuilder: (context, index) =>
              BarcodeListTile(entry: filteredBarcodes[index]),
        );
      },
    );
  }
}
