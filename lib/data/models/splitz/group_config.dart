import 'dart:convert';

class GroupConfig {
    List<Category>? categories;
    List<SplitConfig>? splitConfig;

    GroupConfig({
        this.categories,
        this.splitConfig,
    });

    GroupConfig copyWith({
        List<Category>? categories,
        List<SplitConfig>? splitConfig,
    }) => 
        GroupConfig(
            categories: categories ?? this.categories,
            splitConfig: splitConfig ?? this.splitConfig,
        );

    factory GroupConfig.fromJson(String str) => GroupConfig.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GroupConfig.fromMap(Map<String, dynamic> json) => GroupConfig(
        categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromMap(x))),
        splitConfig: json["split_config"] == null ? [] : List<SplitConfig>.from(json["split_config"]!.map((x) => SplitConfig.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toMap())),
        "split_config": splitConfig == null ? [] : List<dynamic>.from(splitConfig!.map((x) => x.toMap())),
    };
}

class Category {
    String? suffix;
    String? imageUrl;
    int? id;
    List<SplitConfig>? splitConfig;

    Category({
        this.suffix,
        this.imageUrl,
        this.id,
        this.splitConfig,
    });

    Category copyWith({
        String? suffix,
        String? imageUrl,
        int? id,
        List<SplitConfig>? splitConfig,
    }) => 
        Category(
            suffix: suffix ?? this.suffix,
            imageUrl: imageUrl ?? this.imageUrl,
            id: id ?? this.id,
            splitConfig: splitConfig ?? this.splitConfig,
        );

    factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Category.fromMap(Map<String, dynamic> json) => Category(
        suffix: json["suffix"],
        imageUrl: json["imageUrl"],
        id: json["id"],
        splitConfig: json["split_config"] == null ? [] : List<SplitConfig>.from(json["split_config"]!.map((x) => SplitConfig.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "suffix": suffix,
        "imageUrl": imageUrl,
        "id": id,
        "split_config": splitConfig == null ? [] : List<dynamic>.from(splitConfig!.map((x) => x.toMap())),
    };
}

class SplitConfig {
    int? id;
    String? name;
    String? avatarUrl;
    int? slice;

    SplitConfig({
        this.id,
        this.name,
        this.avatarUrl,
        this.slice,
    });

    SplitConfig copyWith({
        int? id,
        String? name,
        String? avatarUrl,
        int? slice,
    }) => 
        SplitConfig(
            id: id ?? this.id,
            name: name ?? this.name,
            avatarUrl: avatarUrl ?? this.avatarUrl,
            slice: slice ?? this.slice,
        );

    factory SplitConfig.fromJson(String str) => SplitConfig.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SplitConfig.fromMap(Map<String, dynamic> json) => SplitConfig(
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
