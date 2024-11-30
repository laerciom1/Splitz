import 'package:splitz/data/entities/external/expense_entity.dart';

class ExportEntity {
  final List<Category> categories;

  ExportEntity._({
    required this.categories,
  });

  factory ExportEntity.fromExpenses(Iterable<ExpenseEntity> expenses) {
    final categoriesMap = <String, Category>{};
    for (final e in expenses) {
      final categoryPrefix = e.description.split(' ')[0];
      final category =
          categoriesMap[categoryPrefix] ?? Category(prefix: categoryPrefix);
      categoriesMap[categoryPrefix] = category.copyWithExpense(e);
    }
    final keys = categoriesMap.keys.toList()..sort();
    final categoriesList = keys.map((key) => categoriesMap[key]!).toList();
    return ExportEntity._(categories: categoriesList);
  }
}

class Category {
  final String prefix;
  final double total;
  final List<ExpenseEntity> expenses;

  Category({
    required this.prefix,
    this.total = 0,
    this.expenses = const [],
  });

  Category copyWithExpense(ExpenseEntity e) => Category(
        prefix: prefix,
        total: total + double.parse(e.cost),
        expenses: [...expenses, e],
      );
}
