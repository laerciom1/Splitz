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

class FullExpense {
  final int id;
  final int groupId;
  final String cost;
  final String description;
  final String currencyCode;
  final bool payment;
  final DateTime date;
  final DateTime? deletedAt;
  final BasicCategory category;
  final List<UserElement> users;

  FullExpense({
    required this.id,
    required this.groupId,
    required this.cost,
    required this.description,
    required this.currencyCode,
    required this.payment,
    required this.date,
    required this.deletedAt,
    required this.category,
    required this.users,
  });

  factory FullExpense.fromMap(Map<String, dynamic> json) => FullExpense(
        id: json["id"],
        groupId: json["group_id"],
        cost: json["cost"],
        description: json["description"],
        currencyCode: json["currency_code"],
        payment: json["payment"] ?? false,
        date: DateTime.parse(json["date"]),
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]),
        category: BasicCategory.fromMap(json["category"]),
        users: json["users"] == null
            ? []
            : List<UserElement>.from(
                json["users"]!.map((x) => UserElement.fromMap(x))),
      );
}

class BasicCategory {
  final int id;

  BasicCategory({required this.id});

  factory BasicCategory.fromMap(Map<String, dynamic> json) =>
      BasicCategory(id: json["id"]);
}

class UserElement {
  final int userId;
  final User user;
  final String owedShare;
  final String paidShare;

  UserElement({
    required this.userId,
    required this.user,
    required this.paidShare,
    required this.owedShare,
  });

  factory UserElement.fromMap(Map<String, dynamic> json) => UserElement(
        user: User.fromMap(json["user"]),
        userId: json["user_id"],
        paidShare: json["paid_share"],
        owedShare: json["owed_share"],
      );
}

class User {
  final String firstName;

  User({required this.firstName});

  factory User.fromMap(Map<String, dynamic> json) =>
      User(firstName: json["first_name"]);
}
