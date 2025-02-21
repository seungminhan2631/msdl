import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/model.dart';

class GroupRepository {
  static const String baseUrl = "http://220.69.203.99:5000";

  Future<List<GroupModel>> getGroupUsers() async {
    final response = await http.get(
      Uri.parse("$baseUrl/group/users"),
      headers: {"Content-Type": "application/json"},
    );

    print("🔍 서버 응답 코드: ${response.statusCode}");
    print("📌 서버 응답 내용: ${response.body}"); // ✅ 응답 내용 확인

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("📌 파싱된 데이터: $data"); // ✅ 데이터를 출력하여 확인

      if (data.isEmpty) {
        print("⚠️ 서버에서 빈 배열을 반환함!");
      }

      return data.map((user) => GroupModel.fromJson(user)).toList();
    } else {
      print("❌ 그룹 데이터 가져오기 실패: ${response.body}");
      return [];
    }
  }
}
