import 'package:splitz/data/models/splitwise/common/expense_full.dart';

class GetExpensesResponse {
  final List<FullExpense> expenses;

  GetExpensesResponse({required this.expenses});

  factory GetExpensesResponse.fromMap(Map<String, dynamic> json) =>
      GetExpensesResponse(
        expenses: json["expenses"] == null
            ? []
            : List<FullExpense>.from(
                json["expenses"]!.map((x) => FullExpense.fromMap(x)),
              ),
      );
}