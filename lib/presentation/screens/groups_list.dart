import 'package:flutter/material.dart';
import 'package:splitz/data/models/splitwise/common/group.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/screens/expenses.dart';
import 'package:splitz/presentation/widgets/group_item.dart';
import 'package:splitz/presentation/widgets/loading.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/splitz_service.dart';

class GroupsListScreen extends StatefulWidget {
  const GroupsListScreen({super.key});

  @override
  State<GroupsListScreen> createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends State<GroupsListScreen> {
  List<Group>? groups;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  Future<void> getGroups({bool refreshing = false}) async {
    setState(() {
      groups = null;
      isRefreshing = refreshing;
    });
    final result = await SplitzService.getGroups();
    if (result == null) {
      showToast(
        'Something went wrong retrieving your groups. Drag down to refresh.',
      );
    } else {
      setState(() {
        groups = result;
        isRefreshing = false;
      });
    }
  }

  Future<void> onSelectGroup(Group group) async {
    await SplitzService.selectGroup('${group.id}');
    AppNavigator.push(ExpensesScreen(groupId: '${group.id}'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: groups != null
            ? RefreshIndicator(
                onRefresh: () => getGroups(refreshing: true),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...groups!
                            .map<Widget>(
                              (e) => GroupItem(group: e, onTap: onSelectGroup),
                            )
                            .intersperse(
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Divider(
                                  height: 1,
                                  indent: 24,
                                  endIndent: 24,
                                ),
                              ),
                            )
                      ],
                    ),
                  ),
                ),
              )
            : isRefreshing
                ? const SizedBox()
                : const Loading(),
      ),
    );
  }
}
