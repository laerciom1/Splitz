import 'package:splitz/application/entities/splitwise/expense_entity.dart';
import 'package:splitz/data/models/splitwise/common/expense_request.dart';
import 'package:splitz/data/models/splitwise/create_expense/create_expense_response.dart';
import 'package:splitz/data/models/splitwise/common/plain_success_response.dart';
import 'package:splitz/data/models/splitwise/get_categories/get_categories_response.dart';
import 'package:splitz/data/models/splitwise/get_current_user/get_current_user_response.dart';
import 'package:splitz/data/models/splitwise/get_expenses/get_expenses_response.dart';
import 'package:splitz/data/models/splitwise/get_group/get_group_response.dart';
import 'package:splitz/data/models/splitwise/get_groups/get_groups_response.dart';
import 'package:splitz/data/models/splitwise/update_expense/update_expense_response.dart';
import 'package:splitz/data/repositories/functions_repo.dart';
import 'package:splitz/application/services/log_service.dart';

abstract class SplitwiseRepository {
  static Future<GetCurrentUserResponse> getCurrentUser() async {
    try {
      final data = await FunctionsRepository.call('getSplitwiseCurrentUser');
      final result = GetCurrentUserResponse.fromMap(data);
      return result;
    } catch (e, s) {
      LogService.log('SplitwiseRepository.getCurrentUser', e, s);
      rethrow;
    }
  }

  static Future<GetGroupsResponse> getGroups() async {
    try {
      final data = await FunctionsRepository.call('getSplitwiseGroups');
      final result = GetGroupsResponse.fromMap(data);
      return result;
    } catch (e, s) {
      LogService.log('SplitwiseRepository.getGroups', e, s);
      rethrow;
    }
  }

  static Future<GetGroupResponse> getGroupInfo(String groupId) async {
    try {
      final data = await FunctionsRepository.call('getSplitwiseGroup', {'groupId': groupId});
      final result = GetGroupResponse.fromMap(data);
      return result;
    } catch (e, s) {
      LogService.log('SplitwiseRepository.getGroupInfo', e, s);
      rethrow;
    }
  }

  static Future<GetExpensesResponse> getExpenses(String groupId) async {
    try {
      final data = await FunctionsRepository.call('getSplitwiseExpenses', {'groupId': groupId});
      final result = GetExpensesResponse.fromMap(data);
      return result;
    } catch (e, s) {
      LogService.log('SplitwiseRepository.getExpenses', e, s);
      rethrow;
    }
  }

  static Future<GetExpensesResponse> getExportExpenses(
    String groupId,
    DateTime month,
  ) async {
    try {
      final data = await FunctionsRepository.call('getSplitwiseExportExpenses', {
        'groupId': groupId,
        'year': month.year,
        'month': month.month,
      });
      final result = GetExpensesResponse.fromMap(data);
      return result;
    } catch (e, s) {
      LogService.log('SplitwiseRepository.getExportExpenses', e, s);
      rethrow;
    }
  }

  static Future<GetCategoriesResponse> getAvailableCategories() async {
    try {
      final data = await FunctionsRepository.call('getSplitwiseCategories');
      final result = GetCategoriesResponse.fromMap(data);
      return result;
    } catch (e, s) {
      LogService.log('SplitwiseRepository.getAvailableCategories', e, s);
      rethrow;
    }
  }

  static Future<int> createExpense(ExpenseEntity expense) async {
    try {
      final request = ExpenseRequest.createBody(expense);
      final data = await FunctionsRepository.call('createSplitwiseExpense', {'expense': request});
      final result = CreateExpenseResponse.fromMap(data);
      return result.expenses[0].id;
    } catch (e, s) {
      LogService.log('SplitwiseRepository.createExpense', e, s);
      rethrow;
    }
  }

  static Future<void> deleteExpense(ExpenseEntity expense) async => _handleDeleteOperation(expense);

  static Future<void> undeleteExpense(ExpenseEntity expense) async => _handleDeleteOperation(expense, undelete: true);

  static Future<void> _handleDeleteOperation(
    ExpenseEntity expense, {
    bool undelete = false,
  }) async {
    final operation = undelete ? 'undeleteSplitwiseExpense' : 'deleteSplitwiseExpense';
    try {
      final data = await FunctionsRepository.call(operation, {'expenseId': expense.id});
      final result = PlainSuccessResponse.fromMap(data);
      if (result.success != true) throw Exception("success isn't true on $operation result");
    } catch (e, s) {
      LogService.log('SplitwiseRepository.$operation', e, s);
      rethrow;
    }
  }

  static Future<int> updateExpense(ExpenseEntity expense) async {
    try {
      final request = ExpenseRequest.createBody(expense);
      final data = await FunctionsRepository.call('updateSplitwiseExpense', {
        'expenseId': expense.id,
        'expense': request,
      });
      final result = UpdateExpenseResponse.fromMap(data);
      return result.expenses[0].id;
    } catch (e, s) {
      LogService.log('SplitwiseRepository.updateExpense', e, s);
      rethrow;
    }
  }
}
