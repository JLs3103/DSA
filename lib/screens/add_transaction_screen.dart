import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/transaction_provider.dart';
import '../models/financial_models.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _expenseCategories = [
    'Food', 'Transportation', 'Shopping', 
    'Entertainment', 'Education', 'Health'
  ];
  
  final _incomeCategories = [
    'Salary', 'Business', 'Investment', 
    'Gift', 'Freelance', 'Other'
  ];

  String _selectedCategory = 'Food';
  double _amount = 0.0;
  String _description = '';
  DateTime _selectedDate = DateTime.now();
  String _transactionType = 'Expense'; // Default to Expense

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Transaction Type Selection
                Text('Transaction Type', style: Theme.of(context).textTheme.headlineMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: 'Expense',
                      groupValue: _transactionType,
                      onChanged: (value) {
                        setState(() {
                          _transactionType = value!;
                          _selectedCategory = _expenseCategories[0]; // Reset to first category
                        });
                      },
                    ),
                    Text('Expense'),
                    Radio<String>(
                      value: 'Income',
                      groupValue: _transactionType,
                      onChanged: (value) {
                        setState(() {
                          _transactionType = value!;
                          _selectedCategory = _incomeCategories[0]; // Reset to first category
                        });
                      },
                    ),
                    Text('Income'),
                  ],
                ),
                SizedBox(height: 16),

                // Category Selection
                DropdownButtonFormField<String>(
                  value: _transactionType == 'Expense' ? _selectedCategory : _incomeCategories[0],
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _transactionType == 'Expense'
                      ? _expenseCategories.map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          )).toList()
                      : _incomeCategories.map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                SizedBox(height: 16),

                // Amount Input
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Amount must be greater than zero';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _amount = double.parse(value!);
                  },
                ),
                SizedBox(height: 16),

                // Description Input
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _description = value ?? '';
                  },
                ),
                SizedBox(height: 16),

                // Date Selection
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date: ${DateFormat('dd MMM yyyy').format(_selectedDate)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _pickDate,
                      child: Text('Select Date'),
                    ),
                  ],
                ),
 SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitTransaction,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Save Transaction'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 365)), // Allow future dates
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitTransaction() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newTransaction = TransactionModel(
        category: _selectedCategory,
        amount: _amount,
        date: _selectedDate,
        description: _description,
      );

      try {
        Provider.of<TransactionProvider>(context, listen: false)
            .addTransaction(newTransaction);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction added successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add transaction: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}