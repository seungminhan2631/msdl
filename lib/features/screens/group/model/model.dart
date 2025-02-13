class GroupModel {
  final String id;
  final String name;
  final String role;
  final String checkInTime;
  final String checkOutTime;

  GroupModel({
    required this.id, // ✅ id를 required로 설정
    required this.name,
    required this.role,
    required this.checkInTime,
    required this.checkOutTime,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'].toString(), // ✅ id를 문자열로 변환 (DB에서 INT일 가능성 있음)
      name: map['name'],
      role: map['role'],
      checkInTime: map['check_in_time'] ?? '--:--',
      checkOutTime: map['check_out_time'] ?? '--:--',
    );
  }
}
