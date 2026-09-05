class PlainSuccessResponse {
  final bool? success;

  PlainSuccessResponse({required this.success});

  factory PlainSuccessResponse.fromMap(Map json) => PlainSuccessResponse(success: json["success"]);
}
