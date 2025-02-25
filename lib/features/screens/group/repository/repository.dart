import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msdl/features/screens/Group/model/model.dart';

class GroupRepository {
  static const String baseUrl = "http://220.69.203.99:5000";

  Future<List<GroupUser>> fetchGroupUsers() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/group/users"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((user) => GroupUser.fromJson(user)).toList();
      } else {
        print("❌ 그룹 사용자 데이터 가져오기 실패: ${response.body}");
        return [];
      }
    } catch (e) {
      print("⚠️ 서버 연결 오류: $e");
      return [];
    }
  }
}
