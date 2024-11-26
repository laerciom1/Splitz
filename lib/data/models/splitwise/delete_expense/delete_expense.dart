class DeleteExpenseResponse {
  final bool? success;

  DeleteExpenseResponse({required this.success});

  factory DeleteExpenseResponse.fromMap(Map<String, dynamic> json) =>
      DeleteExpenseResponse(success: json["success"]);
}
