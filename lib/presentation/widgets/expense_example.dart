import 'package:flutter/material.dart';
import 'package:splitz/data/entities/expense_entity.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/widgets.dart';
import 'package:splitz/presentation/widgets/button_primary.dart';
import 'package:splitz/presentation/widgets/expense_item.dart';

const _defaultCost = '1000.0';

class ExpenseExample extends StatelessWidget {
  static const exampleHeight = 196.0;

  const ExpenseExample({
    required this.category,
    required this.configs,
    required this.onSave,
    super.key,
  });

  final SplitzCategory category;
  final List<SplitzConfig> configs;
  final void Function() onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: exampleHeight,
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Example of an expense of this category:')
              .withPadding(const EdgeInsets.only(top: 12, left: 12)),
          ExpenseItem(
            expense: ExpenseEntity(
              id: 0,
              cost: _defaultCost,
              description:
                  '${category.suffix.isEmpty ? '' : '${category.suffix} '}Expense description',
              date: DateTime.now(),
              currencyCode: 'BRL',
              categoryId: 0,
              groupId: 0,
              users: configs.map(
                (e) {
                  final owedShare =
                      (e.slice / 100) * double.parse(_defaultCost);
                  return UserExpenseEntity(
                    firstName: e.name,
                    userId: e.id,
                    owedShare: owedShare.toString(),
                  );
                },
              ).toList(),
            ),
            categoryPicUrl: category.imageUrl,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PrimaryButton(text: 'Save', onPressed: onSave),
            ],
          ).withPadding(const EdgeInsets.symmetric(horizontal: 12)),
        ],
      ),
    );
  }
}
