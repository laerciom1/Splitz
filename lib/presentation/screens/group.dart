import 'package:flutter/material.dart';
import 'package:splitz/data/models/splitwise/get_expenses/get_expenses_response.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/extensions/widgets.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/screens/group_config.dart';
import 'package:splitz/presentation/widgets/button_primary.dart';
import 'package:splitz/presentation/widgets/expense_item.dart';
import 'package:splitz/presentation/widgets/loading.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/log_service.dart';
import 'package:splitz/services/splitz_service.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({required this.groupId, super.key});

  final String groupId;

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<Expense>? expenses;
  GroupConfig? config;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    initGroup();
  }

  Future<void> initGroup() async {
    final result = await SplitzService.getGroupConfig(widget.groupId);
    if (result == null) {
      await AppNavigator.push(
        GroupConfigScreen(id: widget.groupId, config: null),
      );
    }
    await getExpenses();
  }

  Future<void> getExpenses({bool refreshing = false}) async {
    setState(() {
      expenses = null;
      isRefreshing = refreshing;
    });
    final result = await SplitzService.getExpenses(widget.groupId);
    if (result == null) {
      showToast(
        'Something went wrong retrieving your expenses. Drag down to refresh.',
      );
    } else {
      setState(() {
        expenses = result;
        isRefreshing = false;
      });
    }
  }

  void onTap(Expense expense) {
    LogService.log(expense.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: expenses != null
            ? RefreshIndicator(
                onRefresh: () => getExpenses(refreshing: true),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      PrimaryButton(
                        text: 'teste',
                        onPressed: initGroup,
                      ),
                      ...expenses!
                          .map<Widget>(
                            (e) => ExpenseItem(expense: e, onTap: onTap),
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
                  ).withPadding(const EdgeInsets.all(24)),
                ),
              )
            : isRefreshing
                ? const SizedBox()
                : const Loading(),
      ),
    );
  }
}
