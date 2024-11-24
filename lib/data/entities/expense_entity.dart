import 'package:splitz/data/models/splitwise/get_expenses/get_expenses_response.dart';

class ExpenseEntity {
  int id;
  String cost;
  String description;
  DateTime date;
  String currencyCode;
  int groupId;
  List<UserExpenseEntity> users;
  int categoryId;
  String imageUrl;

  ExpenseEntity({
    required this.id,
    required this.cost,
    required this.description,
    required this.date,
    required this.currencyCode,
    required this.groupId,
    required this.users,
    required this.categoryId,
    required this.imageUrl,
  });

  factory ExpenseEntity.fromExpenseResponse(Expense e, String imageUrl) =>
      ExpenseEntity(
        id: e.id,
        cost: e.cost,
        description: e.description,
        date: e.date,
        currencyCode: e.currencyCode,
        groupId: e.groupId,
        categoryId: e.category.id,
        imageUrl: imageUrl,
        users: [
          ...e.users.map(
            (e) => UserExpenseEntity.fromUserElementResponse(e),
          )
        ],
      );
}

class UserExpenseEntity {
  String firstName;
  int userId;
  String owedShare;

  UserExpenseEntity({
    required this.firstName,
    required this.userId,
    required this.owedShare,
  });

  factory UserExpenseEntity.fromUserElementResponse(UserElement e) =>
      UserExpenseEntity(
        firstName: e.user.firstName,
        userId: e.userId,
        owedShare: e.owedShare,
      );
}
