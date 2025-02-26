class Workplace {
  final int id;
  final int userId;
  final String currentLocation;
  final String category;

  Workplace({
    required this.id,
    required this.userId,
    required this.currentLocation,
    required this.category,
  });

  // Flask 서버에서 받은 데이터를 Workplace 객체로 변환
  factory Workplace.fromJson(Map<String, dynamic> json) {
    return Workplace(
      id: json['id'],
      userId: json['user_id'],
      currentLocation: json['current_location'],
      category: json['category'],
    );
  }

  // Workplace 객체를 Flask 서버로 전송할 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'current_location': currentLocation,
      'category': category,
    };
  }
}
