import 'dart:convert';

class DeleteExpenseResponse {
    final bool? success;

    DeleteExpenseResponse({
        this.success,
    });

    factory DeleteExpenseResponse.fromJson(String str) => DeleteExpenseResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DeleteExpenseResponse.fromMap(Map<String, dynamic> json) => DeleteExpenseResponse(
        success: json["success"],
    );

    Map<String, dynamic> toMap() => {
        "success": success,
    };
}
