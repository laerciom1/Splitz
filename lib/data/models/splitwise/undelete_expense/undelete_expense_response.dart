import 'dart:convert';

class UndeleteExpenseResponse {
    final bool? success;

    UndeleteExpenseResponse({
        this.success,
    });

    factory UndeleteExpenseResponse.fromJson(String str) => UndeleteExpenseResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UndeleteExpenseResponse.fromMap(Map<String, dynamic> json) => UndeleteExpenseResponse(
        success: json["success"],
    );

    Map<String, dynamic> toMap() => {
        "success": success,
    };
}
