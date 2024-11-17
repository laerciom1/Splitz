import 'dart:convert';

class UpdateExpenseResponse {
    final List<Expense>? expenses;
    final Errors? errors;

    UpdateExpenseResponse({
        this.expenses,
        this.errors,
    });

    factory UpdateExpenseResponse.fromJson(String str) => UpdateExpenseResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UpdateExpenseResponse.fromMap(Map<String, dynamic> json) => UpdateExpenseResponse(
        expenses: json["expenses"] == null ? [] : List<Expense>.from(json["expenses"]!.map((x) => Expense.fromMap(x))),
        errors: json["errors"] == null ? null : Errors.fromMap(json["errors"]),
    );

    Map<String, dynamic> toMap() => {
        "expenses": expenses == null ? [] : List<dynamic>.from(expenses!.map((x) => x.toMap())),
        "errors": errors?.toMap(),
    };
}

class Errors {
    Errors();

    factory Errors.fromJson(String str) => Errors.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Errors.fromMap(Map<String, dynamic> json) => Errors(
    );

    Map<String, dynamic> toMap() => {
    };
}

class Expense {
    final String? cost;
    final String? description;
    final String? details;
    final DateTime? date;
    final String? repeatInterval;
    final String? currencyCode;
    final int? categoryId;
    final int? id;
    final int? groupId;
    final int? friendshipId;
    final int? expenseBundleId;
    final bool? repeats;
    final bool? emailReminder;
    final dynamic emailReminderInAdvance;
    final String? nextRepeat;
    final int? commentsCount;
    final bool? payment;
    final bool? transactionConfirmed;
    final List<Repayment>? repayments;
    final DateTime? createdAt;
    final TedBy? createdBy;
    final DateTime? updatedAt;
    final TedBy? updatedBy;
    final DateTime? deletedAt;
    final TedBy? deletedBy;
    final Category? category;
    final Receipt? receipt;
    final List<UserElement>? users;
    final List<Comment>? comments;

    Expense({
        this.cost,
        this.description,
        this.details,
        this.date,
        this.repeatInterval,
        this.currencyCode,
        this.categoryId,
        this.id,
        this.groupId,
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
        this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.updatedBy,
        this.deletedAt,
        this.deletedBy,
        this.category,
        this.receipt,
        this.users,
        this.comments,
    });

    factory Expense.fromJson(String str) => Expense.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Expense.fromMap(Map<String, dynamic> json) => Expense(
        cost: json["cost"],
        description: json["description"],
        details: json["details"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        repeatInterval: json["repeat_interval"],
        currencyCode: json["currency_code"],
        categoryId: json["category_id"],
        id: json["id"],
        groupId: json["group_id"],
        friendshipId: json["friendship_id"],
        expenseBundleId: json["expense_bundle_id"],
        repeats: json["repeats"],
        emailReminder: json["email_reminder"],
        emailReminderInAdvance: json["email_reminder_in_advance"],
        nextRepeat: json["next_repeat"],
        commentsCount: json["comments_count"],
        payment: json["payment"],
        transactionConfirmed: json["transaction_confirmed"],
        repayments: json["repayments"] == null ? [] : List<Repayment>.from(json["repayments"]!.map((x) => Repayment.fromMap(x))),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"] == null ? null : TedBy.fromMap(json["created_by"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"] == null ? null : TedBy.fromMap(json["updated_by"]),
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
        deletedBy: json["deleted_by"] == null ? null : TedBy.fromMap(json["deleted_by"]),
        category: json["category"] == null ? null : Category.fromMap(json["category"]),
        receipt: json["receipt"] == null ? null : Receipt.fromMap(json["receipt"]),
        users: json["users"] == null ? [] : List<UserElement>.from(json["users"]!.map((x) => UserElement.fromMap(x))),
        comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "cost": cost,
        "description": description,
        "details": details,
        "date": date?.toIso8601String(),
        "repeat_interval": repeatInterval,
        "currency_code": currencyCode,
        "category_id": categoryId,
        "id": id,
        "group_id": groupId,
        "friendship_id": friendshipId,
        "expense_bundle_id": expenseBundleId,
        "repeats": repeats,
        "email_reminder": emailReminder,
        "email_reminder_in_advance": emailReminderInAdvance,
        "next_repeat": nextRepeat,
        "comments_count": commentsCount,
        "payment": payment,
        "transaction_confirmed": transactionConfirmed,
        "repayments": repayments == null ? [] : List<dynamic>.from(repayments!.map((x) => x.toMap())),
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy?.toMap(),
        "updated_at": updatedAt?.toIso8601String(),
        "updated_by": updatedBy?.toMap(),
        "deleted_at": deletedAt?.toIso8601String(),
        "deleted_by": deletedBy?.toMap(),
        "category": category?.toMap(),
        "receipt": receipt?.toMap(),
        "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toMap())),
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toMap())),
    };
}

