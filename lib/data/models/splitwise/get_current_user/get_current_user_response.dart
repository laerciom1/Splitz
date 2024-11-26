class GetCurrentUserResponse {
  final User user;

  GetCurrentUserResponse({required this.user});

  factory GetCurrentUserResponse.fromMap(Map<String, dynamic> json) =>
      GetCurrentUserResponse(user: User.fromMap(json["user"]));
}

class User {
  final int id;

  User({required this.id});

  factory User.fromMap(Map<String, dynamic> json) => User(id: json["id"]);
}
