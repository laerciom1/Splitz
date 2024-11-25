import 'dart:async';
import 'package:flutter/material.dart';
import 'package:splitz/data/entities/expense_entity.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/screens/expense_editor.dart';
import 'package:splitz/presentation/screens/group_editor.dart';
import 'package:splitz/presentation/screens/groups_list.dart';
import 'package:splitz/presentation/templates/base_screen.dart';
import 'package:splitz/presentation/widgets/fab_add_split.dart';
import 'package:splitz/presentation/widgets/expense_item.dart';
import 'package:splitz/presentation/widgets/feedback_message.dart';
import 'package:splitz/presentation/widgets/loading.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/splitz_service.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ExpensesListScreen extends StatefulWidget {
  const ExpensesListScreen({required this.groupId, super.key});

  final String groupId;

  @override
  State<ExpensesListScreen> createState() => _ExpensesListScreenState();
}

class _ExpensesListScreenState extends State<ExpensesListScreen> {
  List<ExpenseEntity>? _expenses;
  GroupConfig? _groupConfig;
  String _feedbackMessage = '';
  bool _isLoading = true;

  Future<void> Function()? _lastFunc;

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  void setFeedback(String message) => setState(() {
        _isLoading = false;
        _expenses = null;
        _groupConfig = null;
        _feedbackMessage = message;
      });

  void setLoading() => setState(() {
        _isLoading = true;
        _expenses = null;
        _groupConfig = null;
        _feedbackMessage = '';
      });

  void setInitData(List<ExpenseEntity> expenses, GroupConfig groupConfig) =>
      setState(() {
        _isLoading = false;
        _expenses = expenses;
        _groupConfig = groupConfig;
        _feedbackMessage = '';
      });

  int findIndex(ExpenseEntity expense) {
    final idx = _expenses!.indexWhere((e) => e == expense);
    if (idx == -1) {
      showToast("Something went wrong locating your expense");
    }
    return idx;
  }

  void updateExpenses(List<ExpenseEntity> expenses) => setState(() {
        _expenses = expenses;
      });

  void updateExpense(int idx, ExpenseEntity expense) {
    final newList = [..._expenses!];
    newList[idx] = expense;
    updateExpenses(newList);
  }

  void deleteExpense(int idx) {
    final newList = [..._expenses!]..removeAt(idx);
    updateExpenses(newList);
  }

  Future<void> initScreen() async {
    _lastFunc = initScreen;
    setLoading();
    GroupConfig? remoteGroupConfig;
    try {
      remoteGroupConfig = await SplitzService.getGroupConfig(widget.groupId);
    } catch (e, s) {
      const message =
          'Something went wrong retrieving your group preferences.\n'
          'You can drag down to refresh.';
      return setFeedback(message.addErrorDescription(e, s));
    }

    if (remoteGroupConfig == null) return editGroupPreferences();
    return await getExpenses(remoteGroupConfig);
  }

  Future<void> getExpenses(GroupConfig groupConfig) async {
    _lastFunc = () => getExpenses(groupConfig);
    setLoading();
    try {
      final expenses = await SplitzService.getExpenses(
        widget.groupId,
        groupConfig.splitzCategories,
      );
      setInitData(expenses, groupConfig);
    } catch (e, s) {
      const message = 'Something went wrong retrieving your expenses.\n'
          'Drag down to refresh.';
      return setFeedback(message.addErrorDescription(e, s));
    }
  }

  Future<void> onCreate(SplitzCategory category) async {
    final expense = await AppNavigator.push<ExpenseEntity?>(
      ExpenseEditorScreen(
        category: category,
        groupConfig: _groupConfig!,
        groupId: widget.groupId,
      ),
    );
    if (expense == null) return;
    updateExpenses(
      [expense.copyWith(state: ExpenseEntityState.loading), ..._expenses!],
    );
    await onRetryCreate(expense, 0);
  }

  Future<void> onRetryCreate(ExpenseEntity expense, int idx) async {
    try {
      final id = await SplitzService.createExpense(expense);
      updateExpense(
        idx,
        expense.copyWith(id: id, state: ExpenseEntityState.listed),
      );
    } catch (_) {
      updateExpense(0, expense.copyWith(state: ExpenseEntityState.createError));
    }
  }

