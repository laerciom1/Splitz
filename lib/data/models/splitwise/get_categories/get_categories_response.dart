class GetCategoriesResponse {
  final List<FullCategory> categories;

  GetCategoriesResponse({required this.categories});

  factory GetCategoriesResponse.fromMap(Map<String, dynamic> json) =>
      GetCategoriesResponse(
        categories: json["categories"] == null
            ? []
            : List<FullCategory>.from(
                json["categories"]!.map((x) => FullCategory.fromMap(x)),
              ),
      );
}

class FullCategory {
  final int id;
  final IconTypes iconTypes;
  final List<FullCategory> subcategories;

  FullCategory({
    required this.id,
    required this.iconTypes,
    required this.subcategories,
  });

  factory FullCategory.fromMap(Map<String, dynamic> json) => FullCategory(
        id: json["id"],
        iconTypes: IconTypes.fromMap(json["icon_types"]),
        subcategories: json["subcategories"] == null
            ? []
            : List<FullCategory>.from(
                json["subcategories"]!.map((x) => FullCategory.fromMap(x)),
              ),
      );
}

class IconTypes {
  final Square square;

  IconTypes({required this.square});

  factory IconTypes.fromMap(Map<String, dynamic> json) =>
      IconTypes(square: Square.fromMap(json["square"]));
}

class Square {
  final String large;

  Square({required this.large});

  factory Square.fromMap(Map<String, dynamic> json) =>
      Square(large: json["large"]);
}
