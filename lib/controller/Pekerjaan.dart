class Pekerjaan {
  final int pekerjaan_id;
  final int user_id;
  final String jenis_pekerjaan;
  final String pekerjaan_nama;
  final int jumlah_jam_kompen;
  final String? status;
  final DetailPekerjaan detail_pekerjaan;
  final List <Progres> progres;

  Pekerjaan({
    required this.pekerjaan_id,
    required this.user_id,
    required this.jenis_pekerjaan,
    required this.pekerjaan_nama,
    required this.jumlah_jam_kompen,
    this.status,
    required this.detail_pekerjaan,
    required this.progres
  });

  factory Pekerjaan.fromJson(Map<String, dynamic> json){
    return Pekerjaan(
      pekerjaan_id: json['pekerjaan_id'] ?? 0,
      user_id: json['user_id'] ?? 0,
      jenis_pekerjaan: json['jenis_pekerjaan'] ?? '',
      pekerjaan_nama: json['pekerjaan_nama'] ?? '',
      jumlah_jam_kompen: json['jumlah_jam_kompen'] ?? 0,
      status: json['status'],
      detail_pekerjaan: DetailPekerjaan.fromJson(json['detail_pekerjaan']),
      progres: (json['progres'] as List<dynamic>)
          .map((item) => Progres.fromJson(item))
          .toList(), // Konversi list JSON menjadi List<Progres>
    );
  }
}

class DetailPekerjaan {
  final int detail_pekerjaan_id;
  final int pekerjaan_id;
  final int jumlah_anggota;
  final String deskripsi_tugas;

  DetailPekerjaan({
    required this.detail_pekerjaan_id,
    required this.pekerjaan_id,
    required this.jumlah_anggota,
    required this.deskripsi_tugas,
  });

  factory DetailPekerjaan.fromJson(Map<String, dynamic> json){
    return DetailPekerjaan(
      detail_pekerjaan_id: json['detail_pekerjaan_id'] ?? 0,
      pekerjaan_id: json['pekerjaan_id'] ?? 0,
      jumlah_anggota: json['jumlah_anggota'] ?? 0,
      deskripsi_tugas: json['deskripsi_tugas'] ?? '',
    );
  }
}

class Progres{
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

  factory Progres.fromJson(Map<String, dynamic> json){
    return Progres(
      progres_id: json['progres_id'] ?? 0,
      pekerjaan_id: json['pekerjaan_id'] ?? 0,
      judul_progres: json['judul_progres'] ?? '',
      jam_kompen: json['jam_kompen'] ?? 0,
      hari: json['hari'] ?? 0,
      status: json['status']
    );
  }
}