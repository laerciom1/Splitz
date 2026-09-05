import 'package:splitz/application/entities/splitz/group_config_entity.dart';
import 'package:splitz/application/services/log_service.dart';
import 'package:splitz/data/repositories/functions_repo.dart';

abstract class SplitzRepository {
  static Future<GroupConfigEntity?> getGroupConfig(String groupId) async {
    try {
      final data = await FunctionsRepository.call('getSplitzGroupConfig', {'groupId': groupId});
      final result = _handleGroupConfig(data);
      return result;
    } catch (e, s) {
      LogService.log('SplitzRepository.getGroupConfig', e, s);
      return null;
    }
  }

  static Future<GroupConfigEntity> updateGroup(
    String groupId,
    GroupConfigEntity config,
  ) async {
    try {
      final data = await FunctionsRepository.call('updateSplitzGroupConfig', {
        'groupId': groupId,
        'config': config.toMap(),
      });
      final result = _handleGroupConfig(data);
      return result!;
    } catch (e, s) {
      LogService.log('SplitzRepository.updateGroup', e, s);
      rethrow;
    }
  }

  static GroupConfigEntity? _handleGroupConfig(Map<String, dynamic> data) {
    final config = data['config'];
    if (config == null) return null;
    return GroupConfigEntity.fromMap(Map<String, dynamic>.from(config as Map));
  }
}
