import 'package:splitz/data/models/splitwise/common/expense_basic.dart';

class CreateExpenseResponse {
  final List<ExpenseBasic> expenses;

  CreateExpenseResponse({required this.expenses});

  factory CreateExpenseResponse.fromMap(Map<String, dynamic> json) =>
      CreateExpenseResponse(
        expenses: json["expenses"] == null
            ? []
            : List<ExpenseBasic>.from(
                json["expenses"]!.map((x) => ExpenseBasic.fromMap(x)),
              ),
      );
}
