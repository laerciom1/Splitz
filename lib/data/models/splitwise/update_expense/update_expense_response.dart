import 'package:splitz/data/models/splitwise/common/expense_basic.dart';

class UpdateExpenseResponse {
  final List<ExpenseBasic> expenses;

  UpdateExpenseResponse({required this.expenses});

  factory UpdateExpenseResponse.fromMap(Map<String, dynamic> json) =>
      UpdateExpenseResponse(
        expenses: json["expenses"] == null
            ? []
            : List<ExpenseBasic>.from(
                json["expenses"]!.map((x) => ExpenseBasic.fromMap(x)),
              ),
      );
}
