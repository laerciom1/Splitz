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
        initializeFocusAndControllers(groupConfig.splitzConfigs);
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
      final splitzConfigs = SplitzService.mergeSplitzConfigs(
        splitzGroupConfig?.splitzConfigs ?? {},
        SplitzService.getSplitzConfigsFromMembers(
          splitwiseGroupInfo.group?.members ?? [],
        ),
      );
      setGroupConfig(
        groupConfig: GroupConfig(
          splitzCategories: splitzGroupConfig?.splitzCategories ?? {},
          splitzConfigs: splitzConfigs,
        ),
      );
    } catch (e, s) {
      const message =
          'Something went wrong retrieving your group information.\n'
          'You can drag down to refresh.';
      return setFeedback(message.addErrorDescription(e, s));
    }
  }

  void initializeFocusAndControllers(Map<String, SplitzConfig> splitzConfigs) {
    _controllersWasInitialized = true;
    _focusNodes = List.generate(splitzConfigs.length,
        (_) => FocusNode()..addListener(trackFocusChanges));
    _controllers = [
      ...splitzConfigs.values.map(
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

  void updateSplitzGroupConfig(
    GroupConfig groupConfig, [
    bool shouldTrigger = true,
  ]) {
    _timer?.cancel();
    final oldGroupConfig = _groupConfig!.copyWith();
    setGroupConfig(
      groupConfig: groupConfig,
      showWaitingTimer: shouldTrigger,
    );
    if (shouldTrigger) {
      _timer = Timer(_waitTime, () async {
        try {
          await SplitzService.updateSplitzGroupConfig(
            widget.groupId,
            groupConfig,
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

  void onNewSplitzConfigs(Map<String, SplitzConfig> configs) {
    final sum = configs.values.fold(0, (accu, curr) => accu + curr.slice);
    final groupConfig = _groupConfig!.copyWith(splitzConfigs: configs);
    updateSplitzGroupConfig(groupConfig, sum == 100);
  }

  void addCategory() async {
    final category = await AppNavigator.push<SplitzCategory?>(
      CategoryEditorScreen(category: null, groupConfig: _groupConfig!),
    );
    if (category == null) return;
    final groupConfig = _groupConfig!.copyWith(
      splitzCategories: {
        ..._groupConfig!.splitzCategories,
        category.prefix: category
      },
    );
    updateSplitzGroupConfig(groupConfig);
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
                  splitzConfigs: _groupConfig!.splitzConfigs,
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

  Widget getGroupEditorBody() => SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Text('Categories:'),
              ),
              ..._groupConfig!.splitzCategories.values.map<Widget>(
                (e) {
                  return CategoryItem(
                    category: e,
                    splitzConfigs:
                        e.splitzConfigs ?? _groupConfig!.splitzConfigs,
                  );
                },
              ).intersperse(const SizedBox(height: 12)),
              const SizedBox(height: 24)
            ],
          ),
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
