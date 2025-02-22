import 'package:msdl/features/screens/Home/model/WeeklyAttendance%20_mdel.dart';

class HomeModel {
  final int id;
  final String name;
  final String role;
  final bool isCheckedIn;
  final String checkInTime;
  final String checkOutTime;
  final List<WeeklyAttendance> weeklyTimeline;

  HomeModel({
    required this.id,
    required this.name,
    required this.role,
    required this.isCheckedIn,
    required this.checkInTime,
    required this.checkOutTime,
    required this.weeklyTimeline,
  });

  factory HomeModel.fromJson(Map<String, dynamic> map) {
    return HomeModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? 'Unknown',
      role: map['role'] ?? 'Unknown',
      isCheckedIn: (map['is_checked_in'] ?? 0) == 1,
      checkInTime: map['check_in_time'] ?? '--:--',
      checkOutTime: map['check_out_time'] ?? '--:--',
      weeklyTimeline: (map['weeklyTimeline'] as List<dynamic>)
          .map((e) => WeeklyAttendance.fromJson(e))
          .toList(),
    );
  }

  HomeModel copyWith({
    int? id,
    String? name,
    String? role,
    bool? isCheckedIn,
    String? checkInTime,
    String? checkOutTime,
    List<WeeklyAttendance>? weeklyTimeline,
  }) {
    return HomeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      weeklyTimeline: weeklyTimeline ?? this.weeklyTimeline,
    );
  }
}
