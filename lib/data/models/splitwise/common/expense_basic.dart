class ExpenseBasic {
  final int id;

  ExpenseBasic({required this.id});

  factory ExpenseBasic.fromMap(Map json) => ExpenseBasic(id: json["id"]);
}
