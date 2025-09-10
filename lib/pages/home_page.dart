import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/transaction.dart';
import '../services/sms_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SmsService _smsService = SmsService();
  late Box<TransactionModel> txnBox;

  @override
  void initState() {
    super.initState();
    txnBox = Hive.box<TransactionModel>('transactions');

    _smsService.listenForMessages((txn) {
      txnBox.add(txn);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactions = txnBox.values.toList();
    final totalCredit = transactions
        .where((t) => t.type == "credit")
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalDebit = transactions
        .where((t) => t.type == "debit")
        .fold(0.0, (sum, t) => sum + t.amount);

    return Scaffold(
      appBar: AppBar(title: const Text("Expense Tracker")),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text("Total Credited: ₹$totalCredit"),
              subtitle: Text("Total Debited: ₹$totalDebit"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final txn = transactions[index];
                return ListTile(
                  title: Text("${txn.category} - ₹${txn.amount}"),
                  subtitle: Text("${txn.bank} | ${txn.type}"),
                  trailing: Text("${txn.date.toLocal()}".split(' ')[0]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
