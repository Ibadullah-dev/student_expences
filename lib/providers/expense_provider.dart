import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  final List<Expense> _expenses = [];
  String _userId = '';
  String _searchQuery = '';
  String _selectedFilter = 'All';

  static const String _expensesKey = 'expenses';

  List<Expense> get allExpenses => List.unmodifiable(_expenses);

  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;

  Future<void> init(String userId) async {
    _userId = userId;
    await _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('${_expensesKey}_$_userId');
    if (raw != null) {
      final List decoded = json.decode(raw);
      _expenses.clear();
      _expenses.addAll(decoded.map((e) => Expense.fromMap(e)));
      // Sort by date descending
      _expenses.sort((a, b) => b.date.compareTo(a.date));
    }
    notifyListeners();
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_expenses.map((e) => e.toMap()).toList());
    await prefs.setString('${_expensesKey}_$_userId', encoded);
  }

  // Filtered expenses based on active filter and search query
  List<Expense> get filteredExpenses {
    return _expenses.where((e) {
      final matchesFilter = _selectedFilter == 'All' ||
          e.category.label == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          e.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.category.label.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  // Recent expenses (last 5)
  List<Expense> get recentExpenses {
    return _expenses.take(5).toList();
  }

  // Total spent this month
  double get currentMonthTotal {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  // Spending by category this month
  Map<ExpenseCategory, double> get currentMonthByCategory {
    final now = DateTime.now();
    final map = <ExpenseCategory, double>{};
    for (final e in _expenses) {
      if (e.date.year == now.year && e.date.month == now.month) {
        map[e.category] = (map[e.category] ?? 0) + e.amount;
      }
    }
    return map;
  }

  // Daily totals for the last 7 days (for bar chart)
  List<double> get last7DaysTotals {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return _expenses
          .where((e) =>
              e.date.year == day.year &&
              e.date.month == day.month &&
              e.date.day == day.day)
          .fold(0.0, (sum, e) => sum + e.amount);
    });
  }

  // Daily labels for last 7 days
  List<String> get last7DayLabels {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return days[day.weekday - 1];
    });
  }

  Future<void> addExpense(Expense expense) async {
    _expenses.insert(0, expense);
    await _saveExpenses();
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
    await _saveExpenses();
    notifyListeners();
  }

  Future<void> updateExpense(Expense updated) async {
    final index = _expenses.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _expenses[index] = updated;
      await _saveExpenses();
      notifyListeners();
    }
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clear() {
    _expenses.clear();
    _userId = '';
    _searchQuery = '';
    _selectedFilter = 'All';
    notifyListeners();
  }
}
