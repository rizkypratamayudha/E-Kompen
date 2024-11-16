// lib/Model/detail_mahasiswa_model.dart
class DetailMahasiswa {
  final int detailMahasiswaId;
  final int userId;
  final int prodiId;
  final String email;
  final String noHp;
  final int angkatan;
  final int periodeId;
  final String periodeNama;

  DetailMahasiswa({
    required this.detailMahasiswaId,
    required this.userId,
    required this.prodiId,
    required this.email,
    required this.noHp,
    required this.angkatan,
    required this.periodeId,
    required this.periodeNama,
  });

  factory DetailMahasiswa.fromJson(Map<String, dynamic> json) {
    return DetailMahasiswa(
      detailMahasiswaId: json['detail_mahasiswa_id'],
      userId: json['user_id'],
      prodiId: json['prodi_id'],
      email: json['email'],
      noHp: json['no_hp'],
      angkatan: json['angkatan'],
      periodeId: json['periode']['periode_id'], // Mengambil dari relasi periode
      periodeNama: json['periode']['periode_nama'], // Nama periode dari relasi
    );
  }
}
