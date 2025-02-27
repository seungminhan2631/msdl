import 'package:flutter/material.dart';
import 'package:msdl/features/Edit/model/edit_Model.dart';
import 'package:msdl/features/Edit/repository/edit_repository.dart';

class EditViewModel extends ChangeNotifier {
  final EditRepository _repository = EditRepository();
  EditModel? _user;

  EditModel? get user => _user;
  // 🔹 유저 정보 불러오기
  Future<void> fetchUser(int userId) async {
    _user = await _repository.fetchUser(userId);
    notifyListeners();
  }

  // 🔹 유저 정보 업데이트
  Future<bool> updateUser(String name, String role) async {
    if (_user == null) return false;

    bool success = await _repository.updateUser(_user!.userId, name, role);
    if (success) {
      _user!.name = name;
      _user!.role = role;
      notifyListeners();
    }
    return success;
  }

  // 🔹 비밀번호 변경
  Future<bool> updatePassword(String newPassword) async {
    if (_user == null) return false;

    return await _repository.updatePassword(_user!.userId, newPassword);
  }
}
