extension StringX on String? {
  bool get isNotNullNorEmpty => this != null && this!.isNotEmpty;
}