class Category {
    final int? id;
    final String? name;

    Category({
        this.id,
        this.name,
    });

    factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
    };
}

class Comment {
    final int? id;
    final String? content;
    final String? commentType;
    final String? relationType;
    final int? relationId;
    final DateTime? createdAt;
    final DateTime? deletedAt;
    final CommentUser? user;

    Comment({
        this.id,
        this.content,
        this.commentType,
        this.relationType,
        this.relationId,
        this.createdAt,
        this.deletedAt,
        this.user,
    });

    factory Comment.fromJson(String str) => Comment.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        id: json["id"],
        content: json["content"],
        commentType: json["comment_type"],
        relationType: json["relation_type"],
        relationId: json["relation_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
        user: json["user"] == null ? null : CommentUser.fromMap(json["user"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "content": content,
        "comment_type": commentType,
        "relation_type": relationType,
        "relation_id": relationId,
        "created_at": createdAt?.toIso8601String(),
        "deleted_at": deletedAt?.toIso8601String(),
        "user": user?.toMap(),
    };
}

class CommentUser {
    final int? id;
    final String? firstName;
    final String? lastName;
    final UserPicture? picture;

    CommentUser({
        this.id,
        this.firstName,
        this.lastName,
        this.picture,
    });

    factory CommentUser.fromJson(String str) => CommentUser.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CommentUser.fromMap(Map<String, dynamic> json) => CommentUser(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        picture: json["picture"] == null ? null : UserPicture.fromMap(json["picture"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "picture": picture?.toMap(),
    };
}

class UserPicture {
    final String? medium;

    UserPicture({
        this.medium,
    });

    factory UserPicture.fromJson(String str) => UserPicture.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UserPicture.fromMap(Map<String, dynamic> json) => UserPicture(
        medium: json["medium"],
    );

    Map<String, dynamic> toMap() => {
        "medium": medium,
    };
}

class TedBy {
    final int? id;
    final String? firstName;
    final String? lastName;
    final String? email;
    final String? registrationStatus;
    final CreatedByPicture? picture;
    final bool? customPicture;

    TedBy({
        this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.registrationStatus,
        this.picture,
        this.customPicture,
    });

    factory TedBy.fromJson(String str) => TedBy.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TedBy.fromMap(Map<String, dynamic> json) => TedBy(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        registrationStatus: json["registration_status"],
        picture: json["picture"] == null ? null : CreatedByPicture.fromMap(json["picture"]),
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
    final String? small;
    final String? medium;
    final String? large;

    CreatedByPicture({
        this.small,
        this.medium,
        this.large,
    });

    factory CreatedByPicture.fromJson(String str) => CreatedByPicture.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CreatedByPicture.fromMap(Map<String, dynamic> json) => CreatedByPicture(
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
    final String? large;
    final String? original;

    Receipt({
        this.large,
        this.original,
    });

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
    final int? from;
    final int? to;
    final String? amount;

    Repayment({
        this.from,
        this.to,
        this.amount,
    });

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
    final CommentUser? user;
    final int? userId;
    final String? paidShare;
    final String? owedShare;
    final String? netBalance;

    UserElement({
        this.user,
        this.userId,
        this.paidShare,
        this.owedShare,
        this.netBalance,
    });

    factory UserElement.fromJson(String str) => UserElement.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UserElement.fromMap(Map<String, dynamic> json) => UserElement(
        user: json["user"] == null ? null : CommentUser.fromMap(json["user"]),
        userId: json["user_id"],
        paidShare: json["paid_share"],
        owedShare: json["owed_share"],
        netBalance: json["net_balance"],
    );

    Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "user_id": userId,
        "paid_share": paidShare,
        "owed_share": owedShare,
        "net_balance": netBalance,
    };
}
