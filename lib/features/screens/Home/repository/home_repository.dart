import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/home_model.dart';

class HomeRepository {
  static const String baseUrl = "http://220.69.203.99:5000";

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

  Future<String?> updateAttendance(int userId, bool isClockIn) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/attendance/update"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "action":
              isClockIn ? "check_in" : "check_out", // 출근일 경우 "check_in" 보내기
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ 출퇴근 업데이트 성공 - 시간: ${data["time"]}");
        return data["time"]; // ✅ 기록된 시간을 반환
      } else {
        print("❌ 출퇴근 업데이트 실패: ${response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ 서버 연결 오류: $e");
      return null;
    }
  }
}
