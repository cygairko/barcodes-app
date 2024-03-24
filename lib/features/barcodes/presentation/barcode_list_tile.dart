import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BarcodeListTile extends StatelessWidget {
  const BarcodeListTile({required this.entry, super.key});
  final BarcodeEntry entry;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.qr_code),
      title: Text(entry.name),
      subtitle: Text(entry.type.name),
      onTap: () => context.goNamed(
        BarcodeRoute.name,
        pathParameters: {'eid': entry.id.toString()},
      ),
    );
  }
}
