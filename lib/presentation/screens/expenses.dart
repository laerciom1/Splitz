import 'package:flutter/material.dart';
import 'package:splitz/data/entities/expense_entity.dart';
import 'package:splitz/data/models/splitwise/get_expenses/get_expenses_response.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/screens/group_config.dart';
import 'package:splitz/presentation/widgets/add_split_fab.dart';
import 'package:splitz/presentation/widgets/expense_item.dart';
import 'package:splitz/presentation/widgets/loading.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/splitz_service.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({required this.groupId, super.key});

  final String groupId;

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List<Expense>? _expenses;
  GroupConfig? _config;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    initGroup();
  }

  Future<void> initGroup() async {
    final remoteResult = await SplitzService.getGroupConfig(widget.groupId);
    // TODO: Handle errors
    if (remoteResult != null) return await getExpenses(config: remoteResult);
    return await editGroupPreferences(null);
  }

  Future<void> getExpenses({
    bool refreshing = false,
    GroupConfig? config,
  }) async {
    setState(() {
      _expenses = null;
      _isRefreshing = refreshing;
      _config = config ?? _config;
    });
    final result = await SplitzService.getExpenses(
      widget.groupId,
      _config!.categories,
    );
    // TODO: Handle errors
    if (result == null) {
      showToast(
        'Something went wrong retrieving your expenses. Drag down to refresh.',
      );
    } else {
      setState(() {
        _expenses = result;
        _isRefreshing = false;
      });
    }
  }

  void onNewExpense(SplitzCategory category) {}

  Future<void> editGroupPreferences(GroupConfig? config) async {
    final result = await AppNavigator.push<GroupConfig>(
      GroupConfigScreen(id: widget.groupId, config: config),
    );
    getExpenses(config: result);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: _config != null
            ? AddSplitFAB(
                categories: _config!.categories,
                onSelectCategory: onNewExpense,
                onEditGroupPreferences: () => editGroupPreferences(_config),
              )
            : null,
        body: _expenses != null
            ? RefreshIndicator(
                onRefresh: () => getExpenses(refreshing: true),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        ..._expenses!
                            .map<Widget>(
                              (e) => ExpenseItem(
                                expense: ExpenseEntity.fromExpenseResponse(e),
                                categoryPicUrl:
                                    'https://s3.amazonaws.com/splitwise/uploads/category/icon/square/utilities/cleaning.png',
                              ),
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
                  ),
                ),
              )
            : _isRefreshing
                ? const SizedBox()
                : const Loading(),
      ),
    );
  }
}
