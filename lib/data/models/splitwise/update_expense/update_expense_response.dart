class UpdateExpenseResponse {
  List<Expense> expenses;

  UpdateExpenseResponse({required this.expenses});

  factory UpdateExpenseResponse.fromMap(Map<String, dynamic> json) =>
      UpdateExpenseResponse(
        expenses: json["expenses"] == null
            ? []
            : List<Expense>.from(
                json["expenses"]!.map((x) => Expense.fromMap(x))),
      );
}

class Expense {
  int id;
  String? cost;
  String? description;
  String? details;
  DateTime? date;
  String? repeatInterval;
  String? currencyCode;
  int? categoryId;
  int? groupId;
  int? friendshipId;
  int? expenseBundleId;
  bool? repeats;
  bool? emailReminder;
  dynamic emailReminderInAdvance;
  String? nextRepeat;
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
  List<UserElement>? users;
  List<Comment>? comments;

  Expense({
    required this.id,
    this.cost,
    this.description,
    this.details,
    this.date,
    this.repeatInterval,
    this.currencyCode,
    this.categoryId,
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
        users: json["users"] == null
            ? []
            : List<UserElement>.from(
                json["users"]!.map((x) => UserElement.fromMap(x))),
        comments: json["comments"] == null
            ? []
            : List<Comment>.from(
                json["comments"]!.map((x) => Comment.fromMap(x))),
      );
}

class Category {
  int? id;
  String? name;

  Category({
    this.id,
    this.name,
  });

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );
}

class Comment {
  int? id;
  String? content;
  String? commentType;
  String? relationType;
  int? relationId;
  DateTime? createdAt;
  DateTime? deletedAt;
  CommentUser? user;

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

  factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        id: json["id"],
        content: json["content"],
        commentType: json["comment_type"],
        relationType: json["relation_type"],
        relationId: json["relation_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]),
        user: json["user"] == null ? null : CommentUser.fromMap(json["user"]),
      );
}

class CommentUser {
  int? id;
  String? firstName;
  String? lastName;
  UserPicture? picture;

  CommentUser({
    this.id,
    this.firstName,
    this.lastName,
    this.picture,
  });

  factory CommentUser.fromMap(Map<String, dynamic> json) => CommentUser(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        picture: json["picture"] == null
            ? null
            : UserPicture.fromMap(json["picture"]),
      );
}

class UserPicture {
  String? medium;

  UserPicture({
    this.medium,
  });

  factory UserPicture.fromMap(Map<String, dynamic> json) => UserPicture(
        medium: json["medium"],
      );
}

class TedBy {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? registrationStatus;
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
}

class CreatedByPicture {
  String? small;
  String? medium;
  String? large;

  CreatedByPicture({
    this.small,
    this.medium,
    this.large,
  });

  factory CreatedByPicture.fromMap(Map<String, dynamic> json) =>
      CreatedByPicture(
        small: json["small"],
        medium: json["medium"],
        large: json["large"],
      );
}

class Receipt {
  String? large;
  String? original;

  Receipt({
    this.large,
    this.original,
  });

  factory Receipt.fromMap(Map<String, dynamic> json) => Receipt(
        large: json["large"],
        original: json["original"],
      );
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

  factory Repayment.fromMap(Map<String, dynamic> json) => Repayment(
        from: json["from"],
        to: json["to"],
        amount: json["amount"],
      );
}

class UserElement {
  CommentUser? user;
  int? userId;
  String? paidShare;
  String? owedShare;
  String? netBalance;

  UserElement({
    this.user,
    this.userId,
    this.paidShare,
    this.owedShare,
    this.netBalance,
  });

  factory UserElement.fromMap(Map<String, dynamic> json) => UserElement(
        user: json["user"] == null ? null : CommentUser.fromMap(json["user"]),
        userId: json["user_id"],
        paidShare: json["paid_share"],
        owedShare: json["owed_share"],
        netBalance: json["net_balance"],
      );
}
