import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitz/data/entities/external/expense_entity.dart';
import 'package:splitz/data/entities/splitz/group_config_entity.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/templates/base_screen.dart';
import 'package:splitz/presentation/widgets/button_primary.dart';
import 'package:splitz/presentation/widgets/field_date.dart';
import 'package:splitz/presentation/widgets/field_primary.dart';
import 'package:splitz/presentation/widgets/footer_action.dart';
import 'package:splitz/presentation/widgets/user_selector.dart';
import 'package:splitz/services/splitz_service.dart';

const _initCost = '0.00';
const _fieldTitleVPadding = 8.0;
const _fieldTitleHPadding = 16.0;

class PaymentEditorScreen extends StatefulWidget {
  const PaymentEditorScreen({
    required this.groupConfig,
    required this.groupId,
    this.expense,
    super.key,
  });

  final GroupConfigEntity groupConfig;
  final String groupId;
  final ExpenseEntity? expense;

  @override
  State<PaymentEditorScreen> createState() => _PaymentEditorScreenState();
}

class _PaymentEditorScreenState extends State<PaymentEditorScreen>
    with WidgetsBindingObserver {
  Map<String, SplitzConfig>? _splitzConfigs;
  ExpenseEntity? _expense;
  SplitzConfig? _payer;
  SplitzConfig? _receiver;
  String _screenTitle = '';

  late final TextEditingController _costController;
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
    String currentUserId = '';
    if (widget.expense == null) {
      currentUserId = await SplitzService.getCurrentSplitwiseUser();
    }
    setState(() {
      _splitzConfigs = widget.groupConfig.splitzConfigs;
      if (widget.expense == null) {
        _screenTitle = 'Creating payment';
        _expense = ExpenseEntity.payment(groupId: int.parse(widget.groupId));
        _payer = _splitzConfigs![currentUserId];
      } else {
        _screenTitle = 'Editing payment';
        _expense = widget.expense!;
        String payerId = '';
        String receiverId = '';
        for (final user in _expense!.users) {
          if (payerId.isNotEmpty && receiverId.isNotEmpty) break;
          if (double.parse(user.paidShare) != 0) {
            payerId = '${user.userId}';
          }
          if (double.parse(user.owedShare) != 0) {
            receiverId = '${user.userId}';
          }
        }
        _payer = _splitzConfigs![payerId];
        _receiver = _splitzConfigs![receiverId];
      }
      initializeFocusAndControllers(_splitzConfigs!);
    });
  }

  void initializeFocusAndControllers(Map<String, SplitzConfig> splitzConfigs) {
    if (!_controllersWasInitialized) {
      _controllersWasInitialized = true;
      _costFocusNode = FocusNode()..addListener(trackFocusChanges);
      _costController = TextEditingController(text: _expense!.cost);
    }
  }

  void trackFocusChanges() {
    _lastFocusedNode = _costFocusNode.hasFocus ? _costFocusNode : null;
  }

  @override
  void dispose() {
    _costFocusNode.dispose();
    _costController.dispose();
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

  void onChangeCost(String s) => setState(() {
        _expense = _expense!.copyWithShares(
          cost: s,
          splitzConfigs: _splitzConfigs!,
        );
      });

  void onChangeDate(DateTime d) => setState(() {
        _expense = _expense!.copyWith(date: d);
      });

  void onChangePayer(SplitzConfig payer) => setState(() {
        if (_payer?.id == payer.id) {
          _payer = null;
        } else {
          _payer = payer;
        }
        if (_receiver?.id == _payer?.id) _receiver = null;
      });

  void onChangeReceiver(SplitzConfig receiver) => setState(() {
        if (_receiver?.id == receiver.id) {
          _receiver = null;
        } else {
          _receiver = receiver;
        }
        if (_receiver?.id == _payer?.id) _payer = null;
      });

  void cancel() => AppNavigator.pop();

  void save() {
    final payer = UserExpenseEntity(
      userId: _payer!.id,
      firstName: _payer!.name,
      owedShare: '0.0',
      paidShare: _expense!.cost,
    );
    final receiver = UserExpenseEntity(
      userId: _receiver!.id,
      firstName: _receiver!.name,
      owedShare: _expense!.cost,
      paidShare: '0.0',
    );
    AppNavigator.pop(_expense!.copyWith(users: [payer, receiver]));
  }

  @override
  Widget build(BuildContext ctx) {
    return BaseScreen(
      appBarCenterText: _screenTitle,
      bottomWidget: getPaymentEditorBottom(ctx),
      child: getPaymentEditorBody(),
    );
  }

  Widget getPaymentEditorBody() => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_expense != null && _splitzConfigs != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _fieldTitleHPadding,
                  vertical: _fieldTitleVPadding,
                ),
                child: UserSelector(
                  splitzConfigs: _splitzConfigs!,
                  onChangeSelection: onChangePayer,
                  title: 'Who paid? ${_payer?.name ?? ''}',
                  selection: _payer,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _fieldTitleHPadding,
                  vertical: _fieldTitleVPadding,
                ),
                child: UserSelector(
                  splitzConfigs: _splitzConfigs!,
                  onChangeSelection: onChangeReceiver,
                  title: 'To whom? ${_receiver?.name ?? ''}',
                  selection: _receiver,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _fieldTitleHPadding,
                  vertical: _fieldTitleVPadding,
                ),
                child: Text('How much?'),
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
                      (_, newValue) {
                        if (newValue.text.isNullOrEmpty) {
                          return const TextEditingValue(text: _initCost);
                        }
                        final parts = newValue.text.split('.');
                        final intPart = int.parse(parts[0]);
                        final inputedDigit = int.parse(parts[1].lastChar);
                        final newText = '${intPart + inputedDigit}.00';
                        return TextEditingValue(text: newText);
                      },
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _fieldTitleHPadding,
                  vertical: _fieldTitleVPadding,
                ),
                child: Text('When?'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: DateField(
                  initValue: _expense!.date,
                  onSelect: onChangeDate,
                ),
              ),
            ]
          ],
        ),
      );

  Widget? getPaymentEditorBottom(BuildContext ctx) => ActionFooter(
        onAction: save,
        text: 'Save',
        enabled:
            _expense?.cost != _initCost && _payer != null && _receiver != null,
        leading: PrimaryButton(
          text: 'Cancel',
          onPressed: cancel,
          enabled: true,
        ),
      );
}
