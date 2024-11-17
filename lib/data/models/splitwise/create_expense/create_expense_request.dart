import 'dart:convert';

class CreateExpenseRequest {
    final String? cost;
    final String? description;
    final String? details;
    final DateTime? date;
    final String? repeatInterval;
    final String? currencyCode;
    final int? categoryId;
    final int? groupId;
    final bool? splitEqually;

    CreateExpenseRequest({
        this.cost,
        this.description,
        this.details,
        this.date,
        this.repeatInterval,
        this.currencyCode,
        this.categoryId,
        this.groupId,
        this.splitEqually,
    });

    factory CreateExpenseRequest.fromJson(String str) => CreateExpenseRequest.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CreateExpenseRequest.fromMap(Map<String, dynamic> json) => CreateExpenseRequest(
        cost: json["cost"],
        description: json["description"],
        details: json["details"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        repeatInterval: json["repeat_interval"],
        currencyCode: json["currency_code"],
        categoryId: json["category_id"],
        groupId: json["group_id"],
        splitEqually: json["split_equally"],
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
        "split_equally": splitEqually,
    };
}
