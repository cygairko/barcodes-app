import 'package:barcodes/features/barcodes/presentation/add_entry_form.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEntryScreen extends ConsumerWidget {
  const AddEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appBarTitleAddBarcodeScreen),
      ),
      body: const AddEntryForm(),
    );
  }
}
