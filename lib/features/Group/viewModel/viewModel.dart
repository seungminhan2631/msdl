import 'package:flutter/material.dart';
import 'package:msdl/features/screens/Group/model/model.dart';
import '../repository/repository.dart';

class GroupViewModel extends ChangeNotifier {
  final GroupRepository _repository = GroupRepository();
  List<GroupUser> _groupUsers = [];

  List<GroupUser> get groupUsers => _groupUsers;

  // ✅ ViewModel이 생성될 때 자동으로 fetch 실행
  GroupViewModel() {
    fetchGroupViewModel(); // ✅ 생성자에서 자동 실행
  }

  // ✅ 그룹 사용자 데이터 가져오기
  Future<void> fetchGroupViewModel() async {
    print("🔥 fetchGroupViewModel 실행됨"); // ✅ 실행 로그 추가

    List<GroupUser> fetchedUsers = await _repository.fetchGroupUsers();

    // ✅ workplace 값이 null이면 "Unknown"으로 설정
    _groupUsers = fetchedUsers.map((user) {
      return user.copyWith(
        category: user.category == "N/A" || user.category == null
            ? "Unknown"
            : user.category,
      );
    }).toList();

    print("✅ 그룹 사용자 데이터 변환 완료: $_groupUsers"); // ✅ 변환된 데이터 확인

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
