import 'package:msdl/data/database_helper.dart';
import 'package:msdl/features/screens/Home/model/home_model.dart';

class HomeRepository {
  final db = DatabaseHelper.instance;

  // 🔥 최근 7일 출근 기록 가져오기
  Future<List<Map<String, dynamic>>> getWeeklyAttendance(int userId) async {
    final _db = await db.database;
    final result = await _db.rawQuery('''
      SELECT date, status FROM weekly_attendance
      WHERE user_id = ? 
      AND date BETWEEN date('now', '-6 days') AND date('now')
      ORDER BY date ASC
    ''', [userId]);

    print("📅 주간 출근 기록 가져오기: $result"); // 🔥 디버깅 추가
    return result;
  }

  Future<bool> isUserCheckedIn(int userId) async {
    final _db = await db.database;
    final result = await _db.rawQuery('''
      SELECT is_checked_in FROM attendance 
      WHERE user_id = ? AND date = date('now')
    ''', [userId]);

    print("🟢 출근 상태: $result"); // 🔥 디버깅 추가
    return result.isNotEmpty && (result.first['is_checked_in'] as int) == 1;
  }

  // 🔥 사용자 정보 + 출근 상태 + 근무 위치 + 주간 출근 기록 가져오기
  Future<HomeModel> getHomeData(int userId) async {
    final _db = await db.database;

    final userResult = await _db.rawQuery('''
      SELECT users.id, users.name, users.role, 
             attendance.is_checked_in, attendance.work_category, 
             work_locations.location_name
      FROM users
      LEFT JOIN attendance ON users.id = attendance.user_id
      LEFT JOIN work_locations ON users.id = work_locations.user_id
      WHERE users.id = ?
    ''', [userId]);

    if (userResult.isEmpty) {
      throw Exception("User not found");
    }

    print("👤 사용자 정보 가져오기: $userResult"); // 🔥 디버깅 추가

    final isCheckedIn = await isUserCheckedIn(userId);
    final weeklyTimeline = await getWeeklyAttendance(userId);

    return HomeModel.fromMap(userResult.first, weeklyTimeline);
  }
}
