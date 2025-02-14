class HomeModel {
  final int userId;
  final String name;
  final String role;
  final bool isCheckedIn;
  final String workCategory;
  final String workLocation;
  final List<Map<String, dynamic>> weeklyTimeline;

  HomeModel({
    required this.userId,
    required this.name,
    required this.role,
    required this.isCheckedIn,
    required this.workCategory,
    required this.workLocation,
    required this.weeklyTimeline,
  });

  factory HomeModel.fromMap(
      Map<String, dynamic> map, List<Map<String, dynamic>> weeklyData) {
    return HomeModel(
      userId: map['id'],
      name: map['name'],
      role: map['role'],
      isCheckedIn: (map['is_checked_in'] ?? 0) == 1,
      workCategory: map['work_category'] ?? "Unknown",
      workLocation: map['work_location'] ?? "Unknown",
      weeklyTimeline: weeklyData,
    );
  }
}
