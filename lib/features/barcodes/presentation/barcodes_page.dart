import 'package:barcodes/common_widgets/async_value_widget.dart';
import 'package:barcodes/features/barcodes/presentation/barcode_carousel_view.dart'; // Added import
import 'package:barcodes/features/barcodes/presentation/barcodes_list.dart';
import 'package:barcodes/features/settings/data/settings_repository.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:barcodes/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BarcodesPage extends ConsumerWidget {
  const BarcodesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barcodeDisplayModeAsync = ref.watch(barcodeDisplayModeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appBarTitleBarcodes),
      ),
      body: AsyncValueWidget<BarcodeDisplayMode>(
        value: barcodeDisplayModeAsync,
        data: (displayMode) {
          if (displayMode == BarcodeDisplayMode.list) {
            return const BarcodesList();
          } else if (displayMode == BarcodeDisplayMode.carousel) {
            // Replace placeholder with BarcodeCarouselView
            return const BarcodeCarouselView();
          }
          // Default fallback, though ideally should not be reached if enum is handled exhaustively.
          return const BarcodesList();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed(AddEntryRoute.name),
        child: const Icon(Icons.add),
      ),
    );
  }
}
