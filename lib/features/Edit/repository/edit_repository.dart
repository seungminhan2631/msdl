import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msdl/features/Edit/model/edit_Model.dart';

class EditRepository {
  static String baseUrl = "http://220.69.203.99:5000";

  // 🔹 유저 정보 불러오기
  Future<EditModel?> fetchUser(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return EditModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("⚠️ fetchUser 실패: $e");
      return null;
    }
  }

  // 🔹 유저 정보 업데이트
  Future<bool> updateUser(int userId, String name, String role) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user/update'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'name': name,
          'role': role,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("⚠️ updateUser 실패: $e");
      return false;
    }
  }

  // 🔹 비밀번호 변경
  Future<bool> updatePassword(int userId, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user/update_password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'password': newPassword,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("⚠️ updatePassword 실패: $e");
      return false;
    }
  }
}
