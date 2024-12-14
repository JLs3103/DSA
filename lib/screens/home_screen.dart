import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../providers/transaction_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DSA Finance Manager'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTotalSpendingCard(context),
              SizedBox(height: 16),
              _buildCategorySpendingChart(context),
              SizedBox(height: 16),
              _buildRecentTransactionsList(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add_transaction'),
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.insert_chart), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Budget'),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/insights');
              break;
            case 2:
              Navigator.pushNamed(context, '/budget');
              break;
          }
        },
      ),
    );
  }

  Widget _buildTotalSpendingCard(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final totalSpending = transactionProvider.getTotalSpending();
    final currencyFormat = NumberFormat.currency (locale: 'id_ID', symbol: 'Rp');

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Total Pengeluaran',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              currencyFormat.format(totalSpending),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySpendingChart(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final categorySpending = <String, double>{};

    for (var transaction in transactionProvider.transactions) {
      categorySpending[transaction.category] =
          (categorySpending[transaction.category] ?? 0) + transaction.amount;
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Pengeluaran per Kategori',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            SfCircularChart(
              series: <PieSeries<MapEntry<String, double>, String>>[
                PieSeries(
                  dataSource: categorySpending.entries.toList(),
                  xValueMapper: (entry, _) => entry.key,
                  yValueMapper: (entry, _) => entry.value,
                  dataLabelMapper: (entry, _) =>
                      '${entry.key}\n${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(entry.value)}',
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelIntersectAction: LabelIntersectAction.shift,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsList(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final recentTransactions = transactionProvider.transactions.take(5).toList();
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

    return Card(
      elevation: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaksi Terkini',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/insights'),
                  child: Text('Lihat Semua'),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recentTransactions.length,
            itemBuilder: (context, index) {
              final transaction = recentTransactions[index];
              return ListTile(
                title: Text(transaction.category),
                subtitle: Text(
                  DateFormat('dd MMM yyyy').format(transaction.date),
                ),
                trailing: Text(
                  currencyFormat.format(transaction.amount),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}