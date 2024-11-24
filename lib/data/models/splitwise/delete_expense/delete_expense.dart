class DeleteExpenseResponse {
  bool? success;

  DeleteExpenseResponse({this.success});

  factory DeleteExpenseResponse.fromMap(Map<String, dynamic> json) =>
      DeleteExpenseResponse(
        success: json["success"],
      );
}
