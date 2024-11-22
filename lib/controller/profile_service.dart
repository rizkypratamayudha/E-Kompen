import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';
import '../controller/auth_service.dart';
import 'dart:convert';

class ProfileService {
  final String baseUrl = config.baseUrl;
  
  // Update Foto Profil
Future<String> updateProfilePhoto(String imagePath) async {
  try {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/updatePhoto'),
    );

    request.files.add(await http.MultipartFile.fromPath('photo', imagePath));

    // Mendapatkan token dan user_id dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userId = prefs.getString('user_id');  // Pastikan user_id ada di SharedPreferences

    if (token == null || userId == null) {
      return 'Token atau user_id tidak ditemukan. Silakan login kembali.';
    }

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['user_id'] = userId;  // Kirimkan user_id jika perlu

    final response = await request.send();

    if (response.statusCode == 200) {
      return 'Foto profil berhasil diperbarui';
    } else {
      final responseString = await response.stream.bytesToString();
      return 'Gagal memperbarui foto profil. Error: $responseString';
    }
  } catch (e) {
    return 'Terjadi kesalahan: $e';
  }
}


  
  // Update Password
  Future<String> updatePassword(String currentPassword, String newPassword, String confirmPassword) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/updatePassword'),
        headers: {
          'Authorization': 'Bearer ${await _getToken()}', // Pastikan token benar
          'Content-Type': 'application/json', // Gunakan header JSON
        },
        body: json.encode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        return 'Password berhasil diperbarui';
      } else {
        final responseString = response.body;
        return 'Gagal memperbarui password. Error: $responseString';
      }
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }

  // Mendapatkan token dari SharedPreferences
  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

}
