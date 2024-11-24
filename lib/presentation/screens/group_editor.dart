import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/screens/category_editor.dart';
import 'package:splitz/presentation/screens/expenses_list.dart';
import 'package:splitz/presentation/templates/base_screen.dart';
import 'package:splitz/presentation/widgets/fab_add_category.dart';
import 'package:splitz/presentation/widgets/category_item.dart';
import 'package:splitz/presentation/widgets/feedback_message.dart';
import 'package:splitz/presentation/widgets/loading.dart';
import 'package:splitz/presentation/widgets/slice_editor.dart';
import 'package:splitz/presentation/widgets/splitz_divider.dart';
import 'package:splitz/services/splitz_service.dart';

const _waitTime = Duration(seconds: 1);
const _waitTimeWidth = 24.0;

class GroupEditorScreen extends StatefulWidget {
  const GroupEditorScreen({required this.groupId, super.key});

  final String groupId;

  @override
  State<GroupEditorScreen> createState() => _GroupEditorScreenState();
}

class _GroupEditorScreenState extends State<GroupEditorScreen>
    with WidgetsBindingObserver {
  GroupConfig? _groupConfig;
  String _feedbackMessage = '';
  bool _isLoading = true;
  bool _showWaitingTimer = false;

  late final List<FocusNode> _focusNodes;
  late final List<TextEditingController> _controllers;
  bool _controllersWasInitialized = false;
  FocusNode? _lastFocusedNode;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initScreen();
  }

  void setFeedback(String message) {
    setState(() {
      _isLoading = false;
      _groupConfig = null;
      _feedbackMessage = message;
    });
  }

  void setLoading() {
    setState(() {
      _isLoading = true;
      _groupConfig = null;
      _feedbackMessage = '';
    });
  }

  void setGroupConfig({
    required GroupConfig groupConfig,
    bool? showWaitingTimer,
  }) {
    setState(() {
      _isLoading = false;
      _groupConfig = groupConfig;
      _feedbackMessage = '';
      if (!_controllersWasInitialized) {
        initializeFocusAndControllers(groupConfig.splitConfig);
      }
      if (showWaitingTimer != null) {
        _showWaitingTimer = showWaitingTimer;
      }
    });
  }

  Future<void> initScreen() async {
    setLoading();
    try {
      final splitzGroupConfig =
          await SplitzService.getGroupConfig(widget.groupId);
      final splitwiseGroupInfo =
          await SplitzService.getGroupInfo(widget.groupId);
      final splitConfigs = SplitzService.mergeSplitConfigs(
        splitzGroupConfig?.splitConfig ?? [],
        SplitzService.getSplitConfigsFromMembers(
          splitwiseGroupInfo.group?.members ?? [],
        ),
      );
      setGroupConfig(
        groupConfig: GroupConfig(
          categories: splitzGroupConfig?.categories ?? [],
          splitConfig: splitConfigs,
        ),
      );
    } catch (e, s) {
      const message =
          'Something went wrong retrieving your group information.\n'
          'You can drag down to refresh.';
      return setFeedback(message.addErrorDescription(e, s));
    }
  }

  void initializeFocusAndControllers(List<SplitzConfig> splitConfig) {
    _controllersWasInitialized = true;
    _focusNodes = List.generate(
        splitConfig.length, (_) => FocusNode()..addListener(trackFocusChanges));
    _controllers = [
      ...splitConfig.map(
        (config) => TextEditingController(text: '${config.slice}'),
      )
    ];
  }

  void trackFocusChanges() {
    final focusedNode = _focusNodes.firstWhereOrNull((node) => node.hasFocus);
    _lastFocusedNode = focusedNode;
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_lastFocusedNode != null) {
        Future.delayed(Duration.zero, () {
          _lastFocusedNode!.requestFocus();
          SystemChannels.textInput.invokeMethod('TextInput.show');
        });
      }
    }
  }

  void updateSplitzGroupGroup(
    GroupConfig newGroupConfig, [
    bool shouldTrigger = true,
  ]) {
    _timer?.cancel();
    final oldGroupConfig = _groupConfig!.copyWith();
    setGroupConfig(
      groupConfig: newGroupConfig,
      showWaitingTimer: shouldTrigger,
    );
    if (shouldTrigger) {
      _timer = Timer(_waitTime, () async {
        try {
          await SplitzService.updateSplitzGroupConfig(
            widget.groupId,
            newGroupConfig,
          );
          setState(() {
            _showWaitingTimer = false;
          });
        } catch (_) {
          setGroupConfig(groupConfig: oldGroupConfig, showWaitingTimer: false);
        }
      });
    }
  }

  void onNewSplitzConfigs(List<SplitzConfig> configs) {
    final sum = configs.fold(0, (accu, curr) => accu + curr.slice);
    final newGroupConfig = _groupConfig!.copyWith(splitConfig: configs);
    updateSplitzGroupGroup(newGroupConfig, sum == 100);
  }

  void addCategory() async {
    final newCategory = await AppNavigator.push<SplitzCategory?>(
      CategoryEditorScreen(category: null, groupConfig: _groupConfig!),
    );
    if (newCategory == null) return;
    final newGroupConfig = _groupConfig!.copyWith(
      categories:
          [..._groupConfig!.categories, newCategory].unique((e) => e.id),
    );
    updateSplitzGroupGroup(newGroupConfig);
  }

  void finishEditing() =>
      AppNavigator.replaceAll([ExpensesListScreen(groupId: widget.groupId)]);

  Widget? getHeader(BuildContext ctx) {
    if (_isLoading || _feedbackMessage.isNotEmpty) {
      return null;
    }

    return getGroupEditorHeader(ctx);
  }

  Widget getGroupEditorHeader(BuildContext ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'Default division of expenses among participants:',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                SliceEditor(
                  splitzConfigs: _groupConfig!.splitConfig,
                  focusNodes: _focusNodes,
                  controllers: _controllers,
                  onEditConfigs: onNewSplitzConfigs,
                ),
                if (_showWaitingTimer)
                  const Padding(
                    padding: EdgeInsets.only(right: 24),
                    child: SizedBox(
                      height: _waitTimeWidth,
                      width: _waitTimeWidth,
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(height: 24),
          SplitzDivider(color: Theme.of(ctx).colorScheme.primary)
        ],
      );

  Widget getBody() {
    if (_isLoading) {
      return const Loading();
    }

    if (_feedbackMessage.isNotEmpty) {
      return FeedbackMessage(message: _feedbackMessage);
    }

    return getGroupEditorBody();
  }

  Widget getGroupEditorBody() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                'Categories:',
              ),
            ),
            ..._groupConfig!.categories.map<Widget>(
              (e) {
                return CategoryItem(
                  category: e,
                  splitConfigs: e.splitConfig ?? _groupConfig!.splitConfig,
                );
              },
            ).intersperse(const SizedBox(height: 12)),
            const SizedBox(height: 24)
          ],
        ),
      );

  Widget? getFAB() {
    if (_groupConfig == null || _isLoading || _feedbackMessage.isNotEmpty) {
      return null;
    }
    return AddCategoryFAB(
      enableActions: !_showWaitingTimer,
      onAdd: addCategory,
      onFinish: finishEditing,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      onRefresh: initScreen,
      floatingActionButton: getFAB(),
      topWidget: getHeader(context),
      child: getBody(),
    );
  }
}
