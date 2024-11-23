import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/screens/category_config.dart';
import 'package:splitz/presentation/widgets/category_item.dart';
import 'package:splitz/presentation/widgets/loading.dart';
import 'package:splitz/presentation/widgets/slice_editor.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/splitz_service.dart';

const _waitTime = Duration(seconds: 2);
const _waitTimeWidth = 24.0;

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

class _GroupConfigScreenState extends State<GroupConfigScreen>
    with WidgetsBindingObserver {
  late GroupConfig? _config;
  late final List<FocusNode> _focusNodes;
  late final List<TextEditingController> _controllers;
  FocusNode? _lastFocusedNode;
  Timer? _timer;
  bool _showWaitingTime = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _config = widget.config;
    _syncGroup();
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

  void _initializeFocusAndControllers(List<SplitzConfig> splitConfig) {
    if (_focusNodes.isEmpty) {
      _focusNodes = List.generate(splitConfig.length,
          (_) => FocusNode()..addListener(_trackFocusChanges));
      _controllers = [
        ...splitConfig.map(
          (config) => TextEditingController(text: '${config.slice}'),
        )
      ];
    }
  }

  void _trackFocusChanges() {
    final focusedNode = _focusNodes.firstWhereOrNull((node) => node.hasFocus);
    _lastFocusedNode = focusedNode;
  }

  Future<void> _syncGroup({bool forceSync = false}) async {
    if (_config != null && !forceSync) {
      setState(() {
        _initializeFocusAndControllers(_config!.splitConfig);
      });
      return;
    }
    final groupInfo = await SplitzService.getGroupInfo(widget.id);
    if (groupInfo == null) {
      showToast(
        'Something went wrong retrieving your group. Drag down to refresh.',
      );
    } else {
      final splitConfigs = SplitzService.mergeSplitConfigs(
        widget.config?.splitConfig ?? [],
        SplitzService.getSplitConfigsFromMembers(
          groupInfo.group?.members ?? [],
        ),
      );
      setState(() {
        _config = GroupConfig(
          categories: _config?.categories ?? [],
          splitConfig: splitConfigs,
        );
        _initializeFocusAndControllers(splitConfigs);
      });
    }
  }

  void _onEditConfig(List<SplitzConfig> newConfigs) {
    _timer?.cancel();
    setState(() {
      _config = _config!.copyWith(splitConfig: newConfigs);
      final sum =
          _config!.splitConfig.fold(0, (accu, curr) => accu += curr.slice);
      if (sum == 100) {
        _showWaitingTime = true;
        _timer = Timer(_waitTime, () async {
          await SplitzService.saveSplitzConfig(widget.id, _config!, newConfigs);
          // TODO: Handle errors
          setState(() {
            _showWaitingTime = false;
          });
        });
      }
    });
  }

  void _addCategory() async {
    final newCategory = await AppNavigator.push<SplitzCategory?>(
      CategoryConfigScreen(category: null, groupConfig: _config!),
    );
    if (newCategory == null) return;
    final newConfig =
        await SplitzService.saveCategory(widget.id, _config!, newCategory);
    // TODO: Handle errors
    if (newConfig != null) {
      setState(() {
        _config = newConfig;
      });
    }
  }

  void _finishEditing() {
    AppNavigator.pop(_config!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _config != null
            ? RefreshIndicator(
                onRefresh: () => _syncGroup(forceSync: true),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Default division of expenses among participants:',
                        ),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          SliceEditor(
                            splitzConfigs: _config!.splitConfig,
                            focusNodes: _focusNodes,
                            controllers: _controllers,
                            onEditConfigs: _onEditConfig,
                          ),
                          if (_showWaitingTime)
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
                      const Divider(
                        indent: 36,
                        endIndent: 36,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Categories:',
                        ),
                      ),
                      ..._config!.categories.map<Widget>(
                        (e) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: CategoryItem(
                              category: e,
                              splitConfigs:
                                  e.splitConfig ?? _config!.splitConfig,
                            ),
                          );
                        },
                      ).intersperse(const SizedBox(height: 12)),
                      const SizedBox(height: 120)
                    ],
                  ),
                ),
              )
            : const Loading(),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.extended(
              heroTag: null,
              label: const Text('Add Category'),
              icon: const Icon(Icons.add),
              onPressed: _addCategory,
            ),
            const SizedBox(height: 12),
            FloatingActionButton.extended(
              heroTag: null,
              label: const Text('Finish editing'),
              icon: const Icon(Icons.check),
              onPressed: _finishEditing,
            ),
          ],
        ),
      ),
    );
  }
}
