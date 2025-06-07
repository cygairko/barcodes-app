import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcodes/common_widgets/async_value_widget.dart';
import 'package:barcodes/common_widgets/empty_content.dart';
import 'package:barcodes/features/barcodes/data/barcode_repository.dart';
import 'package:barcodes/features/barcodes/domain/barcode_conf.dart';
import 'package:barcodes/features/barcodes/presentation/barcode_error.dart';
import 'package:barcodes/features/barcodes/presentation/barcode_info.dart';
import 'package:barcodes/features/barcodes/presentation/barcodes_list_controller.dart';
import 'package:barcodes/features/settings/data/settings_repository.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:barcodes/utils/brightness_service.dart';
import 'package:barcodes/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BarcodeScreen extends ConsumerStatefulWidget {
  const BarcodeScreen({required this.entryId, super.key});

  final int entryId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends ConsumerState<BarcodeScreen> {
  double? _originalBrightness;
  bool _brightnessWasAdjustedByThisScreen = false;
  BrightnessService? _brightnessService;

  @override
  void initState() {
    super.initState();
    _setupBrightness();
  }

  @override
  void dispose() {
    if (_brightnessWasAdjustedByThisScreen && _originalBrightness != null) {
      // Use a try-catch here as well, in case restoring brightness fails
      try {
        _brightnessService?.resetBrightness();
      } on Exception catch (e) {
        context.logger.e('Error restoring brightness in BarcodeScreen dispose: $e');
        // Log the error but do not throw it, as we are in dispose and should not interrupt the lifecycle.
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncEntry = ref.watch(barcodeStreamProvider(widget.entryId));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appBarTitleBarcodeScreen),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(barcodesListControllerProvider.notifier).delete(widget.entryId);
              context.pop();
            },
            icon: const Icon(Icons.delete_outlined),
          ),
        ],
      ),
      body: AsyncValueWidget(
        value: asyncEntry,
        data: (p0) {
          if (p0 != null) {
            final conf = BarcodeConf(p0.data, p0.type);

            try {
              conf.barcode.verify(conf.normalizedData);
            } on BarcodeException catch (error) {
              return BarcodeError(message: error.message);
            }

            return SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onDoubleTap: () async {
                          try {
                            final maxLevel = await ref.read(maxScreenBrightnessLevelProvider.future);
                            final brightnessService = ref.read(brightnessServiceProvider);
                            _brightnessService = brightnessService;

                            if (_originalBrightness == null) {
                              // Try to get current brightness only if not already fetched by initState or previous double tap
                              try {
                                _originalBrightness = await brightnessService.getCurrentBrightness();
                              } on Exception catch (e) {
                                ref.read(loggerProvider).e('Error getting current brightness on double tap: $e');

                                // If we can't get current brightness, we might not want to proceed
                                // or we proceed without being able to restore. For now, let's print and continue.
                              }
                            }

                            await brightnessService.setBrightness(maxLevel);
                            // Ensure that if brightness is set, we attempt to restore it.
                            // No need to call setState if these vars don't directly drive UI rebuilds for this action.
                            _brightnessWasAdjustedByThisScreen = true;
                          } on Exception catch (e) {
                            // Catch any errors from reading providers or other operations
                            ref.read(loggerProvider).e('Error in onDoubleTap brightness adjustment: $e');
                          }
                        },
                        child: BarcodeWidget(
                          padding: const EdgeInsets.all(12),
                          data: conf.normalizedData,
                          barcode: conf.barcode,
                          height: conf.height,
                          width: conf.width,
                          style: TextStyle(fontSize: conf.fontSize),
                        ),
                      ),
                    ),
                    BarcodeInfo(
                      entry: p0,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return EmptyContent(
              title: context.l10n.textBarcodeInfoNoContentTitle,
              message: context.l10n.textBarcodeInfoNoContentMessage,
            );
          }
        },
      ),
    );
  }

  Future<void> _setupBrightness() async {
    try {
      final autoBrightEnabled = await ref.read(automaticScreenBrightnessProvider.future);

      if (autoBrightEnabled) {
        final brightnessService = ref.read(brightnessServiceProvider);
        _brightnessService = brightnessService;
        // It's important to handle potential errors when getting current brightness
        // For example, if the platform call fails.
        try {
          _originalBrightness = await brightnessService.getCurrentBrightness();
        } on Exception catch (e) {
          ref.read(loggerProvider).e('Error getting current brightness in BarcodeScreen: $e');
          // Log the error but do not throw it, as we want to handle it gracefully.

          // Decide if we should proceed or not if current brightness can't be fetched.
          // For now, we'll assume we can't proceed reliably without it.
          return;
        }

        final maxLevel = await ref.read(maxScreenBrightnessLevelProvider.future);

        // Check if _originalBrightness is not null before comparison
        if (_originalBrightness != null && _originalBrightness! < maxLevel) {
          await brightnessService.setBrightness(maxLevel);
          // Only set this flag if we actually attempt to change brightness.
          // And ensure it's only true if the setBrightness call is expected to succeed.
          _brightnessWasAdjustedByThisScreen = true;
        }
      }
    } on Exception catch (e) {
      // Catch any errors from reading providers or other operations
      ref.read(loggerProvider).e('Error in _setupBrightness: $e');
      // Log the error but do not throw it, as we want to handle it gracefully.
    }
  }
}
