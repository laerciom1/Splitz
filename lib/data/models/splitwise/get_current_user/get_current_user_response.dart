class GetCurrentUserResponse {
  final User user;

  GetCurrentUserResponse({required this.user});

  factory GetCurrentUserResponse.fromMap(Map json) => GetCurrentUserResponse(user: User.fromMap(json["user"]));
}

class User {
  final int id;

  User({required this.id});

  factory User.fromMap(Map json) => User(id: json["id"]);
}
