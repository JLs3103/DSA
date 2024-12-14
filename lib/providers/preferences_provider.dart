import 'package:flutter/material.dart';

class PreferencesNode {
  String key;
  String value;
  PreferencesNode? left;
  PreferencesNode? right;

  PreferencesNode(this.key, this.value);
}

class PreferencesBST {
  PreferencesNode? root;

  void insert(String key, String value) {
    root = _insertRec(root, key, value);
  }

  PreferencesNode? _insertRec(PreferencesNode? root, String key, String value) {
    if (root == null) {
      return PreferencesNode(key, value);
    }
    if (key.compareTo(root.key) < 0) {
      root.left = _insertRec(root.left, key, value);
    } else if (key.compareTo(root.key) > 0) {
      root.right = _insertRec(root.right, key, value);
    }
    return root;
  }

  String? search(String key) {
    return _searchRec(root, key);
  }

  String? _searchRec(PreferencesNode? root, String key) {
    if (root == null) return null;
    if (key == root.key) return root.value;
    return key.compareTo(root.key) < 0
        ? _searchRec(root.left, key)
        : _searchRec(root.right, key);
  }
}

class PreferencesProvider with ChangeNotifier {
  final PreferencesBST _preferences = PreferencesBST();

  bool get isDarkMode {
    return _preferences.search('isDarkMode') == 'true';
  }

  void toggleDarkMode() {
    String currentValue = isDarkMode ? 'true' : 'false';
    _preferences.insert('isDarkMode', currentValue == 'true' ? 'false' : 'true');
    notifyListeners();
  }
}