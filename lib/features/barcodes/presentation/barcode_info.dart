import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:flutter/material.dart';

class BarcodeInfo extends StatelessWidget {
  const BarcodeInfo({required this.entry, super.key});
  final BarcodeEntry entry;

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final typeController = TextEditingController();
    final commentController = TextEditingController();

    nameController.text = entry.name;
    typeController.text = entry.type.name;
    commentController.text = entry.comment ?? '';

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            enabled: false,
            controller: nameController,
            decoration:
                InputDecoration(labelText: context.l10n.labelAddFormEntryName),
          ),
          TextField(
            enabled: false,
            controller: typeController,
            decoration: InputDecoration(
                labelText: context.l10n.labelAddFormEntryTypeDropdown),
          ),
          TextField(
            enabled: false,
            controller: commentController,
            decoration: InputDecoration(
                labelText: context.l10n.labelAddFormEntryComment),
          ),
        ],
      ),
    );
  }
}
