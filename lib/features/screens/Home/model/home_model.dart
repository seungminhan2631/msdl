class HomeModel {
  final int id;
  final String name;
  final String role;
  final bool isCheckedIn;
  final String workCategory;
  final String workLocation;
  final String checkInTime;
  final String checkOutTime;
  final List<Map<String, dynamic>> weeklyTimeline;

  HomeModel({
    required this.id,
    required this.name,
    required this.role,
    required this.isCheckedIn,
    required this.workCategory,
    required this.workLocation,
    required this.weeklyTimeline,
    required this.checkInTime,
    required this.checkOutTime,
  });

  factory HomeModel.fromMap(
      Map<String, dynamic> map, List<Map<String, dynamic>> weeklyData) {
    return HomeModel(
      id: map['id'], // ✅ 추가됨
      name: map['name'],
      role: map['role'],
      isCheckedIn: (map['is_checked_in'] ?? 0) == 1,
      workCategory: map['work_category'] ?? "Unknown",
      workLocation: map['work_location'] ?? "Unknown",
      checkInTime: map['check_in_time'] ?? '--:--',
      checkOutTime: map['check_out_time'] ?? '--:--',
      weeklyTimeline: weeklyData,
    );
  }
}
