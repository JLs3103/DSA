import 'package:flutter/foundation.dart';
import '../models/financial_models.dart';
import '../models/expense_analysis.dart'; // Pastikan ini diimpor

class TransactionProvider extends ChangeNotifier {
  final List<TransactionModel> _transactions = [];
  final List<BudgetModel> _budgets = [];

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  List<BudgetModel> get budgets => List.unmodifiable(_budgets);

  void addTransaction(TransactionModel transaction) {
    if (transaction.amount <= 0) {
      throw ArgumentError('Jumlah transaksi harus lebih besar dari nol.');
    }

    _transactions.add(transaction);
    
    // Cek apakah budget untuk kategori ini sudah ada
    final relatedBudget = _budgets.firstWhere(
      (budget) => budget.category == transaction.category,
      orElse: () => BudgetModel(category: transaction.category, monthlyLimit: 0)
    );

    // Jika budget tidak ada, tambahkan budget baru
    if (!_budgets.contains(relatedBudget)) {
      _budgets.add(relatedBudget);
    }

    relatedBudget.transactions.add(transaction);

    notifyListeners();
  }

  void addBudget(BudgetModel budget) {
    _budgets.add(budget);
    notifyListeners();
  }

  List<TransactionModel> getTransactionsByCategory(String category) {
    return _transactions.where((t) => t.category == category).toList();
  }

  List<double> getPredictedTrends() {
    return TransactionModel.predictTrends(_transactions);
  }

  List<String> getRecommendedReductionAreas() {
    final graph = ExpenseCategoryGraph(); // Pastikan kelas ini didefinisikan
    return graph.findCostReductionAreas(_transactions);
  }

  double getTotalSpending() {
    return _transactions.fold(0, (total, transaction) => total + transaction.amount);
  }
}