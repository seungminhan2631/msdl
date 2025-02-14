class HomeModel {
  final int? id;
  final String email;
  final String password;
  final String role;
  final String name;

  HomeModel({
    this.id,
    required this.email,
    required this.password,
    required this.role,
    required this.name,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'role': role,
      'name': name,
    };
  }
}
