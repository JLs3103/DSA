import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _defaultCurrency = 'IDR';

  bool get isDarkMode => _isDarkMode;
  String get defaultCurrency => _defaultCurrency;

  PreferencesProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    _defaultCurrency = prefs.getString('currency') ?? 'IDR';
    notifyListeners();
  }

  void toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    notifyListeners();
  }

  void setCurrency(String currency) async {
    _defaultCurrency = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
    notifyListeners();
  }
}