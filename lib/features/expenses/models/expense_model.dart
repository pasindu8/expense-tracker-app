import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String merchant;
  final double amount;
  final String category;
  final DateTime date;
  final String note;

  Expense({
    required this.id,
    required this.merchant,
    required this.amount,
    required this.category,
    required this.date,
    this.note = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'merchant': merchant,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
      'note': note,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory Expense.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Expense(
      id: doc.id,
      merchant: data['merchant'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      category: data['category'] ?? 'Other',
      date: (data['date'] as Timestamp).toDate(),
      note: data['note'] ?? '',
    );
  }
}