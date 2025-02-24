import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msdl/features/authentication/model/user_model.dart';

class AuthRepository {
  String baseUrl = "http://220.69.203.99:5000";

  // ✅ 회원가입 (예외 처리 추가)
  Future<String> createUser(
      String email, String password, String role, String name) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "role": role,
          "name": name,
        }),
      );

      if (response.statusCode == 201) {
        return "✅ 회원가입 성공";
      } else {
        return "❌ 회원가입 실패: ${response.body}";
      }
    } catch (e) {
      return "⚠️ 서버 연결 오류: $e";
    }
  }

  // ✅ 로그인 (예외 처리 추가)
  Future<int?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['user_id']; // 로그인 성공 시 사용자 ID 반환
      } else {
        return null;
      }
    } catch (e) {
      print("⚠️ 서버 연결 오류: $e");
      return null;
    }
  }

  // ✅ 사용자 목록 조회 (UserModel 활용)
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/users"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((user) => UserModel.fromJson(user)).toList();
      } else {
        print("❌ 사용자 목록 조회 실패: ${response.body}");
        return [];
      }
    } catch (e) {
      print("⚠️ 서버 연결 오류: $e");
      return [];
    }
  }
}
