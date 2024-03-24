import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/features/barcodes/presentation/barcodes_page_controller.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:barcodes/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddEntryForm extends ConsumerStatefulWidget {
  const AddEntryForm({super.key});

  @override
  ConsumerState<AddEntryForm> createState() => _AddEntryFormState();
}

class _AddEntryFormState extends ConsumerState<AddEntryForm> {
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final dataController = TextEditingController();
    final typeController = TextEditingController();
    final commentController = TextEditingController();

    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: context.l10n.labelAddFormEntryName,
              ),
            ),
            TextFormField(
              controller: dataController,
              decoration: InputDecoration(
                labelText: context.l10n.labelAddFormEntryData,
              ),
            ),
            TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: context.l10n.labelAddFormEntryComment,
              ),
            ),
            DropdownMenu<BarcodeType>(
              controller: typeController,
              initialSelection: BarcodeType.Code128,
              dropdownMenuEntries: BarcodeType.values
                  .map((e) => DropdownMenuEntry(value: e, label: e.name))
                  .toList(),
            ),
            gapH16,
            ButtonBar(
              children: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(context.l10n.buttonCancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    final entry = BarcodeEntry(
                      name: nameController.text,
                      data: dataController.text,
                      type: BarcodeType.values.byName(typeController.text),
                    );
                    context.pop();
                    ref
                        .read(barcodesPageControllerProvider.notifier)
                        .add(entry);
                  },
                  child: Text(context.l10n.buttonSubmit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
