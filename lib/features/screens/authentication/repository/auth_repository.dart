import 'package:msdl/data/database_helper.dart';

class AuthRepository {
  final db = DatabaseHelper.instance;

  Future<int> createUser(
      String email, String password, String role, String name) async {
    final _db = await db.database;
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

    return result.isNotEmpty; // ✅ 결과가 있으면 로그인 성공 (true)
  }
}
