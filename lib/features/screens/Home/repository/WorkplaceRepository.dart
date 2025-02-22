import 'dart:convert';
import 'package:http/http.dart' as http;

class WorkplaceRepository {
  static const String baseUrl = "http://220.69.203.99:5000";

  Future<void> updateLocation(
      int userId, String latitude, String longitude, String category) async {
    final response = await http.post(
      Uri.parse('$baseUrl/location/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'latitude': latitude,
        'longitude': longitude,
        'category': category,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update location');
    }
  }

  Future<String> fetchLocationCategory(int userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/location/category/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['category'];
    } else {
      throw Exception('Failed to load location category');
    }
  }
}
