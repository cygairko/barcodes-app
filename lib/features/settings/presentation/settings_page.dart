import 'package:barcodes/common_widgets/async_value_widget.dart';
import 'package:barcodes/features/settings/data/settings_repository.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:barcodes/routing/app_routes.dart'; // Added import for typed routes
import 'package:barcodes/utils/package_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Added import for GoRouter

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider);
    final automaticBrightness = ref.watch(automaticScreenBrightnessProvider);
    final maxBrightness = ref.watch(maxScreenBrightnessLevelProvider);
    final barcodeDisplayMode = ref.watch(barcodeDisplayModeProvider); // This should already be correct if I followed the convention. Let's double check.

    // Determine if the slider should be enabled
    // It's enabled if automatic brightness is ON (true) and has data.
    // If automatic brightness is OFF (false) or loading/error, slider is disabled.
    final isAutomaticBrightnessOn = automaticBrightness.asData?.value ?? false;
    final sliderEnabled = isAutomaticBrightnessOn;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appBarTitleSettings),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            key: const Key('automaticBrightnessSwitch'),
            title: Text(context.l10n.settingsAutomaticBrightnessTitle), // Placeholder
            subtitle: Text(context.l10n.settingsAutomaticBrightnessSubtitle), // Placeholder
            value: automaticBrightness.asData?.value ?? false, // Default to false if loading or error
            onChanged: (bool newValue) {
              ref.read(settingsRepositoryProvider).setAutomaticScreenBrightness(isAutoBrightness: newValue);
              ref
                ..invalidate(automaticScreenBrightnessProvider)
                // Also invalidate max brightness provider in case its UI needs to update (e.g. enabled state)
                ..invalidate(maxScreenBrightnessLevelProvider);
            },
          ),
          const Divider(),
          ListTile(
            title: Text(context.l10n.settingsMaxAutomaticBrightnessTitle), // Placeholder
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slider.adaptive(
                  key: const Key('maxBrightnessSlider'),
                  value: maxBrightness.asData?.value ?? 0.8, // Default to 0.8 if loading or error
                  min: 0.1,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Text(context.l10n.settingsMaxAutomaticBrightnessSubtitleLoading),
                  )
                else if (maxBrightness.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Text('${context.l10n.settingsMaxAutomaticBrightnessSubtitleError}${maxBrightness.error}'),
                  )
                else if (!sliderEnabled && !automaticBrightness.isLoading)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Text(context.l10n.settingsMaxAutomaticBrightnessSubtitleDisabled),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Text(context.l10n.settingsMaxAutomaticBrightnessSubtitleEnabled),
                  ),
              ],
            ),
          ),
          const Divider(),
          AsyncValueWidget(
            value: packageInfo,
            data: (p0) => ListTile(
              title: Text(context.l10n.settingsAppVersionTitle),
              subtitle: Text(
                p0.version,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Manage Categories'), // Assuming no l10n for now
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate using GoRouter's named route
              context.pushNamed(ManageCategoriesRoute.name);
            },
          ),
          const Divider(),
          ListTile(
            title: Text(context.l10n.settingsBarcodeDisplayModeTitle),
          ),
          AsyncValueWidget<BarcodeDisplayMode>(
            value: barcodeDisplayMode, // This should be correct
            data: (currentMode) => SegmentedButton<BarcodeDisplayMode>(
              segments: <ButtonSegment<BarcodeDisplayMode>>[
                ButtonSegment<BarcodeDisplayMode>(
                  value: BarcodeDisplayMode.list,
                  label: Text(context.l10n.settingsBarcodeDisplayModeList),
                ),
                ButtonSegment<BarcodeDisplayMode>(
                  value: BarcodeDisplayMode.carousel,
                  label: Text(context.l10n.settingsBarcodeDisplayModeCarousel),
                ),
              ],
              selected: <BarcodeDisplayMode>{currentMode},
              onSelectionChanged: (Set<BarcodeDisplayMode> newSelection) {
                if (newSelection.isNotEmpty) {
                  ref.read(settingsRepositoryProvider).setBarcodeDisplayMode(newSelection.first);
                  ref.invalidate(barcodeDisplayModeProvider); // This should be correct
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
