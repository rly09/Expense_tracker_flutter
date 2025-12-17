import 'package:flutter/foundation.dart';
import '../data/database.dart';
import '../data/repository.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository _repository;
  List<TransactionItem> _transactions = [];

  TransactionProvider(this._repository) {
    _init();
  }

  void _init() {
    _repository.transactions.listen((data) {
      _transactions = data;
      notifyListeners();
    });
  }

  List<TransactionItem> get transaction => _transactions;

  double get totalIncome => _transactions
      .where((tx) => tx.isIncome)
      .fold(0, (sum, tx) => sum + tx.amount);

  double get totalExpense => _transactions
      .where((tx) => !tx.isIncome)
      .fold(0, (sum, tx) => sum + tx.amount);

  double get remainingBalance => totalIncome - totalExpense;

  void addTransaction(String title, double amount, bool isIncome) {
    _repository.addTransaction(
      title: title,
      amount: amount,
      date: DateTime.now(),
      isIncome: isIncome,
    );
  }

  void removeTransaction(int id){
    _repository.deleteTransaction(id);
  }
}
