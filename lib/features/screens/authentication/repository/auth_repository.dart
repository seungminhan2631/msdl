import 'package:msdl/data/database_helper.dart';

class AuthRepository {
  final db = DatabaseHelper.instance;

  Future<int> createUser(
      String email, String password, String role, String name) async {
    final _db = await db.database;
    print("📌 사용자 추가 중... 이메일: $email, Role: $role");

    return await _db.insert('users', {
      'email': email,
      'password': password,
      'role': role,
      'name': name,
    });
  }

  Future<int?> loginUser(String email, String password) async {
    final _db = await db.database;
    final result = await _db.query(
      'users',
      columns: ['id'], // ✅ ID만 가져오도록 수정
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      print("✅ 로그인 성공! 사용자 ID: ${result.first['id']}");
      return result.first['id'] as int; // ✅ 사용자 ID 반환
    } else {
      print("❌ 로그인 실패");
      return null; // 로그인 실패 시 null 반환
    }
  }
}
