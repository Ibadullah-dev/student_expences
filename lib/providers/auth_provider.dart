import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  static const String _usersKey = 'registered_users';
  static const String _loggedInUserKey = 'logged_in_user_id';

  // Called on app startup to restore session
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedInId = prefs.getString(_loggedInUserKey);
    if (loggedInId != null) {
      final users = await _getUsers(prefs);
      try {
        _currentUser = users.firstWhere((u) => u.id == loggedInId);
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<List<AppUser>> _getUsers(SharedPreferences prefs) async {
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return [];
    final List decoded = json.decode(usersJson);
    return decoded.map((e) => AppUser.fromMap(e)).toList();
  }

  Future<void> _saveUsers(SharedPreferences prefs, List<AppUser> users) async {
    final encoded = json.encode(users.map((u) => u.toMap()).toList());
    await prefs.setString(_usersKey, encoded);
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final prefs = await SharedPreferences.getInstance();
    final users = await _getUsers(prefs);

    try {
      final user = users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() && u.passwordHash == password,
      );
      _currentUser = user;
      await prefs.setString(_loggedInUserKey, user.id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'Invalid email or password.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final prefs = await SharedPreferences.getInstance();
    final users = await _getUsers(prefs);

    final emailExists = users.any((u) => u.email.toLowerCase() == email.toLowerCase());
    if (emailExists) {
      _errorMessage = 'An account with this email already exists.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final newUser = AppUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      passwordHash: password,
    );

    users.add(newUser);
    await _saveUsers(prefs, users);
    _currentUser = newUser;
    await prefs.setString(_loggedInUserKey, newUser.id);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> updateProfile({required String name, required String university}) async {
    if (_currentUser == null) return;

    final prefs = await SharedPreferences.getInstance();
    final users = await _getUsers(prefs);

    final index = users.indexWhere((u) => u.id == _currentUser!.id);
    if (index != -1) {
      _currentUser = _currentUser!.copyWith(name: name, university: university);
      users[index] = _currentUser!;
      await _saveUsers(prefs, users);
      notifyListeners();
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (_currentUser == null) return false;
    if (_currentUser!.passwordHash != oldPassword) return false;

    final prefs = await SharedPreferences.getInstance();
    final users = await _getUsers(prefs);
    final index = users.indexWhere((u) => u.id == _currentUser!.id);
    if (index != -1) {
      _currentUser!.passwordHash = newPassword;
      users[index] = _currentUser!;
      await _saveUsers(prefs, users);
      notifyListeners();
    }
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInUserKey);
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
