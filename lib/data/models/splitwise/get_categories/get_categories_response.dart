import 'dart:convert';

class GetCategoriesResponse {
    final List<Category>? categories;

    GetCategoriesResponse({
        this.categories,
    });

    factory GetCategoriesResponse.fromJson(String str) => GetCategoriesResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetCategoriesResponse.fromMap(Map<String, dynamic> json) => GetCategoriesResponse(
        categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toMap())),
    };
}

class Category {
    final int? id;
    final String? name;
    final String? icon;
    final IconTypes? iconTypes;
    final List<Category>? subcategories;

    Category({
        this.id,
        this.name,
        this.icon,
        this.iconTypes,
        this.subcategories,
    });

    factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        iconTypes: json["icon_types"] == null ? null : IconTypes.fromMap(json["icon_types"]),
        subcategories: json["subcategories"] == null ? [] : List<Category>.from(json["subcategories"]!.map((x) => Category.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "icon": icon,
        "icon_types": iconTypes?.toMap(),
        "subcategories": subcategories == null ? [] : List<dynamic>.from(subcategories!.map((x) => x.toMap())),
    };
}

class IconTypes {
    final Slim? slim;
    final Square? square;

    IconTypes({
        this.slim,
        this.square,
    });

    factory IconTypes.fromJson(String str) => IconTypes.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory IconTypes.fromMap(Map<String, dynamic> json) => IconTypes(
        slim: json["slim"] == null ? null : Slim.fromMap(json["slim"]),
        square: json["square"] == null ? null : Square.fromMap(json["square"]),
    );

    Map<String, dynamic> toMap() => {
        "slim": slim?.toMap(),
        "square": square?.toMap(),
    };
}

class Slim {
    final String? small;
    final String? large;

    Slim({
        this.small,
        this.large,
    });

    factory Slim.fromJson(String str) => Slim.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Slim.fromMap(Map<String, dynamic> json) => Slim(
        small: json["small"],
        large: json["large"],
    );

    Map<String, dynamic> toMap() => {
        "small": small,
        "large": large,
    };
}

class Square {
    final String? large;
    final String? xlarge;

    Square({
        this.large,
        this.xlarge,
    });

    factory Square.fromJson(String str) => Square.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Square.fromMap(Map<String, dynamic> json) => Square(
        large: json["large"],
        xlarge: json["xlarge"],
    );

    Map<String, dynamic> toMap() => {
        "large": large,
        "xlarge": xlarge,
    };
}
