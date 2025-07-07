import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = true;

  // Hardcoded credentials
  static const String _validUsername = 'admin';
  static const String _validPassword = 'admin123';
  static const String _loginKey = 'is_logged_in';

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadLoginState();
  }

  Future<void> _loadLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool(_loginKey) ?? false;
    } catch (e) {
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    if (username == _validUsername && password == _validPassword) {
      _isLoggedIn = true;
      await _saveLoginState(true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    await _saveLoginState(false);
    notifyListeners();
  }

  Future<void> _saveLoginState(bool isLoggedIn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loginKey, isLoggedIn);
    } catch (e) {
      // Handle error silently for demo app
    }
  }
}