import 'dart:convert';

class GetCurrentUserResponse {
  User user;

  GetCurrentUserResponse({required this.user});

  factory GetCurrentUserResponse.fromMap(Map<String, dynamic> json) =>
      GetCurrentUserResponse(user: User.fromMap(json["user"]));
}

class User {
  int id;
  String? firstName;
  String? lastName;
  String? email;
  String? registrationStatus;
  Picture? picture;
  bool? customPicture;
  DateTime? notificationsRead;
  int? notificationsCount;
  Notifications? notifications;
  String? defaultCurrency;
  String? locale;

  User({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.registrationStatus,
    this.picture,
    this.customPicture,
    this.notificationsRead,
    this.notificationsCount,
    this.notifications,
    this.defaultCurrency,
    this.locale,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        registrationStatus: json["registration_status"],
        picture:
            json["picture"] == null ? null : Picture.fromMap(json["picture"]),
        customPicture: json["custom_picture"],
        notificationsRead: json["notifications_read"] == null
            ? null
            : DateTime.parse(json["notifications_read"]),
        notificationsCount: json["notifications_count"],
        notifications: json["notifications"] == null
            ? null
            : Notifications.fromMap(json["notifications"]),
        defaultCurrency: json["default_currency"],
        locale: json["locale"],
      );
}

class Notifications {
  bool? addedAsFriend;

  Notifications({
    this.addedAsFriend,
  });

  Notifications copyWith({
    bool? addedAsFriend,
  }) =>
      Notifications(
        addedAsFriend: addedAsFriend ?? this.addedAsFriend,
      );

  factory Notifications.fromJson(String str) =>
      Notifications.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Notifications.fromMap(Map<String, dynamic> json) => Notifications(
        addedAsFriend: json["added_as_friend"],
      );

  Map<String, dynamic> toMap() => {
        "added_as_friend": addedAsFriend,
      };
}

class Picture {
  String? small;
  String? medium;
  String? large;

  Picture({
    this.small,
    this.medium,
    this.large,
  });

  factory Picture.fromMap(Map<String, dynamic> json) => Picture(
        small: json["small"],
        medium: json["medium"],
        large: json["large"],
      );
}

/* Example
{
  "user": {
    "id": 0,
    "first_name": "Ada",
    "last_name": "Lovelace",
    "email": "ada@example.com",
    "registration_status": "confirmed",
    "picture": {
      "small": "string",
      "medium": "string",
      "large": "string"
    },
    "custom_picture": false,
    "notifications_read": "2017-06-02T20:21:57Z",
    "notifications_count": 12,
    "notifications": {
      "added_as_friend": true
    },
    "default_currency": "USD",
    "locale": "en"
  }
}
*/