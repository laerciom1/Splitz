import 'package:collection/collection.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitz/data/entities/expense_entity.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/templates/base_screen.dart';
import 'package:splitz/presentation/widgets/expense_item.dart';
import 'package:splitz/presentation/widgets/field_primary.dart';
import 'package:splitz/presentation/widgets/footer_action.dart';
import 'package:splitz/presentation/widgets/slice_editor.dart';
import 'package:splitz/presentation/widgets/splitz_divider.dart';
import 'package:splitz/services/splitz_service.dart';

const _initCost = '0.00';

class ExpenseEditorScreen extends StatefulWidget {
  const ExpenseEditorScreen({
    required this.category,
    required this.groupConfig,
    required this.groupId,
    this.expense,
    super.key,
  });

  final SplitzCategory category;
  final GroupConfig groupConfig;
  final String groupId;
  final ExpenseEntity? expense;

  @override
  State<ExpenseEditorScreen> createState() => _ExpenseEditorScreenState();
}

class _ExpenseEditorScreenState extends State<ExpenseEditorScreen>
    with WidgetsBindingObserver {
  Map<String, SplitzConfig>? _splitzConfigs;
  ExpenseEntity? _expense;

  late final List<TextEditingController> _controllers;
  late final TextEditingController _descriptionController;
  late final TextEditingController _costController;
  late final List<FocusNode> _focusNodes;
  late final FocusNode _descriptionFocusNode;
  late final FocusNode _costFocusNode;
  bool _controllersWasInitialized = false;
  FocusNode? _lastFocusedNode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initScreen();
  }

  Future<void> initScreen() async {
    String? currentUserId;
    if (widget.expense == null) {
      currentUserId = await SplitzService.getCurrentSplitwiseUser();
    }
    setState(() {
      if (widget.expense == null) {
        _splitzConfigs = widget.groupConfig
            .withPayer(currentUserId: currentUserId!)
            .splitzConfigs;
        _expense = ExpenseEntity.fromSplitzConfig(
          cost: _initCost,
          description: '${widget.category.prefix} ',
          groupId: int.parse(widget.groupId),
          categoryId: widget.category.id,
          imageUrl: widget.category.imageUrl,
          splitzConfigs: _splitzConfigs!,
        );
      } else {
        _expense = widget.expense!;
        _splitzConfigs = widget.groupConfig
            .withPayer(users: widget.expense!.users)
            .splitzConfigs;
      }

      initializeFocusAndControllers(_splitzConfigs!);
    });
  }

  String getInitialDescription() =>
      _expense!.description.split('${widget.category.prefix} ')[1];

  void initializeFocusAndControllers(Map<String, SplitzConfig> splitzConfigs) {
    if (!_controllersWasInitialized) {
      _controllersWasInitialized = true;
      _descriptionFocusNode = FocusNode()..addListener(trackFocusChanges);
      _costFocusNode = FocusNode()..addListener(trackFocusChanges);
      _focusNodes = List.generate(splitzConfigs.length,
          (_) => FocusNode()..addListener(trackFocusChanges));
      _descriptionController =
          TextEditingController(text: getInitialDescription());
      _costController = TextEditingController(text: _expense!.cost);
      _controllers = [
        ...splitzConfigs.values.map(
          (config) => TextEditingController(text: config.slice.toString()),
        )
      ];
    }
  }

  void trackFocusChanges() {
    final focusedNode = [..._focusNodes, _descriptionFocusNode, _costFocusNode]
        .firstWhereOrNull((node) => node.hasFocus);
    _lastFocusedNode = focusedNode;
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _costFocusNode.dispose();
    for (final node in _focusNodes) {
      node.dispose();
    }
    _descriptionController.dispose();
    _costController.dispose();
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

  void onChangeDescription(String s) => setState(() {
        _expense =
            _expense!.copyWith(description: '${widget.category.prefix} $s');
      });

  void onChangeCost(String s) => setState(() {
        _expense = _expense!.copyWithShares(
          cost: s,
          splitzConfigs: _splitzConfigs!,
        );
      });

  void onNewSplitzConfigs(Map<String, SplitzConfig> configs) => setState(() {
        _expense = _expense!.copyWithShares(
          splitzConfigs: configs,
        );
        _splitzConfigs = configs;
      });

  void save() => AppNavigator.pop(_expense);

  Widget getExpenseEditorHeader(BuildContext ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_expense == null)
            const Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          if (_expense != null) ...[
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('Expense resume:'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ExpenseItem(expense: _expense!),
            ),
            const SizedBox(height: 24),
            SplitzDivider(color: Theme.of(ctx).colorScheme.primary)
          ]
        ],
      );

  Widget getExpenseEditorBody() => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_expense != null) ...[
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Type a description:'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: PrimaryField(
                  onChanged: onChangeDescription,
                  focusNode: _descriptionFocusNode,
                  controller: _descriptionController,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Type a cost:'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: PrimaryField(
                  onChanged: onChangeCost,
                  focusNode: _costFocusNode,
                  controller: _costController,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      symbol: '',
                      enableNegative: false,
                      turnOffGrouping: true,
                    ),
                    TextInputFormatter.withFunction(
                      (_, newValue) => TextEditingValue(
                        text: newValue.text.isNotEmpty
                            ? newValue.text
                            : _initCost,
                      ),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Select who paid this time:'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SliceEditor(
                  splitzConfigs: _splitzConfigs!,
                  focusNodes: _focusNodes,
                  controllers: _controllers,
                  onEditConfigs: onNewSplitzConfigs,
                  enablePayerSelection: true,
                ),
              ),
            ]
          ],
        ),
      );

  Widget? getExpenseEditorBottom(BuildContext ctx) => ActionFooter(
        onAction: save,
        text: 'Save',
        enabled: (_expense?.description).isNotNullNorEmpty &&
            _expense?.cost != _initCost &&
            _expense?.payerId != null,
      );

  @override
  Widget build(BuildContext ctx) {
    return BaseScreen(
      topWidget: getExpenseEditorHeader(context),
      bottomWidget: getExpenseEditorBottom(context),
      child: getExpenseEditorBody(),
    );
  }
}
