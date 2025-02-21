import 'package:flutter/material.dart';
import 'package:msdl/features/screens/group/model/model.dart';
import 'package:msdl/features/screens/group/repository/repository.dart';

class GroupViewModel extends ChangeNotifier {
  final GroupRepository _repository = GroupRepository();
  Map<Role, List<GroupModel>> _groupedUsers = {};

  Map<Role, List<GroupModel>> get groupedUsers => _groupedUsers;

  Future<void> fetchGroupData() async {
    try {
      print("🔄 fetchGroupData 실행");
      List<GroupModel> users = await _repository.getGroupUsers();

      print("🔍 가져온 사용자 목록 (${users.length}명):");
      for (var user in users) {
        print(
            "✅ ID: ${user.id}, Name: ${user.name}, Role: ${user.role}, CheckIn: ${user.checkInTime}, CheckOut: ${user.checkOutTime}");
      }

      _groupedUsers = _groupByRole(users);
      print("📌 그룹화된 데이터: $_groupedUsers"); // ✅ 그룹화된 데이터 확인

      notifyListeners();
      print("✅ notifyListeners 호출됨"); // ✅ 추가된 디버깅 코드
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
