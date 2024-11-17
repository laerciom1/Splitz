extension IterableX<T> on Iterable<T> {
  /// Puts [element] between every element in [list].
  Iterable<T> intersperse(T element) {
    return _intersperse(element, this);
  }
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