import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:msdl/data/database_helper.dart';
import 'package:msdl/features/Group/model/model.dart';
import 'package:msdl/features/Group/repository/repository.dart';

// Role Enum
enum Role { professor, phd, ms, bs }

extension RoleExtension on Role {
  static Role fromString(String role) {
    // ✅ 문자열을 소문자로 변환하고 공백을 정리하여 비교
    String normalizedRole =
        role.trim().toLowerCase().replaceAll(".", "").replaceAll(" ", "");

    switch (normalizedRole) {
      case 'professor':
        return Role.professor;
      case 'phdstudent': // ✅ 공백과 마침표 제거 후 비교
        return Role.phd;
      case 'msstudent':
        return Role.ms;
      case 'bsstudent':
        return Role.bs;
      default:
        throw ArgumentError("⚠️ 유효하지 않은 Role 값: '$role'");
    }
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

class GroupUser {
  final int id;
  final String name;
  final Role role;
  final String category;
  final String checkInTime;
  final String checkOutTime;

  GroupUser({
    required this.id,
    required this.name,
    required this.role,
    required this.category,
    required this.checkInTime,
    required this.checkOutTime,
  });

  factory GroupUser.fromJson(Map<String, dynamic> json) {
    return GroupUser(
      id: json['user_id'] ?? 0,
      name: json['name'] ?? "Unknown",
      role: RoleExtension.fromString(json['role'] ?? "Unknown"),
      category: json['attendance']?['workplace'] ?? "Unknown", // ✅ Null 방지
      checkInTime: json['attendance']?['check_in_time'] ?? "--:--",
      checkOutTime: json['attendance']?['check_out_time'] ?? "--:--",
    );
  }

  GroupUser copyWith({
    int? id,
    String? name,
    Role? role,
    String? category,
    String? checkInTime,
    String? checkOutTime,
  }) {
    return GroupUser(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      category: category ?? this.category,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
    );
  }
}
