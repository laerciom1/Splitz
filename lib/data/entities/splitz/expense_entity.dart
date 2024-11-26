import 'package:splitz/data/models/splitwise/get_expenses/get_expenses_response.dart';
import 'package:splitz/data/entities/splitz/group_config_entity.dart';
import 'package:collection/collection.dart';

enum ExpenseEntityState { example, listed, loading, createError, editError }

const _zero = '0.0';

class ExpenseEntity {
  ExpenseEntityState state;
  String cost;
  String description;
  DateTime date;
  int groupId;
  int categoryId;
  String imageUrl;
  List<UserExpenseEntity> users;
  String currencyCode;
  int? id;
  int? payerId;
  ExpenseEntity? backup;

  ExpenseEntity({
    required this.state,
    required this.cost,
    required this.description,
    required this.date,
    required this.groupId,
    required this.categoryId,
    required this.imageUrl,
    required this.users,
    this.currencyCode = 'BRL',
    this.id,
    this.payerId,
    this.backup,
  });

  ExpenseEntity copyWith({
    ExpenseEntityState? state,
    String? description,
    DateTime? date,
    int? groupId,
    int? categoryId,
    String? imageUrl,
    String? currencyCode,
    int? id,
    int? payerId,
    ExpenseEntity? backup,
  }) =>
      ExpenseEntity(
        state: state ?? this.state,
        cost: cost,
        description: description ?? this.description,
        date: date ?? this.date,
        groupId: groupId ?? this.groupId,
        categoryId: categoryId ?? this.categoryId,
        imageUrl: imageUrl ?? this.imageUrl,
        users: users,
        currencyCode: currencyCode ?? this.currencyCode,
        id: id ?? this.id,
        payerId: payerId ?? this.payerId,
        backup: backup ?? this.backup,
      );

  static List<UserExpenseEntity> getUsers(
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
    final users = getUsers(costToUse, splitzConfigs);
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
    );
  }

  factory ExpenseEntity.fromExpenseResponse(Expense e, String imageUrl) {
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
      date: e.date,
      groupId: e.groupId,
      categoryId: e.category.id,
      imageUrl: imageUrl,
      users: users,
      currencyCode: e.currencyCode,
      id: e.id,
      payerId: payerId,
      backup: null,
    );
  }

  factory ExpenseEntity.fromSplitzConfig({
    required cost,
    String description = '',
    DateTime? date,
    int groupId = 0,
    int categoryId = 0,
    String imageUrl = '',
    String currencyCode = 'BRL',
    required Map<String, SplitzConfig> splitzConfigs,
    ExpenseEntity? newVersion,
  }) {
    final payerId = splitzConfigs.values.firstWhereOrNull((e) => e.payer == true)?.id;
    return ExpenseEntity(
      state: ExpenseEntityState.example,
      cost: cost,
      description: description,
      date: date ?? DateTime.now(),
      groupId: groupId,
      categoryId: categoryId,
      imageUrl: imageUrl,
      users: getUsers(cost, splitzConfigs),
      currencyCode: currencyCode,
      payerId: payerId,
      backup: newVersion,
    );
  }

  String get prefix => description.split(' ')[0];
}

class UserExpenseEntity {
  String firstName;
  int userId;
  String owedShare;
  String? paidShare;

  UserExpenseEntity({
    required this.firstName,
    required this.userId,
    required this.owedShare,
    this.paidShare,
  });

  factory UserExpenseEntity.fromUserElementResponse(UserElement e) =>
      UserExpenseEntity(
        firstName: e.user.firstName,
        userId: e.userId,
        owedShare: e.owedShare,
        paidShare: e.paidShare,
      );
}
