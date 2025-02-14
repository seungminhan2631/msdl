import 'package:msdl/data/database_helper.dart';
import 'package:msdl/features/screens/group/model/model.dart';

class GroupRepository {
  final db = DatabaseHelper.instance;

  Future<List<GroupModel>> getGroupUsers() async {
    final _db = await db.database;
    final result = await _db.rawQuery('''
      SELECT users.id, users.name, users.role, 
             attendance.check_in_time, attendance.check_out_time
      FROM users
      LEFT JOIN attendance ON users.id = attendance.user_id
      LEFT JOIN work_locations ON users.id = work_locations.user_id;
    ''');

    print("🔎 SQL Query Result: $result");
    return result.map((map) => GroupModel.fromMap(map)).toList();
  }
}
