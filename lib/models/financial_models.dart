import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'financial_models.g.dart';

@HiveType(typeId: 0)
class TransactionModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String description;

  TransactionModel({
    String? id,
    required this.category,
    required this.amount,
    DateTime? date,
    this.description = '',
  }) : 
    id = id ?? const Uuid().v4(),
    date = date ?? DateTime.now();

  // Predict financial trends using a simple algorithm
  static List<double> predictTrends(List<TransactionModel> transactions) {
    if (transactions.isEmpty) return [];

    final amounts = transactions.map((t) => t.amount).toList();
    final totalAmount = amounts.reduce((a, b) => a + b);
    final averageAmount = totalAmount / amounts.length;

    return List.generate(3, (_) => averageAmount);
  }
}

@HiveType(typeId: 1)
class BudgetModel {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final double monthlyLimit;

  @HiveField(2)
  List<TransactionModel> transactions;

  BudgetModel({
    required this.category, 
    required this.monthlyLimit,
    List<TransactionModel>? transactions
  }) : transactions = transactions ?? [];

  // Segment Tree concept for budget analysis
  double calculateTotalSpending(DateTime startDate, DateTime endDate) {
    return transactions
        .where((t) => 
          t.date.isAfter(startDate) && t.date.isBefore(endDate))
        .map((t) => t.amount)
        .fold(0, (a, b) => a + b);
  }

  bool isOverBudget() {
    final monthTotal = calculateTotalSpending(
      DateTime(DateTime.now().year, DateTime.now().month), 
      DateTime(DateTime.now().year, DateTime.now().month + 1)
    );
    return monthTotal > monthlyLimit;
  }
}

class ExpenseCategoryGraph {
  Map<String, Map<String, double>> categoryConnections = {
    'Food': {'Transportation': 0.3, 'Shopping': 0.2},
    'Transportation': {'Food': 0.4, 'Online Shopping': 0.1},
    'Online Shopping': {'Transportation': 0.2, 'Food': 0.1}
  };

  // Greedy algorithm for cost reduction recommendations
  List<String> findCostReductionAreas(List<TransactionModel> transactions) {
    final categorySpending = <String, double>{};
    
    for (var transaction in transactions) {
      categorySpending[transaction.category] = 
        (categorySpending[transaction.category] ?? 0) + transaction.amount;
    }

    final sortedCategories = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedCategories.map((e) => e.key).take(2).toList();
  }
}