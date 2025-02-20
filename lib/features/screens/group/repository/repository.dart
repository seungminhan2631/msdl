import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/model.dart';

class GroupRepository {
  static const String baseUrl = "http://10.0.2.2:5000";

  // ✅ 그룹 사용자 목록 가져오기 (Flask 서버 연동)
  Future<List<GroupModel>> getGroupUsers() async {
    final response = await http.get(
      Uri.parse("$baseUrl/group/users"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((user) => GroupModel.fromJson(user)).toList();
    } else {
      print("❌ 그룹 데이터 가져오기 실패: ${response.body}");
      return [];
    }
  }
}
