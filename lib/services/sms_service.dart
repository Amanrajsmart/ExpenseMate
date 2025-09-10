import 'package:telephony/telephony.dart';
import '../models/transaction.dart';

class SmsService {
  final Telephony telephony = Telephony.instance;

  void listenForMessages(Function(TransactionModel) onTransaction) {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        if (message.body != null) {
          final txn = parseMessage(message.body!);
          if (txn != null) onTransaction(txn);
        }
      },
      listenInBackground: false,
    );
  }

  TransactionModel? parseMessage(String body) {
    // Detect amount
    final amountRegex = RegExp(r'INR\s?([\d,]+\.?\d*)');
    final match = amountRegex.firstMatch(body);
    if (match == null) return null;

    final amount = double.tryParse(match.group(1)!.replaceAll(',', '')) ?? 0;

    // Detect type
    String type = body.toLowerCase().contains("debited") ? "debit" : "credit";

    // Detect bank (basic)
    String bank = body.contains("ICICI")
        ? "ICICI"
        : body.contains("HDFC")
        ? "HDFC"
        : "Unknown Bank";

    // Detect category (basic keywords)
    String category = body.contains("AMAZON")
        ? "Shopping"
        : body.contains("SWIGGY")
        ? "Food"
        : body.contains("OLA")
        ? "Travel"
        : "Other";

    return TransactionModel(
      amount: amount,
      type: type,
      bank: bank,
      category: category,
      date: DateTime.now(),
    );
  }
}
