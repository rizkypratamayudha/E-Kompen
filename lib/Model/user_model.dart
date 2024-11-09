class UserModel {
  final int id;
  final String nama;
  final String role;

  UserModel({
    required this.id,
    required this.nama,
    required this.role
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      id: json['id'],
      nama: json['name'],
      role: json['role'],
    );
  }
}