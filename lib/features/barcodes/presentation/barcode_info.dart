import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:flutter/material.dart';

class BarcodeInfo extends StatelessWidget {
  const BarcodeInfo({required this.entry, super.key});
  final BarcodeEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.label_outline),
            title: Text(
              entry.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(context.l10n.labelAddFormEntryName),
          ),
          ListTile(
            leading: const Icon(Icons.settings_overscan),
            title: Text(
              entry.type.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(context.l10n.labelAddFormEntryTypeDropdown),
          ),
          ListTile(
            leading: const Icon(Icons.comment_outlined),
            title: Text(
              entry.comment ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(context.l10n.labelAddFormEntryComment),
          ),
        ],
      ),
    );
  }
}
