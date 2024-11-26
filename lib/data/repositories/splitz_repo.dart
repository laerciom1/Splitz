import 'package:firebase_database/firebase_database.dart';
import 'package:splitz/data/entities/splitz/group_config_entity.dart';
import 'package:splitz/services/log_service.dart';

abstract class SplitzRepository {
  static final FirebaseDatabase _db = FirebaseDatabase.instance;
  static Future<GroupConfigEntity?> getGroupConfig(String groupId) async {
    try {
      final snapshot = await _db.ref('/groups/$groupId').get();
      if (snapshot.value != null) {
        final json = snapshot.value as Map<dynamic, dynamic>;
        // final json = Map<String, dynamic>.from(snapshot.value as Map);
        final result = GroupConfigEntity.fromMap(json);
        return result;
      }
      return null;
    } catch (e, s) {
      LogService.log('Splitz.getGroupConfig', error: e, stackTrace: s);
      return null;
    }
  }

  static Future<GroupConfigEntity> updateGroup(
    String groupId,
    GroupConfigEntity config,
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
