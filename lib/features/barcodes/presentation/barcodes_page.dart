import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/features/barcodes/presentation/barcodes_list.dart';
import 'package:barcodes/features/barcodes/presentation/barcodes_page_controller.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:barcodes/routing/app_routes.dart';
import 'package:barcodes/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BarcodesPage extends ConsumerWidget {
  const BarcodesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      barcodesPageControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    // ignore: unused_local_variable
    final state = ref.watch(barcodesPageControllerProvider);

    const entry = BarcodeEntry(
      title: 'title',
      content: 'content',
      type: BarcodeType.Code128,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appBarTitleBarcodes),
      ),
      body: const BarcodesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed(AddEntryRoute.name),
        child: const Icon(Icons.add),
      ),
    );
  }
}
