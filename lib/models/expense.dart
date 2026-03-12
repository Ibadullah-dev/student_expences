import 'dart:convert';
import 'package:flutter/material.dart';

enum ExpenseCategory {
  food,
  transport,
  recharge,
  shopping,
  university,
  other,
}

extension ExpenseCategoryExt on ExpenseCategory {
  String get label {
    switch (this) {
      case ExpenseCategory.food: return 'Food';
      case ExpenseCategory.transport: return 'Transport';
      case ExpenseCategory.recharge: return 'Recharge';
      case ExpenseCategory.shopping: return 'Shopping';
      case ExpenseCategory.university: return 'University';
      case ExpenseCategory.other: return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.food: return Icons.fastfood;
      case ExpenseCategory.transport: return Icons.directions_bus;
      case ExpenseCategory.recharge: return Icons.phone_android;
      case ExpenseCategory.shopping: return Icons.shopping_bag;
      case ExpenseCategory.university: return Icons.school;
      case ExpenseCategory.other: return Icons.more_horiz;
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.food: return Colors.orange;
      case ExpenseCategory.transport: return Colors.blue;
      case ExpenseCategory.recharge: return Colors.teal;
      case ExpenseCategory.shopping: return Colors.purple;
      case ExpenseCategory.university: return Colors.green;
      case ExpenseCategory.other: return Colors.grey;
    }
  }

  static ExpenseCategory fromLabel(String label) {
    return ExpenseCategory.values.firstWhere(
      (e) => e.label == label,
      orElse: () => ExpenseCategory.other,
    );
  }
}

class Expense {
  final String id;
  final double amount;
  final ExpenseCategory category;
  final String description;
  final DateTime date;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category.label,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: (map['amount'] as num).toDouble(),
      category: ExpenseCategoryExt.fromLabel(map['category']),
      description: map['description'],
      date: DateTime.parse(map['date']),
    );
  }

  String toJson() => json.encode(toMap());
  factory Expense.fromJson(String source) => Expense.fromMap(json.decode(source));

  Expense copyWith({
    String? id,
    double? amount,
    ExpenseCategory? category,
    String? description,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }
}
