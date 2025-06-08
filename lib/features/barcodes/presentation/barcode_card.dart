import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcodes/features/barcodes/domain/barcode_conf.dart';
import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/features/barcodes/presentation/barcode_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added for potential future use, not strictly needed now
import 'package:barcodes/utils/logger.dart'; // Added for potential future use

class BarcodeCard extends ConsumerWidget {
  const BarcodeCard({
    super.key,
    required this.entry,
    required this.onDoubleTap,
  });

  final BarcodeEntry entry;
  final VoidCallback onDoubleTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conf = BarcodeConf(entry.data, entry.type);

    // It's good practice to handle potential errors during barcode verification
    try {
      conf.barcode.verify(conf.normalizedData);
    } on BarcodeException catch (error) {
      // Log the error and return an error message widget
      ref.read(loggerProvider).e('Error verifying barcode: \$error');
      return Card(
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error displaying barcode: \${error.message}',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onDoubleTap: onDoubleTap,
              child: BarcodeWidget(
                padding: const EdgeInsets.all(12),
                data: conf.normalizedData,
                barcode: conf.barcode,
                height: conf.height,
                width: conf.width,
                style: TextStyle(fontSize: conf.fontSize),
              ),
            ),
          ),
          BarcodeInfo(
            entry: entry,
          ),
        ],
      ),
    );
  }
}
