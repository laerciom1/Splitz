import 'package:splitz/data/entities/external/group_entity.dart';
import 'package:splitz/data/entities/external/member_entity.dart';
import 'package:splitz/data/entities/splitz/app_preferences_entity.dart';
import 'package:splitz/data/entities/external/expense_entity.dart';
import 'package:splitz/data/entities/splitz/export_entity.dart';
import 'package:splitz/data/entities/splitz/init_result_entity.dart';
import 'package:splitz/data/entities/splitz/group_config_entity.dart';
import 'package:splitz/data/repositories/gsheets_repo.dart';
import 'package:splitz/data/repositories/splitwise_repo.dart';
import 'package:splitz/data/repositories/splitz_repo.dart';
import 'package:splitz/extensions/datetime.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/services/auth_service.dart';
import 'package:splitz/data/repositories/storage_repo.dart';

const _storageKey = 'SPLITZ_SERVICE_STORAGE_KEY';

abstract class SplitzService {
  static AppPreferencesEntity? _inMemoryAppPreferences;

  static Future<AppPreferencesEntity> get _appPreferences async {
    if (_inMemoryAppPreferences != null) return _inMemoryAppPreferences!;
    final appPrefs = await StorageRepository.read(_storageKey);
    if (appPrefs != null) {
      _inMemoryAppPreferences = AppPreferencesEntity.fromJson(appPrefs);
    } else {
      _inMemoryAppPreferences = AppPreferencesEntity();
      await saveAppPrefs(_inMemoryAppPreferences!);
    }
    return _inMemoryAppPreferences!;
  }

  static Future<void> saveAppPrefs(AppPreferencesEntity appPrefs) async =>
      StorageRepository.save(_storageKey, appPrefs.toJson());

  static Future<void> clearAppPrefs() async =>
      StorageRepository.clear(_storageKey);

  static Future<InitResultEntity> init() async {
    final isSignedInToSplitz = AuthService.isSignedInToSplitz;
    if (!isSignedInToSplitz) {
      return InitResultEntity(firstScreen: FirstScreen.splitzLogin);
    }

    final isSignedInToSplitwise = await AuthService.isSignedInToSplitwise;
    if (!isSignedInToSplitwise) {
      return InitResultEntity(firstScreen: FirstScreen.splitwiseLogin);
    }

    final appPrefs = await _appPreferences;
    if (appPrefs.selectedGroup.isNotNullNorEmpty) {
      return InitResultEntity(
        firstScreen: FirstScreen.group,
        args: appPrefs.selectedGroup,
      );
    }

    return InitResultEntity(firstScreen: FirstScreen.groupsList);
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

  static Future<List<GroupEntity>> getGroups() async {
    final response = await SplitwiseRepository.getGroups();
    if (response.groups.isNullOrEmpty) return [];
    final groups = response.groups
        .map(GroupEntity.fromSplitwiseModel)
        .where((e) => e.id != 0)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return groups;
  }

  static Future<void> selectGroup(String group) async {
    final appPrefs = await _appPreferences;
    appPrefs.selectedGroup = group;
    await saveAppPrefs(appPrefs);
  }

  static Future<GroupConfigEntity?> getGroupConfig(String groupId) async =>
      await SplitzRepository.getGroupConfig(groupId);

  static Future<List<ExpenseEntity>> getExpenses(
    String groupId,
    Map<String, SplitzCategory> categories,
  ) async {
    final response = await SplitwiseRepository.getExpenses(groupId);
    final filteredExpenses = [
      ...response.expenses
          .where((e) => e.deletedAt == null && e.payment != true),
    ];
    return filteredExpenses.map((e) {
      final prefix = e.description.split(' ')[0];
      final imageUrl = categories[prefix]!.imageUrl;
      return ExpenseEntity.fromExpenseResponse(e, imageUrl);
    }).toList();
  }

  static Future<GroupEntity> getGroupInfo(String groupId) async {
    final response = await SplitwiseRepository.getGroupInfo(groupId);
    return GroupEntity.fromSplitwiseModel(response.group);
  }

  static Map<String, SplitzConfig> getSplitzConfigsFromMembers(
    List<MemberEntity> members,
  ) {
    final result = <String, SplitzConfig>{};
    double sum = 0;
    for (int idx = 0; idx < members.length - 1; idx++) {
      sum += (100 / members.length).round();
      result['${members[idx].id}'] = SplitzConfig(
        id: members[idx].id,
        name: members[idx].firstName,
        avatarUrl: members[idx].imageUrl,
        slice: (100 / members.length).round(),
      );
    }
    result['${members.last.id}'] = SplitzConfig(
      id: members.last.id,
      name: members.last.firstName,
      avatarUrl: members.last.imageUrl,
      slice: (100 - sum).round(),
    );
    return result;
  }

  static Map<String, SplitzConfig> mergeSplitzConfigs(
    Map<String, SplitzConfig> a,
    Map<String, SplitzConfig> b,
  ) =>
      {...b, ...a};

  static Future<List<SplitzCategory>> getAvailableCategories(
    Map<String, SplitzCategory> actualCategories,
  ) async {
    final response = await SplitwiseRepository.getAvailableCategories();
    final result = <SplitzCategory>[];
    for (var c in response.categories) {
      result.add(SplitzCategory.fromCategory(c));
      result.addAll(c.subcategories.map((c) => SplitzCategory.fromCategory(c)));
    }
    final actualCategoriesSet = <String>{};
    for (var e in actualCategories.values) {
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

  static Future<GroupConfigEntity> updateSplitzGroupConfig(
    String groupId,
    GroupConfigEntity config,
  ) async =>
      await SplitzRepository.updateGroup(groupId, config);

  static Future<int> createExpense(ExpenseEntity expense) async =>
      await SplitwiseRepository.createExpense(expense);

  static Future<void> deleteExpense(ExpenseEntity expense) async =>
      await SplitwiseRepository.deleteExpense(expense);

  static Future<int> updateExpense(ExpenseEntity expense) async =>
      await SplitwiseRepository.updateExpense(expense);

  static Future<ExportEntity> getExportExpenses(
    String groupId,
    DateTime month,
  ) async {
    final response =
        await SplitwiseRepository.getExportExpenses(groupId, month);
    final filteredExpenses = [
      ...response.expenses
          .where((e) => e.deletedAt == null && e.payment != true),
    ];
    final expenses = filteredExpenses.map(ExpenseEntity.fromExpenseResponse);
    return ExportEntity.fromExpenses(expenses);
  }

  static Future<void> exportExpenses(
    ExportEntity export,
  ) async {
    final dateColumn = ['Date'];
    final descriptionColumn = ['Expense'];
    final costColumn = ['Cost'];
    final categoryColumn = ['Category'];
    final totalColumn = ['Total'];

    for (final category in export.categories) {
      categoryColumn.add(category.prefix);
      totalColumn.add('${category.total}'.replaceAll('.', ','));
      for (final expense in category.expenses) {
        dateColumn.add(expense.date.toDateFormat('dd/MM/yy'));
        descriptionColumn.add(expense.description);
        costColumn.add(expense.cost.replaceAll('.', ','));
      }
    }

    await GSheetsRepository.recreate('SplitzExport', [
      dateColumn,
      descriptionColumn,
      costColumn,
      [],
      categoryColumn,
      totalColumn,
    ]);
  }

  static Future<void> signOut() async {
    AuthService.signOut();
    await clearAppPrefs();
  }
}
