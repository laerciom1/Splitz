import 'package:firebase_database/firebase_database.dart';
import 'package:splitz/services/log.dart';

abstract class Splitz {
  static Future<void> test() async {
    try {
      FirebaseDatabase database = FirebaseDatabase.instance;
      final snapshot = await database.ref().get();
      return;
    } catch (e, s) {
      Log.that('Splitz.test', error: e, stackTrace: s);
      return;
    }
  }
}
