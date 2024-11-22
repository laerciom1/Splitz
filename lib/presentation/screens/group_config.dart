import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _GroupConfigScreenState extends State<GroupConfigScreen>
    with WidgetsBindingObserver {
  late GroupConfig? _config;
  late final List<FocusNode> _focusNodes;
  late final List<TextEditingController> _controllers;
  FocusNode? _lastFocusedNode;

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
    _focusNodes = List.generate(splitConfig.length,
        (_) => FocusNode()..addListener(_trackFocusChanges));
    _controllers = splitConfig
        .map((config) => TextEditingController(text: config.slice.toString()))
        .toList();
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
    setState(() {
      _config = _config!.copyWith(splitConfig: newConfigs);
    });
  }

  void _addCategory() async {
    final newCategory = await AppNavigator.push<SplitzCategory?>(
      CategoryConfigScreen(
        category: null,
        splitzConfigs: _config!.splitConfig,
      ),
    );
    if (newCategory == null) return;
    setState(() {
      _config = _config!.copyWith(
        categories: [...(_config!.categories), newCategory],
      );
    });
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
                      const Text(
                              'Default division of expenses among participants:')
                          .withPadding(const EdgeInsets.all(24)),
                      SliceEditor(
                        splitzConfigs: _config!.splitConfig,
                        focusNodes: _focusNodes,
                        controllers: _controllers,
                        onEditConfigs: _onEditConfig,
                      ),
                    ],
                  ),
                ),
              )
            : const Loading(),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Add Category'),
          icon: const Icon(Icons.add),
          onPressed: _addCategory,
        ),
      ),
    );
  }
}
