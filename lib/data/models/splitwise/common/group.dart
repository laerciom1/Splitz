import 'dart:convert';

class Group {
  int? id;
  String? name;
  String? groupType;
  DateTime? updatedAt;
  bool? simplifyByDefault;
  List<Member>? members;
  List<Debt>? originalDebts;
  List<Debt>? simplifiedDebts;
  Avatar? avatar;
  bool? customAvatar;
  CoverPhoto? coverPhoto;
  String? inviteLink;

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

  Group copyWith({
    int? id,
    String? name,
    String? groupType,
    DateTime? updatedAt,
    bool? simplifyByDefault,
    List<Member>? members,
    List<Debt>? originalDebts,
    List<Debt>? simplifiedDebts,
    Avatar? avatar,
    bool? customAvatar,
    CoverPhoto? coverPhoto,
    String? inviteLink,
  }) =>
      Group(
        id: id ?? this.id,
        name: name ?? this.name,
        groupType: groupType ?? this.groupType,
        updatedAt: updatedAt ?? this.updatedAt,
        simplifyByDefault: simplifyByDefault ?? this.simplifyByDefault,
        members: members ?? this.members,
        originalDebts: originalDebts ?? this.originalDebts,
        simplifiedDebts: simplifiedDebts ?? this.simplifiedDebts,
        avatar: avatar ?? this.avatar,
        customAvatar: customAvatar ?? this.customAvatar,
        coverPhoto: coverPhoto ?? this.coverPhoto,
        inviteLink: inviteLink ?? this.inviteLink,
      );

  factory Group.fromJson(String str) => Group.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Group.fromMap(Map<String, dynamic> json) => Group(
        id: json["id"],
        name: json["name"],
        groupType: json["group_type"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        simplifyByDefault: json["simplify_by_default"],
        members: json["members"] == null
            ? []
            : List<Member>.from(json["members"]!.map((x) => Member.fromMap(x))),
        originalDebts: json["original_debts"] == null
            ? []
            : List<Debt>.from(
                json["original_debts"]!.map((x) => Debt.fromMap(x))),
        simplifiedDebts: json["simplified_debts"] == null
            ? []
            : List<Debt>.from(
                json["simplified_debts"]!.map((x) => Debt.fromMap(x))),
        avatar: json["avatar"] == null ? null : Avatar.fromMap(json["avatar"]),
        customAvatar: json["custom_avatar"],
        coverPhoto: json["cover_photo"] == null
            ? null
            : CoverPhoto.fromMap(json["cover_photo"]),
        inviteLink: json["invite_link"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "group_type": groupType,
        "updated_at": updatedAt?.toIso8601String(),
        "simplify_by_default": simplifyByDefault,
        "members": members == null
            ? []
            : List<dynamic>.from(members!.map((x) => x.toMap())),
        "original_debts": originalDebts == null
            ? []
            : List<dynamic>.from(originalDebts!.map((x) => x.toMap())),
        "simplified_debts": simplifiedDebts == null
            ? []
            : List<dynamic>.from(simplifiedDebts!.map((x) => x.toMap())),
        "avatar": avatar?.toMap(),
        "custom_avatar": customAvatar,
        "cover_photo": coverPhoto?.toMap(),
        "invite_link": inviteLink,
      };
}

class Avatar {
  String? original;
  String? xxlarge;
  String? xlarge;
  String? large;
  String? medium;
  String? small;

  Avatar({
    this.original,
    this.xxlarge,
    this.xlarge,
    this.large,
    this.medium,
    this.small,
  });

  Avatar copyWith({
    String? original,
    String? xxlarge,
    String? xlarge,
    String? large,
    String? medium,
    String? small,
  }) =>
      Avatar(
        original: original ?? this.original,
        xxlarge: xxlarge ?? this.xxlarge,
        xlarge: xlarge ?? this.xlarge,
        large: large ?? this.large,
        medium: medium ?? this.medium,
        small: small ?? this.small,
      );

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
  String? xxlarge;
  String? xlarge;

  CoverPhoto({
    this.xxlarge,
    this.xlarge,
  });

  CoverPhoto copyWith({
    String? xxlarge,
    String? xlarge,
  }) =>
      CoverPhoto(
        xxlarge: xxlarge ?? this.xxlarge,
        xlarge: xlarge ?? this.xlarge,
      );

  factory CoverPhoto.fromJson(String str) =>
      CoverPhoto.fromMap(json.decode(str));

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
  int id;
  String firstName;
  Picture picture;
  dynamic lastName;
  String? email;
  String? registrationStatus;
  bool? customPicture;
  List<Balance>? balance;

  Member({
    required this.id,
    required this.firstName,
    required this.picture,
    this.lastName,
    this.email,
    this.registrationStatus,
    this.customPicture,
    this.balance,
  });

  Member copyWith({
    int? id,
    String? firstName,
    dynamic lastName,
    String? email,
    String? registrationStatus,
    Picture? picture,
    bool? customPicture,
    List<Balance>? balance,
  }) =>
      Member(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        registrationStatus: registrationStatus ?? this.registrationStatus,
        picture: picture ?? this.picture,
        customPicture: customPicture ?? this.customPicture,
        balance: balance ?? this.balance,
      );

  factory Member.fromJson(String str) => Member.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Member.fromMap(Map<String, dynamic> json) => Member(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        registrationStatus: json["registration_status"],
        picture: Picture.fromMap(json["picture"]),
        customPicture: json["custom_picture"],
        balance: json["balance"] == null
            ? []
            : List<Balance>.from(
                json["balance"]!.map((x) => Balance.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "registration_status": registrationStatus,
        "picture": picture.toMap(),
        "custom_picture": customPicture,
        "balance": balance == null
            ? []
            : List<dynamic>.from(balance!.map((x) => x.toMap())),
      };
}

class Balance {
  String? currencyCode;
  String? amount;

  Balance({
    this.currencyCode,
    this.amount,
  });

  Balance copyWith({
    String? currencyCode,
    String? amount,
  }) =>
      Balance(
        currencyCode: currencyCode ?? this.currencyCode,
        amount: amount ?? this.amount,
      );

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
  String large;
  String? small;
  String? medium;

  Picture({
    required this.large,
    this.small,
    this.medium,
  });

  Picture copyWith({
    String? small,
    String? medium,
    String? large,
  }) =>
      Picture(
        small: small ?? this.small,
        medium: medium ?? this.medium,
        large: large ?? this.large,
      );

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
  int? from;
  int? to;
  String? amount;
  String? currencyCode;

  Debt({
    this.from,
    this.to,
    this.amount,
    this.currencyCode,
  });

  Debt copyWith({
    int? from,
    int? to,
    String? amount,
    String? currencyCode,
  }) =>
      Debt(
        from: from ?? this.from,
        to: to ?? this.to,
        amount: amount ?? this.amount,
        currencyCode: currencyCode ?? this.currencyCode,
      );

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
