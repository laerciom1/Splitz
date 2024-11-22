// ignore_for_file: prefer_const_constructors

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/entities/expense_entity.dart';
import 'package:splitz/extensions/datetime.dart';
import 'package:splitz/extensions/double.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/extensions/widgets.dart';

const _cardHeight = 80.0;

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({
    required this.expense,
    required this.categoryPicUrl,
    super.key,
  });

  final ExpenseEntity expense;
  final String? categoryPicUrl;

  Widget getInfo(String str) => Text(
        style: TextStyle(fontSize: 12),
        str,
        softWrap: true,
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _cardHeight,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: _cardHeight,
            width: _cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular((1 / 10) * _cardHeight),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: categoryPicUrl.isNotNullNorEmpty
                ? CachedNetworkImage(imageUrl: categoryPicUrl!)
                : Placeholder(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          'No image yet',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
          ),
          SizedBox(width: 12.0, height: 1),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      expense.description,
                      softWrap: true,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getInfo(expense.date.toDateFormat('dd/MM/yyyy')),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        getInfo(
                          'Total: ${double.parse(expense.cost).toBRL()}',
                        ),
                        ...expense.users.map(
                          (e) => getInfo(
                            '${e.firstName}: ${double.parse(e.owedShare).toBRL()}',
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ).withPadding(EdgeInsets.all(12.0));
  }
}
