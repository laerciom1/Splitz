import 'package:intl/intl.dart';

extension DateTimeX on DateTime? {
  String toDateFormat(String format) =>
      DateFormat(format).format(this ?? DateTime.now());
}
