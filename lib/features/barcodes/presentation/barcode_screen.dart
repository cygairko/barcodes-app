import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcodes/common_widgets/async_value_widget.dart';
import 'package:barcodes/features/barcodes/data/barcode_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BarcodeScreen extends ConsumerWidget {
  const BarcodeScreen({required this.entryId, super.key});

  final int entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEntry = ref.watch(barcodeStreamProvider(entryId));
    return Scaffold(
      appBar: AppBar(),
      body: AsyncValueWidget(
        value: asyncEntry,
        data: (p0) => SizedBox(
          width: 300,
          height: 50,
          child: BarcodeWidget(
            data: p0!.content,
            barcode: Barcode.fromType(p0.type),
          ),
        ),
      ),
    );
  }
}
