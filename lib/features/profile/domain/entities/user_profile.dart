import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String role;
  final Map<String, dynamic> settings;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
    this.settings = const {},
    required this.createdAt,
    required this.lastLoginAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    avatarUrl,
    role,
    settings,
    createdAt,
    lastLoginAt,
  ];
}