  Future<void> onEdit(ExpenseEntity expenseToEdit) async {
    final idx = findIndex(expenseToEdit);
    if (idx == -1) return;
    final category = _groupConfig!.splitzCategories[expenseToEdit.prefix];
    if (category == null) {
      showToast(
        "You can't edit an expense of a category that doesn't exist on your group preferences anymore",
      );
      return;
    }
    final expense = await AppNavigator.push<ExpenseEntity?>(
      ExpenseEditorScreen(
        category: category,
        groupConfig: _groupConfig!,
        groupId: widget.groupId,
        expense: expenseToEdit,
      ),
    );
    if (expense == null) return;
    await onRetryEdit(expenseToEdit, idx, expense);
  }

  Future<void> onRetryEdit(
    ExpenseEntity expenseToEdit,
    int idx, [
    ExpenseEntity? newVersion,
  ]) async {
    final finalExpense = newVersion != null
        ? expenseToEdit.copyWithBackup(
            state: ExpenseEntityState.loading,
            newVersion: newVersion,
          )
        : expenseToEdit.copyWith(state: ExpenseEntityState.loading);
    try {
      updateExpense(idx, finalExpense);
      final id = await SplitzService.updateExpense(finalExpense);
      updateExpense(
        idx,
        finalExpense.copyWith(id: id, state: ExpenseEntityState.listed),
      );
    } catch (_) {
      updateExpense(
        idx,
        finalExpense.copyWith(state: ExpenseEntityState.editError),
      );
    }
  }

  Future<bool> onDelete(ExpenseEntity expense) async {
    try {
      final idx = findIndex(expense);
      if (idx == -1) return false;
      if (expense.state == ExpenseEntityState.listed) {
        await SplitzService.deleteExpense(expense);
      }
      deleteExpense(idx);
      return true;
    } catch (_) {
      showToast(
        'Something went wrong deleting the expense. You can retry later',
      );
      return false;
    }
  }

  Future<bool> onCancelEdit(ExpenseEntity expense) async {
    final idx = findIndex(expense);
    if (idx == -1) return false;
    if (expense.backup == null) {
      showToast("This expense doesn't have an associated backup");
      updateExpense(
        idx,
        expense.copyWith(state: ExpenseEntityState.listed),
      );
      return false;
    }
    updateExpense(
      idx,
      expense.backup!.copyWith(state: ExpenseEntityState.listed),
    );
    return false;
  }

  Future<bool> onRetry(ExpenseEntity expense) async {
    final idx = findIndex(expense);
    if (idx == -1) return false;
    updateExpense(
      idx,
      expense.copyWith(state: ExpenseEntityState.loading),
    );
    if (expense.state == ExpenseEntityState.createError) {
      await onRetryCreate(expense, idx);
    }
    if (expense.state == ExpenseEntityState.editError) {
      await onRetryEdit(expense, idx);
    }
    return false;
  }

  void editGroupPreferences() =>
      AppNavigator.replaceAll([GroupEditorScreen(groupId: widget.groupId)]);

  Widget getBody() {
    if (_isLoading) {
      return const Loading();
    }

    if (_feedbackMessage.isNotEmpty) {
      return FeedbackMessage(message: _feedbackMessage);
    }

    return getExpensesWidget();
  }

  Widget getExpensesWidget() => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Use swipe and click to interact with expenses'),
            const SizedBox(height: 24),
            ..._expenses!
                .map<Widget>((e) => ExpenseItem(
                      expense: e,
                      onRetry: onRetry,
                      onCancel: onCancelEdit,
                      onDelete: onDelete,
                      onSelect: onEdit,
                    ))
                .intersperse(const SizedBox(height: 12))
          ],
        ),
      );

  Widget? getFAB() {
    if (_groupConfig == null || _isLoading || _feedbackMessage.isNotEmpty) {
      return null;
    }
    return AddSplitFAB(
      categories: _groupConfig!.splitzCategories,
      onSelectCategory: onCreate,
      onEditGroupPreferences: editGroupPreferences,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      onPop: (_, __) async {
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          _scaffoldKey.currentState?.openEndDrawer();
        } else {
          AppNavigator.replaceAll([const GroupsListScreen()]);
        }
      },
      scaffoldKey: _scaffoldKey,
      onRefresh: _lastFunc,
      floatingActionButton: getFAB(),
      child: getBody(),
    );
  }
}
