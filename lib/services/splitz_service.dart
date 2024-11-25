import 'package:splitz/data/entities/app_preferences.dart';
import 'package:splitz/data/entities/expense_entity.dart';
import 'package:splitz/data/entities/init_result.dart';
import 'package:splitz/data/models/splitwise/common/group.dart';
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
  static AppPreferences? _inMemoryAppPreferences;

  static Future<AppPreferences> get _appPreferences async {
    if (_inMemoryAppPreferences != null) return _inMemoryAppPreferences!;
    final appPrefs = await StorageService.read(_storageKey);
    if (appPrefs != null) {
      _inMemoryAppPreferences = AppPreferences.fromJson(appPrefs);
    } else {
      _inMemoryAppPreferences = AppPreferences();
      await saveAppPrefs(_inMemoryAppPreferences!);
    }
    return _inMemoryAppPreferences!;
  }

  static Future<void> saveAppPrefs(AppPreferences appPrefs) async =>
      StorageService.save(_storageKey, appPrefs.toJson());

  static Future<void> clearAppPrefs() async =>
      StorageService.clear(_storageKey);

  static Future<InitResult> init() async {
    final isSignedInToSplitz = AuthService.isSignedInToSplitz;
    if (!isSignedInToSplitz) {
      return InitResult(firstScreen: FirstScreen.splitzLogin);
    }

    final isSignedInToSplitwise = await AuthService.isSignedInToSplitwise;
    if (!isSignedInToSplitwise) {
      return InitResult(firstScreen: FirstScreen.splitwiseLogin);
    }

    final appPrefs = await _appPreferences;
    if (appPrefs.selectedGroup.isNotNullNorEmpty) {
      return InitResult(
        firstScreen: FirstScreen.group,
        args: appPrefs.selectedGroup,
      );
    }

    return InitResult(firstScreen: FirstScreen.groupsList);
  }

  static Future<void> getAndSaveCurrentSplitwiseUser() async {
    final response = await SplitwiseRepository.getCurrentUser();
    final appPrefs = await _appPreferences;
    appPrefs.currentUserId = '${response.user.id}';
    await saveAppPrefs(appPrefs);
  }

  static Future<String> getCurrentSplitwiseUser() async {
    final appPrefs = await _appPreferences;
    if (appPrefs.currentUserId.isNotNullNorEmpty) {
      return appPrefs.currentUserId!;
    }
    final response = await SplitwiseRepository.getCurrentUser();
    appPrefs.currentUserId = '${response.user.id}';
    await saveAppPrefs(appPrefs);
    return appPrefs.currentUserId!;
  }

  static Future<List<Group>> getGroups() async {
    final response = await SplitwiseRepository.getGroups();
    if (response.groups.isNullOrEmpty) return [];
    final groups = response.groups!.where((e) => e.id != 0).toList()
      ..sort((a, b) => (b.updatedAt ?? DateTime.now()).compareTo(
            (a.updatedAt ?? DateTime.now()),
          ));
    return groups;
  }

  static Future<void> selectGroup(String group) async {
    final appPrefs = await _appPreferences;
    appPrefs.selectedGroup = group;
    await saveAppPrefs(appPrefs);
  }

  static Future<GroupConfig?> getGroupConfig(String groupId) async =>
      await SplitzRepository.getGroupConfig(groupId);

  static Future<List<ExpenseEntity>> getExpenses(
    String groupId,
    List<SplitzCategory> categories,
  ) async {
    final response = await SplitwiseRepository.getExpenses(groupId);
    final filteredExpenses = [
      ...(response.expenses ?? [])
          .where((e) => e.deletedAt == null && e.payment != true),
    ];
    final idMap = categories.fold(
      <int, String>{},
      (accu, curr) => {...accu, curr.id: curr.imageUrl},
    );
    final prefixMap = categories.fold(
      <String, String>{},
      (accu, curr) => {...accu, curr.prefix: curr.imageUrl},
    );
    return filteredExpenses.map((e) {
      final imageUrl =
          idMap[e.category.id] ?? prefixMap[e.description.split(' ')[0]];
      return ExpenseEntity.fromExpenseResponse(e, imageUrl!);
    }).toList();
  }

  static Future<GetGroupResponse> getGroupInfo(String groupId) async =>
      await SplitwiseRepository.getGroupInfo(groupId);

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

  static Future<List<SplitzCategory>> getAvailableCategories(
    List<SplitzCategory> actualCategories,
  ) async {
    final response = await SplitwiseRepository.getAvailableCategories();
    final result = <SplitzCategory>[];
    for (var c in response.categories) {
      result.add(SplitzCategory.fromCategory(c));
      result.addAll(
        (c.subcategories ?? []).map((c) => SplitzCategory.fromCategory(c)),
      );
    }
    final actualCategoriesSet = <String>{};
    for (var e in actualCategories) {
      actualCategoriesSet.addAll(['${e.id}', e.imageUrl]);
    }
    return [
      ...result
          .where((e) =>
              !actualCategoriesSet.contains('${e.id}') &&
              !actualCategoriesSet.contains(e.imageUrl))
          .unique((e) => e.imageUrl)
    ];
  }

  static Future<GroupConfig> updateSplitzGroupConfig(
    String groupId,
    GroupConfig config,
  ) async =>
      await SplitzRepository.updateGroup(groupId, config);

  static Future<int> createExpense(ExpenseEntity expense) async =>
      await SplitwiseRepository.createExpense(expense);

  static Future<void> deleteExpense(ExpenseEntity expense) async =>
      await SplitwiseRepository.deleteExpense(expense);

  static Future<int> updateExpense(ExpenseEntity expense) async =>
      await SplitwiseRepository.updateExpense(expense);

  static Future<void> signOut() async {
    AuthService.signOut();
    await clearAppPrefs();
  }
}
