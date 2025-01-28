import 'package:collection/collection.dart';
import 'package:splitz/data/entities/splitz/group_config_entity.dart';
import 'package:splitz/data/models/splitwise/get_expenses/get_expenses_response.dart';

enum ExpenseEntityState { example, listed, loading, createError, editError }

const _zero = '0.0';

class ExpenseEntity {
  ExpenseEntityState state;
  String cost;
  String description;
  DateTime date;
  int groupId;
  int categoryId;
  List<UserExpenseEntity> users;
  String? imageUrl;
  String currencyCode;
  int? id;
  int? payerId;
  ExpenseEntity? backup;
  bool payment;

  ExpenseEntity({
    required this.state,
    required this.cost,
    required this.description,
    required this.date,
    required this.groupId,
    required this.categoryId,
    required this.users,
    this.imageUrl,
    this.currencyCode = 'BRL',
    this.id,
    this.payerId,
    this.backup,
    this.payment = false,
  });

  ExpenseEntity copyWith({
    ExpenseEntityState? state,
    String? cost,
    String? description,
    DateTime? date,
    int? groupId,
    int? categoryId,
    List<UserExpenseEntity>? users,
    String? imageUrl,
    String? currencyCode,
    int? id,
    int? payerId,
    ExpenseEntity? backup,
    bool? payment,
  }) =>
      ExpenseEntity(
        state: state ?? this.state,
        cost: cost ?? this.cost,
        description: description ?? this.description,
        date: date ?? this.date,
        groupId: groupId ?? this.groupId,
        categoryId: categoryId ?? this.categoryId,
        users: users ?? this.users,
        imageUrl: imageUrl ?? this.imageUrl,
        currencyCode: currencyCode ?? this.currencyCode,
        id: id ?? this.id,
        payerId: payerId ?? this.payerId,
        backup: backup ?? this.backup,
        payment: payment ?? this.payment,
      );

  static List<UserExpenseEntity> _getUsers(
    String cost,
    Map<String, SplitzConfig> splitzConfigs,
  ) =>
      [
        ...splitzConfigs.values.map((e) {
          final owedShare = (e.slice / 100) * double.parse(cost);
          return UserExpenseEntity(
            firstName: e.name,
            userId: e.id,
            owedShare: owedShare.toString(),
            paidShare: e.payer == true ? cost : _zero,
          );
        })
      ];

  ExpenseEntity copyWithShares({
    String? cost,
    required Map<String, SplitzConfig> splitzConfigs,
  }) {
    final costToUse = cost ?? this.cost;
    final users = _getUsers(costToUse, splitzConfigs);
    final payerId = users.firstWhereOrNull((e) => e.paidShare != _zero)?.userId;

    return ExpenseEntity(
      state: state,
      cost: costToUse,
      description: description,
      date: date,
      groupId: groupId,
      categoryId: categoryId,
      imageUrl: imageUrl,
      users: users,
      currencyCode: currencyCode,
      id: id,
      payerId: payerId,
      backup: backup,
      payment: payment,
    );
  }

  ExpenseEntity copyWithBackup({
    required ExpenseEntity newVersion,
    ExpenseEntityState? state,
  }) {
    final backup = copyWith();
    return ExpenseEntity(
      state: state ?? newVersion.state,
      cost: newVersion.cost,
      description: newVersion.description,
      date: newVersion.date,
      groupId: newVersion.groupId,
      categoryId: newVersion.categoryId,
      imageUrl: newVersion.imageUrl,
      users: newVersion.users,
      currencyCode: newVersion.currencyCode,
      id: newVersion.id,
      payerId: newVersion.payerId,
      backup: backup,
      payment: payment,
    );
  }

  factory ExpenseEntity.fromExpenseResponse(FullExpense e, [String? imageUrl]) {
    final users = <UserExpenseEntity>[];
    int? payerId;
    for (final user in e.users) {
      if (double.parse(user.paidShare) > 0) {
        payerId = user.userId;
      }
      users.add(UserExpenseEntity.fromUserElementResponse(user));
    }
    return ExpenseEntity(
      state: ExpenseEntityState.listed,
      cost: e.cost,
      description: e.description,
      date: e.date.toLocal(),
      groupId: e.groupId,
      categoryId: e.category.id,
      imageUrl: imageUrl,
      users: users,
      currencyCode: e.currencyCode,
      id: e.id,
      payerId: payerId,
      backup: null,
      payment: e.payment,
    );
  }

  factory ExpenseEntity.fromSplitzConfig({
    required Map<String, SplitzConfig> splitzConfigs,
    required cost,
    String description = '',
    DateTime? date,
    int groupId = 0,
    int categoryId = 0,
    String imageUrl = '',
    String currencyCode = 'BRL',
    ExpenseEntity? newVersion,
  }) {
    final payerId =
        splitzConfigs.values.firstWhereOrNull((e) => e.payer == true)?.id;
    return ExpenseEntity(
      state: ExpenseEntityState.example,
      cost: cost,
      description: description,
      date: date ?? DateTime.now(),
      groupId: groupId,
      categoryId: categoryId,
      imageUrl: imageUrl,
      users: _getUsers(cost, splitzConfigs),
      currencyCode: currencyCode,
      payerId: payerId,
      backup: newVersion,
      payment: false,
    );
  }

  factory ExpenseEntity.payment({
    required groupId,
  }) {
    return ExpenseEntity(
      state: ExpenseEntityState.example,
      cost: '0.0',
      description: 'Payment',
      date: DateTime.now(),
      groupId: groupId,
      categoryId: 18,
      users: [],
      payment: true,
    );
  }

  String get prefix => description.split(' ')[0];
}

class UserExpenseEntity {
  String firstName;
  int userId;
  String owedShare;
  String paidShare;

  UserExpenseEntity({
    required this.firstName,
    required this.userId,
    required this.owedShare,
    required this.paidShare,
  });

  factory UserExpenseEntity.fromUserElementResponse(UserElement e) =>
      UserExpenseEntity(
        firstName: e.user.firstName,
        userId: e.userId,
        owedShare: e.owedShare,
        paidShare: e.paidShare,
      );
}
