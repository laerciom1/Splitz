extension IterableX<T, E> on Iterable<T>? {
  /// Puts [element] between every element in [list].
  Iterable<T> intersperse(T element) {
    return _intersperse(element, this ?? []);
  }

  List<T> unique([E Function(T element)? id]) {
    final ids = <E>{};
    var list = List<T>.from(this ?? []);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as E));
    return list;
  }

  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

Iterable<T> _intersperse<T>(T element, Iterable<T> iterable) sync* {
  final iterator = iterable.iterator;
  if (iterator.moveNext()) {
    yield iterator.current;
    while (iterator.moveNext()) {
      yield element;
      yield iterator.current;
    }
  }
}
