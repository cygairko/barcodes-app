import 'package:barcodes/common_widgets/async_value_widget.dart';
import 'package:barcodes/l10n/l10n.dart';
import 'package:barcodes/utils/package_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appBarTitleSettings),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            title: Text('[tba] ${context.l10n.settingsIncreaseBrigtnessTitle}'),
            subtitle: Text(context.l10n.settingsIncreaseBrigtnessSubtitle),
            value: false,
            onChanged: null,
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
