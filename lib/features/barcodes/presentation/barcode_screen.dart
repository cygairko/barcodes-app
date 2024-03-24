import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcodes/common_widgets/async_value_widget.dart';
import 'package:barcodes/features/barcodes/data/barcode_repository.dart';
import 'package:barcodes/features/barcodes/domain/barcode_conf.dart';
import 'package:barcodes/features/barcodes/presentation/barcode_error.dart';
import 'package:barcodes/features/barcodes/presentation/barcode_info.dart';
import 'package:barcodes/features/barcodes/presentation/barcodes_list_controller.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BarcodeScreen extends ConsumerWidget {
  const BarcodeScreen({required this.entryId, super.key});

  final int entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEntry = ref.watch(barcodeStreamProvider(entryId));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appBarTitleBarcodeScreen),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(barcodesListControllerProvider.notifier).delete(entryId);
              context.pop();
            },
            icon: const Icon(Icons.delete_outlined),
          ),
        ],
      ),
      body: AsyncValueWidget(
        value: asyncEntry,
        data: (p0) {
          if (p0 != null) {
            final conf = BarcodeConf(p0.data, p0.type);

            try {
              conf.barcode.verify(conf.normalizedData);
            } on BarcodeException catch (error) {
              return BarcodeError(message: error.message);
            }

            return Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: BarcodeWidget(
                    padding: const EdgeInsets.all(12),
                    data: conf.normalizedData,
                    barcode: conf.barcode,
                    height: conf.height,
                    width: conf.width,
                    style: TextStyle(fontSize: conf.fontSize),
                  ),
                ),
                BarcodeInfo(
                  entry: p0,
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
