import 'dart:convert';

import 'package:splitz/data/models/splitwise/common/category.dart';

class GetCategoriesResponse {
  List<Category> categories;

  GetCategoriesResponse({
    required this.categories,
  });

  GetCategoriesResponse copyWith({
    List<Category>? categories,
  }) =>
      GetCategoriesResponse(
        categories: categories ?? this.categories,
      );

  factory GetCategoriesResponse.fromJson(String str) =>
      GetCategoriesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetCategoriesResponse.fromMap(Map<String, dynamic> json) =>
      GetCategoriesResponse(
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toMap())),
      };
}
