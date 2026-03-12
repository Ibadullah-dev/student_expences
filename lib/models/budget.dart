import 'dart:convert';

class Budget {
  final String userId;
  final int year;
  final int month;
  final double limit;

  const Budget({
    required this.userId,
    required this.year,
    required this.month,
    required this.limit,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'year': year,
      'month': month,
      'limit': limit,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      userId: map['userId'],
      year: map['year'],
      month: map['month'],
      limit: (map['limit'] as num).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());
  factory Budget.fromJson(String source) => Budget.fromMap(json.decode(source));

  Budget copyWith({double? limit}) {
    return Budget(
      userId: userId,
      year: year,
      month: month,
      limit: limit ?? this.limit,
    );
  }
}
