import 'package:barcodes/features/settings/data/settings_repository.dart';
import 'package:barcodes/utils/data_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';

void main() {
  group('SettingsRepository', () {
    late DatabaseFactory dbFactory;
    late Database db;
    late DataStore dataStore;
    late SettingsRepository settingsRepository;

    setUpAll(() {
      // Use an in-memory database factory for testing
      dbFactory = databaseFactoryMemory;
    });

    setUp(() async {
      // Open a new in-memory database for each test
      db = await dbFactory.openDatabase('test_settings.db');
      dataStore = DataStore(db);
      settingsRepository = SettingsRepository(dataStore);
    });

    tearDown(() async {
      // Close the database after each test
      await db.close();
    });

    group('automaticScreenBrightness', () {
      test('returns default value (false) when no value is in the database', () async {
        final value = await settingsRepository.getAutomaticScreenBrightness();
        expect(value, isFalse);
      });

      test('setAutomaticScreenBrightness(true) and then getAutomaticScreenBrightness() returns true', () async {
        await settingsRepository.setAutomaticScreenBrightness(true);
        final value = await settingsRepository.getAutomaticScreenBrightness();
        expect(value, isTrue);
      });

      test('setAutomaticScreenBrightness(false) and then getAutomaticScreenBrightness() returns false', () async {
        await settingsRepository.setAutomaticScreenBrightness(false);
        final value = await settingsRepository.getAutomaticScreenBrightness();
        expect(value, isFalse);
      });
    });

    group('maxScreenBrightnessLevel', () {
      test('returns default value (0.8) when no value is in the database', () async {
        final value = await settingsRepository.getMaxScreenBrightnessLevel();
        expect(value, 0.8);
      });

      test('setMaxScreenBrightnessLevel(0.5) and then getMaxScreenBrightnessLevel() returns 0.5', () async {
        await settingsRepository.setMaxScreenBrightnessLevel(0.5);
        final value = await settingsRepository.getMaxScreenBrightnessLevel();
        expect(value, 0.5);
      });

      test('setMaxScreenBrightnessLevel(1.0) and then getMaxScreenBrightnessLevel() returns 1.0', () async {
        await settingsRepository.setMaxScreenBrightnessLevel(1.0);
        final value = await settingsRepository.getMaxScreenBrightnessLevel();
        expect(value, 1.0);
      });
      
      test('setMaxScreenBrightnessLevel(0) and then getMaxScreenBrightnessLevel() returns 0.0 (edge case)', () async {
        await settingsRepository.setMaxScreenBrightnessLevel(0.0);
        final value = await settingsRepository.getMaxScreenBrightnessLevel();
        expect(value, 0.0);
      });

      test('retrieves integer value as double (e.g. 1 stored, retrieved as 1.0)', () async {
        // Directly manipulate the store to simulate an integer being stored
        // This can happen if a previous version of the app stored it as an int
        await settingsRepository.storeRef.record(kMaxScreenBrightnessLevel).put(db, 1);
        final value = await settingsRepository.getMaxScreenBrightnessLevel();
        expect(value, 1.0);
        expect(value, isA<double>());
      });
    });
  });
}
