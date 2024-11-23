extension StringX on String? {
  bool get isNotNullNorEmpty => this != null && this!.isNotEmpty;
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
