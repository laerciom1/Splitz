import 'package:flutter/material.dart';
import 'package:splitz/data/models/splitwise/get_expenses/get_expenses_response.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/extensions/widgets.dart';
import 'package:splitz/presentation/widgets/expense_item.dart';
import 'package:splitz/presentation/widgets/loading.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/splitz_service.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({required this.groupId, super.key});

  final String groupId;

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<Expense>? expenses;
  @override
  void initState() {
    super.initState();
    getExpenses();
  }

  Future<void> getExpenses() async {
    final result = await SplitzService.getExpenses(widget.groupId);
    if (result == null) {
      showToast(
        'Something went wrong retrieving your expenses. Drag down to refresh.',
      );
    } else {
      setState(() {
        expenses = result;
      });
    }
  }

  void onTap(Expense expense) {
    print(expense.description);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: expenses == null
            ? const Loading()
            : RefreshIndicator(
                onRefresh: getExpenses,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: expenses!
                        .map<Widget>(
                          (e) => ExpenseItem(expense: e, onTap: onTap),
                        )
                        .intersperse(const SizedBox(height: 12))
                        .toList(),
                  ).withPadding(const EdgeInsets.all(24)),
                ),
              ),
      ),
    );
  }
}
