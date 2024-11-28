import 'dart:async';

import 'package:flutter/material.dart';
import 'package:splitz/data/entities/external/group_entity.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/screens/expenses_list.dart';
import 'package:splitz/presentation/templates/base_screen.dart';
import 'package:splitz/presentation/widgets/context_menu.dart';
import 'package:splitz/presentation/widgets/feedback_message.dart';
import 'package:splitz/presentation/widgets/group_item.dart';
import 'package:splitz/presentation/widgets/loading.dart';
import 'package:splitz/services/splitz_service.dart';

class GroupsListScreen extends StatefulWidget {
  const GroupsListScreen({super.key});

  @override
  State<GroupsListScreen> createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends State<GroupsListScreen> {
  List<GroupEntity>? groups;
  String feedbackMessage = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  void setFeedback(String message) {
    setState(() {
      isLoading = false;
      groups = null;
      feedbackMessage = message;
    });
  }

  void setLoading() {
    setState(() {
      isLoading = true;
      groups = null;
      feedbackMessage = '';
    });
  }

  void setGroups(List<GroupEntity> newGroups) {
    setState(() {
      isLoading = false;
      groups = newGroups;
      feedbackMessage = '';
    });
  }

  Future<void> initScreen() async {
    try {
      setLoading();
      final result = await SplitzService.getGroups();
      if (result.isEmpty) {
        setFeedback(
          'It looks like you dont have groups on your Splitwise account.\n'
          'You can drag down to refresh or create a group on Splitwise app.',
        );
      } else {
        setGroups(result);
      }
    } catch (e, s) {
      const message = 'Something went wrong retrieving your groups.\n'
          'You can drag down to refresh.';
      setFeedback(message.addErrorDescription(e, s));
    }
  }

  Future<void> onSelectGroup(GroupEntity group) async {
    await SplitzService.selectGroup('${group.id}');
    AppNavigator.replaceAll([ExpensesListScreen(groupId: '${group.id}')]);
  }

  Widget getBody() {
    if (isLoading) {
      return const Loading();
    }

    if (feedbackMessage.isNotEmpty) {
      return FeedbackMessage(message: feedbackMessage);
    }

    return getGroups();
  }

  Widget getGroups() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...groups!.map<Widget>((e) {
            return GroupItem(group: e, onTap: onSelectGroup);
          }).intersperse(const SizedBox(height: 2))
        ],
      );

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBarCenterText: 'Groups',
      appBarLeading: ContextMenu(
        direction: TextDirection.ltr,
        icon: Icons.menu,
        children: [
          ContextMenuOption.logout,
        ],
      ),
      onPop: (_, __) async {},
      onRefresh: initScreen,
      child: getBody(),
    );
  }
}
