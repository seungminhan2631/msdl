import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/workplace_model.dart';

class WorkplaceRepository {
  static const String baseUrl = "http://220.69.203.99:5000"; // Flask 서버 주소

  // ✅ 특정 유저의 Workplace 정보 가져오기 (오류 해결)
  Future<Workplace?> fetchUserWorkplace(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/location/$userId'));

      print("📡 서버 응답: ${response.body}");

      if (response.statusCode != 200) {
        print("❌ 서버 응답 오류: ${response.statusCode}");
        return null;
      }

      final decodedJson = jsonDecode(response.body);

      if (decodedJson is Map<String, dynamic>) {
        return Workplace.fromJson(decodedJson);
      } else {
        print("⚠️ 예상치 못한 응답: $decodedJson");
        return null;
      }
    } catch (e) {
      print("🔥 fetchUserWorkplace 실패: $e");
      return null;
    }
  }

  // ✅ 유저의 Workplace 정보 업데이트
  Future<void> updateUserWorkplace(
      int userId, String location, String category) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/location/update'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'current_location': location,
          'category': category,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('❌ Failed to update workplace: ${response.statusCode}');
      }

      print("✅ Workplace 업데이트 성공: ${response.body}");
    } catch (e) {
      print("🔥 updateUserWorkplace 실패: $e");
      throw Exception('Failed to update workplace');
    }
  }
}
