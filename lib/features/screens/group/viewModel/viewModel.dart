import 'package:flutter/material.dart';
import 'package:msdl/features/screens/group/model/model.dart';
import 'package:msdl/features/screens/group/repository/repository.dart';

class GroupViewModel extends ChangeNotifier {
  final GroupRepository _repository = GroupRepository();
  Map<Role, List<GroupModel>> _groupedUsers = {};

  Map<Role, List<GroupModel>> get groupedUsers => _groupedUsers;

  Future<void> fetchGroupData() async {
    try {
      List<GroupModel> users = await _repository.getGroupUsers();

      print("🔍 가져온 사용자 목록 (${users.length}명):");
      for (var user in users) {
        print(
            "✅ ID: ${user.id}, Name: ${user.name}, Role: ${user.role}, CheckIn: ${user.checkInTime}, CheckOut: ${user.checkOutTime}");
      }

      _groupedUsers = _groupByRole(users);

      // 🔥 변환된 groupedUsers 출력 확인
      print("📌 groupedUsers 데이터:");
      _groupedUsers.forEach((role, userList) {
        print("🔹 Role: $role, Users: ${userList.map((u) => u.name).toList()}");
      });

      notifyListeners();
    } catch (e) {
      debugPrint("⚠️ Error fetching group data: $e");
    }
  }

  Map<Role, List<GroupModel>> _groupByRole(List<GroupModel> users) {
    Map<Role, List<GroupModel>> grouped = {};
    for (var user in users) {
      grouped.putIfAbsent(user.role, () => []).add(user);
    }
    return grouped;
  }
}
