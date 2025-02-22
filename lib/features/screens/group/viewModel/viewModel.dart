import 'package:flutter/material.dart';
import 'package:msdl/features/screens/Group/model/model.dart';
import '../repository/repository.dart';

class GroupViewModel extends ChangeNotifier {
  final GroupRepository _repository = GroupRepository();
  List<GroupUser> _groupUsers = [];

  List<GroupUser> get groupUsers => _groupUsers;

  // ✅ ViewModel이 생성될 때 자동으로 fetch 실행
  GroupViewModel() {
    fetchGroupUsers(); // ✅ 생성자에서 자동 실행
  }

  // ✅ 그룹 사용자 데이터 가져오기
  Future<void> fetchGroupUsers() async {
    _groupUsers = await _repository.fetchGroupUsers();
    notifyListeners();
  }

  // ✅ role(직급)에 따라 사용자 분류하는 메서드 추가!
  Map<Role, List<GroupUser>> getGroupedUsers() {
    Map<Role, List<GroupUser>> groupedUsers = {};

    for (var user in _groupUsers) {
      Role role = user.role; // ✅ String이 아닌 Role 타입 사용
      if (!groupedUsers.containsKey(role)) {
        groupedUsers[role] = [];
      }
      groupedUsers[role]!.add(user);
    }

    return groupedUsers;
  }
}
