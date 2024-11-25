import 'package:collection/collection.dart';
import 'package:splitz/data/entities/expense_entity.dart';
import 'package:splitz/data/models/splitwise/common/category.dart';
import 'package:splitz/extensions/strings.dart';

const _zero = 0.0;

class GroupConfig {
  List<SplitzCategory> categories;
  List<SplitzConfig> splitConfig;

  GroupConfig({
    required this.categories,
    required this.splitConfig,
  });

  GroupConfig copyWith({
    List<SplitzCategory>? categories,
    List<SplitzConfig>? splitConfig,
  }) =>
      GroupConfig(
        categories: categories ?? this.categories,
        splitConfig: splitConfig ?? this.splitConfig,
      );

  GroupConfig withPayer({
    List<UserExpenseEntity>? users,
    String? currentUserId,
  }) {
    int payerId = -1;
    if (currentUserId != null) payerId = int.parse(currentUserId);
    if (users != null) {
      final payerUser = users.firstWhereOrNull((e) =>
          e.paidShare.isNotNullNorEmpty && double.parse(e.paidShare!) != _zero);
      payerId = payerUser?.userId ?? payerId;
    }
    var splitConfig = this.splitConfig;
    splitConfig = splitConfig
        .map((e) => e.id == payerId ? e.copyWith(payer: true) : e)
        .toList();
    return GroupConfig(
      categories: categories,
      splitConfig: splitConfig,
    );
  }

  factory GroupConfig.fromMap(Map<dynamic, dynamic> json) => GroupConfig(
        categories: json["categories"] == null
            ? []
            : List<SplitzCategory>.from((json["categories"]! as List)
                .map((x) => SplitzCategory.fromMap(x))),
        splitConfig: json["split_config"] == null
            ? []
            : List<SplitzConfig>.from((json["split_config"]! as List)
                .map((x) => SplitzConfig.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toMap())),
        "split_config": List<dynamic>.from(splitConfig.map((x) => x.toMap())),
      };
}

class SplitzCategory {
  String prefix;
  String imageUrl;
  int id;
  List<SplitzConfig>? splitConfig;

  SplitzCategory({
    required this.prefix,
    required this.imageUrl,
    required this.id,
    this.splitConfig,
  });

  SplitzCategory copyWith({
    String? prefix,
    String? imageUrl,
    int? id,
    List<SplitzConfig>? splitConfig,
  }) =>
      SplitzCategory(
        prefix: prefix ?? this.prefix,
        imageUrl: imageUrl ?? this.imageUrl,
        id: id ?? this.id,
        splitConfig: splitConfig ?? this.splitConfig,
      );

  factory SplitzCategory.fromMap(Map<dynamic, dynamic> json) => SplitzCategory(
        prefix: json["prefix"],
        imageUrl: json["imageUrl"],
        id: json["id"],
        splitConfig: json["split_config"] == null
            ? null
            : List<SplitzConfig>.from(
                json["split_config"]!.map((x) => SplitzConfig.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "prefix": prefix,
        "imageUrl": imageUrl,
        "id": id,
        "split_config": splitConfig == null
            ? null
            : List<dynamic>.from(splitConfig!.map((x) => x.toMap())),
      };

  factory SplitzCategory.fromCategory(Category c) => SplitzCategory(
        prefix: '',
        imageUrl: c.iconTypes!.square!.large!,
        id: c.id,
      );
}

class SplitzConfig {
  int id;
  String name;
  String avatarUrl;
  int slice;
  bool? payer;

  SplitzConfig({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.slice,
    this.payer,
  });

  SplitzConfig copyWith({
    int? id,
    String? name,
    String? avatarUrl,
    int? slice,
    bool? payer,
  }) =>
      SplitzConfig(
        id: id ?? this.id,
        name: name ?? this.name,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        slice: slice ?? this.slice,
        payer: payer ?? this.payer,
      );

  factory SplitzConfig.fromMap(Map<dynamic, dynamic> json) => SplitzConfig(
        id: json["id"],
        name: json["name"],
        avatarUrl: json["avatarUrl"],
        slice: json["slice"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "avatarUrl": avatarUrl,
        "slice": slice,
      };
}
