class KompetensiAdmin {
  final int id;
  final String nama;

  KompetensiAdmin({
    required this.id,
    required this.nama,
  });

  factory KompetensiAdmin.fromJson(Map<String, dynamic> json) {
    return KompetensiAdmin(
      id: json['kompetensi_admin_id'],
      nama: json['kompetensi_nama'],
    );
  }
}
