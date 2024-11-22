// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/widgets.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/screens/category_config.dart';
import 'package:splitz/presentation/widgets/loading.dart';
import 'package:splitz/presentation/widgets/slice_editor.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/splitz_service.dart';

class GroupConfigScreen extends StatefulWidget {
  const GroupConfigScreen({
    required this.id,
    required this.config,
    super.key,
  });

  final String id;
  final GroupConfig? config;

  @override
  State<GroupConfigScreen> createState() => _GroupConfigScreenState();
}

class _GroupConfigScreenState extends State<GroupConfigScreen> {
  late GroupConfig? config;

  @override
  void initState() {
    super.initState();
    config = widget.config;
    syncGroup();
  }

  Future<void> syncGroup({bool forceSync = false}) async {
    if (config == null || forceSync) {
      final groupInfo = await SplitzService.getGroupInfo(widget.id);
      if (groupInfo == null) {
        showToast(
          'Something went wrong retrieving your group. Drag down to refresh.',
        );
      } else {
        final splitConfigsFromMembers =
            SplitzService.getSplitConfigsFromMembers(
          groupInfo.group?.members ?? [],
        );
        /* The order here is important. SplitConfigs from the widget MUST be the
           first param, because they have priority
        */
        final splitConfigs = SplitzService.mergeSplitConfigs(
          widget.config?.splitConfig ?? [],
          splitConfigsFromMembers,
        );
        setState(() {
          config = GroupConfig(
            categories: config?.categories ?? [],
            splitConfig: splitConfigs,
          );
        });
      }
    }
  }

  void addCategory() async {
    final groupConfig = await AppNavigator.push<GroupConfig?>(
      CategoryConfigScreen(category: null, groupConfig: config!),
    );
    if (groupConfig == null) return;
    setState(() {
      config = groupConfig;
    });
  }

  void onEditConfig(GroupConfig newConfig) {
    setState(() {
      config = newConfig;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return SafeArea(
      child: Scaffold(
        body: config != null
            ? RefreshIndicator(
                onRefresh: () => syncGroup(forceSync: true),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Default division of expenses among participants:')
                          .withPadding(EdgeInsets.all(24)),
                      SliceEditor(config: config!, onEditConfig: onEditConfig),
                    ],
                  ),
                ),
              )
            : const Loading(),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Add Category'),
          icon: const Icon(Icons.add),
          onPressed: addCategory,
        ),
      ),
    );
  }
}
