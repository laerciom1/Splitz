extension DoubleX on double {
  String toBRL() {
    final split = toStringAsFixed(2).split('.');
    return 'R\$ ${split[0]}.${split[1]}';
  }
}
