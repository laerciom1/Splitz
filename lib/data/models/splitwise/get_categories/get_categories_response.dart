import 'package:splitz/data/models/splitwise/common/category_full.dart';

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
