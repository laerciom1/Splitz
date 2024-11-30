// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:splitz/data/entities/external/expense_entity.dart';
import 'package:splitz/data/entities/splitz/export_entity.dart';
import 'package:splitz/extensions/datetime.dart';
import 'package:splitz/extensions/double.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/templates/base_screen.dart';
import 'package:splitz/presentation/theme/util.dart';
import 'package:splitz/presentation/widgets/button_primary.dart';
import 'package:splitz/presentation/widgets/button_secondary.dart';
import 'package:splitz/presentation/widgets/feedback_message.dart';
import 'package:splitz/presentation/widgets/footer_action.dart';
import 'package:splitz/presentation/widgets/loading.dart';
import 'package:splitz/presentation/widgets/splitz_divider.dart';
import 'package:splitz/services/splitz_service.dart';

const _spacing = 24.0;
const _expenseTextStyle = TextStyle(fontSize: 12);

class ExpensesExportScreen extends StatefulWidget {
  const ExpensesExportScreen({
    required this.groupId,
    super.key,
  });

  final String groupId;

  @override
  State<ExpensesExportScreen> createState() => _ExpensesExportStateScreen();
}

class _ExpensesExportStateScreen extends State<ExpensesExportScreen> {
  late final List<DateTime> _monthOptions;

  ExportEntity? _export;
  DateTime? _selectedMonth;
  String _feedbackMessage = '';
  bool _isLoading = false;

  Future<void> Function()? _lastFunc;

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  void setData({
    ExportEntity? export,
    DateTime? selectedMonth,
    String feedbackMessage = '',
    bool isLoading = false,
  }) {
    setState(() {
      _export = export ?? _export;
      _selectedMonth = selectedMonth ?? _selectedMonth;
      _feedbackMessage = feedbackMessage;
      _isLoading = isLoading;
    });
  }

  Future<void> initScreen() async {
    final today = DateTime.now();
    _monthOptions = List.generate(
      12,
      (idx) => DateTime(today.year, today.month - (idx + 1), 1),
    );
  }

  Future<void> getMonthResume(DateTime date) async {
    _lastFunc = () => getMonthResume(date);
    try {
      setData(selectedMonth: date, isLoading: true);
      final export =
          await SplitzService.getExportExpenses(widget.groupId, date);
      setData(export: export);
    } catch (e, s) {
      const message =
          'Something went wrong retrieving the expenses of this month.\n'
          'You can drag down to retry or select other month.';
      setData(feedbackMessage: message.addErrorDescription(e, s));
    }
  }

  Future<void> export() async {
    _lastFunc = export;
    try {
      setData(isLoading: true);
      await SplitzService.exportExpenses(_export!);
      setData();
    } catch (e, s) {
      const message = 'Something went wrong exporting to GSheets.\n'
          'You can drag down to retry or select other month.';
      setData(feedbackMessage: message.addErrorDescription(e, s));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBarCenterText: 'Exporting expenses',
      bottomWidget: getBottom(),
      onRefresh: _lastFunc,
      child: getBody(),
    );
  }

  Widget getBody() {
    if (_isLoading) {
      return const Loading();
    }

    if (_feedbackMessage.isNotEmpty) {
      return FeedbackMessage(message: _feedbackMessage);
    }

    if (_export == null) return getEmptyState();

    return getExport();
  }

  Widget getEmptyState() => Text('Select a month');

  Widget getExportExpense(ExpenseEntity e) => Row(
        children: [
          Text(
            e.date.toDateFormat('dd/MM'),
            style: _expenseTextStyle,
          ),
          SizedBox(width: _spacing / 4),
          Text(
            e.description,
            style: _expenseTextStyle,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _spacing / 4,
              ),
              child: SplitzDivider(
                color: ThemeColors.surfaceBright,
              ),
            ),
          )
        ],
      );

  Widget getExportCategory(Category category) {
    final costs = category.expenses.map((e) => double.parse(e.cost).toBRL());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${category.prefix}: ${category.total.toBRL()}'),
        SizedBox(height: _spacing * (1 / 3)),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [...category.expenses.map(getExportExpense)],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...costs.map((e) => Text(e, style: _expenseTextStyle)),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget getExport() => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: _spacing,
          horizontal: _spacing / 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._export!.categories
                .map<Widget>(getExportCategory)
                .intersperse(SizedBox(height: _spacing))
          ],
        ),
      );

  Widget getBottom() => ActionFooter(
        onAction: export,
        text: 'Export',
        enabled: _export != null,
        leading: PrimaryButton(
          text: selectButtonText,
          onPressed: openMonthSelector,
          enabled: true,
        ),
      );

  String get selectButtonText {
    return _selectedMonth == null
        ? 'Select a month'
        : _selectedMonth.toDateFormat('MMM/yy');
  }

  void openMonthSelector() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => getMonthSelectorBody(),
    );
  }

  Widget getMonthSelectorBody() => Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ThemeColors.surfaceBright,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_spacing),
            topRight: Radius.circular(_spacing),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            _spacing * (2 / 3),
            _spacing * (2 / 3),
            _spacing * (2 / 3),
            0,
          ),
          child: Container(
            padding: EdgeInsets.all(_spacing / 3),
            decoration: BoxDecoration(
              color: ThemeColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_spacing / 2),
                topRight: Radius.circular(_spacing / 2),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: _monthOptions.map(getMonthOption).toList(),
              ),
            ),
          ),
        ),
      );

  Widget getMonthOption(DateTime e) => SizedBox(
        width: double.infinity,
        child: SecondaryButton(
          text: e.toDateFormat('MMM/yy'),
          onPressed: () {
            AppNavigator.pop();
            getMonthResume(e);
          },
        ),
      );
}
