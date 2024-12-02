import 'package:flutter/material.dart';
import 'package:splitz/extensions/datetime.dart';
import 'package:splitz/presentation/theme/util.dart';

class DateField extends StatefulWidget {
  const DateField({
    required this.onSelect,
    this.initValue,
    super.key,
  });

  final void Function(DateTime) onSelect;
  final DateTime? initValue;

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  late final TextEditingController _controller;
  late final DateTime date;
  @override
  void initState() {
    super.initState();
    date = widget.initValue ?? DateTime.now();
    _controller = TextEditingController()..text = date.toDateFormat('dd/MM/yy');
  }

  @override
  Widget build(BuildContext context) {
    final lastDate = DateTime.now();
    final firstDate = DateTime(lastDate.year - 1, lastDate.month, lastDate.day);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          width: 1.0,
          color: ThemeColors.primary,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextField(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              firstDate: firstDate,
              lastDate: DateTime.now(),
              initialDate: date,
            );
            if (selectedDate != null) {
              widget.onSelect(selectedDate);
              _controller.text = selectedDate.toDateFormat('dd/MM/yy');
            }
          },
          readOnly: true,
          controller: _controller,
          scrollPadding: const EdgeInsets.only(bottom: 32.0),
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }
}
