import 'dart:convert';

class GetCurrentUserResponse {
    final User? user;

    GetCurrentUserResponse({
        this.user,
    });

    factory GetCurrentUserResponse.fromJson(String str) => GetCurrentUserResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetCurrentUserResponse.fromMap(Map<String, dynamic> json) => GetCurrentUserResponse(
        user: json["user"] == null ? null : User.fromMap(json["user"]),
    );

    Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
    };
}

class User {
    final int? id;
    final String? firstName;
    final String? lastName;
    final String? email;
    final String? registrationStatus;
    final Picture? picture;
    final bool? customPicture;
    final DateTime? notificationsRead;
    final int? notificationsCount;
    final Notifications? notifications;
    final String? defaultCurrency;
    final String? locale;

    User({
        this.id,
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

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        registrationStatus: json["registration_status"],
        picture: json["picture"] == null ? null : Picture.fromMap(json["picture"]),
        customPicture: json["custom_picture"],
        notificationsRead: json["notifications_read"] == null ? null : DateTime.parse(json["notifications_read"]),
        notificationsCount: json["notifications_count"],
        notifications: json["notifications"] == null ? null : Notifications.fromMap(json["notifications"]),
        defaultCurrency: json["default_currency"],
        locale: json["locale"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "registration_status": registrationStatus,
        "picture": picture?.toMap(),
        "custom_picture": customPicture,
        "notifications_read": notificationsRead?.toIso8601String(),
        "notifications_count": notificationsCount,
        "notifications": notifications?.toMap(),
        "default_currency": defaultCurrency,
        "locale": locale,
    };
}

class Notifications {
    final bool? addedAsFriend;

    Notifications({
        this.addedAsFriend,
    });

    factory Notifications.fromJson(String str) => Notifications.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Notifications.fromMap(Map<String, dynamic> json) => Notifications(
        addedAsFriend: json["added_as_friend"],
    );

    Map<String, dynamic> toMap() => {
        "added_as_friend": addedAsFriend,
    };
}

class Picture {
    final String? small;
    final String? medium;
    final String? large;

    Picture({
        this.small,
        this.medium,
        this.large,
    });

    factory Picture.fromJson(String str) => Picture.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Picture.fromMap(Map<String, dynamic> json) => Picture(
        small: json["small"],
        medium: json["medium"],
        large: json["large"],
    );

    Map<String, dynamic> toMap() => {
        "small": small,
        "medium": medium,
        "large": large,
    };
}
