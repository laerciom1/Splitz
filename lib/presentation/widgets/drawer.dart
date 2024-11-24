import 'package:flutter/material.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/screens/groups_list.dart';
import 'package:splitz/presentation/widgets/drawer_header.dart';
import 'package:splitz/presentation/widgets/drawer_option.dart';

class SplitzDrawer extends Drawer {
  SplitzDrawer({super.key})
      : super(
          child: Column(
            children: [
              const SplitzDrawerHeader(),
              SplitzDrawerTile(
                label: 'Go to groups',
                leading: const Icon(Icons.group),
                onTap: () =>
                    AppNavigator.replaceAll([const GroupsListScreen()]),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: SplitzDrawerTile(
                    label: 'Logout',
                    leading: const Icon(Icons.logout),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
        );
}
