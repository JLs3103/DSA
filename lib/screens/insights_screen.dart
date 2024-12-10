import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';

class InsightsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final predictedTrends = transactionProvider.getPredictedTrends();
    final recommendedReductionAreas = transactionProvider.getRecommendedReductionAreas();

    return Scaffold(
      appBar: AppBar(
        title: Text('Financial Insights'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Predicted Spending Trends',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            for (var trend in predictedTrends)
              Text(
                'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '').format(trend)}',
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 16),
            Text(
              'Recommended Cost Reduction Areas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            for (var area in recommendedReductionAreas)
              Text(
                area,
                style: TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}