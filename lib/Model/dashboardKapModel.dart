class DashboardKap {
  final User user;
  final int pendingCount;
  final int approveCount;

  DashboardKap({
    required this.user,
    required this.pendingCount,
    required this.approveCount,
  });

  factory DashboardKap.fromJson(Map<String, dynamic> json) {
    return DashboardKap(
      user: User.fromJson(json['user']),
      pendingCount: json['pendingCount'],
      approveCount: json['approveCount'],
    );
  }
}

class User {
  final int userId;
  final int levelId;
  final String username;
  final String nama;
  final String avatar;
  final Level level;
  final DetailKaprodi detailKaprodi;

  User({
    required this.userId,
    required this.levelId,
    required this.username,
    required this.nama,
    required this.avatar,
    required this.level,
    required this.detailKaprodi,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      levelId: json['level_id'],
      username: json['username'],
      nama: json['nama'],
      avatar: json['avatar'],
      level: Level.fromJson(json['level']),
      detailKaprodi: DetailKaprodi.fromJson(json['detail_kaprodi']),
    );
  }
}

class Level {
  final int levelId;
  final String levelKode;
  final String levelNama;

  Level({
    required this.levelId,
    required this.levelKode,
    required this.levelNama,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      levelId: json['level_id'],
      levelKode: json['kode_level'],
      levelNama: json['level_nama'],
    );
  }
}

class DetailKaprodi {
  final int detailKaprodiId;
  final int userId;
  final String email;
  final String noHp;
  final Prodi prodi;

  DetailKaprodi({
    required this.detailKaprodiId,
    required this.userId,
    required this.email,
    required this.noHp,
    required this.prodi,
  });

  factory DetailKaprodi.fromJson(Map<String, dynamic> json) {
    return DetailKaprodi(
      detailKaprodiId: json['detail_kaprodi_id'],
      userId: json['user_id'],
      email: json['email'],
      noHp: json['no_hp'],
      prodi: Prodi.fromJson(json['prodi']),
    );
  }
}

class Prodi {
  final int prodiId;
  final String prodiNama;

  Prodi({
    required this.prodiId,
    required this.prodiNama,
  });

  factory Prodi.fromJson(Map<String, dynamic> json) {
    return Prodi(
      prodiId: json['prodi_id'],
      prodiNama: json['prodi_nama'],
    );
  }
}
