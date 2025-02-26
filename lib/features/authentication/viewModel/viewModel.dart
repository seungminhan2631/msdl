import 'package:flutter/material.dart';
import 'package:msdl/features/authentication/model/user_model.dart';
import '../repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  int? get userId => _currentUser?.id;

  String? selectedRole;
  String? userName;

  void setRole(String role) {
    if (selectedRole != role) {
      selectedRole = role;
      print("✅ Role이 설정됨: $selectedRole");
      notifyListeners();
    }
  }

  void setName(String name) {
    if (userName != name) {
      userName = name;
      print("✅ Name이 설정됨: $userName");
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    Map<String, dynamic>? userData =
        await _repository.loginUser(email, password);

    if (userData != null && userData.containsKey('user_id')) {
      _currentUser = UserModel(
        id: userData['user_id'],
        email: email,
        role: userData['role'] ?? "Unknown", // 🔹 Null 방지 (기본값: "Unknown")
        name: userData['name'] ?? "Unknown", // 🔹 Null 방지 (기본값: "Unknown")
        password: '', // ❌ 비밀번호 저장 X
      );

      print(
          "✅ 로그인 성공! ID: ${_currentUser?.id}, Name: ${_currentUser?.name}, Role: ${_currentUser?.role}");
      notifyListeners(); // ✅ UI 업데이트
      return true;
    } else {
      print("❌ 로그인 실패: 이메일 또는 비밀번호 확인 필요");
      return false;
    }
  }

  Future<String> signUp(String email, String password) async {
    if (selectedRole == null || userName == null || userName!.isEmpty) {
      return "❌ 회원가입 실패: 역할과 이름이 설정되지 않음!";
    }

    print(
        "📌 회원가입 요청 - 이메일: $email, 비밀번호: $password, Role: $selectedRole, Name: $userName");

    String result =
        await _repository.createUser(email, password, selectedRole!, userName!);
    notifyListeners();
    return result;
  }

  void logout() {
    _currentUser = null; // ✅ 로그아웃 처리
    notifyListeners();
    print("🚪 로그아웃 노무현");
  }
}
