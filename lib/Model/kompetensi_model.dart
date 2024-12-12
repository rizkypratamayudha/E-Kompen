class Kompetensi {
  final int? kompetensiId;
  final int userId;
  final String periodeNama; // Untuk pengambilan data saja, tidak dikirim
  final int kompetensiAdminId; // Mengacu ke kompetensi_admin_id
  final String kompetensiNama; // Mengambil dari tabel kompetensi_admin
  final String pengalaman;
  final String? bukti;
  final String? createdAt;
  final String? uploadAt;

  Kompetensi({
    this.kompetensiId,
    required this.userId,
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
    userId: json['user_id'] ?? 0, // Default 0 jika tidak ada
    periodeNama: json['periode'] ?? '', // Pastikan ada default
    kompetensiAdminId: json['kompetensi_admin_id'],
    kompetensiNama: json['kompetensi_nama'], // Nama kompetensi
    pengalaman: json['pengalaman'] ?? '', // Pengalaman bisa kosong
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
