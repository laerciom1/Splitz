import 'dart:convert';

class GetGroupsResponse {
    final List<Group>? groups;

    GetGroupsResponse({
        this.groups,
    });

    factory GetGroupsResponse.fromJson(String str) => GetGroupsResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetGroupsResponse.fromMap(Map<String, dynamic> json) => GetGroupsResponse(
        groups: json["groups"] == null ? [] : List<Group>.from(json["groups"]!.map((x) => Group.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "groups": groups == null ? [] : List<dynamic>.from(groups!.map((x) => x.toMap())),
    };
}

class Group {
    final int? id;
    final String? name;
    final String? groupType;
    final DateTime? updatedAt;
    final bool? simplifyByDefault;
    final List<Member>? members;
    final List<Debt>? originalDebts;
    final List<Debt>? simplifiedDebts;
    final Avatar? avatar;
    final bool? customAvatar;
    final CoverPhoto? coverPhoto;
    final String? inviteLink;

    Group({
        this.id,
        this.name,
        this.groupType,
        this.updatedAt,
        this.simplifyByDefault,
        this.members,
        this.originalDebts,
        this.simplifiedDebts,
        this.avatar,
        this.customAvatar,
        this.coverPhoto,
        this.inviteLink,
    });

    factory Group.fromJson(String str) => Group.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Group.fromMap(Map<String, dynamic> json) => Group(
        id: json["id"],
        name: json["name"],
        groupType: json["group_type"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        simplifyByDefault: json["simplify_by_default"],
        members: json["members"] == null ? [] : List<Member>.from(json["members"]!.map((x) => Member.fromMap(x))),
        originalDebts: json["original_debts"] == null ? [] : List<Debt>.from(json["original_debts"]!.map((x) => Debt.fromMap(x))),
        simplifiedDebts: json["simplified_debts"] == null ? [] : List<Debt>.from(json["simplified_debts"]!.map((x) => Debt.fromMap(x))),
        avatar: json["avatar"] == null ? null : Avatar.fromMap(json["avatar"]),
        customAvatar: json["custom_avatar"],
        coverPhoto: json["cover_photo"] == null ? null : CoverPhoto.fromMap(json["cover_photo"]),
        inviteLink: json["invite_link"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "group_type": groupType,
        "updated_at": updatedAt?.toIso8601String(),
        "simplify_by_default": simplifyByDefault,
        "members": members == null ? [] : List<dynamic>.from(members!.map((x) => x.toMap())),
        "original_debts": originalDebts == null ? [] : List<dynamic>.from(originalDebts!.map((x) => x.toMap())),
        "simplified_debts": simplifiedDebts == null ? [] : List<dynamic>.from(simplifiedDebts!.map((x) => x.toMap())),
        "avatar": avatar?.toMap(),
        "custom_avatar": customAvatar,
        "cover_photo": coverPhoto?.toMap(),
        "invite_link": inviteLink,
    };
}

class Avatar {
    final dynamic original;
    final String? xxlarge;
    final String? xlarge;
    final String? large;
    final String? medium;
    final String? small;

    Avatar({
        this.original,
        this.xxlarge,
        this.xlarge,
        this.large,
        this.medium,
        this.small,
    });

    factory Avatar.fromJson(String str) => Avatar.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Avatar.fromMap(Map<String, dynamic> json) => Avatar(
        original: json["original"],
        xxlarge: json["xxlarge"],
        xlarge: json["xlarge"],
        large: json["large"],
        medium: json["medium"],
        small: json["small"],
    );

    Map<String, dynamic> toMap() => {
        "original": original,
        "xxlarge": xxlarge,
        "xlarge": xlarge,
        "large": large,
        "medium": medium,
        "small": small,
    };
}

class CoverPhoto {
    final String? xxlarge;
    final String? xlarge;

    CoverPhoto({
        this.xxlarge,
        this.xlarge,
    });

    factory CoverPhoto.fromJson(String str) => CoverPhoto.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CoverPhoto.fromMap(Map<String, dynamic> json) => CoverPhoto(
        xxlarge: json["xxlarge"],
        xlarge: json["xlarge"],
    );

    Map<String, dynamic> toMap() => {
        "xxlarge": xxlarge,
        "xlarge": xlarge,
    };
}

class Member {
    final int? id;
    final String? firstName;
    final String? lastName;
    final String? email;
    final String? registrationStatus;
    final Picture? picture;
    final bool? customPicture;
    final List<Balance>? balance;

    Member({
        this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.registrationStatus,
        this.picture,
        this.customPicture,
        this.balance,
    });

    factory Member.fromJson(String str) => Member.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Member.fromMap(Map<String, dynamic> json) => Member(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        registrationStatus: json["registration_status"],
        picture: json["picture"] == null ? null : Picture.fromMap(json["picture"]),
        customPicture: json["custom_picture"],
        balance: json["balance"] == null ? [] : List<Balance>.from(json["balance"]!.map((x) => Balance.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "registration_status": registrationStatus,
        "picture": picture?.toMap(),
        "custom_picture": customPicture,
        "balance": balance == null ? [] : List<dynamic>.from(balance!.map((x) => x.toMap())),
    };
}

class Balance {
    final String? currencyCode;
    final String? amount;

    Balance({
        this.currencyCode,
        this.amount,
    });

    factory Balance.fromJson(String str) => Balance.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Balance.fromMap(Map<String, dynamic> json) => Balance(
        currencyCode: json["currency_code"],
        amount: json["amount"],
    );

    Map<String, dynamic> toMap() => {
        "currency_code": currencyCode,
        "amount": amount,
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

class Debt {
    final int? from;
    final int? to;
    final String? amount;
    final String? currencyCode;

    Debt({
        this.from,
        this.to,
        this.amount,
        this.currencyCode,
    });

    factory Debt.fromJson(String str) => Debt.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Debt.fromMap(Map<String, dynamic> json) => Debt(
        from: json["from"],
        to: json["to"],
        amount: json["amount"],
        currencyCode: json["currency_code"],
    );

    Map<String, dynamic> toMap() => {
        "from": from,
        "to": to,
        "amount": amount,
        "currency_code": currencyCode,
    };
}
