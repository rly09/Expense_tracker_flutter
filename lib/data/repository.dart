
import 'package:drift/drift.dart';
import 'database.dart';

class TransactionRepository {
  final AppDatabase _db;

  TransactionRepository(this._db);

  Stream<List<TransactionItem>> get transactions => _db.watchAllTransactions();

  Future<void> addTransaction({
    required String title,
    required double amount,
    required DateTime date,
    required bool isIncome,
  }) async {
    await _db.addTransactionItem(TransactionItemsCompanion(
      title: Value(title),
      amount: Value(amount),
      date: Value(date),
      isIncome: Value(isIncome),
    ));
  }

  Future<void> deleteTransaction(int id) async {
    await _db.deleteTransactionItem(id);
  }
  
  // Helpers for stats
  Stream<double> get totalIncome => transactions.map((list) => list
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount));

  Stream<double> get totalExpense => transactions.map((list) => list
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount));
}
