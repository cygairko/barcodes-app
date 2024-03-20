import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

part 'data_store.g.dart';

@Riverpod(keepAlive: true)
Future<SembastDataStore> sembastDataStore(SembastDataStoreRef ref) =>
    SembastDataStore.makeDefault();

// class SembastDataStore implements DataStore {
//   SembastDataStore(this.db);
//   final Database db;

//   static Future<Database> createDatabase(String filename) async {
//     if (!kIsWeb) {
//       final appDocDir = await getApplicationDocumentsDirectory();
//       return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
//     } else {
//       return databaseFactoryWeb.openDatabase(filename);
//     }
//   }

//   static Future<SembastDataStore> makeDefault() async {
//     return SembastDataStore(await createDatabase('default.db'));
//   }
// }

class SembastDataStore {
  SembastDataStore(this.db);
  final Database db;

  Database get database => db;

  static Future<Database> createDatabase(String filename) async {
    if (!kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
    } else {
      return databaseFactoryWeb.openDatabase(filename);
    }
  }

  static Future<SembastDataStore> makeDefault() async {
    return SembastDataStore(await createDatabase('baskets.db'));
  }
}
