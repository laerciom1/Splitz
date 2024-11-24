import 'package:firebase_database/firebase_database.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/services/log_service.dart';

abstract class SplitzRepository {
  static final FirebaseDatabase _db = FirebaseDatabase.instance;
  static Future<GroupConfig?> getGroupConfig(String groupId) async {
    try {
      final snapshot = await _db.ref('/groups/$groupId').get();
      if (snapshot.value != null) {
        final json = snapshot.value as Map<dynamic, dynamic>;
        // final json = Map<String, dynamic>.from(snapshot.value as Map);
        final result = GroupConfig.fromMap(json);
        return result;
      }
      return null;
    } catch (e, s) {
      LogService.log('Splitz.getGroupConfig', error: e, stackTrace: s);
      return null;
    }
  }

  static Future<GroupConfig> updateGroup(
    String groupId,
    GroupConfig config,
  ) async {
    try {
      final ref = _db.ref('/groups/$groupId');
      await ref.set(config.toMap());
      return config;
    } catch (e, s) {
      LogService.log('Splitz.updateGroupe', error: e, stackTrace: s);
      rethrow;
    }
  }
}
