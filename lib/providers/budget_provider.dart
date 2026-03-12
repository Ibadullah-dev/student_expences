import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/budget.dart';

class BudgetProvider extends ChangeNotifier {
  final List<Budget> _budgets = [];
  String _userId = '';

  static const String _budgetsKey = 'budgets';

  List<Budget> get budgets => List.unmodifiable(_budgets);

  Future<void> init(String userId) async {
    _userId = userId;
    await _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('${_budgetsKey}_$_userId');
    if (raw != null) {
      final List decoded = json.decode(raw);
      _budgets.clear();
      _budgets.addAll(decoded.map((e) => Budget.fromMap(e)));
    }
    notifyListeners();
  }

  Future<void> _saveBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_budgets.map((b) => b.toMap()).toList());
    await prefs.setString('${_budgetsKey}_$_userId', encoded);
  }

  Budget getBudgetForMonth(int year, int month) {
    try {
      return _budgets.firstWhere((b) => b.year == year && b.month == month);
    } catch (_) {
      return Budget(userId: _userId, year: year, month: month, limit: 5000.0);
    }
  }

  Budget get currentMonthBudget {
    final now = DateTime.now();
    return getBudgetForMonth(now.year, now.month);
  }

  Future<void> setBudget(int year, int month, double limit) async {
    final index = _budgets.indexWhere((b) => b.year == year && b.month == month);
    final newBudget = Budget(userId: _userId, year: year, month: month, limit: limit);
    if (index == -1) {
      _budgets.add(newBudget);
    } else {
      _budgets[index] = newBudget;
    }
    await _saveBudgets();
    notifyListeners();
  }

  Future<void> setCurrentMonthBudget(double limit) async {
    final now = DateTime.now();
    await setBudget(now.year, now.month, limit);
  }

  void clear() {
    _budgets.clear();
    _userId = '';
    notifyListeners();
  }
}
