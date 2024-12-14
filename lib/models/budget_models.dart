import 'package:hive/hive.dart';

part 'budget_models.g.dart';

@HiveType(typeId: 2)
class BudgetModel {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final double monthlyLimit;

  BudgetModel({
    required this.category,
    required this.monthlyLimit,
  });
}

class BudgetHashTable {
  final Map<String, BudgetModel> _budgets = {};

  void addBudget(BudgetModel budget) {
    _budgets[budget.category] = budget;
  }

  BudgetModel? getBudget(String category) {
    return _budgets[category];
  }

  bool contains(String category) {
    return _budgets.containsKey(category);
  }
}