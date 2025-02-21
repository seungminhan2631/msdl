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
    required this.checkInTime,
    required this.checkOutTime,
    required this.weeklyTimeline,
  });

  factory HomeModel.fromJson(Map<String, dynamic> map) {
    return HomeModel(
      id: map['id'] ?? 0, // 기본값 추가
      name: map['name'] ?? 'Unknown',
      role: map['role'] ?? 'Unknown',
      isCheckedIn: (map['is_checked_in'] ?? 0) == 1,
      workCategory: map['work_category'] ?? "Unknown",
      workLocation: map['work_location'] ?? "Unknown",
      checkInTime: map['check_in_time'] ?? '--:--',
      checkOutTime: map['check_out_time'] ?? '--:--',
      weeklyTimeline:
          List<Map<String, dynamic>>.from(map['weeklyTimeline'] ?? []),
    );
  }

  // ✅ copyWith 메서드 수정
  HomeModel copyWith({
    int? id,
    String? name,
    String? role,
    bool? isCheckedIn,
    String? workCategory,
    String? workLocation,
    String? checkInTime,
    String? checkOutTime,
    List<Map<String, dynamic>>? weeklyTimeline,
  }) {
    return HomeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      workCategory: workCategory ?? this.workCategory,
      workLocation: workLocation ?? this.workLocation,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      weeklyTimeline: weeklyTimeline ?? this.weeklyTimeline,
    );
  }
}
