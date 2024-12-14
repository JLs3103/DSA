import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'financial_models.g.dart';

class TransactionNode {
  TransactionModel transaction;
  TransactionNode? next;

  TransactionNode(this.transaction);
}

class TransactionLinkedList {
  TransactionNode? head;

  void add(TransactionModel transaction) {
    final newNode = TransactionNode(transaction);
    if (head == null) {
      head = newNode;
    } else {
      TransactionNode current = head!;
      while (current.next != null) {
        current = current.next!;
      }
      current.next = newNode;
    }
  }

  List<TransactionModel> toList() {
    List<TransactionModel> transactions = [];
    TransactionNode? current = head;
    while (current != null) {
      transactions.add(current.transaction);
      current = current.next;
    }
    return transactions;
  }
}

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

// Merge Sort for sorting transactions
List<TransactionModel> mergeSort(List<TransactionModel> transactions) {
  if (transactions.length <= 1) return transactions;

  final mid = transactions.length ~/ 2;
  final left = mergeSort(transactions.sublist(0, mid));
  final right = mergeSort(transactions.sublist(mid));

  return merge(left, right);
}

List<TransactionModel> merge(List<TransactionModel> left, List<TransactionModel> right) {
  List<TransactionModel> result = [];
  int i = 0, j = 0;

  while (i < left.length && j < right.length) {
    if (left[i].date.isBefore(right[j].date)) {
      result.add(left[i]);
      i++;
    } else {
      result.add(right[j]);
      j++;
    }
  }

  result.addAll(left.sublist(i));
  result.addAll(right.sublist(j));
  return result;
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

  // Calculate total spending for a given period
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

class ExpenseGraph {
  final Map<String, List<String>> _connections = {};

  void addConnection(String category1, String category2) {
    _connections.putIfAbsent(category1, () => []).add(category2);
    _connections.putIfAbsent(category2, () => []).add(category1);
  }

  List<String> getConnections(String category) {
    return _connections[category] ?? [];
  }

  void dfs(String category, Set<String> visited) {
    if (visited.contains(category)) return;
    visited.add(category);
    print(category); // Atau lakukan analisis lebih lanjut

    for (var neighbor in getConnections(category)) {
      dfs(neighbor, visited);
    }
  }
}