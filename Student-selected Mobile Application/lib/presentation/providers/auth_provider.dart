import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _userEmail = '';
  String _userName = 'Alex Morgan';
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  String get userEmail => _userEmail;
  String get userName => _userName;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadAuthStatus();
  }

  Future<void> _loadAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('is_authenticated') ?? false;
    _userEmail = prefs.getString('user_email') ?? 'alex.morgan@example.com';
    _userName = prefs.getString('user_name') ?? 'Alex Morgan';
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700)); // Simulate auth API

    _isAuthenticated = true;
    _userEmail = email;
    _userName = email.split('@').first.replaceAll('.', ' ').toUpperCase();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_authenticated', true);
    await prefs.setString('user_email', _userEmail);
    await prefs.setString('user_name', _userName);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isAuthenticated = false;
    notifyListeners();
  }
}
