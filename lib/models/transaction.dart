import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class TransactionModel {
  @HiveField(0)
  final double amount;

  @HiveField(1)
  final String type; // credit or debit

  @HiveField(2)
  final String bank;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime date;

  TransactionModel({
    required this.amount,
    required this.type,
    required this.bank,
    required this.category,
    required this.date,
  });
}
