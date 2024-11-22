import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/dosen_pekerjaan_model.dart';
import '../config/config.dart';

class DosenBuatPekerjaanService {
  final String baseUrl = config.baseUrl;

  // Mengambil pekerjaan berdasarkan user_id
  Future<List<DosenPekerjaan>> fetchPekerjaan(int userId) async {
    final String apiUrl = '$baseUrl/dosen/pekerjaan/$userId';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final pekerjaanData = data['pekerjaan'] as List;
        return pekerjaanData
            .map((json) => DosenPekerjaan.fromJson(json))
            .toList();
      } else {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ??
            'Pekerjaan tidak ditemukan (status ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal memuat data pekerjaan: $e');
    }
  }

  Future<Map<String, dynamic>> tambahPekerjaan(DosenPekerjaanCreateRequest request) async {
  final String apiUrl = '$baseUrl/dosen/pekerjaan/create';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      return {
        'success': true,
        'jumlahJamKompen': responseData['jumlah_jam_kompen'],
        'akumulasiDeadline': responseData['akumulasi_deadline'],
      };
    } else {
      final errorData = json.decode(response.body) as Map<String, dynamic>;
      throw Exception(errorData['message'] ?? 
          'Gagal menambahkan pekerjaan (status ${response.statusCode})');
    }
  } catch (e) {
    throw Exception('Gagal menambahkan pekerjaan: $e');
  }
}

}
