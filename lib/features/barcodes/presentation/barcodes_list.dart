import 'package:barcodes/common_widgets/async_value_widget.dart';
import 'package:barcodes/features/barcodes/data/barcode_repository.dart';
import 'package:barcodes/features/barcodes/presentation/barcode_list_tile.dart';
import 'package:barcodes/features/barcodes/presentation/barcodes_list_controller.dart';
import 'package:barcodes/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BarcodesList extends ConsumerStatefulWidget {
  const BarcodesList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BarcodesListState();
}

class _BarcodesListState extends ConsumerState<BarcodesList> {
  @override
  Widget build(BuildContext context) {
    final barcodes = ref.watch(barcodesStreamProvider);
    ref.listen<AsyncValue<void>>(
      barcodesListControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    // ignore: unused_local_variable , Watching the provider to ensure it stays active and to trigger rebuilds on state changes, even if the 'state' variable itself is not directly used in this build method.
    final state = ref.watch(barcodesListControllerProvider);

    return AsyncValueWidget(
      value: barcodes,
      data: (list) => ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => BarcodeListTile(entry: list[index]),
      ),
    );
  }
}
