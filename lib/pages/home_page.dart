// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import '../models/transaction.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _transactions = [];

  // Bank & card selection
  String _selectedBank = "Bank";
  String _selectedCard = "";
  final Map<String, List<String>> _bankCards = {
    "SBI": ["Debit Card", "Credit Card"],
    "HDFC": ["Debit Card", "Credit Card"],
    "ICICI": ["Debit Card", "Credit Card"],
    "Axis": ["Debit Card", "Credit Card"],
  };

  // Categories
  final List<Map<String, dynamic>> _categories = [
    {"icon": Icons.fastfood, "label": "Food", "color": Colors.orange},
    {"icon": Icons.directions_car, "label": "Travel", "color": Colors.blue},
    {"icon": Icons.receipt_long, "label": "Bills", "color": Colors.purple},
    {"icon": Icons.shopping_cart, "label": "Shopping", "color": Colors.green},
  ];

  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    _requestSmsPermission();
  }

  void _requestSmsPermission() async {
    bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted ?? false) {
      _listenToIncomingSms();
    }
  }

  void _listenToIncomingSms() {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        if (message.body != null) {
          _parseBankSms(message.body!);
        }
      },
      listenInBackground: false,
    );
  }

  void _parseBankSms(String sms) {
    final RegExp creditRegex = RegExp(
      r'credited.*?(\d+\.?\d*)',
      caseSensitive: false,
    );
    final RegExp debitRegex = RegExp(
      r'debited.*?(\d+\.?\d*)',
      caseSensitive: false,
    );

    double amount = 0;
    String title = "Bank Transaction";

    if (creditRegex.hasMatch(sms)) {
      amount = double.parse(creditRegex.firstMatch(sms)!.group(1)!);
    } else if (debitRegex.hasMatch(sms)) {
      amount = -double.parse(debitRegex.firstMatch(sms)!.group(1)!);
    } else {
      return;
    }

    setState(() {
      _transactions.add(
        Transaction(
          title: title,
          amount: amount,
          date: DateTime.now(),
          isManual: false, // SMS-added
        ),
      );
    });
  }

  void _addTransaction(String title, double amount) {
    setState(() {
      _transactions.add(
        Transaction(
          title: title,
          amount: amount,
          date: DateTime.now(),
          isManual: true, // manual
        ),
      );
    });
  }

  void _openAddTransactionDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Add Transaction"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final amount = double.tryParse(amountController.text) ?? 0;
                if (title.isNotEmpty && amount != 0) {
                  _addTransaction(title, amount);
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _refreshTransactions() {
    setState(() {
      // Keep SMS-added transactions only
      _transactions.removeWhere((tx) => tx.isManual);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Manual transactions cleared!")),
    );
  }

  void _deleteTransaction(int index) {
    final tx = _transactions[index];
    if (!tx.isManual) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot delete SMS-added transaction")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Transaction"),
        content: const Text(
          "Are you sure you want to delete this transaction?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _transactions.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  double get _totalBalance =>
      _transactions.fold(0, (sum, tx) => sum + tx.amount);

  double get _totalIncome => _transactions
      .where((tx) => tx.amount > 0)
      .fold(0, (sum, tx) => sum + tx.amount);

  double get _totalExpenses => _transactions
      .where((tx) => tx.amount < 0)
      .fold(0, (sum, tx) => sum + tx.amount.abs());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        title: Row(
          children: [
            const Text("ExpenseMate"),
            const SizedBox(width: 15),
            // Bank + Card Dropdown
            DropdownButton<String>(
              value: _selectedBank,
              items: ["Bank", ..._bankCards.keys].map((bank) {
                return DropdownMenuItem(value: bank, child: Text(bank));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBank = value!;
                  _selectedCard = "";
                });
              },
            ),
            const SizedBox(width: 10),
            if (_selectedBank != "Bank")
              DropdownButton<String>(
                value: _selectedCard.isEmpty ? null : _selectedCard,
                hint: const Text("Select Card"),
                items: _bankCards[_selectedBank]!
                    .map(
                      (card) =>
                          DropdownMenuItem(value: card, child: Text(card)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCard = value!;
                  });
                },
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTransactions,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.teal,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Balance",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "₹${_totalBalance.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Income",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "₹${_totalIncome.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Expenses",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "₹${_totalExpenses.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Categories
            const Text(
              "Quick Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _categories.map((cat) {
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      // ignore: deprecated_member_use
                      backgroundColor: (cat["color"] as Color).withOpacity(0.2),
                      child: Icon(cat["icon"], color: cat["color"], size: 28),
                    ),
                    const SizedBox(height: 6),
                    Text(cat["label"], style: const TextStyle(fontSize: 14)),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Recent Transactions
            const Text(
              "Recent Transactions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _transactions.isEmpty
                ? const Center(
                    child: Text("No transactions yet. Tap + to add one."),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _transactions.length,
                    itemBuilder: (ctx, index) {
                      final tx = _transactions[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        elevation: 3,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: Text(
                              tx.title[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(tx.title),
                          subtitle: Text("${tx.date.toLocal()}".split(' ')[0]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "₹${tx.amount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: tx.amount >= 0
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (tx.isManual)
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteTransaction(index),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: _openAddTransactionDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
