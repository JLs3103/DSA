import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/transaction_provider.dart';
import 'providers/preferences_provider.dart'; // Pastikan ini diimpor
import 'screens/home_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/budget_screen.dart';
import 'screens/insights_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => PreferencesProvider()), // Pastikan ini didefinisikan
      ],
      child: DSAFinanceApp(),
    )
  );
}

class DSAFinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, preferences, child) {
        return MaterialApp(
          title: 'DSA Finance Manager',
          theme: preferences.isDarkMode 
            ? ThemeData.dark().copyWith(
                primaryColor: Colors.teal,
                colorScheme: ColorScheme.dark(
                  primary: Colors.teal,
                  secondary: Colors.tealAccent,
                ),
              )
            : ThemeData.light().copyWith(
                primaryColor: Colors.blue,
                colorScheme: ColorScheme.light(
                  primary: Colors.blue,
                  secondary: Colors.blueAccent,
                ),
              ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => HomeScreen(),
            '/add_transaction': (context) => AddTransactionScreen(),
            '/budget': (context) => BudgetScreen(),
            '/insights': (context) => InsightsScreen(),
          },
        );
      },
    );
  }
}