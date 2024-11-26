import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:splitz/data/entities/external/expense_entity.dart';
import 'package:splitz/data/models/splitwise/get_categories/get_categories_response.dart';
import 'package:splitz/extensions/strings.dart';

class GroupConfigEntity {
  Map<String, SplitzCategory> splitzCategories;
  Map<String, SplitzConfig> splitzConfigs;

  GroupConfigEntity({
    required this.splitzCategories,
    required this.splitzConfigs,
  });

  GroupConfigEntity copyWith({
    Map<String, SplitzCategory>? splitzCategories,
    Map<String, SplitzConfig>? splitzConfigs,
  }) =>
      GroupConfigEntity(
        splitzCategories: splitzCategories ?? this.splitzCategories,
        splitzConfigs: splitzConfigs ?? this.splitzConfigs,
      );

  factory GroupConfigEntity.fromJson(String str) =>
      GroupConfigEntity.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GroupConfigEntity.fromMap(Map<dynamic, dynamic> json) =>
      GroupConfigEntity(
        splitzCategories: json["splitz_categories"] == null
            ? {}
            : Map.from(json["splitz_categories"]).map((k, v) =>
                MapEntry<String, SplitzCategory>(k, SplitzCategory.fromMap(v))),
        splitzConfigs: json["splitz_configs"] == null
            ? {}
            : Map.from(json["splitz_configs"]).map((k, v) =>
                MapEntry<String, SplitzConfig>(k, SplitzConfig.fromMap(v))),
      );

  Map<String, dynamic> toMap() => {
        "splitz_categories": Map.from(splitzCategories)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
        "splitz_configs": Map.from(splitzConfigs)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
      };

  GroupConfigEntity withPayer({
    List<UserExpenseEntity>? users,
    String? currentUserId,
  }) {
    int payerId = -1;
    if (currentUserId != null) payerId = int.parse(currentUserId);
    if (users != null) {
      final payerUser = users.firstWhereOrNull((e) =>
          e.paidShare.isNotNullNorEmpty && double.parse(e.paidShare!) != 0.0);
      payerId = payerUser?.userId ?? payerId;
    }
    var splitzConfigs = this.splitzConfigs;
    splitzConfigs['$payerId'] =
        splitzConfigs['$payerId']!.copyWith(payer: true);
    return copyWith(splitzConfigs: splitzConfigs);
  }
}

class SplitzCategory {
  String prefix;
  String imageUrl;
  int id;
  Map<String, SplitzConfig>? splitzConfigs;

  SplitzCategory({
    required this.prefix,
    required this.imageUrl,
    required this.id,
    this.splitzConfigs,
  });

  SplitzCategory copyWith({
    String? prefix,
    String? imageUrl,
    int? id,
    Map<String, SplitzConfig>? splitzConfigs,
  }) =>
      SplitzCategory(
        prefix: prefix ?? this.prefix,
        imageUrl: imageUrl ?? this.imageUrl,
        id: id ?? this.id,
        splitzConfigs: splitzConfigs ?? this.splitzConfigs,
      );

  factory SplitzCategory.fromJson(String str) =>
      SplitzCategory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SplitzCategory.fromMap(Map<dynamic, dynamic> json) => SplitzCategory(
        prefix: json["prefix"],
        imageUrl: json["imageUrl"],
        id: json["id"],
        splitzConfigs: json["splitz_configs"] == null
            ? null
            : Map.from(json["splitz_configs"]).map((k, v) =>
                MapEntry<String, SplitzConfig>(k, SplitzConfig.fromMap(v))),
      );

  Map<String, dynamic> toMap() => {
        "prefix": prefix,
        "imageUrl": imageUrl,
        "id": id,
        "splitz_configs": splitzConfigs == null
            ? null
            : Map.from(splitzConfigs!)
                .map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
      };

  factory SplitzCategory.fromCategory(FullCategory c) => SplitzCategory(
        prefix: '',
        imageUrl: c.iconTypes.square.large,
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

  factory SplitzConfig.fromJson(String str) =>
      SplitzConfig.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SplitzConfig.fromMap(Map<dynamic, dynamic> json) => SplitzConfig(
        id: json["id"],
        name: json["name"],
        avatarUrl: json["avatarUrl"],
        slice: json["slice"],
        payer: json["payer"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "avatarUrl": avatarUrl,
        "slice": slice,
        "payer": payer,
      };
}

/*
{
  "splitz_categories": {
    "MERCADO": {
      "prefix": "MERCADO",
      "imageUrl": "url",
      "id": 1,
      "splitz_configs": {
        "123": {
          "id": 123,
          "name": "123",
          "avatarUrl": "3213",
          "slice": 80,
          "payer": true
        },
        "213": {
          "id": 213,
          "name": "123",
          "avatarUrl": "3213",
          "slice": 80,
          "payer": false
        }
      }
    },
    "LAZER": {
      "prefix": "LAZER",
      "imageUrl": "url",
      "id": 1
    }
  },
  "splitz_configs": {
    "123": {
      "id": 123,
      "name": "123",
      "avatarUrl": "3213",
      "slice": 80,
      "payer": true
    },
    "213": {
      "id": 213,
      "name": "123",
      "avatarUrl": "3213",
      "slice": 80,
      "payer": false
    }
  }
}
*/