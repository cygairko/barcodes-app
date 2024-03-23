import 'package:barcodes/common_widgets/async_value_widget.dart';
import 'package:barcodes/features/barcodes/data/barcode_repository.dart';
import 'package:barcodes/features/barcodes/presentation/barcode_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BarcodesList extends ConsumerWidget {
  const BarcodesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barcodes = ref.watch(barcodesStreamProvider);
    return AsyncValueWidget(
      value: barcodes,
      data: (list) => ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => BarcodeListTile(entry: list[index]),
      ),
    );
  }
}
