// lib/Model/periode_model.dart
class Periode {
  final int periodeId;
  final String periodeNama;

  Periode({
    required this.periodeId,
    required this.periodeNama,
  });

  factory Periode.fromJson(Map<String, dynamic> json) {
    return Periode(
      periodeId: json['periode_id'],
      periodeNama: json['periode_nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'periode_id': periodeId,
      'periode_nama': periodeNama,
    };
  }
}
