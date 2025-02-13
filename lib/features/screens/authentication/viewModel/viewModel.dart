import '../repository/auth_repository.dart';

class AuthViewModel {
  final AuthRepository _repository = AuthRepository();
  String? selectedRole;
  String? userName;

  void setRole(String role) {
    selectedRole = role;
  }

  void setName(String name) {
    userName = name;
  }

  Future<bool> signUp(String email, String password) async {
    if (selectedRole == null || userName == null) {
      return false;
    }
    try {
      await _repository.createUser(email, password, selectedRole!, userName!);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    return await _repository.loginUser(email, password);
  }
}
