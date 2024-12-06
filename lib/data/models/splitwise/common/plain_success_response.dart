class PlainSuccessResponse {
  final bool? success;

  PlainSuccessResponse({required this.success});

  factory PlainSuccessResponse.fromMap(Map<String, dynamic> json) =>
      PlainSuccessResponse(success: json["success"]);
}
