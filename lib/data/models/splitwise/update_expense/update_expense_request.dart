import 'dart:convert';

class UpdateExpenseRequest {
    final String? cost;
    final String? description;
    final String? details;
    final DateTime? date;
    final String? repeatInterval;
    final String? currencyCode;
    final int? categoryId;
    final int? groupId;
    final int? users0UserId;
    final String? users0PaidShare;
    final String? users0OwedShare;
    final String? users1FirstName;
    final String? users1LastName;
    final String? users1Email;
    final String? users1PaidShare;
    final String? users1OwedShare;
    final String? usersIndexProperty1;
    final String? usersIndexProperty2;

    UpdateExpenseRequest({
        this.cost,
        this.description,
        this.details,
        this.date,
        this.repeatInterval,
        this.currencyCode,
        this.categoryId,
        this.groupId,
        this.users0UserId,
        this.users0PaidShare,
        this.users0OwedShare,
        this.users1FirstName,
        this.users1LastName,
        this.users1Email,
        this.users1PaidShare,
        this.users1OwedShare,
        this.usersIndexProperty1,
        this.usersIndexProperty2,
    });

    factory UpdateExpenseRequest.fromJson(String str) => UpdateExpenseRequest.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UpdateExpenseRequest.fromMap(Map<String, dynamic> json) => UpdateExpenseRequest(
        cost: json["cost"],
        description: json["description"],
        details: json["details"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        repeatInterval: json["repeat_interval"],
        currencyCode: json["currency_code"],
        categoryId: json["category_id"],
        groupId: json["group_id"],
        users0UserId: json["users__0__user_id"],
        users0PaidShare: json["users__0__paid_share"],
        users0OwedShare: json["users__0__owed_share"],
        users1FirstName: json["users__1__first_name"],
        users1LastName: json["users__1__last_name"],
        users1Email: json["users__1__email"],
        users1PaidShare: json["users__1__paid_share"],
        users1OwedShare: json["users__1__owed_share"],
        usersIndexProperty1: json["users__{index}__{property}1"],
        usersIndexProperty2: json["users__{index}__{property}2"],
    );

    Map<String, dynamic> toMap() => {
        "cost": cost,
        "description": description,
        "details": details,
        "date": date?.toIso8601String(),
        "repeat_interval": repeatInterval,
        "currency_code": currencyCode,
        "category_id": categoryId,
        "group_id": groupId,
        "users__0__user_id": users0UserId,
        "users__0__paid_share": users0PaidShare,
        "users__0__owed_share": users0OwedShare,
        "users__1__first_name": users1FirstName,
        "users__1__last_name": users1LastName,
        "users__1__email": users1Email,
        "users__1__paid_share": users1PaidShare,
        "users__1__owed_share": users1OwedShare,
        "users__{index}__{property}1": usersIndexProperty1,
        "users__{index}__{property}2": usersIndexProperty2,
    };
}
