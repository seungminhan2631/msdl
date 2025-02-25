import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/home_model.dart';

class HomeRepository {
  static const String baseUrl = "http://220.69.203.99:5000";

  Future<HomeModel?> fetchHomeData(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/home/$userId'));

      print("📡 서버 응답 타입: ${response.runtimeType}");
      print("📡 서버 응답 내용: ${response.body}");

      if (response.statusCode != 200) {
        print("❌ 서버 응답 오류: ${response.statusCode}");
        return null;
      }

      final decodedJson = jsonDecode(response.body); // ✅ JSON 변환

      if (decodedJson == null) {
        print("⚠️ 서버 응답이 null임.");
        return null;
      }

      if (decodedJson is List && decodedJson.isNotEmpty) {
        print("🔍 서버 응답이 List 형태 → 첫 번째 요소 사용");
        return HomeModel.fromJson(decodedJson.first);
      } else if (decodedJson is Map<String, dynamic>) {
        print("✅ 서버 응답이 Map 형태");
        return HomeModel.fromJson(decodedJson);
      } else {
        print("⚠️ 서버 응답이 예상과 다름: $decodedJson");
        return null;
      }
    } catch (e) {
      print("🔥 fetchHomeData 실패: $e");
      return null;
    }
  }

  Future<void> updateAttendance(int userId, String action) async {
    final response = await http.post(
      Uri.parse('$baseUrl/attendance/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'action': action,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update attendance');
    }
  }
}
