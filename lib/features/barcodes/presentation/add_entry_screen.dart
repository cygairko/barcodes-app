import 'package:barcodes/features/barcodes/presentation/add_entry_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEntryScreen extends ConsumerWidget {
  const AddEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: const AddEntryForm(),
    );
  }
}
