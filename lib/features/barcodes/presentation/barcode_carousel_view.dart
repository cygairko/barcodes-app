// lib/features/barcodes/presentation/barcode_carousel_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/features/barcodes/presentation/barcode_card.dart';
import 'package:barcodes/features/barcodes/data/barcode_repository.dart'; // Added import
import 'package:barcodes/common_widgets/async_value_widget.dart'; // Added import

class BarcodeCarouselView extends ConsumerWidget { // Changed to ConsumerWidget
  const BarcodeCarouselView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Added WidgetRef
    final barcodesAsyncValue = ref.watch(barcodesStreamProvider); // Watch the provider

    return AsyncValueWidget<List<BarcodeEntry>>(
      value: barcodesAsyncValue,
      data: (barcodes) {
        if (barcodes.isEmpty) {
          return const Center(
            child: Text('No barcodes found.'),
          );
        }
        // Replace placeholder with CarouselView.weighted
        return CarouselView.weighted(
          scrollDirection: Axis.horizontal,
          itemSnapping: true,
          flexWeights: const <int>[1], // Show one card at a time primarily
          children: barcodes.map((barcode) {
            return BarcodeCard(
              entry: barcode,
              onDoubleTap: () {
                // No action specified for double tap in carousel view as per issue
              },
            );
          }).toList(),
        );
      },
      // Error and loading states are handled by AsyncValueWidget
    );
  }
}
