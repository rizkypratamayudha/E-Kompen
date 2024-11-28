import 'dart:convert';

import 'package:firstapp/config/config.dart';
import 'package:firstapp/controller/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Apply{
  Future <Map<String, dynamic>> applyPekerjaan(int pekerjaan_id) async{
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      
      if (userId == null) {
        throw Exception('User belum login. Tidak bisa melamar pekerjaan.');
      }

      final token = await AuthService().getToken(); // Ambil token autentikasi
      final url = Uri.parse('${config.baseUrl}/pekerjaan/apply'); // API endpoint

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Sertakan token untuk otorisasi
        },
        body: jsonEncode({
          'pekerjaan_id': pekerjaan_id,
          'user_id': userId,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        return {'success': true, 'message': responseData['message']};
      }
      else {
        return {
          'success': false,
          'message': responseData['message'] ??
              'Gagal melamar pekerjaan. Silakan coba lagi.'
        };
      }
    }
    catch (error) {
      print('Error: $error');
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server. Periksa koneksi Anda.'
      };
    }
  }
}