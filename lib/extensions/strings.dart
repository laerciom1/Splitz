extension StringX on String? {
  bool get isNotNullNorEmpty => this != null && this!.isNotEmpty;
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  String addErrorDescription(Object e, StackTrace s) {
    return '$this\n\n'
        '-- for nerds --\n\n'
        'Error message:\n'
        '${e.toString()}\n\n'
        'Stacktrace:\n'
        '${s.toString()}';
  }

  String get lastChar {
    if (isNullOrEmpty) return '';
    return this!.substring(this!.length - 1);
  }
}
