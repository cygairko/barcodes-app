import 'package:barcodes/utils/data_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast.dart';

part 'settings_repository.g.dart';

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository(ref.read(dataStoreProvider).requireValue);
}

class SettingsRepository {
  SettingsRepository(this.datastore);
  final DataStore datastore;
  final storeRef = stringMapStoreFactory.store('settings_store');
}
