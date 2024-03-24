import 'package:barcodes/features/barcodes/presentation/barcodes_list.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:barcodes/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BarcodesPage extends ConsumerWidget {
  const BarcodesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
