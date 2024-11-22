import 'package:splitz/data/entities/app_preferences.dart';
import 'package:splitz/data/entities/init_result.dart';
import 'package:splitz/data/models/splitwise/common/group.dart';
import 'package:splitz/data/models/splitwise/get_expenses/get_expenses_response.dart';
import 'package:splitz/data/models/splitwise/get_group/get_group_response.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/data/repositories/splitwise_repo.dart';
import 'package:splitz/data/repositories/splitz_repo.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/services/auth_service.dart';
import 'package:splitz/data/repositories/storage_repo.dart';

const _storageKey = 'SPLITZ_SERVICE_STORAGE_KEY';

abstract class SplitzService {
  static AppPreferences? _appPreferences;

  static Future<InitResult> init() async {
    if (_appPreferences == null) {
      final appPrefs = await StorageService.read(_storageKey);
      if (appPrefs != null) {
        _appPreferences = AppPreferences.fromJson(appPrefs);
      } else {
        _appPreferences = AppPreferences();
        await StorageService.save(_storageKey, _appPreferences!.toJson());
      }
    }

    final isSignedInToSplitz = AuthService.isSignedInToSplitz;
    if (!isSignedInToSplitz) {
      return InitResult(firstScreen: FirstScreen.splitzLogin);
    }

    final isSignedInToSplitwise = await AuthService.isSignedInToSplitwise;
    if (!isSignedInToSplitwise) {
      return InitResult(firstScreen: FirstScreen.splitwiseLogin);
    }

    if (_appPreferences!.selectedGroup.isNotNullNorEmpty) {
      return InitResult(
        firstScreen: FirstScreen.group,
        args: _appPreferences!.selectedGroup,
      );
    }
    return InitResult(firstScreen: FirstScreen.groupsList);
  }

  static Future<List<Expense>?> getExpenses(String groupId) async {
    final response = await SplitwiseRepository.getExpenses();
    if (response == null) return null;
    final filteredExpenses = (response.expenses ?? [])
        .where((e) => groupId == '${e.groupId}' && e.deletedAt == null)
        .toList();
    return filteredExpenses;
  }

  static List<SplitzConfig> getSplitConfigsFromMembers(List<Member> members) {
    final result = <SplitzConfig>[];
    double sum = 0;
    for (int idx = 0; idx < members.length - 1; idx++) {
      sum += (100 / members.length).round();
      result.add(SplitzConfig(
        id: members[idx].id,
        name: members[idx].firstName,
        avatarUrl: members[idx].picture.large,
        slice: (100 / members.length).round(),
      ));
    }
    result.add(SplitzConfig(
      id: members.last.id,
      name: members.last.firstName,
      avatarUrl: members.last.picture.large,
      slice: (100 - sum).round(),
    ));
    return result;
  }

  static List<SplitzConfig> mergeSplitConfigs(
    List<SplitzConfig> a,
    List<SplitzConfig> b,
  ) {
    if (a.isEmpty) return b;
    if (b.isEmpty) return a;
    return [...a, ...b].unique((config) => config.id);
  }

  static Future<GetGroupResponse?> getGroupInfo(String groupId) async {
    final response = await SplitwiseRepository.getGroupInfo(groupId);
    if (response == null) return null;
    return response;
  }

  static Future<GroupConfig?> getGroupConfig(String groupId) async {
    final response = await SplitzRepository.getGroupConfig(groupId);
    if (response == null) return null;
    return response;
  }

  static Future<void> selectGroup(String group) async {
    _appPreferences!.selectedGroup = group;
    await StorageService.save(_storageKey, _appPreferences!.toJson());
  }

  static Future<List<Group>?> getGroups() async {
    final response = await SplitwiseRepository.getGroups();
    if (response == null || response.groups == null) return null;
    final groups = (response.groups ?? [])
      ..sort((a, b) => (b.updatedAt ?? DateTime.now()).compareTo(
            (a.updatedAt ?? DateTime.now()),
          ));
    return groups;
  }

  static Future<List<SplitzCategory>> getAvailableCategories() async {
    final response = await SplitwiseRepository.getAvailableCategories();
    if (response == null || response.categories == null) return [];
    final result = <SplitzCategory>[];
    for (var c in response.categories!) {
      result.add(SplitzCategory.fromCategory(c));
      result.addAll(
        (c.subcategories ?? []).map((c) => SplitzCategory.fromCategory(c)),
      );
    }
    return result.unique((e) => e.imageUrl);
  }
}
