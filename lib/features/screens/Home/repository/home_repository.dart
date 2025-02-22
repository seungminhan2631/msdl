import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/home_model.dart';

class HomeRepository {
  static const String baseUrl = "http://220.69.203.99:5000";

  Future<HomeModel> fetchHomeData(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/home/$userId'));

    if (response.statusCode == 200) {
      return HomeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load home data');
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
