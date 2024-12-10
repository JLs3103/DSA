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
  final _categories = [
    'Makan', 'Transportasi', 'Belanja', 
    'Hiburan', 'Pendidikan', 'Kesehatan'
  ];

  String _selectedCategory = 'Makan';
  double _amount = 0.0;
  String _description = '';
  DateTime _selectedDate = DateTime.now();

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
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Jumlah',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan jumlah';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Jumlah harus lebih besar dari nol';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _amount = double.parse(value!);
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Deskripsi (Opsional)',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _description = value ?? '';
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tanggal: ${DateFormat('dd MMM yyyy').format(_selectedDate)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _pickDate,
                      child: Text('Pilih Tanggal'),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitTransaction,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Simpan Transaksi'),
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
      lastDate: DateTime.now(),
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
            content: Text('Transaksi berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan transaksi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}