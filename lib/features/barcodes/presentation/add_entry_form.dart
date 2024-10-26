import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/features/barcodes/presentation/barcodes_list_controller.dart';
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
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: context.l10n.labelAddFormEntryName,
              ),
            ),
            TextFormField(
              controller: dataController,
              keyboardType: TextInputType.text,
              // validator: (value) => ,
              decoration: InputDecoration(
                labelText: context.l10n.labelAddFormEntryData,
              ),
            ),
            TextFormField(
              controller: commentController,
              // minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: context.l10n.labelAddFormEntryComment,
              ),
            ),
            Row(
              children: [
                DropdownMenu<BarcodeType>(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: UnderlineInputBorder(),
                  ),
                  label: Text(context.l10n.labelAddFormEntryTypeDropdown),
                  controller: typeController,
                  initialSelection: BarcodeType.Code128,
                  dropdownMenuEntries: BarcodeType.values
                      .map((e) => DropdownMenuEntry(value: e, label: e.name))
                      .toList(),
                ),
              ],
            ),
            gapH16,
            OverflowBar(
              children: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(context.l10n.buttonCancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    final type = BarcodeType.values.byName(typeController.text);
                    final entry = BarcodeEntry(
                      name: nameController.text,
                      data: dataController.text,
                      type: BarcodeType.values.byName(typeController.text),
                    );
                    try {
                      Barcode.fromType(type).verify(dataController.text);

                      context.pop();
                      ref
                          .read(barcodesListControllerProvider.notifier)
                          .add(entry);
                    } on BarcodeException catch (error) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('$error')));
                    }
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
