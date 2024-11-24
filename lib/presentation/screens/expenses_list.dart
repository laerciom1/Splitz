import 'package:flutter/material.dart';
import 'package:splitz/data/entities/expense_entity.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/screens/group_editor.dart';
import 'package:splitz/presentation/templates/base_screen.dart';
import 'package:splitz/presentation/widgets/fab_add_split.dart';
import 'package:splitz/presentation/widgets/expense_item.dart';
import 'package:splitz/presentation/widgets/feedback_message.dart';
import 'package:splitz/presentation/widgets/loading.dart';
import 'package:splitz/services/splitz_service.dart';

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

  void setFeedback(String message) {
    setState(() {
      _isLoading = false;
      _expenses = null;
      _groupConfig = null;
      _feedbackMessage = message;
    });
  }

  void setLoading() {
    setState(() {
      _isLoading = true;
      _expenses = null;
      _groupConfig = null;
      _feedbackMessage = '';
    });
  }

  void setData(List<ExpenseEntity> newExpenses, GroupConfig newGroupConfig) {
    setState(() {
      _isLoading = false;
      _expenses = newExpenses;
      _groupConfig = newGroupConfig;
      _feedbackMessage = '';
    });
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

  Future<void> getExpenses(GroupConfig newGroupConfig) async {
    _lastFunc = () => getExpenses(newGroupConfig);
    setLoading();
    try {
      final newExpenses = await SplitzService.getExpenses(
        widget.groupId,
        newGroupConfig.categories,
      );
      setData(newExpenses, newGroupConfig);
    } catch (e, s) {
      const message = 'Something went wrong retrieving your expenses.\n'
          'Drag down to refresh.';
      return setFeedback(message.addErrorDescription(e, s));
    }
  }

  void onNewExpense(SplitzCategory category) async {}

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
          children: [
            ..._expenses!
                .map<Widget>(
                  (e) => ExpenseItem(expense: e),
                )
                .intersperse(
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Divider(
                      height: 1,
                      indent: 24,
                      endIndent: 24,
                    ),
                  ),
                )
          ],
        ),
      );

  Widget? getFAB() {
    if (_groupConfig == null || _isLoading || _feedbackMessage.isNotEmpty) {
      return null;
    }
    return AddSplitFAB(
      categories: _groupConfig!.categories,
      onSelectCategory: onNewExpense,
      onEditGroupPreferences: editGroupPreferences,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      onRefresh: _lastFunc,
      floatingActionButton: getFAB(),
      child: getBody(),
    );
  }
}
