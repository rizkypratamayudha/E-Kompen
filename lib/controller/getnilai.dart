class Pengumpulan {
  final int pengumpulanId;
  final int progresId;
  final int userId;
  final String buktiPengumpulan;
  final String namaOriginal;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;
  final Progres progres;

  Pengumpulan({
    required this.pengumpulanId,
    required this.progresId,
    required this.userId,
    required this.buktiPengumpulan,
    required this.namaOriginal,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.progres,
  });

  factory Pengumpulan.fromJson(Map<String, dynamic> json) {
    return Pengumpulan(
      pengumpulanId: json['pengumpulan_id'],
      progresId: json['progres_id'],
      userId: json['user_id'],
      buktiPengumpulan: json['bukti_pengumpulan'],
      namaOriginal: json['namaoriginal'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: User.fromJson(json['user']),
      progres: Progres.fromJson(json['progres']),
    );
  }
}

class User {
  final int userId;
  final int levelId;
  final String username;
  final String nama;
  final String? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.userId,
    required this.levelId,
    required this.username,
    required this.nama,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      levelId: json['level_id'],
      username: json['username'],
      nama: json['nama'],
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Progres {
  final int progresId;
  final int pekerjaanId;
  final String judulProgres;
  final int jamKompen;
  final int hari;
  final String? status;
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Pekerjaan pekerjaan;

  Progres({
    required this.progresId,
    required this.pekerjaanId,
    required this.judulProgres,
    required this.jamKompen,
    required this.hari,
    this.status,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
    required this.pekerjaan,
  });

  factory Progres.fromJson(Map<String, dynamic> json) {
    return Progres(
      progresId: json['progres_id'],
      pekerjaanId: json['pekerjaan_id'],
      judulProgres: json['judul_progres'],
      jamKompen: json['jam_kompen'],
      hari: json['hari'],
      status: json['status'],
      deadline: DateTime.parse(json['deadline']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      pekerjaan: Pekerjaan.fromJson(json['pekerjaan']),
    );
  }
}

class Pekerjaan {
  final int pekerjaanId;
  final int userId;
  final String jenisPekerjaan;
  final String pekerjaanNama;
  final int jumlahJamKompen;
  final String status;
  final DateTime akumulasiDeadline;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pekerjaan({
    required this.pekerjaanId,
    required this.userId,
    required this.jenisPekerjaan,
    required this.pekerjaanNama,
    required this.jumlahJamKompen,
    required this.status,
    required this.akumulasiDeadline,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pekerjaan.fromJson(Map<String, dynamic> json) {
    return Pekerjaan(
      pekerjaanId: json['pekerjaan_id'],
      userId: json['user_id'],
      jenisPekerjaan: json['jenis_pekerjaan'],
      pekerjaanNama: json['pekerjaan_nama'],
      jumlahJamKompen: json['jumlah_jam_kompen'],
      status: json['status'],
      akumulasiDeadline: DateTime.parse(json['akumulasi_deadline']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
