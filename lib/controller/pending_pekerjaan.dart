class PendingPekerjaan {
  final int pendingPekerjaanId;
  final int userId;
  final int pekerjaanId;
  final User user;
  final Pekerjaan pekerjaan;

  PendingPekerjaan(
      {required this.pendingPekerjaanId,
      required this.userId,
      required this.pekerjaanId,
      required this.user,
      required this.pekerjaan});

  factory PendingPekerjaan.fromJson(Map<String, dynamic> json) {
    return PendingPekerjaan(
        pendingPekerjaanId: json['t_pending_pekerjaan_id'] ?? 0,
        userId: json['user_id'] ?? 0,
        pekerjaanId: json['pekerjaan_id'] ?? 0,
        user: User.fromJson(json['user']),
        pekerjaan: Pekerjaan.fromJson(json['pekerjaan']));
  }
}

class User {
  final int userId;
  final int levelId;
  final String username;
  final String nama;
  final String avatar;
  final DetailMahasiswa detailMahasiswa;
  final List<Kompetensi> kompetensi;

  User(
      {required this.userId,
      required this.levelId,
      required this.username,
      required this.nama,
      required this.avatar,
      required this.detailMahasiswa,
      required this.kompetensi});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? 0,
      levelId: json['level_id'] ?? 0,
      username: json['username'] ?? '',
      nama: json['nama'] ?? '',
      avatar: json['avatar'] ?? '',
      detailMahasiswa: DetailMahasiswa.fromJson(json['detail_mahasiswa']),
      kompetensi: (json['kompetensi'] as List<dynamic>?)
              ?.map((item) => Kompetensi.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class DetailMahasiswa {
  final int detailMahasiswaId;
  final int UserId;
  final String email;
  final String noHP;
  final String angkatan;
  final int prodiId;
  final int periodeID;

  DetailMahasiswa({
    required this.detailMahasiswaId,
    required this.UserId,
    required this.email,
    required this.noHP,
    required this.angkatan,
    required this.prodiId,
    required this.periodeID,
  });

  factory DetailMahasiswa.fromJson(Map<String, dynamic> json) {
    return DetailMahasiswa(
        detailMahasiswaId: json['detail_mahasiswa_id'] ?? 0,
        UserId: json['user_id'] ?? 0,
        email: json['email'] ?? '',
        noHP: json['no_hp'] ?? '',
        angkatan: json['angkatan'] ?? '',
        prodiId: json['prodi_id'] ?? 0,
        periodeID: json['periode_id'] ?? 0);
  }
}

class Kompetensi {
  final int kompetensiID;
  final int kompetensiAdminId;
  final int userID;
  final String pengalmaan;
  final String bukti;
  final KompetensiAdmin kompetensiAdmin;

  Kompetensi(
      {required this.kompetensiID,
      required this.kompetensiAdminId,
      required this.userID,
      required this.pengalmaan,
      required this.bukti,
      required this.kompetensiAdmin});

  factory Kompetensi.fromJson(Map<String, dynamic> json) {
    return Kompetensi(
        kompetensiID: json['kompetensi_id'] ?? 0,
        kompetensiAdminId: json['kompetensi_admin_id'] ?? 0,
        userID: json['user_id'] ?? 0,
        pengalmaan: json['pengalaman'] ?? '',
        bukti: json['bukti'] ?? '',
        kompetensiAdmin: KompetensiAdmin.fromJson(json['kompetensi_admin']));
  }
}

class KompetensiAdmin {
  final int kompetensiAdmin;
  final String kompetensiNama;

  KompetensiAdmin({
    required this.kompetensiAdmin,
    required this.kompetensiNama,
  });

  factory KompetensiAdmin.fromJson(Map<String, dynamic> json) {
    return KompetensiAdmin(
        kompetensiAdmin: json['kompetensi_admin_id'] ?? 0,
        kompetensiNama: json['kompetensi_nama'] ?? '');
  }
}

class Pekerjaan {
  final int pekerjaanID;
  final int userID;
  final String pekerjaanNama;

  Pekerjaan({
    required this.pekerjaanID,
    required this.userID,
    required this.pekerjaanNama,
  });

  factory Pekerjaan.fromJson(Map<String, dynamic> json) {
    return Pekerjaan(
        pekerjaanID: json['pekerjaan_id'] ?? 0,
        userID: json['user_id'] ?? 0,
        pekerjaanNama: json['pekerjaan_nama'] ?? '');
  }
}
