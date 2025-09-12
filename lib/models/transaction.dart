// lib/models/transaction.dart
class Transaction {
  String title;
  double amount;
  DateTime date;
  bool isManual; // true if user added manually

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    this.isManual = false,
  });
}
