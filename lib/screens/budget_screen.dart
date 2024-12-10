import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../models/financial_models.dart';

class BudgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final budgets = transactionProvider.budgets;

    return Scaffold(
      appBar: AppBar(
        title: Text('Budget'),
      ),
      body: ListView.builder(
        itemCount: budgets.length,
        itemBuilder: (context, index) {
          final budget = budgets[index];
          return Card(
            margin: const EdgeInsets.all(16.0),
            child: ListTile(
              title: Text(budget.category),
              subtitle: Text('Monthly Limit: Rp ${budget.monthlyLimit.toStringAsFixed(0)}'),
              trailing: Text(
                'Spent: Rp ${budget.calculateTotalSpending(DateTime(DateTime.now().year, DateTime.now().month), DateTime(DateTime.now().year, DateTime.now().month + 1)).toStringAsFixed(0)}',
                style: TextStyle(
                  color: budget.isOverBudget() ? Colors.red : Colors.green,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBudgetDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController limitController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: limitController,
                decoration: InputDecoration(labelText: 'Monthly Limit'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final category = categoryController.text;
                final monthlyLimit = double.tryParse(limitController.text) ?? 0.0;
                if (category.isNotEmpty && monthlyLimit > 0) {
                  final newBudget = BudgetModel(category: category, monthlyLimit: monthlyLimit);
                  Provider.of<TransactionProvider>(context, listen: false).addBudget(newBudget);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}