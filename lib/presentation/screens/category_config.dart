import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/widgets/category_selector.dart';
import 'package:splitz/presentation/widgets/expense_example.dart';
import 'package:splitz/presentation/widgets/field_primary.dart';
import 'package:splitz/presentation/widgets/slice_editor.dart';
import 'package:splitz/services/splitz_service.dart';

class CategoryConfigScreen extends StatefulWidget {
  const CategoryConfigScreen({
    required this.category,
    required this.groupConfig,
    super.key,
  });

  final SplitzCategory? category;
  final GroupConfig groupConfig;

  @override
  State<CategoryConfigScreen> createState() => _CategoryConfigScreenState();
}

class _CategoryConfigScreenState extends State<CategoryConfigScreen>
    with WidgetsBindingObserver {
  late SplitzCategory _category;
  late GroupConfig _groupConfig;
  late List<SplitzConfig> _splitzConfigs;
  List<SplitzCategory> _availableCategories = [];
  bool _shoulUseCustomSlices = false;

  late final List<FocusNode> _focusNodes;
  late final FocusNode _preffixFocusNode;
  late final List<TextEditingController> _controllers;
  FocusNode? _lastFocusedNode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _category =
        widget.category ?? SplitzCategory(prefix: '', imageUrl: '', id: 0);
    _groupConfig = widget.groupConfig;
    _splitzConfigs = _groupConfig.splitConfig;
    _initScreen();
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

  Future<void> _initScreen() async {
    _initializeFocusAndControllers(_splitzConfigs);
    final results =
        await SplitzService.getAvailableCategories(_groupConfig.categories);
    setState(() {
      _availableCategories = results;
    });
  }

  void _initializeFocusAndControllers(List<SplitzConfig> splitConfig) {
    _preffixFocusNode = FocusNode()..addListener(_trackFocusChanges);
    _focusNodes = List.generate(splitConfig.length,
        (_) => FocusNode()..addListener(_trackFocusChanges));
    _controllers = [
      ...splitConfig.map(
        (config) => TextEditingController(text: config.slice.toString()),
      )
    ];
  }

  void _trackFocusChanges() {
    final focusedNode = [..._focusNodes, _preffixFocusNode]
        .firstWhereOrNull((node) => node.hasFocus);
    _lastFocusedNode = focusedNode;
  }

  void _selectImage(SplitzCategory c) => setState(() {
        _category = _category.copyWith(imageUrl: c.imageUrl, id: c.id);
      });

  void _onChangePrefix(String s) => setState(() {
        _category = _category.copyWith(prefix: s);
      });

  void _toggleUseCustomSlices() {
    setState(() {
      _shoulUseCustomSlices = !_shoulUseCustomSlices;
      if (!_shoulUseCustomSlices) {}
    });
  }

  void _onEditConfig(List<SplitzConfig> newConfigs) {
    setState(() {
      _splitzConfigs = newConfigs;
    });
  }

  void _save() {
    final category = _category.copyWith(
      splitConfig: _shoulUseCustomSlices ? _splitzConfigs : null,
    );
    AppNavigator.pop(category);
  }

  @override
  Widget build(BuildContext ctx) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: ExpenseExample.exampleHeight),
                    const Text(
                        'Select an image for this category (mandatory):'),
                    CategorySelector(
                      categories: _availableCategories,
                      onSelect: _selectImage,
                      selectedCategory: _category,
                    ),
                    const Text('Type a preffix for this category (mandatory):'),
                    PrimaryField(
                      onChanged: _onChangePrefix,
                      focusNode: _preffixFocusNode,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Use custom division for this category'),
                        Checkbox(
                          value: _shoulUseCustomSlices,
                          onChanged: (_) => _toggleUseCustomSlices(),
                        ),
                      ],
                    ),
                    if (_shoulUseCustomSlices)
                      SliceEditor(
                        splitzConfigs: _splitzConfigs,
                        focusNodes: _focusNodes,
                        controllers: _controllers,
                        onEditConfigs: _onEditConfig,
                      ),
                  ].intersperse(const SizedBox(height: 12)).toList(),
                ),
              ),
            ),
            ExpenseExample(
              category: _category,
              configs: _splitzConfigs,
              onSave: _save,
            ),
          ],
        ),
      ),
    );
  }
}
