import 'package:barcodes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appBarTitleSettings),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            title: Text('[tba] ${context.l10n.settingsIncreaseBrigtnessTitle}'),
            subtitle: Text(context.l10n.settingsIncreaseBrigtnessSubtitle),
            value: true,
            onChanged: (bool value) {},
          ),
          SwitchListTile.adaptive(
            title: Text('[tba] ${context.l10n.settingsIncreaseBrigtnessTitle}'),
            subtitle: Text(context.l10n.settingsIncreaseBrigtnessSubtitle),
            value: true,
            onChanged: (bool value) {},
          ),
          const Divider(),
          ListTile(
            title: Text(context.l10n.settingsIncreaseAppVersionTitle),
            subtitle: Text('0.1.0'),
          ),
        ],
      ),
    );
  }
}
