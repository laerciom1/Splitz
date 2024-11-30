import 'package:flutter/material.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/screens/expenses_export.dart';
import 'package:splitz/presentation/screens/groups_list.dart';
import 'package:splitz/presentation/screens/login_splitz.dart';
import 'package:splitz/services/splitz_service.dart';

const _iconSize = 24.0;

class ContextMenu extends StatelessWidget {
  const ContextMenu({
    required this.direction,
    required this.icon,
    this.children = const [],
    super.key,
  });

  final TextDirection direction;
  final IconData icon;
  final List<ContextMenuOption> children;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: direction,
      child: MenuAnchor(
        builder: (context, controller, child) => IconButton(
          iconSize: _iconSize,
          onPressed: () {
            (controller.isOpen ? controller.close : controller.open).call();
          },
          icon: Icon(icon),
        ),
        menuChildren: (children as List<Widget>)
            .intersperse(const SizedBox(height: 8.0))
            .toList(),
      ),
    );
  }

  static ContextMenu get primary => ContextMenu(
        direction: TextDirection.ltr,
        icon: Icons.menu,
        children: [
          ContextMenuOption.groups,
          ContextMenuOption.logout,
        ],
      );
}

class ContextMenuOption extends StatelessWidget {
  const ContextMenuOption({
    required this.child,
    this.onTap,
    super.key,
  });

  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Widget tempChild = child;
    if (onTap != null) {
      tempChild = InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: tempChild,
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: tempChild,
    );
  }

  static ContextMenuOption get groups => ContextMenuOption(
        onTap: () => AppNavigator.replaceAll([const GroupsListScreen()]),
        child: const Row(
          children: [
            Icon(Icons.group),
            SizedBox(width: 12),
            Text('Groups'),
          ],
        ),
      );

  static ContextMenuOption export(int groupId) => ContextMenuOption(
        onTap: () =>
            AppNavigator.push(ExpensesExportScreen(groupId: '$groupId')),
        child: const Row(
          children: [
            Icon(Icons.cloud_upload),
            SizedBox(width: 12),
            Text('Export'),
          ],
        ),
      );

  static ContextMenuOption get logout => ContextMenuOption(
        onTap: () {
          SplitzService.signOut();
          AppNavigator.replaceAll([const SplitzLoginScreen()]);
        },
        child: const Row(
          children: [
            Icon(Icons.logout),
            SizedBox(width: 12),
            Text('Logout'),
          ],
        ),
      );
}
