class UserModel {
  final int id;
  final String nama;
  final String role;
  final String avatar;

  UserModel({
    required this.id,
    required this.nama,
    required this.role,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nama: json['name'],
      role: json['role'],
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nama,
      'role': role,
      'avatar': avatar,
    };
  }
}
