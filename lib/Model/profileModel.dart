class ProfileModel {
  final int profileId;
  final String? avatar;
  final int userId;
  final int kompetensiId;

  ProfileModel({
    required this.profileId,
    this.avatar,
    required this.userId,
    required this.kompetensiId,
  
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profileId: json['profil_id'],
      avatar: json['avatar'],
      userId: json['user_id'],
      kompetensiId: json['kompetensi_id'],
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profil_id': profileId,
      'avatar': avatar,
      'user_id': userId,
      'kompetensi_id': kompetensiId,
    };
  }
}
