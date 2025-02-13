import 'package:flutter/material.dart';
import 'package:msdl/features/screens/group/model/model.dart';
import 'package:msdl/features/screens/group/repository/repository.dart';

class GroupViewModel extends ChangeNotifier {
  final GroupRepository _repository = GroupRepository();
  Map<String, List<GroupModel>> _groupedUsers = {}; // ✅ 타입 명확히 지정

  Map<String, List<GroupModel>> get groupedUsers =>
      _groupedUsers; // ✅ Getter도 명확하게

  Future<void> groupData() async {
    // ✅ 함수명 변경 (groupData → fetchGroupData)
    try {
      List<GroupModel> users = await _repository.getGroupUsers();
      _groupedUsers = _groupByRole(users);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching group data: $e");
    }
  }

  Map<String, List<GroupModel>> _groupByRole(List<GroupModel> users) {
    Map<String, List<GroupModel>> grouped = {};
    for (var user in users) {
      grouped.putIfAbsent(user.role, () => []).add(user);
    }
    return grouped;
  }
}
