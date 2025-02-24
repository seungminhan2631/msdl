class WeeklyAttendance {
  final String date; // 날짜 (YYYY-MM-DD 형식)
  final bool weeklyAttendance; // 출근 여부 (true = 출근, false = 결석)
  final String checkInTime; // 출근 시간
  final String checkOutTime; // 퇴근 시간
  final int id; //userId
  WeeklyAttendance({
    required this.date,
    required this.weeklyAttendance,
    required this.checkInTime,
    required this.checkOutTime,
    required this.id,
  });

  factory WeeklyAttendance.fromJson(Map<String, dynamic> json) {
    return WeeklyAttendance(
      id: json['id'] ?? 0,
      date: json['date'] ?? '', // 날짜
      weeklyAttendance: json['weekly_attendance'] ?? false, // 출근 여부
      checkInTime: json['check_in_time'] ?? '--:--', // 출근 시간 (기본값: "--:--")
      checkOutTime: json['check_out_time'] ?? '--:--', // 퇴근 시간 (기본값: "--:--")
    );
  }
}
