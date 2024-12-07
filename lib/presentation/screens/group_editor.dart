import 'dart:async';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitz/data/entities/external/group_entity.dart';
import 'package:splitz/data/entities/splitz/group_config_entity.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/screens/category_editor.dart';
import 'package:splitz/presentation/screens/expenses_list.dart';
import 'package:splitz/presentation/templates/base_screen.dart';
import 'package:splitz/presentation/theme/util.dart';
import 'package:splitz/presentation/widgets/context_menu.dart';
import 'package:splitz/presentation/widgets/fab_add_category.dart';
import 'package:splitz/presentation/widgets/category_item.dart';
import 'package:splitz/presentation/widgets/feedback_message.dart';
import 'package:splitz/presentation/widgets/loading.dart';
import 'package:splitz/presentation/widgets/slice_editor.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
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
  GroupConfigEntity? _groupConfig;
  String _screenTitle = '';
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

  void setData({
    GroupConfigEntity? groupConfig,
    bool? showWaitingTimer,
    String? screenTitle,
    bool? loading,
    String? feedbackMessage,
  }) {
    setState(() {
      _isLoading = loading ?? false;
      _feedbackMessage = feedbackMessage ?? '';
      _groupConfig = groupConfig ?? _groupConfig;
      _screenTitle = screenTitle ?? _screenTitle;
      if (showWaitingTimer != null) {
        _showWaitingTimer = showWaitingTimer;
      }
      if (!_controllersWasInitialized && groupConfig != null) {
        initializeFocusAndControllers(groupConfig.splitzConfigs);
      }
    });
  }

  Future<void> initScreen() async {
    setData(loading: true);
    try {
      final [
        splitzGroupConfig as GroupConfigEntity?,
        splitwiseGroupInfo as GroupEntity,
      ] = await Future.wait([
        SplitzService.getGroupConfig(widget.groupId),
        SplitzService.getGroupInfo(widget.groupId),
      ]);
      final splitzConfigs = SplitzService.mergeSplitzConfigs(
        splitzGroupConfig?.splitzConfigs ?? {},
        SplitzService.getSplitzConfigsFromMembers(
          splitwiseGroupInfo.members,
        ),
      );
      setData(
        screenTitle:
            '${splitzGroupConfig != null ? 'Editing' : 'Creating'} group',
        groupConfig: GroupConfigEntity(
          splitzCategories: splitzGroupConfig?.splitzCategories ?? [],
          splitzConfigs: splitzConfigs,
        ),
      );
    } catch (e, s) {
      const message = 'Something went wrong retrieving your group information. '
          'You can drag down to retry.';
      return setData(feedbackMessage: message.addErrorDescription(e, s));
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
    GroupConfigEntity groupConfig, [
    bool shouldTrigger = true,
  ]) {
    _timer?.cancel();
    final oldGroupConfig = _groupConfig!.copyWith();
    setData(
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
          setData(groupConfig: oldGroupConfig, showWaitingTimer: false);
          showToast(
            'Something went wrong updating your group preferences. '
            'Try again later',
          );
        }
      });
    }
  }

  void onNewSplitzConfigs(Map<String, SplitzConfig> configs) {
    final sum = configs.values.fold(0, (accu, curr) => accu + curr.slice);
    final groupConfig = _groupConfig!.copyWith(splitzConfigs: configs);
    updateSplitzGroupConfig(groupConfig, sum == 100);
  }

  Future<void> onEditCategory([SplitzCategory? categoryToEdit]) async {
    if (_groupConfig == null) return;
    final category = await AppNavigator.push<SplitzCategory?>(
      CategoryEditorScreen(
        category: categoryToEdit,
        groupConfig: _groupConfig!,
      ),
    );
    if (category == null) return;

    final categories = [..._groupConfig!.splitzCategories];
    final prefixMatchIndex =
        categories.indexWhere((e) => e.prefix == category.prefix);

    if (categoryToEdit == null) {
      // Adding new category
      if (prefixMatchIndex != -1) {
        // Updates existing category
        categories[prefixMatchIndex] = category;
        _showCategoryUpdatedToast();
      } else {
        // Adds new category
        categories.insert(0, category);
      }
    } else {
      // Editing category
      final originalIndex = categories.indexOf(categoryToEdit);
      if (prefixMatchIndex != -1) {
        // Updates existing category with the same prefix
        categories[prefixMatchIndex] = category;
        if (prefixMatchIndex != originalIndex) {
          // Removes the old one if the index is different
          categories.removeAt(originalIndex);
          _showCategoryUpdatedToast();
        }
      } else {
        // Updates to a different prefix
        categories[originalIndex] = category;
      }
    }

    updateSplitzGroupConfig(
      _groupConfig!.copyWith(splitzCategories: categories),
    );
  }

  void _showCategoryUpdatedToast() => showToast(
        'A category with this prefix was already registered. '
        'We updated this category instead of creating a new one',
      );

  Future<bool> onDelete(SplitzCategory category) async {
    final categories = [..._groupConfig!.splitzCategories];
    categories.remove(category);
    updateSplitzGroupConfig(
      _groupConfig!.copyWith(splitzCategories: categories),
    );
    return true;
  }

  void onReorder(int oldIndex, int newIndex) {
    final categories = [..._groupConfig!.splitzCategories];
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = categories.removeAt(oldIndex);
    categories.insert(newIndex, item);
    final groupConfig = _groupConfig!.copyWith(splitzCategories: categories);
    updateSplitzGroupConfig(groupConfig);
  }

  void finishEditing() =>
      AppNavigator.replaceAll([ExpensesListScreen(groupId: widget.groupId)]);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBarCenterText: _screenTitle,
      appBarLeading: ContextMenu.primary,
      onPop: (_, __) async => finishEditing(),
      onRefresh: initScreen,
      floatingActionButton: getFAB(),
      topWidget: getHeader(context),
      shouldHaveMaxHeightConstraint: true,
      child: getBody(),
    );
  }

  Widget? getHeader(BuildContext ctx) {
    if (_isLoading || _feedbackMessage.isNotEmpty) return null;
    return getGroupEditorHeader(ctx);
  }

  Widget getGroupEditorHeader(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: Text('Default division of expenses among participants:'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
          SplitzDivider(color: ThemeColors.primary)
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

  Widget getGroupEditorBody() {
    final categories = <CategoryItem>[];

    for (int idx = 0; idx < _groupConfig!.splitzCategories.length; idx += 1) {
      final category = _groupConfig!.splitzCategories[idx];
      final splitzConfigs =
          category.splitzConfigs ?? _groupConfig!.splitzConfigs;
      categories.add(
        CategoryItem(
          key: Key('${category.id}-${category.prefix}'),
          index: idx,
          category: category,
          splitzConfigs: splitzConfigs,
          onDelete: onDelete,
          onSelect: onEditCategory,
        ),
      );
    }

    Widget proxyDecorator(
      Widget child,
      int index,
      Animation<double> animation,
    ) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double scale = lerpDouble(1, 1.02, animValue)!;
          final category = _groupConfig!.splitzCategories[index];
          final splitzConfigs =
              category.splitzConfigs ?? _groupConfig!.splitzConfigs;
          return Material(
            color: Colors.transparent,
            child: Transform.scale(
              scale: scale,
              child: CategoryItem(
                key: Key('${category.id}-${category.prefix}'),
                index: index,
                category: category,
                splitzConfigs: splitzConfigs,
                onDelete: onDelete,
                onSelect: onEditCategory,
              ),
            ),
          );
        },
        child: child,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Categories:'),
          ),
          Expanded(
            child: ReorderableListView(
              proxyDecorator: proxyDecorator,
              onReorder: onReorder,
              children: categories,
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget? getFAB() {
    if (_groupConfig == null || _isLoading || _feedbackMessage.isNotEmpty) {
      return null;
    }
    return AddCategoryFAB(
      enableActions: !_showWaitingTimer,
      onAdd: onEditCategory,
      onFinish: finishEditing,
    );
  }
}
