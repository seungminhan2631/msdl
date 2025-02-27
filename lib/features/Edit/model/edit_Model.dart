class EditModel {
  final int userId;
  String name;
  String role;
  String email;

  EditModel({
    required this.userId,
    required this.name,
    required this.role,
    required this.email,
  });

  factory EditModel.fromJson(Map<String, dynamic> json) {
    return EditModel(
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "name": name,
      "role": role,
      "email": email,
    };
  }
}
