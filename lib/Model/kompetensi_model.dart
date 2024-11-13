class Kompetensi {
  final int? kompetensiId;
  final int userId;
  final int semesterId;
  final String kompetensiNama;
  final String pengalaman;
  final String? bukti;
  final String? createdAt;
  final String? uploadAt;

  Kompetensi({
    this.kompetensiId,
    required this.userId,
    required this.semesterId,
    required this.kompetensiNama,
    required this.pengalaman,
    this.bukti,
    this.createdAt,
    this.uploadAt,
  });

  factory Kompetensi.fromJson(Map<String, dynamic> json) {
    return Kompetensi(
      kompetensiId: json['kompetensi_id'],
      userId: json['user_id'],
      semesterId: json['semester_id'],
      kompetensiNama: json['kompetensi_nama'],
      pengalaman: json['pengalaman'],
      bukti: json['bukti'],
      createdAt: json['created_at'],
      uploadAt: json['upload_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'semester_id': semesterId,
      'kompetensi_nama': kompetensiNama,
      'pengalaman': pengalaman,
      'bukti': bukti,
    };
  }
}
