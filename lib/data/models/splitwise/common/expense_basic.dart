class ExpenseBasic {
  final int id;

  ExpenseBasic({required this.id});

  factory ExpenseBasic.fromMap(Map<String, dynamic> json) =>
      ExpenseBasic(id: json["id"]);
}
