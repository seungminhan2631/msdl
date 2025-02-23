import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msdl/features/screens/Home/model/workplace_model.dart';

class HomeWorkplaceRepository {
  static const String baseUrl = "http://220.69.203.99:5000";

  // ✅ 유저의 모든 Workplace 가져오기
  Future<List<HomeWorkplace>> fetchUserWorkplaces(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/location/$userId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> locations = data['locations']; // ✅ 리스트 반환

      return locations.map((json) => HomeWorkplace.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load workplaces');
    }
  }
}
