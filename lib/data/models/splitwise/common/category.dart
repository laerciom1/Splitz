import 'dart:convert';

class Category {
  int id;
  String? name;
  String? icon;
  IconTypes? iconTypes;
  List<Category>? subcategories;

  Category({
    required this.id,
    this.name,
    this.icon,
    this.iconTypes,
    this.subcategories,
  });

  Category copyWith({
    int? id,
    String? name,
    String? icon,
    IconTypes? iconTypes,
    List<Category>? subcategories,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        iconTypes: iconTypes ?? this.iconTypes,
        subcategories: subcategories ?? this.subcategories,
      );

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        iconTypes: json["icon_types"] == null
            ? null
            : IconTypes.fromMap(json["icon_types"]),
        subcategories: json["subcategories"] == null
            ? []
            : List<Category>.from(
                json["subcategories"]!.map((x) => Category.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "icon": icon,
        "icon_types": iconTypes?.toMap(),
        "subcategories": subcategories == null
            ? []
            : List<dynamic>.from(subcategories!.map((x) => x.toMap())),
      };
}

class IconTypes {
  Slim? slim;
  Square? square;

  IconTypes({
    this.slim,
    this.square,
  });

  IconTypes copyWith({
    Slim? slim,
    Square? square,
  }) =>
      IconTypes(
        slim: slim ?? this.slim,
        square: square ?? this.square,
      );

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
  String? small;
  String? large;

  Slim({
    this.small,
    this.large,
  });

  Slim copyWith({
    String? small,
    String? large,
  }) =>
      Slim(
        small: small ?? this.small,
        large: large ?? this.large,
      );

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
  String? large;
  String? xlarge;

  Square({
    this.large,
    this.xlarge,
  });

  Square copyWith({
    String? large,
    String? xlarge,
  }) =>
      Square(
        large: large ?? this.large,
        xlarge: xlarge ?? this.xlarge,
      );

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
