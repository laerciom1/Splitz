import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/entities/external/expense_entity.dart';
import 'package:splitz/extensions/datetime.dart';
import 'package:splitz/extensions/double.dart';
import 'package:splitz/extensions/strings.dart';

const _imageHeight = 80.0;
const _badgeHeight = 24.0;

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({
    required this.expense,
    this.onDelete,
    this.onCancel,
    this.onSelect,
    this.onRetry,
    super.key,
  });

  final ExpenseEntity expense;
  final Future<bool> Function(ExpenseEntity)? onDelete;
  final Future<bool> Function(ExpenseEntity)? onCancel;
  final Future<bool> Function(ExpenseEntity)? onRetry;
  final void Function(ExpenseEntity)? onSelect;

  Widget getImagePlaceholder(Color backgroundcolor) => Container(
        color: backgroundcolor,
        child: const Padding(
          padding: EdgeInsets.all(4.0),
          child: Center(
            child: Text('Select an image', textAlign: TextAlign.center),
          ),
        ),
      );

  Widget getImage(Color backgroundcolor) => Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        height: _imageHeight,
        width: _imageHeight,
        child: expense.imageUrl.isNotNullNorEmpty
            ? CachedNetworkImage(imageUrl: expense.imageUrl)
            : getImagePlaceholder(backgroundcolor),
      );

  Widget getInfo(String str) => Text(
        style: const TextStyle(fontSize: 12),
        str,
        softWrap: true,
      );

  Widget getExpenseInfo() => Row(
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
              ),
            ],
          ),
        ],
      );

  Widget addingBadgeContent() {
    return const Padding(
      padding: EdgeInsets.all(_badgeHeight / 4),
      child: SizedBox(
        height: _badgeHeight / 2,
        width: _badgeHeight / 2,
        child: CircularProgressIndicator(strokeWidth: 1),
      ),
    );
  }

  Widget errorBadgeContent() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error,
            size: _badgeHeight * .8,
          ),
          SizedBox(width: 4),
          Text(
            'Something went wrong. Swipe to retry or cancel',
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }

  Widget? getBadgeContent() {
    switch (expense.state) {
      case ExpenseEntityState.listed:
      case ExpenseEntityState.example:
        return null;
      case ExpenseEntityState.loading:
        return addingBadgeContent();
      case ExpenseEntityState.createError:
      case ExpenseEntityState.editError:
        return errorBadgeContent();
    }
  }

  DismissDirection getDismissDirection() {
    switch (expense.state) {
      case ExpenseEntityState.listed:
      case ExpenseEntityState.createError:
      case ExpenseEntityState.editError:
        return DismissDirection.horizontal;
      case ExpenseEntityState.loading:
      case ExpenseEntityState.example:
        return DismissDirection.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final placeholderBgColor = Theme.of(context).hoverColor;
    final isOnErrorState = expense.state == ExpenseEntityState.createError ||
        expense.state == ExpenseEntityState.editError;
    final isOnErrorOnEditState = expense.state == ExpenseEntityState.editError;
    final dismissible =
        expense.state == ExpenseEntityState.listed || isOnErrorState;
    final selectable =
        expense.state == ExpenseEntityState.listed && onSelect != null;
    Widget widget = Container(
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius:
            dismissible ? null : const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: getImage(placeholderBgColor),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(expense.description, softWrap: true),
                  getExpenseInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (dismissible) {
      widget = ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Dismissible(
          key: Key('${expense.id}-${expense.categoryId}'),
          confirmDismiss: (direction) async {
            if (isOnErrorState && direction == DismissDirection.startToEnd) {
              return onRetry!(expense);
            }
            if (isOnErrorOnEditState) return onCancel!(expense);
            return onDelete!(expense);
          },
          // start to end
          background: Container(
            color: isOnErrorState ? Colors.green : Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  isOnErrorState ? Icons.refresh : Icons.delete,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // end to start
          secondaryBackground: Container(
            color: isOnErrorOnEditState ? Colors.orange : Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                Icon(
                  isOnErrorOnEditState ? Icons.cancel : Icons.delete,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          child: widget,
        ),
      );
    }

    if (selectable) {
      widget = InkWell(
        onTap: () => onSelect!.call(expense),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: widget,
      );
    }

    final badgeContent = getBadgeContent();
    if (badgeContent != null) {
      final badgeBorderColor = Theme.of(context).colorScheme.primary;
      final badgeColor = Theme.of(context).primaryColor;
      widget = Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            widget,
            Positioned(
              bottom: -1 * (_badgeHeight / 2),
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: badgeBorderColor),
                    borderRadius: BorderRadius.circular(_badgeHeight),
                    color: badgeColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: _badgeHeight,
                          maxHeight: _badgeHeight * 2,
                          minWidth: _badgeHeight,
                        ),
                        child: badgeContent,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    return widget;
  }
}
