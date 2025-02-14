import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:msdl/data/database_helper.dart';
import 'package:msdl/features/screens/group/model/model.dart';
import 'package:msdl/features/screens/group/repository/repository.dart';

// Role Enum
enum Role { professor, phd, ms, bs }

extension RoleExtension on Role {
  static Role fromString(String role) {
    switch (role.trim()) {
      case 'Professor':
        return Role.professor;
      case 'Ph.D. Student':
        return Role.phd;
      case 'MS Student':
        return Role.ms;
      case 'BS Student':
        return Role.bs;
    }
    throw ArgumentError("⚠️ 유효하지 않은 Role 값: '$role'");
  }

  IconData get icon {
    switch (this) {
      case Role.professor:
        return Icons.school;
      case Role.phd:
        return Icons.library_books_outlined;
      case Role.ms:
        return Icons.school_outlined;
      case Role.bs:
        return Icons.auto_stories_outlined;
      default:
        return Icons.error; // 🚨 오류 시 기본 아이콘
    }
  }

  Color get color {
    switch (this) {
      case Role.professor:
        return Color(0xFFF59E0B);
      case Role.phd:
        return Color(0xFF31B454);
      case Role.ms:
        return Color(0xFF935E38);
      case Role.bs:
        return Color(0xFF3F51B5);
      default:
        return Colors.red; // 🚨 오류 시 기본 색상
    }
  }

  String get displayName {
    switch (this) {
      case Role.professor:
        return "Professor";
      case Role.phd:
        return "Ph.D. Student";
      case Role.ms:
        return "MS Student";
      case Role.bs:
        return "BS Student";
    }
  }
}

// GroupModel
class GroupModel {
  final String id;
  final String name;
  final Role role;
  final String checkInTime;
  final String checkOutTime;
  final String category;

  GroupModel({
    required this.id,
    required this.name,
    required this.role,
    required this.checkInTime,
    required this.checkOutTime,
    required this.category,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'].toString(),
      name: map['name'] ?? 'Unknown',
      role: RoleExtension.fromString(map['role'] ?? 'Unknown'),
      checkInTime: map['check_in_time'] ?? '--:--',
      checkOutTime: map['check_out_time'] ?? '--:--',
      category:
          map['category'] != null ? map['category'].toString() : "My WorkPlace",
    );
  }
}
