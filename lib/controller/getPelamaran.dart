import 'dart:convert';
import 'package:firstapp/controller/pending_pekerjaan.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import 'auth_service.dart';

class PelamaranService {
  final AuthService authService = AuthService();

  Future<Map<String, dynamic>> getPelamaran() async {
    final userId =
        await authService.getUserId(); // Ambil user_id dari AuthService
    if (userId == null) {
      return {
        'success': false,
        'message': 'Tidak ada user_id. Pastikan Anda sudah login.',
      };
    }

    final token = await authService.getToken(); // Ambil token yang disimpan
    if (token == null) {
      return {
        'success': false,
        'message': 'Tidak ada token. Pastikan Anda sudah login.',
      };
    }

    final url = Uri.parse(
        '${config.baseUrl}/dosen/$userId/pelamaran'); // Gunakan userId di URL

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == true) {
          var pelamaran = (responseData['data'] as List)
              .map((item) => PendingPekerjaan.fromJson(item))
              .toList();

          return {
            'success': true,
            'data': pelamaran,
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'],
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Gagal mendapatkan data pelamaran. Coba lagi nanti.',
        };
      }
    } catch (error) {
      print('Error: $error');
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server. Periksa koneksi Anda.',
      };
    }
  }

  Future<Map<String, dynamic>> approvePekerjaan(
      String pekerjaanId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('${config.baseUrl}/pekerjaan/approve-pekerjaan'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'pekerjaan_id': pekerjaanId,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(
            response.body); // Mengasumsikan respons API dalam format JSON
      } else {
        print(
            'Error: ${response.body}'); // Log respons body untuk analisis lebih lanjut
        throw Exception('Gagal menyetujui pekerjaan');
      }
    } catch (e) {
      print('Error: $e'); // Log kesalahan
      throw Exception('Gagal menyetujui pekerjaan: $e');
    }
  }
}
