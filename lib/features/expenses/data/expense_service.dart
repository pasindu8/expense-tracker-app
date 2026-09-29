import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense_model.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

  CollectionReference get _expensesRef {
    if (userId == null) throw Exception("User not authenticated");
    return _firestore.collection('users').doc(userId).collection('expenses');
  }

  Stream<List<Expense>> streamExpenses() {
    if (userId == null) return Stream.value([]);
    return _expensesRef
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
    });
  }

  Future<void> addExpense(Expense expense) async {
    await _expensesRef.add(expense.toMap());
  }

  Future<void> updateExpense(Expense expense) async {
    await _expensesRef.doc(expense.id).update({
      'merchant': expense.merchant,
      'amount': expense.amount,
      'category': expense.category,
      'date': Timestamp.fromDate(expense.date),
      'note': expense.note,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteExpense(String id) async {
    await _expensesRef.doc(id).delete();
  }
}