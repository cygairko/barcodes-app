import 'package:barcodes/utils/data_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast.dart';

part 'settings_repository.g.dart';

const String kAutomaticScreenBrightness = 'automaticScreenBrightness';
const String kMaxScreenBrightnessLevel = 'maxScreenBrightnessLevel';
const String kBarcodeDisplayMode = 'barcodeDisplayMode';

enum BarcodeDisplayMode {
  list,
  carousel,
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository(ref.read(dataStoreProvider).requireValue);
}

@riverpod
Future<bool> automaticScreenBrightness(Ref ref) {
  return ref.watch(settingsRepositoryProvider).getAutomaticScreenBrightness();
}

@riverpod
Future<double> maxScreenBrightnessLevel(Ref ref) {
  return ref.watch(settingsRepositoryProvider).getMaxScreenBrightnessLevel();
}

@riverpod
Future<BarcodeDisplayMode> barcodeDisplayMode(BarcodeDisplayModeRef ref) {
  return ref.watch(settingsRepositoryProvider).getBarcodeDisplayMode();
}

class SettingsRepository {
  SettingsRepository(this.datastore);
  final DataStore datastore;
  // Use a store that can hold primitive types directly, keyed by String.
  final storeRef = StoreRef<String, Object?>('settings_store');

  Future<bool> getAutomaticScreenBrightness() async {
    final value = await storeRef.record(kAutomaticScreenBrightness).get(datastore.db);
    return value as bool? ?? false;
  }

  Future<void> setAutomaticScreenBrightness({required bool isAutoBrightness}) async {
    await storeRef.record(kAutomaticScreenBrightness).put(datastore.db, isAutoBrightness);
  }

  Future<double> getMaxScreenBrightnessLevel() async {
    final value = await storeRef.record(kMaxScreenBrightnessLevel).get(datastore.db);
    // Sembast stores numbers as num, so we need to cast to double.
    // If it's an int (e.g. 1), it will be cast to 1.0.
    // If it's a double (e.g. 0.8), it will be cast to 0.8.
    return (value as num?)?.toDouble() ?? 0.8;
  }

  Future<void> setMaxScreenBrightnessLevel(double value) async {
    await storeRef.record(kMaxScreenBrightnessLevel).put(datastore.db, value);
  }

  Future<BarcodeDisplayMode> getBarcodeDisplayMode() async {
    final value = await storeRef.record(kBarcodeDisplayMode).get(datastore.db);
    if (value == null) {
      return BarcodeDisplayMode.list;
    }
    return BarcodeDisplayMode.values.firstWhere(
      (e) => e.toString() == 'BarcodeDisplayMode.$value',
      orElse: () => BarcodeDisplayMode.list,
    );
  }

  Future<void> setBarcodeDisplayMode(BarcodeDisplayMode mode) async {
    await storeRef.record(kBarcodeDisplayMode).put(datastore.db, mode.name);
  }
}
