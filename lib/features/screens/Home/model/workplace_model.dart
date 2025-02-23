class HomeWorkplace {
  final int locationId;
  final String currentLocation;
  final String category;
  final String createdAt;

  HomeWorkplace({
    required this.locationId,
    required this.currentLocation,
    required this.category,
    required this.createdAt,
  });

  factory HomeWorkplace.fromJson(Map<String, dynamic> json) {
    return HomeWorkplace(
      locationId: json['location_id'],
      currentLocation: json['current_location'],
      category: json['category'],
      createdAt: json['created_at'],
    );
  }
}
