class UserModel {
  final int id;
  final String email;
  final String role;
  final String name;
  final String password;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.name,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      name: json['name'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'name': name,
      'password': password,
    };
  }
}
