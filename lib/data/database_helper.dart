// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;

//   DatabaseHelper._init();

//   Future<Database> get database async {
//     if (_database == null || !_database!.isOpen) {
//       print("📌 데이터베이스가 닫혀 있음. 새로 열기...");
//       _database = await _initDB('msdl.db');
//     }
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     print("📌 데이터베이스 경로: $path");

//     return await openDatabase(
//       path,
//       version: 2, // ✅ 버전 2 (업데이트 시 변경)
//       onCreate: _createDB,
//       onUpgrade: _onUpgrade,
//     );
//   }

//   Future<void> _createDB(Database db, [int? version]) async {
//     try {
//       await db.execute('''
//         CREATE TABLE IF NOT EXISTS users (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             email TEXT UNIQUE NOT NULL,
//             password TEXT NOT NULL,
//             role TEXT CHECK(role IN ('Professor', 'Ph.D. Student', 'MS Student', 'BS Student')) NOT NULL,
//             name TEXT NOT NULL
//         );
//       ''');
//       print("✅ users 테이블 생성 완료");

//       await db.execute('''
//         CREATE TABLE IF NOT EXISTS attendance (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             user_id INTEGER NOT NULL,
//             date TEXT NOT NULL,
//             check_in_time TEXT,
//             check_out_time TEXT,
//             is_checked_in INTEGER DEFAULT 0,
//             work_category TEXT CHECK(work_category IN ('Lab', 'Home', 'Out Of Office', 'Other')),
//             work_location TEXT,
//             FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
//             UNIQUE(user_id, date)  -- ✅ 중복 방지
//         );
//       ''');
//       print("✅ attendance 테이블 생성 완료");

//       await db.execute('''
//         CREATE TABLE IF NOT EXISTS work_locations (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             user_id INTEGER NOT NULL,
//             location_name TEXT NOT NULL,
//             latitude REAL NOT NULL,
//             longitude REAL NOT NULL,
//             work_category TEXT CHECK(work_category IN ('Lab', 'Home', 'Out Of Office', 'Other')),
//             FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
//         );
//       ''');
//       print("✅ work_locations 테이블 생성 완료");

//       await db.execute('''
//         CREATE TABLE IF NOT EXISTS week (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             user_id INTEGER NOT NULL,
//             date TEXT NOT NULL,
//             status TEXT CHECK(status IN ('Checked In', 'Checked Out', 'Absent')) NOT NULL,
//             FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
//         );
//       ''');
//       print("✅ week 테이블 생성 완료");
//     } catch (e) {
//       print("❌ 데이터베이스 생성 중 오류 발생: $e");
//     }
//   }

//   Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
//     if (oldVersion < 2) {
//       print("🔄 데이터베이스 업그레이드 중...");
//       await db.execute('''
//         CREATE TABLE IF NOT EXISTS week (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           user_id INTEGER NOT NULL,
//           date TEXT NOT NULL,
//           status TEXT CHECK(status IN ('Checked In', 'Checked Out', 'Absent')) NOT NULL,
//           FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
//         );
//       ''');
//       print("✅ week 테이블 추가 완료");
//     }
//   }

//   Future<void> recreateDatabase() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, 'msdl.db');

//     // ✅ 기존 데이터베이스 삭제
//     await deleteDatabase(path);
//     print("⚠️ 기존 데이터베이스 삭제 완료");

//     // ✅ 새 데이터베이스 초기화
//     _database = await _initDB('msdl.db');
//     print("✅ 새로운 데이터베이스 생성 완료");
//   }

//   Future<void> printAllTables() async {
//     final db = await database;
//     final tables =
//         await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
//     print("📌 현재 존재하는 테이블 목록:");
//     for (var table in tables) {
//       print("🔹 Table: ${table['name']}");
//     }
//   }

//   Future<void> printAllUsers() async {
//     final db = await database;
//     final users = await db.query('users');
//     print("📌 users 테이블 데이터:");
//     for (var user in users) {
//       print(
//           "🔹 ID: ${user['id']}, Email: ${user['email']}, Role: ${user['role']}, Name: ${user['name']}");
//     }
//   }

//   Future<void> printAllAttendance() async {
//     final db = await database;
//     final attendance = await db.query('attendance');
//     print("📌 attendance 테이블 데이터:");
//     for (var record in attendance) {
//       print(
//           "🔹 ID: ${record['id']}, User ID: ${record['user_id']}, Date: ${record['date']}, "
//           "Check-In: ${record['check_in_time']}, Check-Out: ${record['check_out_time']}, "
//           "Checked In: ${record['is_checked_in']}, Work Category: ${record['work_category']}, "
//           "Work Location: ${record['work_location']}");
//     }
//   }

//   Future<void> printAllWeekRecords() async {
//     final db = await database;
//     final week = await db.query('week');
//     print("📌 week 테이블 데이터:");
//     for (var record in week) {
//       print(
//           "🔹 ID: ${record['id']}, User ID: ${record['user_id']}, Date: ${record['date']}, Status: ${record['status']}");
//     }
//   }

//   Future<void> printAllWorkLocations() async {
//     final db = await database;
//     final locations = await db.query('work_locations');
//     print("📌 work_locations 테이블 데이터:");
//     for (var location in locations) {
//       print("🔹 ID: ${location['id']}, User ID: ${location['user_id']}, "
//           "Latitude: ${location['latitude']}, Longitude: ${location['longitude']}, "
//           "Category: ${location['work_category']}");
//     }
//   }
// }
