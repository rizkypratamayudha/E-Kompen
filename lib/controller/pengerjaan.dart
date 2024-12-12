class Pekerjaan {
  final int pekerjaanId;
  final int userId;
  final String jenisPekerjaan;
  final String pekerjaanNama;
  final int jumlahJamKompen;
  final String status;
  final String? akumulasiDeadline;
  final String createdAt;
  final String updatedAt;
  final List<Progres> progres;
  final DetailPekerjaan detailpekerjaan;
  final User user;

  Pekerjaan({
    required this.pekerjaanId,
    required this.userId,
    required this.jenisPekerjaan,
    required this.pekerjaanNama,
    required this.jumlahJamKompen,
    required this.status,
    this.akumulasiDeadline,
    required this.createdAt,
    required this.updatedAt,
    required this.progres,
    required this.detailpekerjaan,
    required this.user,
  });

  factory Pekerjaan.fromJson(Map<String, dynamic> json) {
    return Pekerjaan(
      pekerjaanId: json['pekerjaan_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      jenisPekerjaan: json['jenis_pekerjaan'] ?? '',
      pekerjaanNama: json['pekerjaan_nama'] ?? '',
      jumlahJamKompen: json['jumlah_jam_kompen'] ?? 0,
      status: json['status'] ?? '',
      akumulasiDeadline: json['akumulasi_deadline'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      detailpekerjaan: DetailPekerjaan.fromJson(json['detail_pekerjaan'] ?? {}),
      user: User.fromJson(json['user'] ?? {}),
      progres: (json['progres'] as List?)
              ?.map((item) => Progres.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class DetailPekerjaan {
  final int detailPekerjaanId;
  final int pekerjaanId;
  final int jumlahAnggota;
  final String deskripsiTugas;
  final String createdAt;
  final String updatedAt;

  DetailPekerjaan({
    required this.detailPekerjaanId,
    required this.pekerjaanId,
    required this.jumlahAnggota,
    required this.deskripsiTugas,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DetailPekerjaan.fromJson(Map<String, dynamic> json) {
    return DetailPekerjaan(
      detailPekerjaanId: json['detail_pekerjaan_id'] ?? 0,
      pekerjaanId: json['pekerjaan_id'] ?? 0,
      jumlahAnggota: json['jumlah_anggota'] ?? 0,
      deskripsiTugas: json['deskripsi_tugas'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class User {
  final int userId;
  final int levelId;
  final String username;
  final String nama;
  final String avatar;
  final String createdAt;
  final String updatedAt;
  final DetailDosen detailDosen;

  User({
    required this.userId,
    required this.levelId,
    required this.username,
    required this.nama,
    required this.avatar,
    required this.createdAt,
    required this.updatedAt,
    required this.detailDosen,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? 0,
      levelId: json['level_id'] ?? 0,
      username: json['username'] ?? '',
      nama: json['nama'] ?? '',
      avatar: json['avatar'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      detailDosen: json['detail_dosen'] != null
          ? DetailDosen.fromJson(json['detail_dosen'])
          : DetailDosen(),
    );
  }
}

class DetailDosen {
  final int? detailDosenId;
  final int? userId;
  final String? email;
  String? noHp;
  final String? createdAt;
  final String? updatedAt;

  DetailDosen({
    this.detailDosenId,
    this.userId,
    this.email,
    this.noHp,
    this.createdAt,
    this.updatedAt,
  });

  factory DetailDosen.fromJson(Map<String, dynamic> json) {
    return DetailDosen(
      detailDosenId: json['detail_dosen_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      email: json['email'] ?? '',
      noHp: json['no_hp'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
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
  final String? deadline;
  final String createdAt;
  final String updatedAt;
  final List<Pengumpulan> pengumpulan;

  Progres({
    required this.progresId,
    required this.pekerjaanId,
    required this.judulProgres,
    required this.jamKompen,
    required this.hari,
    this.status,
    this.deadline,
    required this.createdAt,
    required this.updatedAt,
    required this.pengumpulan,
  });

  factory Progres.fromJson(Map<String, dynamic> json) {
    return Progres(
      progresId: json['progres_id'] ?? 0,
      pekerjaanId: json['pekerjaan_id'] ?? 0,
      judulProgres: json['judul_progres'] ?? '',
      jamKompen: json['jam_kompen'] ?? 0,
      hari: json['hari'] ?? 0,
      status: json['status'],
      deadline: json['deadline'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      pengumpulan: (json['pengumpulan'] as List?)
              ?.map((item) => Pengumpulan.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class Pengumpulan {
  final int pengumpulanId;
  final int progresId;
  final int userId;
  final String buktiPengumpulan;
  final String? namaoriginal;
  final String status;
  final String createdAt;
  final String updatedAt;

  Pengumpulan({
    required this.pengumpulanId,
    required this.progresId,
    required this.userId,
    required this.buktiPengumpulan,
    this.namaoriginal,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pengumpulan.fromJson(Map<String, dynamic> json) {
    return Pengumpulan(
      pengumpulanId: json['pengumpulan_id'] ?? 0,
      progresId: json['progres_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      buktiPengumpulan: json['bukti_pengumpulan'] ?? '',
      namaoriginal: json['namaoriginal'],
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class PekerjaanResponse {
  final bool status;
  final String message;
  final List<Pekerjaan> data;

  PekerjaanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PekerjaanResponse.fromJson(Map<String, dynamic> json) {
    return PekerjaanResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List?)
              ?.map((item) => Pekerjaan.fromJson(item))
              .toList() ??
          [],
    );
  }
}
