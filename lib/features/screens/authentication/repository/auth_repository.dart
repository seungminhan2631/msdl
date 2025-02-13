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

  Future<bool> loginUser(String email, String password) async {
    final _db = await db.database;
    final result = await _db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    return result.isNotEmpty;
  }
}
