import 'dart:convert';

import 'package:splitz/data/models/splitwise/common/category.dart';

class GetExpensesResponse {
  List<Expense>? expenses;

  GetExpensesResponse({
    this.expenses,
  });

  GetExpensesResponse copyWith({
    List<Expense>? expenses,
  }) =>
      GetExpensesResponse(
        expenses: expenses ?? this.expenses,
      );

  factory GetExpensesResponse.fromJson(String str) =>
      GetExpensesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetExpensesResponse.fromMap(Map<String, dynamic> json) =>
      GetExpensesResponse(
        expenses: json["expenses"] == null
            ? []
            : List<Expense>.from(
                json["expenses"]!.map((x) => Expense.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "expenses": expenses == null
            ? []
            : List<dynamic>.from(expenses!.map((x) => x.toMap())),
      };
}

class Expense {
  int id;
  String cost;
  String description;
  DateTime date;
  String currencyCode;
  int groupId;
  List<UserElement> users;
  int? categoryId;
  String? details;
  String? repeatInterval;
  dynamic friendshipId;
  dynamic expenseBundleId;
  bool? repeats;
  bool? emailReminder;
  int? emailReminderInAdvance;
  DateTime? nextRepeat;
  int? commentsCount;
  bool? payment;
  bool? transactionConfirmed;
  List<Repayment>? repayments;
  DateTime? createdAt;
  TedBy? createdBy;
  DateTime? updatedAt;
  TedBy? updatedBy;
  DateTime? deletedAt;
  TedBy? deletedBy;
  Category? category;
  Receipt? receipt;
  List<dynamic>? comments;

  Expense({
    required this.id,
    required this.cost,
    required this.description,
    required this.date,
    required this.currencyCode,
    required this.groupId,
    required this.users,
    this.categoryId,
    this.createdAt,
    this.details,
    this.repeatInterval,
    this.friendshipId,
    this.expenseBundleId,
    this.repeats,
    this.emailReminder,
    this.emailReminderInAdvance,
    this.nextRepeat,
    this.commentsCount,
    this.payment,
    this.transactionConfirmed,
    this.repayments,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
    this.category,
    this.receipt,
    this.comments,
  });

  Expense copyWith({
    String? cost,
    String? description,
    String? details,
    DateTime? date,
    String? repeatInterval,
    String? currencyCode,
    dynamic categoryId,
    int? id,
    int? groupId,
    dynamic friendshipId,
    dynamic expenseBundleId,
    bool? repeats,
    bool? emailReminder,
    int? emailReminderInAdvance,
    DateTime? nextRepeat,
    int? commentsCount,
    bool? payment,
    bool? transactionConfirmed,
    List<Repayment>? repayments,
    DateTime? createdAt,
    TedBy? createdBy,
    DateTime? updatedAt,
    TedBy? updatedBy,
    DateTime? deletedAt,
    TedBy? deletedBy,
    Category? category,
    Receipt? receipt,
    List<UserElement>? users,
    List<dynamic>? comments,
  }) =>
      Expense(
        cost: cost ?? this.cost,
        description: description ?? this.description,
        details: details ?? this.details,
        date: date ?? this.date,
        repeatInterval: repeatInterval ?? this.repeatInterval,
        currencyCode: currencyCode ?? this.currencyCode,
        categoryId: categoryId ?? this.categoryId,
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        friendshipId: friendshipId ?? this.friendshipId,
        expenseBundleId: expenseBundleId ?? this.expenseBundleId,
        repeats: repeats ?? this.repeats,
        emailReminder: emailReminder ?? this.emailReminder,
        emailReminderInAdvance:
            emailReminderInAdvance ?? this.emailReminderInAdvance,
        nextRepeat: nextRepeat ?? this.nextRepeat,
        commentsCount: commentsCount ?? this.commentsCount,
        payment: payment ?? this.payment,
        transactionConfirmed: transactionConfirmed ?? this.transactionConfirmed,
        repayments: repayments ?? this.repayments,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt ?? this.deletedAt,
        deletedBy: deletedBy ?? this.deletedBy,
        category: category ?? this.category,
        receipt: receipt ?? this.receipt,
        users: users ?? this.users,
        comments: comments ?? this.comments,
      );

  factory Expense.fromJson(String str) => Expense.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Expense.fromMap(Map<String, dynamic> json) => Expense(
        id: json["id"],
        cost: json["cost"],
        description: json["description"],
        date: DateTime.parse(json["date"]),
        currencyCode: json["currency_code"],
        categoryId: json["category_id"],
        groupId: json["group_id"],
        users: json["users"] == null
            ? []
            : List<UserElement>.from(
                json["users"]!.map((x) => UserElement.fromMap(x))),
        details: json["details"],
        repeatInterval: json["repeat_interval"],
        friendshipId: json["friendship_id"],
        expenseBundleId: json["expense_bundle_id"],
        repeats: json["repeats"],
        emailReminder: json["email_reminder"],
        emailReminderInAdvance: json["email_reminder_in_advance"],
        nextRepeat: json["next_repeat"] == null
            ? null
            : DateTime.parse(json["next_repeat"]),
        commentsCount: json["comments_count"],
        payment: json["payment"],
        transactionConfirmed: json["transaction_confirmed"],
        repayments: json["repayments"] == null
            ? []
            : List<Repayment>.from(
                json["repayments"]!.map((x) => Repayment.fromMap(x))),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"] == null
            ? null
            : TedBy.fromMap(json["created_by"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"] == null
            ? null
            : TedBy.fromMap(json["updated_by"]),
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]),
        deletedBy: json["deleted_by"] == null
            ? null
            : TedBy.fromMap(json["deleted_by"]),
        category: json["category"] == null
            ? null
            : Category.fromMap(json["category"]),
        receipt:
            json["receipt"] == null ? null : Receipt.fromMap(json["receipt"]),
        comments: json["comments"] == null
            ? []
            : List<dynamic>.from(json["comments"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "cost": cost,
        "description": description,
        "date": date.toIso8601String(),
        "currency_code": currencyCode,
        "category_id": categoryId,
        "group_id": groupId,
        "users": List<dynamic>.from(users.map((x) => x.toMap())),
        "details": details,
        "repeat_interval": repeatInterval,
        "friendship_id": friendshipId,
        "expense_bundle_id": expenseBundleId,
        "repeats": repeats,
        "email_reminder": emailReminder,
        "email_reminder_in_advance": emailReminderInAdvance,
        "next_repeat": nextRepeat?.toIso8601String(),
        "comments_count": commentsCount,
        "payment": payment,
        "transaction_confirmed": transactionConfirmed,
        "repayments": repayments == null
            ? []
            : List<dynamic>.from(repayments!.map((x) => x.toMap())),
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy?.toMap(),
        "updated_at": updatedAt?.toIso8601String(),
        "updated_by": updatedBy?.toMap(),
        "deleted_at": deletedAt?.toIso8601String(),
        "deleted_by": deletedBy?.toMap(),
        "category": category?.toMap(),
        "receipt": receipt?.toMap(),
        "comments":
            comments == null ? [] : List<dynamic>.from(comments!.map((x) => x)),
      };
}

class TedBy {
  int? id;
  String? firstName;
  dynamic lastName;
  dynamic email;
  dynamic registrationStatus;
  CreatedByPicture? picture;
  bool? customPicture;

  TedBy({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.registrationStatus,
    this.picture,
    this.customPicture,
  });

  TedBy copyWith({
    int? id,
    String? firstName,
    dynamic lastName,
    dynamic email,
    dynamic registrationStatus,
    CreatedByPicture? picture,
    bool? customPicture,
  }) =>
      TedBy(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        registrationStatus: registrationStatus ?? this.registrationStatus,
        picture: picture ?? this.picture,
        customPicture: customPicture ?? this.customPicture,
      );

  factory TedBy.fromJson(String str) => TedBy.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TedBy.fromMap(Map<String, dynamic> json) => TedBy(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        registrationStatus: json["registration_status"],
        picture: json["picture"] == null
            ? null
            : CreatedByPicture.fromMap(json["picture"]),
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

class CreatedByPicture {
  dynamic small;
  String? medium;
  dynamic large;

  CreatedByPicture({
    this.small,
    this.medium,
    this.large,
  });

  CreatedByPicture copyWith({
    dynamic small,
    String? medium,
    dynamic large,
  }) =>
      CreatedByPicture(
        small: small ?? this.small,
        medium: medium ?? this.medium,
        large: large ?? this.large,
      );

  factory CreatedByPicture.fromJson(String str) =>
      CreatedByPicture.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreatedByPicture.fromMap(Map<String, dynamic> json) =>
      CreatedByPicture(
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

class Receipt {
  dynamic large;
  dynamic original;

  Receipt({
    this.large,
    this.original,
  });

  Receipt copyWith({
    dynamic large,
    dynamic original,
  }) =>
      Receipt(
        large: large ?? this.large,
        original: original ?? this.original,
      );

  factory Receipt.fromJson(String str) => Receipt.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Receipt.fromMap(Map<String, dynamic> json) => Receipt(
        large: json["large"],
        original: json["original"],
      );

  Map<String, dynamic> toMap() => {
        "large": large,
        "original": original,
      };
}

class Repayment {
  int? from;
  int? to;
  String? amount;

  Repayment({
    this.from,
    this.to,
    this.amount,
  });

  Repayment copyWith({
    int? from,
    int? to,
    String? amount,
  }) =>
      Repayment(
        from: from ?? this.from,
        to: to ?? this.to,
        amount: amount ?? this.amount,
      );

  factory Repayment.fromJson(String str) => Repayment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Repayment.fromMap(Map<String, dynamic> json) => Repayment(
        from: json["from"],
        to: json["to"],
        amount: json["amount"],
      );

  Map<String, dynamic> toMap() => {
        "from": from,
        "to": to,
        "amount": amount,
      };
}

class UserElement {
  UserUser user;
  int userId;
  String paidShare;
  String owedShare;
  String netBalance;

  UserElement({
    required this.user,
    required this.userId,
    required this.paidShare,
    required this.owedShare,
    required this.netBalance,
  });

  UserElement copyWith({
    UserUser? user,
    int? userId,
    String? paidShare,
    String? owedShare,
    String? netBalance,
  }) =>
      UserElement(
        user: user ?? this.user,
        userId: userId ?? this.userId,
        paidShare: paidShare ?? this.paidShare,
        owedShare: owedShare ?? this.owedShare,
        netBalance: netBalance ?? this.netBalance,
      );

  factory UserElement.fromJson(String str) =>
      UserElement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserElement.fromMap(Map<String, dynamic> json) => UserElement(
        user: UserUser.fromMap(json["user"]),
        userId: json["user_id"],
        paidShare: json["paid_share"],
        owedShare: json["owed_share"],
        netBalance: json["net_balance"],
      );

  Map<String, dynamic> toMap() => {
        "user": user.toMap(),
        "user_id": userId,
        "paid_share": paidShare,
        "owed_share": owedShare,
        "net_balance": netBalance,
      };
}

class UserUser {
  String firstName;
  int? id;
  dynamic lastName;
  UserPicture? picture;

  UserUser({
    required this.firstName,
    this.id,
    this.lastName,
    this.picture,
  });

  UserUser copyWith({
    int? id,
    String? firstName,
    dynamic lastName,
    UserPicture? picture,
  }) =>
      UserUser(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        picture: picture ?? this.picture,
      );

  factory UserUser.fromJson(String str) => UserUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserUser.fromMap(Map<String, dynamic> json) => UserUser(
        id: json["id"],
        firstName: json["first_name"],
        picture: UserPicture.fromMap(json["picture"]),
        lastName: json["last_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "first_name": firstName,
        "picture": picture?.toMap(),
        "last_name": lastName,
      };
}

class UserPicture {
  String? medium;

  UserPicture({
    this.medium,
  });

  UserPicture copyWith({
    String? medium,
  }) =>
      UserPicture(
        medium: medium ?? this.medium,
      );

  factory UserPicture.fromJson(String str) =>
      UserPicture.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserPicture.fromMap(Map<String, dynamic> json) => UserPicture(
        medium: json["medium"],
      );

  Map<String, dynamic> toMap() => {
        "medium": medium,
      };
}
