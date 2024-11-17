extension DoubleX on double {
  String toBRL() {
    final split = toString().split('.');
    return 'R\$ ${split[0]}.${split[1]}';
  }
}
