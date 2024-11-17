enum FirstScreen { splitzLogin, splitwiseLogin, groupsList, group }

class InitResult {
  final FirstScreen firstScreen;
  final dynamic args;

  InitResult({
    required this.firstScreen,
    this.args,
  });
}
