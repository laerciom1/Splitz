import 'package:firebase_database/firebase_database.dart';
import 'package:splitz/services/log_service.dart';

abstract class SplitzRepository {
  static final FirebaseDatabase _db = FirebaseDatabase.instance;
  static Future<void> test() async {
    try {
      final snapshot = await _db.ref().get();
      return;
    } catch (e, s) {
      LogService.log('Splitz.test', error: e, stackTrace: s);
      return;
    }
  }
}
