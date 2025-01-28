import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/entities/external/expense_entity.dart';
import 'package:splitz/extensions/datetime.dart';
import 'package:splitz/extensions/double.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/presentation/theme/util.dart';
import 'package:splitz/presentation/widgets/base_item.dart';

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

  Widget getImage() {
    final size = BaseItem.contentMinHeight / (expense.payment ? 2 : 1);
    Widget child;
    if (expense.payment) {
      child = const Icon(Icons.currency_exchange);
    } else {
      child = expense.imageUrl.isNotNullNorEmpty
          ? CachedNetworkImage(imageUrl: expense.imageUrl!)
          : getImagePlaceholder(ThemeColors.surfaceBright);
    }
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
      height: size,
      width: size,
      child: child,
    );
  }

  Widget getInfo(String str, [bool bold = false]) => Text(
        style: TextStyle(
          fontSize: 11,
          fontWeight: bold ? FontWeight.w900 : FontWeight.normal,
        ),
        str,
        softWrap: true,
      );

  Widget getExpenseInfo() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getInfo(expense.date.toDateFormat('dd/MM')),
          if (!expense.payment)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                getInfo(
                  'Total: ${double.parse(expense.cost).toBRL()}',
                ),
                ...expense.users.map((e) {
                  final hasPaid = double.parse(e.paidShare) != 0;
                  return getInfo(
                    '${hasPaid ? '\$ ' : ''}${e.firstName}: ${double.parse(e.owedShare).toBRL()}',
                    hasPaid,
                  );
                }),
              ],
            ),
        ],
      );

  Widget loadingBadgeContent() => const Padding(
        padding: EdgeInsets.all(BaseItem.badgeHeight / 4),
        child: SizedBox(
          height: BaseItem.badgeHeight / 2,
          width: BaseItem.badgeHeight / 2,
          child: CircularProgressIndicator(strokeWidth: 1),
        ),
      );

  Widget errorBadgeContent() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error),
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
        return loadingBadgeContent();
      case ExpenseEntityState.createError:
      case ExpenseEntityState.editError:
        return errorBadgeContent();
    }
  }

  String getPaymentDescription() {
    String payer = '';
    String receiver = '';
    String cost = '';
    for (final user in expense.users) {
      if (payer.isNotEmpty && receiver.isNotEmpty) break;
      if (user.paidShare.isNotNullNorEmpty && user.paidShare != '0.0') {
        payer = user.firstName;
        cost = user.paidShare;
      }
      if (user.owedShare.isNotEmpty && user.owedShare != '0.0') {
        receiver = user.firstName;
        cost = user.owedShare;
      }
    }
    return '$payer paid ${double.parse(cost).toBRL()} to $receiver';
  }

  @override
  Widget build(BuildContext context) {
    final isOnErrorState = expense.state == ExpenseEntityState.createError ||
        expense.state == ExpenseEntityState.editError;
    final isOnErrorOnEditState = expense.state == ExpenseEntityState.editError;
    final dismissible =
        expense.state == ExpenseEntityState.listed || isOnErrorState;
    final selectable =
        expense.state == ExpenseEntityState.listed && onSelect != null;
    final description =
        expense.payment ? getPaymentDescription() : expense.description;
    return BaseItem(
      dismissible: dismissible,
      dismissibleKey: Key('${expense.id}-${expense.categoryId}'),
      dismissibleBgColor: isOnErrorState ? Colors.green : Colors.red,
      dismissibleBgIcon: isOnErrorState ? Icons.refresh : Icons.delete,
      dismissible2ndBgColor: isOnErrorOnEditState ? Colors.orange : Colors.red,
      dismissible2ndBgIcon: isOnErrorOnEditState ? Icons.cancel : Icons.delete,
      confirmDismiss: (direction) async {
        if (isOnErrorState && direction == DismissDirection.startToEnd) {
          return onRetry!(expense);
        }
        if (isOnErrorOnEditState) return onCancel!(expense);
        return onDelete!(expense);
      },
      onTap: selectable ? () => onSelect!.call(expense) : null,
      badgeContent: getBadgeContent(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getImage(),
          const SizedBox(width: 8.0),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description, softWrap: true),
                getExpenseInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
