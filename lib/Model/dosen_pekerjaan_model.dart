import 'package:intl/intl.dart';

class DosenPekerjaan {
  final int pekerjaanId;
  final String jenisPekerjaan; // Tambahkan jenis pekerjaan
  final String pekerjaanNama;
  final int jumlahAnggota;
  final String? akumulasiDeadline;
  String? status;

  DosenPekerjaan({
    required this.pekerjaanId,
    required this.jenisPekerjaan, // Harus ada
    required this.pekerjaanNama,
    required this.jumlahAnggota,
    this.akumulasiDeadline, // Not required
    this.status,
  });

  factory DosenPekerjaan.fromJson(Map<String, dynamic> json) {
    return DosenPekerjaan(
      pekerjaanId: json['pekerjaan_id'] ?? 0, // Default value if null
      jenisPekerjaan:
          json['jenis_pekerjaan'] ?? '', // Pastikan field sesuai dengan API
      pekerjaanNama:
          json['pekerjaan_nama'] ?? '', // Default empty string if null
      jumlahAnggota: json['jumlah_anggota'] ?? 0, // Default value if null
      akumulasiDeadline: json['akumulasi_deadline'],
      status: json['status'] ?? 'open',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pekerjaan_id': pekerjaanId,
      'jenis_pekerjaan': jenisPekerjaan,
      'pekerjaan_nama': pekerjaanNama,
      'jumlah_anggota': jumlahAnggota,
      'akumulasi_deadline': akumulasiDeadline,
      'status': status,
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
  final List<int> kompetensiAdminId; // Tambahan

  DosenPekerjaanCreateRequest({
    required this.userId,
    required this.jenisPekerjaan,
    required this.pekerjaanNama,
    required this.jumlahAnggota,
    required this.deskripsiTugas,
    required this.persyaratan,
    required this.progress,
    required this.kompetensiAdminId, // Tambahan
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
      'kompetensi_admin_id': kompetensiAdminId, // Tambahan
    };
  }
}

class ProgressItem {
  final String judulProgres;
  final int jumlahJam;
  final int jumlahHari;
  final String? deadline; // Nullable type

  ProgressItem({
    required this.judulProgres,
    required this.jumlahJam,
    required this.jumlahHari,
    this.deadline, // Not required
  });

  factory ProgressItem.fromJson(Map<String, dynamic> json) {
    return ProgressItem(
      judulProgres: json['judul_progres'] ?? '', // Default empty string if null
      jumlahJam: json['jumlah_jam'] ?? 0, // Default value if null
      jumlahHari: json['jumlah_hari'] ?? 0, // Default value if null
      deadline: json['deadline'], // Can be null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul_progres': judulProgres,
      'jumlah_jam': jumlahJam,
      'jumlah_hari': jumlahHari,
      'deadline': deadline, // Nullable field
    };
  }
}

class AmbilProgres {
  final int id;
  final String judulProgres;
  final int jumlahJam;
  final int jumlahHari;
  final DateTime? deadline; // Jadikan nullable

  AmbilProgres({
    required this.id,
    required this.judulProgres,
    required this.jumlahJam,
    required this.jumlahHari,
    this.deadline, // Nullable
  });

  factory AmbilProgres.fromJson(Map<String, dynamic> json) {
    return AmbilProgres(
      id: json['progres_id'] ?? 0, // Default value if null
      judulProgres: json['judul_progres'] ?? '', // Default empty string if null
      jumlahJam: json['jam_kompen'] ?? 0, // Default value if null
      jumlahHari: json['hari'] ?? 0, // Default value if null
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline']) // Parse jika tidak null
          : null, // Jika null, tetap null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'progres_id': id,
      'judul_progres': judulProgres,
      'jam_kompen': jumlahJam,
      'hari': jumlahHari,
      'deadline': deadline?.toIso8601String(), // Null-safe serialization
    };
  }

  // Tambahkan getter untuk mendapatkan representasi string deadline
  String get formattedDeadline {
    if (deadline != null) {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(deadline!);
    } else {
      return "Belum membuat deadline";
    }
  }
}


class AmbilPersyaratan {
  final int id; // ID persyaratan
  final String nama; // Nama persyaratan

  AmbilPersyaratan({
    required this.id,
    required this.nama,
  });

  factory AmbilPersyaratan.fromJson(Map<String, dynamic> json) {
    return AmbilPersyaratan(
      id: json['persyaratan_id'] ?? 0, // Default value jika null
      nama: json['persyaratan_nama'] ?? '', // Default string kosong jika null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'persyaratan_id': id,
      'persyaratan_nama': nama,
    };
  }
}

class AmbilKompetensi {
  final int id;
  final int kompetensiAdminId;
  final String namaKompetensi; // Tambahkan properti nama kompetensi

  AmbilKompetensi({
    required this.id,
    required this.kompetensiAdminId,
    required this.namaKompetensi, // Inisialisasi nama kompetensi
  });

  factory AmbilKompetensi.fromJson(Map<String, dynamic> json) {
    final kompetensiAdmin = json['kompetensi_admin'] as Map<String, dynamic>?;
    return AmbilKompetensi(
      id: json['kompetensi_dosen_id'] ?? 0,
      kompetensiAdminId: json['kompetensi_admin_id'] ?? 0,
      namaKompetensi:
          kompetensiAdmin?['kompetensi_nama'] ?? '', // Aman jika null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kompetensi_dosen_id': id,
      'kompetensi_admin_id': kompetensiAdminId,
      'kompetensi_nama': namaKompetensi, // Sertakan nama kompetensi
    };
  }
}

class DosenPekerjaanUpdateRequest {
  final String jenisPekerjaan;
  final String pekerjaanNama;
  final int jumlahAnggota;
  final String deskripsiTugas;
  final List<UpdatePersyaratanItem> persyaratan;
  final List<UpdateProgressItem> progress;
  final List<UpdateKompetensiItem> kompetensi;

  DosenPekerjaanUpdateRequest({
    required this.jenisPekerjaan,
    required this.pekerjaanNama,
    required this.jumlahAnggota,
    required this.deskripsiTugas,
    required this.persyaratan,
    required this.progress,
    required this.kompetensi,
  });

  Map<String, dynamic> toJson() {
    return {
      'jenis_pekerjaan': jenisPekerjaan,
      'pekerjaan_nama': pekerjaanNama,
      'jumlah_anggota': jumlahAnggota,
      'deskripsi_tugas': deskripsiTugas,
      'persyaratan': persyaratan.map((item) => item.toJson()).toList(),
      'progres': progress.map((item) => item.toJson()).toList(),
      'kompetensi':
          kompetensi.map((item) => item.toJson()).toList(), // Pastikan ini ada
    };
  }
}

class UpdatePersyaratanItem {
  final int? id;
  String nama; // Tidak lagi 'final'

  UpdatePersyaratanItem({this.id, required this.nama});

  Map<String, dynamic> toJson() {
    return {
      'persyaratan_id': id,
      'persyaratan_nama': nama,
    };
  }
}

class UpdateProgressItem {
  final int? id;
  String judulProgres; // Tidak lagi 'final'
  int jumlahJam; // Tidak lagi 'final'
  int jumlahHari; 

  UpdateProgressItem({
    this.id,
    required this.judulProgres,
    required this.jumlahJam,
    required this.jumlahHari,
  });

  Map<String, dynamic> toJson() {
    return {
      'progres_id': id,
      'judul_progres': judulProgres,
      'jam_kompen': jumlahJam,
      'hari': jumlahHari,
    };
  }
}

class UpdateKompetensiItem {
  final int? id; // ID untuk kompetensi lama
  final int kompetensiAdminId; // ID admin untuk kompetensi baru

  UpdateKompetensiItem({this.id, required this.kompetensiAdminId});

  Map<String, dynamic> toJson() {
    return {
      'kompetensi_dosen_id': id, // Untuk kompetensi lama
      'kompetensi_admin_id': kompetensiAdminId, // Untuk kompetensi baru
    };
  }
}

class PekerjaanDetail {
  final DosenPekerjaan pekerjaan;
  final String deskripsiTugas;
  final int jumlahAnggota;
  final List<AmbilPersyaratan> persyaratan;
  final List<AmbilProgres> progress;
  final List<AmbilKompetensi> kompetensi;

  PekerjaanDetail({
    required this.pekerjaan,
    required this.deskripsiTugas,
    required this.jumlahAnggota,
    required this.persyaratan,
    required this.progress,
    required this.kompetensi,
  });

  factory PekerjaanDetail.fromJson(Map<String, dynamic> json) {
    return PekerjaanDetail(
      pekerjaan: DosenPekerjaan.fromJson(json['pekerjaan']),
      deskripsiTugas: json['detail_pekerjaan']['deskripsi_tugas'] ?? '',
      jumlahAnggota: json['detail_pekerjaan']['jumlah_anggota'] ?? 0,
      persyaratan: (json['persyaratan'] as List<dynamic>?)
              ?.map((persyaratan) => AmbilPersyaratan.fromJson(persyaratan))
              .toList() ??
          [],
      progress: (json['progress'] as List<dynamic>?)
              ?.map((progres) => AmbilProgres.fromJson(progres))
              .toList() ??
          [],
      kompetensi: (json['kompetensi_dosen'] as List<dynamic>?)
              ?.map((kompetensi) => AmbilKompetensi.fromJson(kompetensi))
              .toList() ??
          [],
    );
  }
}

class DosenPekerjaanModel {
  final int userId;
  final String nama;
  final String nim;
  final String email;
  final String noHp;
  final String periode;

  DosenPekerjaanModel({
    required this.userId,
    required this.nama,
    required this.nim,
    required this.email,
    required this.noHp,
    required this.periode,
  });

  factory DosenPekerjaanModel.fromJson(Map<String, dynamic> json) {
    // Pastikan JSON memiliki struktur aman untuk diakses
    final user = json['user'] ?? {};
    final detail = user['detail_mahasiswa'] ?? {};
    final periode = detail['periode'] ?? {};

    return DosenPekerjaanModel(
      userId: user['user_id'] ?? 0, // Gunakan 0 sebagai fallback jika null
      nama: user['nama'] ?? '',
      nim: user['username'] ?? '',
      email: detail['email'] ?? '',
      noHp: detail['no_hp'] ?? '',
      periode: periode['periode_nama'] ?? '',
    );
  }
}

