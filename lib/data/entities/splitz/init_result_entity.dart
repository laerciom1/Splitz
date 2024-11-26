enum FirstScreen { splitzLogin, splitwiseLogin, groupsList, group }

class InitResultEntity {
  final FirstScreen firstScreen;
  final dynamic args;

  InitResultEntity({
    required this.firstScreen,
    this.args,
  });
}
