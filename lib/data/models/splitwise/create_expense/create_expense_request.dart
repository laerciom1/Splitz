import 'package:splitz/data/entities/expense_entity.dart';

abstract class CreateExpenseRequest {
  static Map<String, dynamic> createBody(
    ExpenseEntity expense,
  ) {
    final Map<String, dynamic> request = {
      "cost": expense.cost,
      "description": expense.description,
      "date": expense.date.toIso8601String(),
      "currency_code": expense.currencyCode,
      "category_id": expense.categoryId,
      "group_id": expense.groupId,
    };

    final entries = expense.users.asMap().entries.fold(
        <MapEntry<String, dynamic>>[],
        (accu, curr) => [
              ...accu,
              ...[
                MapEntry(
                  "users__${curr.key}__user_id",
                  curr.value.userId,
                ),
                MapEntry(
                  "users__${curr.key}__paid_share",
                  curr.value.paidShare,
                ),
                MapEntry(
                  "users__${curr.key}__owed_share",
                  curr.value.owedShare,
                ),
              ]
            ]);

    request.addEntries(entries);

    return request;
  }
}
