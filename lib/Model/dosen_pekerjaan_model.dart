class DosenPekerjaan {
  final int pekerjaanId;
  final String pekerjaanNama;
  final int jumlahAnggota;

  DosenPekerjaan({
    required this.pekerjaanId,
    required this.pekerjaanNama,
    required this.jumlahAnggota,
  });

  factory DosenPekerjaan.fromJson(Map<String, dynamic> json) {
    return DosenPekerjaan(
      pekerjaanId: json['pekerjaan_id'],
      pekerjaanNama: json['pekerjaan_nama'],
      jumlahAnggota: json['jumlah_anggota'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pekerjaan_id': pekerjaanId,
      'pekerjaan_nama': pekerjaanNama,
      'jumlah_anggota': jumlahAnggota,
    };
  }
}

class DosenPekerjaanCreateRequest {
  final int userId;
  final String jenisPekerjaan;
  final String pekerjaanNama;
  final int jumlahAnggota;
  final String deskripsiTugas;
  final List<String> persyaratan;
  final List<ProgressItem> progress;

  DosenPekerjaanCreateRequest({
    required this.userId,
    required this.jenisPekerjaan,
    required this.pekerjaanNama,
    required this.jumlahAnggota,
    required this.deskripsiTugas,
    required this.persyaratan,
    required this.progress,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'jenis_pekerjaan': jenisPekerjaan,
      'pekerjaan_nama': pekerjaanNama,
      'jumlah_anggota': jumlahAnggota,
      'deskripsi_tugas': deskripsiTugas,
      'persyaratan': persyaratan,
      'progress': progress.map((item) => item.toJson()).toList(),
    };
  }
}

class ProgressItem {
  final String judulProgres;
  final int jumlahJam;
  final int jumlahHari;

  ProgressItem({
    required this.judulProgres,
    required this.jumlahJam,
    required this.jumlahHari,
  });

  Map<String, dynamic> toJson() {
    return {
      'judul_progres': judulProgres,
      'jumlah_jam': jumlahJam,
      'jumlah_hari': jumlahHari,
    };
  }
}
