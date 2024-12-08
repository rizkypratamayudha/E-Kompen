class Pekerjaan {
  final int pekerjaan_id;
  final int user_id;
  final String jenis_pekerjaan;
  final String pekerjaan_nama;
  final int jumlah_jam_kompen;
  final String? akumulasi_deadline;
  final String? status;
  final DetailPekerjaan detail_pekerjaan;
  final List<Progres> progres;
  final User user;
  int anggotasekarang;

  Pekerjaan({
    required this.pekerjaan_id,
    required this.user_id,
    required this.jenis_pekerjaan,
    required this.pekerjaan_nama,
    required this.jumlah_jam_kompen,
    this.akumulasi_deadline,
    this.status,
    required this.detail_pekerjaan,
    required this.progres,
    required this.user,
    this.anggotasekarang = 0
  });

  factory Pekerjaan.fromJson(Map<String, dynamic> json) {
    return Pekerjaan(
      pekerjaan_id: json['pekerjaan_id'] ?? 0,
      user_id: json['user_id'] ?? 0,
      jenis_pekerjaan: json['jenis_pekerjaan'] ?? '',
      pekerjaan_nama: json['pekerjaan_nama'] ?? '',
      jumlah_jam_kompen: json['jumlah_jam_kompen'] ?? 0,
      akumulasi_deadline:
          json['akumulasi_deadline'], // Biarkan null jika nullable
      status: json['status'], // Tidak ada default jika nullable
      detail_pekerjaan: DetailPekerjaan.fromJson(json['detail_pekerjaan']),
      progres: (json['progres'] as List<dynamic>?)
              ?.map((item) => Progres.fromJson(item))
              .toList() ??
          [], // Kosongkan list jika null
      user: User.fromJson(json['user']),
      anggotasekarang: 0
    );
  }
}

class DetailPekerjaan {
  final int detail_pekerjaan_id;
  final int pekerjaan_id;
  final int jumlah_anggota;
  final String deskripsi_tugas;
  final List<Persyaratan> persyaratan;
  final List<KompetensiDosen> kompetensi_dosen;

  DetailPekerjaan(
      {required this.detail_pekerjaan_id,
      required this.pekerjaan_id,
      required this.jumlah_anggota,
      required this.deskripsi_tugas,
      required this.persyaratan,
      required this.kompetensi_dosen});

  factory DetailPekerjaan.fromJson(Map<String, dynamic> json) {
    return DetailPekerjaan(
      detail_pekerjaan_id: json['detail_pekerjaan_id'] ?? 0,
      pekerjaan_id: json['pekerjaan_id'] ?? 0,
      jumlah_anggota: json['jumlah_anggota'] ?? 0,
      deskripsi_tugas: json['deskripsi_tugas'] ?? '',
      persyaratan: (json['persyaratan'] as List<dynamic>?)
              ?.map((item) => Persyaratan.fromJson(item))
              .toList() ??
          [], // Kosongkan list jika null
      kompetensi_dosen: (json['kompetensi_dosen'] as List<dynamic>?)
              ?.map((item) => KompetensiDosen.fromJson(item))
              .toList() ??
          [], // Kosongkan list jika null
    );
  }
}

class Persyaratan {
  final int persyaratan_id;
  final int detail_pekerjaan_id;
  final String persyaratan_nama;

  Persyaratan({
    required this.persyaratan_id,
    required this.detail_pekerjaan_id,
    required this.persyaratan_nama,
  });

  factory Persyaratan.fromJson(Map<String, dynamic> json) {
    return Persyaratan(
      persyaratan_id: json['persyaratan_id'] ?? 0,
      detail_pekerjaan_id: json['detail_pekerjaan_id'] ?? 0,
      persyaratan_nama: json['persyaratan_nama'] ?? '',
    );
  }
}

class KompetensiDosen {
  final int kompetensi_dosen_id;
  final int detail_pekerjaan_id;
  final int kompetensi_admin_id;
  final KompetensiAdmin kompetensi_admin;

  KompetensiDosen(
      {required this.kompetensi_admin_id,
      required this.detail_pekerjaan_id,
      required this.kompetensi_dosen_id,
      required this.kompetensi_admin});

  factory KompetensiDosen.fromJson(Map<String, dynamic> json) {
    return KompetensiDosen(
        kompetensi_admin_id: json['kompetensi_admin_id'] ?? 0,
        detail_pekerjaan_id: json['detail_pekerjaan_id'] ?? 0,
        kompetensi_dosen_id: json['kompetensi_dosen_id'] ?? 0,
        kompetensi_admin: KompetensiAdmin.fromJson(json['kompetensi_admin']));
  }
}

class KompetensiAdmin {
  final int kompetensi_admin_id;
  final String kompetensi_nama;

  KompetensiAdmin({
    required this.kompetensi_admin_id,
    required this.kompetensi_nama,
  });

  factory KompetensiAdmin.fromJson(Map<String, dynamic> json) {
    return KompetensiAdmin(
      kompetensi_admin_id: json['kompetensi_admin_id'] ?? 0,
      kompetensi_nama: json['kompetensi_nama'] ?? '',
    );
  }
}

class Progres {
  final int progres_id;
  final int pekerjaan_id;
  final String judul_progres;
  final int jam_kompen;
  final int hari;
  final String? status;

  Progres({
    required this.progres_id,
    required this.pekerjaan_id,
    required this.judul_progres,
    required this.jam_kompen,
    required this.hari,
    this.status,
  });

  factory Progres.fromJson(Map<String, dynamic> json) {
    return Progres(
        progres_id: json['progres_id'] ?? 0,
        pekerjaan_id: json['pekerjaan_id'] ?? 0,
        judul_progres: json['judul_progres'] ?? '',
        jam_kompen: json['jam_kompen'] ?? 0,
        hari: json['hari'] ?? 0,
        status: json['status'] ?? '');
  }
}

class User {
  final int user_id;
  final int level_id;
  final String username;
  final String nama;
  final String avatar;
  final DetailDosen? detail_dosen; // Jadikan nullable

  User({
    required this.user_id,
    required this.level_id,
    required this.username,
    required this.nama,
    required this.avatar,
    this.detail_dosen, // Sesuaikan dengan nullable
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user_id: json['user_id'] ?? 0,
      level_id: json['level_id'] ?? 0,
      username: json['username'] ?? '',
      nama: json['nama'] ?? '',
      avatar: json['avatar'] ?? '',
      detail_dosen: json['detail_dosen'] != null
          ? DetailDosen.fromJson(json['detail_dosen'])
          : null, // Tangani null dengan aman
    );
  }
}

class DetailDosen {
  final int detail_dosen_id;
  final int user_id;
  final String email;
  final String? no_hp;

  DetailDosen({
    required this.detail_dosen_id,
    required this.user_id,
    required this.email,
    this.no_hp,
  });

  factory DetailDosen.fromJson(Map<String, dynamic> json) {
    return DetailDosen(
      detail_dosen_id:
          json['detail_dosen_id'] ?? 0, // Gunakan angka, bukan string
      user_id: json['user_id'] ?? 0, // Pastikan default value
      email: json['email'] ?? '',
      no_hp: json['no_hp'] ?? '',
    );
  }
}
