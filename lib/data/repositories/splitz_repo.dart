import 'package:firebase_database/firebase_database.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/services/log_service.dart';

abstract class SplitzRepository {
  static final FirebaseDatabase _db = FirebaseDatabase.instance;
  static Future<GroupConfig?> getGroupConfig(String groupId) async {
    try {
      final snapshot = await _db.ref('/groups/$groupId').get();
      if (snapshot.value != null) {
        final result = GroupConfig.fromMap(
          snapshot.value as Map<String, dynamic>,
        );
        return result;
      }
      return null;
    } catch (e, s) {
      LogService.log('Splitz.test', error: e, stackTrace: s);
      return null;
    }
  }
}
