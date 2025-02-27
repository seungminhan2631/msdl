import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msdl/features/screens/Home/model/WeeklyAttendance%20_mdel.dart';
import 'package:msdl/features/screens/Home/model/workplace_model.dart';

class WeeklyAttendanceRepository {
  static String baseUrl = "http://220.69.203.99:5000";

  Future<List<WeeklyAttendance>> fetchWeeklyAttendance(int userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/attendance/weekly/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> weeklyData = jsonDecode(response.body);
      return weeklyData.map((data) => WeeklyAttendance.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load weekly attendance');
    }
  }
}
