import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcodes/features/barcodes/domain/barcode_conf.dart';
import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/features/barcodes/presentation/barcode_info.dart';
import 'package:barcodes/utils/logger.dart'; // Added for potential future use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added for potential future use, not strictly needed now

class BarcodeCard extends ConsumerWidget {
  const BarcodeCard({
    required this.entry,
    required this.onDoubleTap,
    super.key,
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
      ref.read(loggerProvider).e('Error verifying barcode: $error');
      return Card(
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Error displaying barcode: ${error.message}',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias, // Add clipBehavior to ensure content respects card boundaries
      child: Stack(
        alignment: Alignment.center, // Or Alignment.topCenter for BarcodeWidget
        children: [
          // BarcodeWidget part (ensure it's not unnecessarily expanding)
          Container(
            alignment: Alignment.topCenter, // Keep barcode at the top
            child: GestureDetector(
              onDoubleTap: onDoubleTap,
              child: BarcodeWidget(
                padding: const EdgeInsets.all(12),
                data: conf.normalizedData,
                barcode: conf.barcode,
                height: conf.height, // These dimensions from conf might be key
                width: conf.width,   // to controlling size
                style: TextStyle(fontSize: conf.fontSize),
              ),
            ),
          ),
          // BarcodeInfo part, positioned at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container( // Optional: Add a background to BarcodeInfo for readability
              color: Colors.black.withOpacity(0.0), // Start with transparent, can be themed later
              child: BarcodeInfo(entry: entry),
            ),
          ),
        ],
      ),
    );
  }
}
