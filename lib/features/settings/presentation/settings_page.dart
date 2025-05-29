import 'package:barcodes/common_widgets/async_value_widget.dart';
import 'package:barcodes/features/settings/data/settings_repository.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:barcodes/utils/package_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider);
    final automaticBrightness = ref.watch(automaticScreenBrightnessProvider);
    final maxBrightness = ref.watch(maxScreenBrightnessLevelProvider);

    // Determine if the slider should be enabled
    // It's enabled if automatic brightness is ON (true) and has data.
    // If automatic brightness is OFF (false) or loading/error, slider is disabled.
    final bool isAutomaticBrightnessOn = automaticBrightness.asData?.value ?? false;
    final bool sliderEnabled = isAutomaticBrightnessOn;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appBarTitleSettings),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            key: const Key('automaticBrightnessSwitch'),
            title: const Text('Automatic screen brightness'), // Placeholder
            subtitle: const Text('Adjust brightness automatically when a barcode is shown'), // Placeholder
            value: automaticBrightness.asData?.value ?? false, // Default to false if loading or error
            onChanged: (bool newValue) {
              ref.read(settingsRepositoryProvider).setAutomaticScreenBrightness(newValue);
              ref.invalidate(automaticScreenBrightnessProvider);
              // Also invalidate max brightness provider in case its UI needs to update (e.g. enabled state)
              ref.invalidate(maxScreenBrightnessLevelProvider);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Maximum brightness level'), // Placeholder
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slider.adaptive(
                  key: const Key('maxBrightnessSlider'),
                  value: maxBrightness.asData?.value ?? 0.8, // Default to 0.8 if loading or error
                  min: 0.1,
                  max: 1.0,
                  divisions: 9,
                  label: (maxBrightness.asData?.value ?? 0.8).toStringAsFixed(1),
                  onChanged: sliderEnabled
                      ? (double newValue) {
                          ref.read(settingsRepositoryProvider).setMaxScreenBrightnessLevel(newValue);
                          ref.invalidate(maxScreenBrightnessLevelProvider);
                        }
                      : null, // Disable if automatic brightness is off or loading
                ),
                if (maxBrightness.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: Text('Loading...'),
                  ),
                if (maxBrightness.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: Text('Error: ${maxBrightness.error}'),
                  ),
                 if (!sliderEnabled && !automaticBrightness.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: Text('Enable automatic brightness to set level.'),
                  ),
              ],
            ),
          ),
          const Divider(),
          AsyncValueWidget(
            value: packageInfo,
            data: (p0) => ListTile(
              title: Text(context.l10n.settingsIncreaseAppVersionTitle),
              subtitle: Text(
                p0.version,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
