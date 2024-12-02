import 'dart:async';
import 'package:flutter/material.dart';
import 'package:splitz/data/entities/external/expense_entity.dart';
import 'package:splitz/data/entities/external/group_entity.dart';
import 'package:splitz/data/entities/splitz/group_config_entity.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/screens/expense_editor.dart';
import 'package:splitz/presentation/screens/group_editor.dart';
import 'package:splitz/presentation/screens/groups_list.dart';
import 'package:splitz/presentation/widgets/fab_add_split.dart';
import 'package:splitz/presentation/widgets/expense_item.dart';
import 'package:splitz/presentation/widgets/feedback_message.dart';
import 'package:splitz/presentation/widgets/loading.dart';
import 'package:splitz/presentation/widgets/expenses_list_page_header.dart';
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
  GroupConfigEntity? _groupConfig;
  GroupEntity? _groupInfo;
  String _feedbackMessage = '';
  bool _isLoading = true;

  Future<void> Function()? _lastFunc;

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  void setData({
    List<ExpenseEntity>? expenses,
    GroupConfigEntity? groupConfig,
    GroupEntity? groupInfo,
    String feedbackMessage = '',
    bool isLoading = false,
  }) =>
      setState(() {
        _expenses = expenses;
        _groupConfig = groupConfig ?? _groupConfig;
        _groupInfo = groupInfo ?? _groupInfo;
        _feedbackMessage = feedbackMessage;
        _isLoading = isLoading;
      });

  int findIndex(ExpenseEntity expense) {
    final idx = _expenses!.indexWhere((e) => e == expense);
    if (idx == -1) {
      showToast("Something went wrong locating your expense");
    }
    return idx;
  }

  void updateExpense(int idx, ExpenseEntity expense) {
    final newList = [..._expenses!];
    newList[idx] = expense;
    setData(expenses: newList);
  }

  void deleteExpense(int idx) {
    final newList = [..._expenses!]..removeAt(idx);
    setData(expenses: newList);
  }

  Future<void> initScreen() async {
    _lastFunc = initScreen;
    setData(isLoading: true);
    late GroupConfigEntity? remoteGroupConfig;
    late GroupEntity remoteGroupInfo;
    try {
      final [config, info] = await Future.wait([
        SplitzService.getGroupConfig(widget.groupId),
        SplitzService.getGroupInfo(widget.groupId),
      ]);
      remoteGroupConfig = config as GroupConfigEntity?;
      remoteGroupInfo = info as GroupEntity;
    } catch (e, s) {
      const message =
          'Something went wrong retrieving your group preferences.\n'
          'You can drag down to retry.';
      return setData(feedbackMessage: message.addErrorDescription(e, s));
    }

    if (remoteGroupConfig == null) return editGroupPreferences();
    setData(groupConfig: remoteGroupConfig, groupInfo: remoteGroupInfo);
    return await getExpenses();
  }

  Future<void> getExpenses() async {
    _lastFunc = getExpenses;
    setData(isLoading: true);
    try {
      final expenses = await SplitzService.getExpenses(
        widget.groupId,
        _groupConfig!.splitzCategories,
      );
      setData(expenses: expenses);
    } catch (e, s) {
      const message = 'Something went wrong retrieving your expenses.\n'
          'Drag down to refresh.';
      return setData(feedbackMessage: message.addErrorDescription(e, s));
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
    setData(
      expenses: [
        expense.copyWith(state: ExpenseEntityState.loading),
        ..._expenses!
      ],
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

  void onPop() {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      AppNavigator.replaceAll([const GroupsListScreen()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => onPop(),
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: getFAB(),
        body: RefreshIndicator(
          onRefresh: () async => unawaited(_lastFunc?.call()),
          child: CustomScrollView(
            slivers: getSlivers(),
          ),
        ),
      ),
    );
  }

  List<Widget> getSlivers() => [
        if (_groupInfo != null)
          SliverPersistentHeader(
            pinned: true,
            delegate: ExpensesListPageHeader(
              groupInfo: _groupInfo!,
              scaffold: _scaffoldKey,
            ),
          ),
        SliverPadding(
          padding: EdgeInsets.only(
            top: _groupInfo!.simplifiedDebt == null ? 80 : 88,
          ),
        ),
        if (_isLoading) const SliverToBoxAdapter(child: Loading()),
        if (_feedbackMessage.isNotEmpty)
          SliverToBoxAdapter(child: FeedbackMessage(message: _feedbackMessage)),
        if (_expenses != null)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 24,
                  ),
                  child: ExpenseItem(
                    expense: _expenses![index],
                    onRetry: onRetry,
                    onCancel: onCancelEdit,
                    onDelete: onDelete,
                    onSelect: onEdit,
                  ),
                );
              },
              childCount: _expenses!.length,
            ),
          ),
      ];

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
}
