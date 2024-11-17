// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/models/splitwise/get_expenses/get_expenses_response.dart';
import 'package:splitz/extensions/datetime.dart';
import 'package:splitz/extensions/double.dart';
import 'package:splitz/extensions/widgets.dart';

const _cardHeight = 84.0;
const _imageSize = 44.0;

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({required this.expense, required this.onTap, super.key});

  final Expense expense;
  final void Function(Expense) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(expense),
      borderRadius: BorderRadius.all(
        Radius.circular((1 / 10) * _cardHeight),
      ),
      child: SizedBox(
        height: _cardHeight,
        width: double.infinity,
        child: Row(
          children: [
            Container(
              height: _imageSize,
              width: _imageSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((1 / 10) * _cardHeight),
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: Container(
                decoration: BoxDecoration(color: Colors.amber),
              ),
              // child: CachedNetworkImage(
              //   imageUrl: avatarUrl,
              //   placeholder: (_, __) => CircularProgressIndicator()
              //       .withPadding(EdgeInsets.all((1 / 4) * _cardHeight)),
              // ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        expense.description!,
                        softWrap: true,
                      ),
                      Text(
                        double.parse(expense.cost!).toBRL(),
                        softWrap: true,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.createdAt!.toDateFormat('dd/MM/yyyy'),
                        softWrap: true,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ...expense.users!.map(
                            (e) => Text(
                              '${e.user!.firstName}: ${double.parse(e.owedShare!).toBRL()}',
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ).withPadding(EdgeInsets.all(12)),
            ),
          ],
        ),
      ),
    );
  }
}
