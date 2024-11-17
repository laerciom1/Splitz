import 'package:splitz/data/entities/app_preferences.dart';
import 'package:splitz/data/entities/init_result.dart';
import 'package:splitz/data/models/splitwise/get_expenses/get_expenses_response.dart';
import 'package:splitz/data/models/splitwise/get_groups/get_groups_response.dart';
import 'package:splitz/data/repositories/splitwise_repo.dart';
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

  static Future<void> selectGroup(String group) async {
    _appPreferences!.selectedGroup = group;
    await StorageService.save(_storageKey, _appPreferences!.toJson());
  }

  static Future<List<Group>?> getGroups() async {
    final response = await SplitwiseRepository.getGroups();
    if (response == null || response.groups == null) return null;
    final groups = response.groups!
      ..sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
    return groups;
  }

  static Future<List<Expense>?> getExpenses(String groupId) async {
    final response = await SplitwiseRepository.getExpenses();
    if (response == null || response.expenses == null) return null;
    final filteredExpenses = response.expenses!
        .where((e) => groupId == '${e.groupId}' && e.deletedAt == null)
        .toList();
    return filteredExpenses;
  }
}
