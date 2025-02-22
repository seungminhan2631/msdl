class WeeklyAttendance {
  final String date;
  final bool weeklyAttendance;

  WeeklyAttendance({required this.date, required this.weeklyAttendance});

  factory WeeklyAttendance.fromJson(Map<String, dynamic> json) {
    return WeeklyAttendance(
      date: json['date'] ?? '',
      weeklyAttendance: json['weekly_attendance'] ?? false,
    );
  }
}
