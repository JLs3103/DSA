import '../models/financial_models.dart'; // Pastikan ini mengarah ke model yang benar

class ExpenseCategoryGraph {
  final Map<String, List<String>> _connections = {};

  void addConnection(String category1, String category2) {
    _connections.putIfAbsent(category1, () => []).add(category2);
    _connections.putIfAbsent(category2, () => []).add(category1);
  }

  List<String> getConnections(String category) {
    return _connections[category] ?? [];
  }

  List<String> findCostReductionAreas(List<TransactionModel> transactions) {
    Map<String, double> categorySpending = {};

    for (var transaction in transactions) {
      categorySpending[transaction.category] = 
          (categorySpending[transaction.category] ?? 0) + transaction.amount;
    }

    var sortedCategories = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedCategories.map((entry) => entry.key).toList();
  }
}