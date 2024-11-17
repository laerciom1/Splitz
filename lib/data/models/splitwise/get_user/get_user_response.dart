import 'dart:convert';

class GetUserResponse {
    final User? user;

    GetUserResponse({
        this.user,
    });

    factory GetUserResponse.fromJson(String str) => GetUserResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetUserResponse.fromMap(Map<String, dynamic> json) => GetUserResponse(
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

    User({
        this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.registrationStatus,
        this.picture,
        this.customPicture,
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
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "registration_status": registrationStatus,
        "picture": picture?.toMap(),
        "custom_picture": customPicture,
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
