import 'package:barcodes/l10n/string_hardcoded.dart';
import 'package:barcodes/utils/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueUI on AsyncValue<dynamic> {
  void showAlertDialogOnError(BuildContext context) {
    debugPrint('isLoading: $isLoading, hasError: $hasError');
    if (!isLoading && hasError) {
      final message = error.toString();
      showExceptionAlertDialog(
        context: context,
        title: 'Error'.hardcoded,
        exception: message,
      );
    }
  }
}
