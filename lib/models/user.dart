import 'dart:convert';

class AppUser {
  final String id;
  String name;
  String email;
  String passwordHash; // stored simply as the password for local auth
  String university;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.university = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'passwordHash': passwordHash,
      'university': university,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      passwordHash: map['passwordHash'],
      university: map['university'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory AppUser.fromJson(String source) => AppUser.fromMap(json.decode(source));

  AppUser copyWith({
    String? name,
    String? email,
    String? university,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash,
      university: university ?? this.university,
    );
  }
}
