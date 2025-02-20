import 'package:flutter/material.dart';
import 'package:msdl/features/screens/authentication/model/user_model.dart';
import '../repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  UserModel? _currentUser; // ✅ 로그인한 사용자 정보 저장

  UserModel? get currentUser => _currentUser; // ✅ Getter 추가

  // ✅ userId Getter 추가
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
    int? userId = await _repository.loginUser(email, password);

    if (userId != null) {
      List<UserModel> users = await _repository.getUsers();
      _currentUser = users.firstWhere(
        (user) => user.id == userId,
        orElse: () => UserModel(id: -1, email: '', role: '', name: ''),
      );

      if (_currentUser!.id == -1) {
        print("❌ 로그인 실패: 서버에서 사용자 정보를 찾을 수 없음");
        return false;
      }

      print("✅ 로그인 성공! ID: ${_currentUser?.id}, Name: ${_currentUser?.name}");
      notifyListeners();
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
    print("🚪 로그아웃 완료");
  }
}
