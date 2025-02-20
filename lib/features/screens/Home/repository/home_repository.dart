import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/home_model.dart';

class HomeRepository {
  static const String baseUrl = "http://192.168.1.21:5000";

  Future<HomeModel?> getHomeData(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/home/$userId"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return HomeModel.fromJson(data);
      } else {
        print("❌ 홈 데이터 가져오기 실패: ${response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ 서버 연결 오류: $e");
      return null;
    }
  }

  Future<void> updateAttendance(int userId, bool isClockIn) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/attendance/update"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "action": isClockIn ? "check_in" : "check_out",
        }),
      );

      if (response.statusCode == 200) {
        print("✅ 출퇴근 업데이트 성공");
      } else {
        print("❌ 출퇴근 업데이트 실패: ${response.body}");
      }
    } catch (e) {
      print("⚠️ 서버 연결 오류: $e");
    }
  }
}
