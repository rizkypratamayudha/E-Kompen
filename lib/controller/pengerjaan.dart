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
  });

  factory Pekerjaan.fromJson(Map<String, dynamic> json) {
    return Pekerjaan(
      pekerjaanId: json['pekerjaan_id'],
      userId: json['user_id'],
      jenisPekerjaan: json['jenis_pekerjaan'],
      pekerjaanNama: json['pekerjaan_nama'],
      jumlahJamKompen: json['jumlah_jam_kompen'],
      status: json['status'],
      akumulasiDeadline: json['akumulasi_deadline'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      progres: (json['progres'] as List)
          .map((item) => Progres.fromJson(item))
          .toList(),
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
      progresId: json['progres_id'],
      pekerjaanId: json['pekerjaan_id'],
      judulProgres: json['judul_progres'],
      jamKompen: json['jam_kompen'],
      hari: json['hari'],
      status: json['status'],
      deadline: json['deadline'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      pengumpulan: (json['pengumpulan'] as List)
          .map((item) => Pengumpulan.fromJson(item))
          .toList(),
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
      pengumpulanId: json['pengumpulan_id'],
      progresId: json['progres_id'],
      userId: json['user_id'],
      buktiPengumpulan: json['bukti_pengumpulan'],
      namaoriginal: json['namaoriginal'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => Pekerjaan.fromJson(item))
          .toList(),
    );
  }
}
