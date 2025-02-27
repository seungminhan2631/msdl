import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msdl/features/screens/Group/model/model.dart';

class GroupRepository {
  static const String baseUrl = "http://220.69.203.99:5000";

  Future<List<GroupUser>> fetchGroupUsers() async {
    try {
      print("🔥 fetchGroupUsers 실행됨"); // ✅ 실행 로그 추가

      final response = await http.get(
        Uri.parse("$baseUrl/users/all"), // ✅ group/attendance → users/all 변경
        headers: {
          "Content-Type": "application/json",
          "Cache-Control": "no-cache", // ✅ 캐싱 방지
        },
      );

      print("📡 서버 응답 코드: ${response.statusCode}"); // ✅ 응답 코드 확인
      print("📡 서버 응답 데이터: ${response.body}"); // ✅ 응답 내용 확인

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        print("✅ 그룹 사용자 데이터 로드 완료: $data"); // ✅ JSON 변환 후 로그 출력

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
