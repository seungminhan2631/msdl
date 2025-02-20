// import 'package:msdl/data/database_helper.dart';

// Future<void> resetDatabase() async {
//   final db = await DatabaseHelper.instance.database;

//   await db.execute("DROP TABLE IF EXISTS attendance");
//   await db.execute("DROP TABLE IF EXISTS users");
//   await db.execute("DROP TABLE IF EXISTS work_locations");
//   await db.execute("DROP TABLE IF EXISTS week");
//   print("⚠️ 기존 데이터베이스 삭제 완료");
//   await DatabaseHelper.instance.recreateDatabase(); // ✅ 새롭게 DB 생성

//   await db.execute('''
//     CREATE TABLE users (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         email TEXT UNIQUE NOT NULL,
//         password TEXT NOT NULL,
//         role TEXT CHECK(role IN ('Professor', 'Ph.D. Student', 'MS Student', 'BS Student')) NOT NULL,
//         name TEXT NOT NULL
//     );
//   ''');

//   await db.execute('''
//     CREATE TABLE attendance (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         user_id INTEGER NOT NULL,
//         date TEXT NOT NULL,
//         check_in_time TEXT,
//         check_out_time TEXT,
//         is_checked_in INTEGER DEFAULT 0, -- ✅ 출근 상태 컬럼 추가
//         work_category TEXT CHECK(work_category IN ('Lab', 'Home', 'Out Of Office', 'Other')),
//         work_location TEXT,
//         FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
//     );
//   ''');

//   await db.execute('''
//     CREATE TABLE work_locations (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         user_id INTEGER NOT NULL,
//         location_name TEXT NOT NULL,
//         latitude REAL NOT NULL,
//         longitude REAL NOT NULL,
//         work_category TEXT CHECK(work_category IN ('Lab', 'Home', 'Out Of Office', 'Other')),
//         FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
//     );
//   ''');

//   print("✅ 새로운 데이터베이스 생성 완료");
// }
