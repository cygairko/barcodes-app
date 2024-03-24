import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcodes/features/barcodes/data/barcode_repository.dart';
import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:barcodes/features/barcodes/presentation/barcodes_page_controller.dart';
import 'package:barcodes/l10n/l10n.dart';
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
    TextEditingController title = TextEditingController();
    TextEditingController content = TextEditingController();

    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: title,
          ),
          TextFormField(
            controller: content,
          ),
          ButtonBar(
            children: [
              TextButton(
                onPressed: () {},
                child: Text(context.l10n.buttonCancel),
              ),
              ElevatedButton(
                onPressed: () {
                  final entry = BarcodeEntry(
                    title: title.text,
                    content: content.text,
                    type: BarcodeType.Code128,
                  );
                  context.pop();
                  ref.read(barcodesPageControllerProvider.notifier).add(entry);
                },
                child: Text(context.l10n.buttonSubmit),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
