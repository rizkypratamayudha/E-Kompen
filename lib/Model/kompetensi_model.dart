class Kompetensi {
  final int? kompetensiId;
  final int userId;
  final int? mahasiswaId; // Tambahan variabel untuk detail_mahasiswa_id
  final String periodeNama;
  final int kompetensiAdminId;
  final String kompetensiNama;
  final String pengalaman;
  final String? bukti;
  final String? createdAt;
  final String? uploadAt;

  Kompetensi({
    this.kompetensiId,
    required this.userId,
    this.mahasiswaId, // Tambahkan pada constructor
    required this.periodeNama,
    required this.kompetensiAdminId,
    required this.kompetensiNama,
    required this.pengalaman,
    this.bukti,
    this.createdAt,
    this.uploadAt,
  });

  factory Kompetensi.fromJson(Map<String, dynamic> json) {
    return Kompetensi(
      kompetensiId: json['kompetensi_id'],
      userId: json['user_id'] ?? 0,
      mahasiswaId:
          json['detail_mahasiswa_id'] ?? 0, // Ambil mahasiswa_id dari response
      periodeNama: json['periode'] ?? '',
      kompetensiAdminId: json['kompetensi_admin_id'],
      kompetensiNama: json['kompetensi_nama'],
      pengalaman: json['pengalaman'] ?? '',
      bukti: json['bukti'],
      createdAt: json['created_at'],
      uploadAt: json['upload_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'kompetensi_admin_id': kompetensiAdminId,
      'pengalaman': pengalaman,
      'bukti': bukti,
    };
  }
}

class MahasiswaDetail {
  final String nama;
  final String username;

  MahasiswaDetail({required this.nama, required this.username});

  factory MahasiswaDetail.fromJson(Map<String, dynamic> json) {
    return MahasiswaDetail(
      nama: json['nama'],
      username: json['username'],
    );
  }
}
