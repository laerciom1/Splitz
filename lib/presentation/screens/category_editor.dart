import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitz/data/entities/external/expense_entity.dart';
import 'package:splitz/data/entities/splitz/group_config_entity.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/templates/base_screen.dart';
import 'package:splitz/presentation/widgets/category_selector.dart';
import 'package:splitz/presentation/widgets/expense_item.dart';
import 'package:splitz/presentation/widgets/feedback_message.dart';
import 'package:splitz/presentation/widgets/field_primary.dart';
import 'package:splitz/presentation/widgets/footer_action.dart';
import 'package:splitz/presentation/widgets/loading.dart';
import 'package:splitz/presentation/widgets/slice_editor.dart';
import 'package:splitz/presentation/widgets/splitz_divider.dart';
import 'package:splitz/services/splitz_service.dart';

const _defaultCost = '1000.0';

class CategoryEditorScreen extends StatefulWidget {
  const CategoryEditorScreen({
    required this.category,
    required this.groupConfig,
    super.key,
  });

  final SplitzCategory? category;
  final GroupConfigEntity groupConfig;

  @override
  State<CategoryEditorScreen> createState() => _CategoryEditorScreenState();
}

class _CategoryEditorScreenState extends State<CategoryEditorScreen>
    with WidgetsBindingObserver {
  late SplitzCategory _currentCategory;
  late Map<String, SplitzConfig> _customSplitzConfigs;
  List<SplitzCategory>? _availableCategories;

  bool _shoulUseCustomSplitzConfig = false;
  String _feedbackMessage = '';
  bool _isLoading = true;

  late final List<FocusNode> _focusNodes;
  late final FocusNode _preffixFocusNode;
  late final List<TextEditingController> _controllers;
  bool _controllersWasInitialized = false;
  FocusNode? _lastFocusedNode;

  final _bodyScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _customSplitzConfigs = {...widget.groupConfig.splitzConfigs};
    _currentCategory =
        widget.category ?? SplitzCategory(prefix: '', imageUrl: '', id: 0);
    initScreen();
  }

  void setFeedback(String message) {
    setState(() {
      _isLoading = false;
      _availableCategories = [];
      _feedbackMessage = message;
    });
  }

  void setLoading() {
    setState(() {
      _isLoading = true;
      _availableCategories = [];
      _feedbackMessage = '';
    });
  }

  void setAvailableCategories(List<SplitzCategory> categories) {
    setState(() {
      _isLoading = false;
      _availableCategories = categories;
      _feedbackMessage = '';
      if (!_controllersWasInitialized) {
        initializeFocusAndControllers(_customSplitzConfigs);
      }
    });
  }

  Future<void> initScreen() async {
    setLoading();
    try {
      final results = await SplitzService.getAvailableCategories(
        widget.groupConfig.splitzCategories,
      );
      setAvailableCategories(results);
    } catch (e, s) {
      const message =
          'Something went wrong retrieving the available categories.\n'
          'You can drag down to refresh.';
      return setFeedback(message.addErrorDescription(e, s));
    }
  }

  void initializeFocusAndControllers(Map<String, SplitzConfig> splitzConfigs) {
    _controllersWasInitialized = true;
    _preffixFocusNode = FocusNode()..addListener(trackFocusChanges);
    _focusNodes = List.generate(splitzConfigs.length,
        (_) => FocusNode()..addListener(trackFocusChanges));
    _controllers = [
      ...splitzConfigs.values.map(
        (config) => TextEditingController(text: config.slice.toString()),
      )
    ];
  }

  void trackFocusChanges() {
    final focusedNode = [..._focusNodes, _preffixFocusNode]
        .firstWhereOrNull((node) => node.hasFocus);
    _lastFocusedNode = focusedNode;
  }

  @override
  void dispose() {
    _preffixFocusNode.dispose();
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

  void selectImage(SplitzCategory c) => setState(() {
        _currentCategory =
            _currentCategory.copyWith(imageUrl: c.imageUrl, id: c.id);
      });

  void onChangePrefix(String s) => setState(() {
        _currentCategory = _currentCategory.copyWith(prefix: s);
      });

  void toggleUseCustomSlices() => setState(() {
        _shoulUseCustomSplitzConfig = !_shoulUseCustomSplitzConfig;
        if (_shoulUseCustomSplitzConfig) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_bodyScrollController.hasClients) {
              _bodyScrollController.animateTo(
                _bodyScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      });

  void onNewSplitzConfigs(Map<String, SplitzConfig> newConfigs) => setState(() {
        _customSplitzConfigs = newConfigs;
      });

  void save() {
    final category = _currentCategory.copyWith(
      splitzConfigs: _shoulUseCustomSplitzConfig ? _customSplitzConfigs : null,
    );
    AppNavigator.pop(category);
  }

  Widget? getHeader(BuildContext ctx) {
    if (_isLoading || _feedbackMessage.isNotEmpty) {
      return null;
    }

    return getCategoryEditorHeader(ctx);
  }

  Widget getCategoryEditorHeader(BuildContext ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text('Example of an expense of this category:'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ExpenseItem(
              expense: ExpenseEntity.fromSplitzConfig(
                cost: _defaultCost,
                description:
                    '${_currentCategory.prefix.isEmpty ? '' : '${_currentCategory.prefix} '}Expense description',
                imageUrl: _currentCategory.imageUrl,
                splitzConfigs: _customSplitzConfigs,
              ),
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

    return getCategoryEditorBody();
  }

  Widget getCategoryEditorBody() => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('Select an image for this category:'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CategorySelector(
              categories: _availableCategories!,
              onSelect: selectImage,
              selectedCategory: _currentCategory,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('Type a preffix for this category:'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: PrimaryField(
              onChanged: onChangePrefix,
              focusNode: _preffixFocusNode,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Use custom division for this category'),
                Checkbox(
                  value: _shoulUseCustomSplitzConfig,
                  onChanged: (_) => toggleUseCustomSlices(),
                ),
              ],
            ),
          ),
          if (_shoulUseCustomSplitzConfig)
            SliceEditor(
              splitzConfigs: _customSplitzConfigs,
              focusNodes: _focusNodes,
              controllers: _controllers,
              onEditConfigs: onNewSplitzConfigs,
            ),
        ],
      );

  Widget? getBottom(BuildContext ctx) {
    if (_isLoading || _feedbackMessage.isNotEmpty) {
      return null;
    }

    return getCategoryEditorBottom(ctx);
  }

  Widget getCategoryEditorBottom(BuildContext ctx) => ActionFooter(
        onAction: save,
        text: 'Save',
        enabled: _currentCategory.imageUrl.isNotEmpty &&
            _currentCategory.prefix.isNotEmpty,
      );

  @override
  Widget build(BuildContext ctx) {
    return BaseScreen(
      scrollController: _bodyScrollController,
      onRefresh: initScreen,
      topWidget: getHeader(context),
      bottomWidget: getBottom(context),
      child: getBody(),
    );
  }
}
