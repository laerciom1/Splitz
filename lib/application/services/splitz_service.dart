import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:splitz/application/entities/splitwise/group_entity.dart';
import 'package:splitz/application/entities/splitwise/member_entity.dart';
import 'package:splitz/application/entities/splitz/app_preferences_entity.dart';
import 'package:splitz/application/entities/splitwise/expense_entity.dart';
import 'package:splitz/application/entities/splitz/export_entity.dart';
import 'package:splitz/application/entities/splitz/init_result_entity.dart';
import 'package:splitz/application/entities/splitz/group_config_entity.dart';
import 'package:splitz/data/repositories/gsheets_repo.dart';
import 'package:splitz/data/repositories/splitwise_repo.dart';
import 'package:splitz/data/repositories/splitz_repo.dart';
import 'package:splitz/util/extensions/datetime.dart';
import 'package:splitz/util/extensions/list.dart';
import 'package:splitz/util/extensions/strings.dart';
import 'package:splitz/core/navigator.dart';
import 'package:splitz/presentation/screens/loading.dart';
import 'package:splitz/presentation/screens/login_splitz.dart';
import 'package:splitz/application/services/auth_service.dart';
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

  static Future<void> clearAppPrefs() async => StorageRepository.clear(_storageKey);

  static Future<InitResultEntity> init(Uri initialUri) async {
    final isSignedInToSplitz = await AuthService.isSignedInToSplitz;
    if (!isSignedInToSplitz) {
      return InitResultEntity(firstScreen: FirstScreen.splitzLogin);
    }

    final isSignedInToSplitwise = await AuthService.isSignedInToSplitwise;
    if (!isSignedInToSplitwise) {
      if (kIsWeb) {
        final code = checkRedirectUrlAndGetCode(initialUri);
        if (code.isNotEmpty) return InitResultEntity(firstScreen: FirstScreen.splitwiseLogin, args: code);
      }
      return InitResultEntity(firstScreen: FirstScreen.splitwiseLogin);
    }

    final appPrefs = await _appPreferences;
    if (appPrefs.selectedGroup.isNotNullNorEmpty) {
      return InitResultEntity(firstScreen: FirstScreen.group, args: appPrefs.selectedGroup);
    }

    return InitResultEntity(firstScreen: FirstScreen.groupsList);
  }

  static String checkRedirectUrlAndGetCode(Uri uri) {
    final redirectUrl = Uri.parse(const String.fromEnvironment('SW_REDIRECT_URL'));
    final code = uri.queryParameters['code'];
    if (uri.path == redirectUrl.path && !code.isNullOrEmpty) {
      return code ?? '';
    }
    return '';
  }

  static Future<String> getAndSaveCurrentSplitwiseUser() async {
    final response = await SplitwiseRepository.getCurrentUser();
    final appPrefs = await _appPreferences;
    appPrefs.currentUserId = '${response.user.id}';
    await saveAppPrefs(appPrefs);
    return appPrefs.currentUserId!;
  }

  static Future<String> getCurrentSplitwiseUser() async {
    final appPrefs = await _appPreferences;
    if (appPrefs.currentUserId.isNotNullNorEmpty) return appPrefs.currentUserId!;
    return await getAndSaveCurrentSplitwiseUser();
  }

  static Future<List<GroupEntity>> getGroups() async {
    final currentUserId = await getCurrentSplitwiseUser();
    final response = await SplitwiseRepository.getGroups();
    if (response.groups.isNullOrEmpty) return [];
    final groups = response.groups
        .map((e) => GroupEntity.fromSplitwiseModel(e, currentUserId))
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

  static Future<List<ExpenseEntity>> getExpenses(String groupId, List<SplitzCategory> categories) async {
    final response = await SplitwiseRepository.getExpenses(groupId);
    final filteredExpenses = [
      ...response.expenses.where((e) => e.deletedAt == null),
    ];
    final result = <ExpenseEntity>[];
    for (final e in filteredExpenses) {
      final prefix = e.description.split(' ')[0];
      final imageUrl = categories.firstWhereOrNull((e) => e.prefix == prefix)?.imageUrl;
      if (imageUrl.isNotNullNorEmpty || e.payment) {
        result.add(ExpenseEntity.fromExpenseResponse(e, imageUrl));
      }
    }
    return result;
  }

  static Future<GroupEntity> getGroupInfo(String groupId) async {
    final currentUserId = await getCurrentSplitwiseUser();
    final response = await SplitwiseRepository.getGroupInfo(groupId);
    return GroupEntity.fromSplitwiseModel(response.group, currentUserId);
  }

  static Map<String, SplitzConfig> getSplitzConfigsFromMembers(List<MemberEntity> members) {
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

  static Map<String, SplitzConfig> mergeSplitzConfigs(Map<String, SplitzConfig> a, Map<String, SplitzConfig> b) =>
      {...a, ...b};

  static Future<List<SplitzCategory>> getAvailableCategories(List<SplitzCategory> actualCategories) async {
    final response = await SplitwiseRepository.getAvailableCategories();
    final result = <SplitzCategory>[];
    for (var c in response.categories) {
      result.add(SplitzCategory.fromCategory(c));
      result.addAll(c.subcategories.map((c) => SplitzCategory.fromCategory(c)));
    }
    final actualCategoriesSet = <String>{};
    for (var e in actualCategories) {
      actualCategoriesSet.addAll(['${e.id}', e.imageUrl]);
    }
    return [
      ...result
          .where((e) => !actualCategoriesSet.contains('${e.id}') && !actualCategoriesSet.contains(e.imageUrl))
          .unique((e) => e.imageUrl)
    ];
  }

  static Future<GroupConfigEntity> updateSplitzGroupConfig(String groupId, GroupConfigEntity config) =>
      SplitzRepository.updateGroup(groupId, config);

  static Future<int> createExpense(ExpenseEntity expense) => SplitwiseRepository.createExpense(expense);

  static Future<void> deleteExpense(ExpenseEntity expense) => SplitwiseRepository.deleteExpense(expense);

  static Future<void> undeleteExpense(ExpenseEntity expense) => SplitwiseRepository.undeleteExpense(expense);

  static Future<int> updateExpense(ExpenseEntity expense) => SplitwiseRepository.updateExpense(expense);

  static Future<ExportEntity> getExportExpenses(String groupId, DateTime month) async {
    final response = await SplitwiseRepository.getExportExpenses(groupId, month);
    final filteredExpenses = [
      ...response.expenses.where((e) => e.deletedAt == null && e.payment != true),
    ];
    final expenses = filteredExpenses.map(ExpenseEntity.fromExpenseResponse);
    return ExportEntity.fromExpenses(expenses);
  }

  static Future<void> exportExpenses(String groupId, ExportEntity export) async {
    final rows = <List<String>>[
      ['Date', 'Expense', 'Cost', '', 'Category', 'Total']
    ];

    for (final category in export.categories) {
      var start = true;

      for (final expense in category.expenses) {
        final row = List.filled(6, '');
        row[0] = expense.date.toDateFormat('dd/MM/yy');
        row[1] = expense.description;
        row[2] = expense.cost.replaceAll('.', ',');
        if (start) {
          row[4] = category.prefix;
          row[5] = '${category.total}'.replaceAll('.', ',');
          start = false;
        }

        rows.add(row);
      }
    }

    await GSheetsRepository.recreate(groupId, rows);
  }

  static Future<void> signOut() async {
    AppNavigator.replaceAll([const LoadingScreen()]);
    await AuthService.signOut();
    await clearAppPrefs();
    Future.delayed(const Duration(milliseconds: 250), () {
      AppNavigator.replaceAll([const SplitzLoginScreen()]);
    });
  }
}
