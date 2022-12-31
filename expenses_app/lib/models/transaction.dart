//defining how transaction should look like (ie model)
class Transaction {
  final String id; //to identify
  final String title;
  final double amount;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });
}
