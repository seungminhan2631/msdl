import '../repository/auth_repository.dart';

class AuthViewModel {
  final AuthRepository _repository = AuthRepository();
  String? selectedRole;
  String? userName;
  String testName = "MSDL";

  void setRole(String role) {
    selectedRole = role;
    print("✅ Role이 설정됨: $selectedRole"); // Role 설정 로그 추가
  }

  void setName(String name) {
    userName = testName;
  }

  Future<bool> signUp(String email, String password) async {
    if (selectedRole == null || userName == null) {
      print("❌ 오류: Role이 설정되지 않음!");

      return false;
    }
    try {
      print(" 회원가입 요청 - 이메일: $email, 비밀번호: $password, Role: $selectedRole");

      await _repository.createUser(email, password, selectedRole!, testName);
      print("회원가입 성공 - 이메일: $email");

      return true;
    } catch (e) {
      print("회원가입 실패: $e");

      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    return await _repository.loginUser(email, password);
  }
}
