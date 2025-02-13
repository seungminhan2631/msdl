import 'package:flutter/material.dart';
import '../repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  String? selectedRole;
  String? userName;

  void setRole(String role) {
    selectedRole = role;
    print("✅ Role이 설정됨: $selectedRole");
    notifyListeners();
  }

  void setName(String name) {
    userName = name;
    print("✅ Name이 설정됨: $userName");
    notifyListeners();
  }

  Future<bool> signUp(String email, String password) async {
    print("📌 signUp() 실행됨! 이메일: $email, 비밀번호: $password");

    if (selectedRole == null || userName == null || userName!.isEmpty) {
      print(
          "❌ 오류: Role 또는 Name이 설정되지 않음! selectedRole: $selectedRole, userName: $userName");
      return false;
    }

    print(
        "📌 회원가입 요청 - 이메일: $email, 비밀번호: $password, Role: $selectedRole, Name: $userName");

    try {
      await _repository.createUser(email, password, selectedRole!, userName!);
      print("✅ 회원가입 성공 - 이메일: $email");

      return true;
    } catch (e) {
      print("❌ 회원가입 실패: $e");
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    return await _repository.loginUser(email, password);
  }
}
