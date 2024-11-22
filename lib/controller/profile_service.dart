import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  final String baseUrl = config.baseUrl;
  final _storage = FlutterSecureStorage();
// Update Foto Profil

  Future<String> updatePhoto(String imagePath) async {
    try {
      // Buat request multipart
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/updatePhoto'),
      );

      request.files.add(await http.MultipartFile.fromPath('avatar', imagePath));

      // Tambahkan token autentikasi
      String? token = await _storage.read(key: 'token');
      if (token == null || token.isEmpty) {
        return 'Token tidak ditemukan. Silakan login kembali.';
      }
      request.headers['Authorization'] = 'Bearer $token';

      // Kirim request
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final jsonResponse = jsonDecode(responseData.body);

        // Ambil URL avatar baru
        final avatarUrl = jsonResponse['avatar_url'] as String;

        // Simpan URL avatar ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('avatarUrl', avatarUrl);

        return 'Foto profil berhasil diperbarui';
      } else {
        // Tampilkan error dari server
        final responseString = await response.stream.bytesToString();
        return 'Gagal memperbarui foto profil. Error: $responseString';
      }
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }



  // Update Password
  Future<String> updatePassword(String currentPassword, String password,
      String passwordConfirmation) async {
    try {
      // Ambil token dari FlutterSecureStorage
      String? token = await _storage.read(key: 'token');
      if (token == null || token.isEmpty) {
        return 'Token tidak ditemukan. Silakan login ulang.';
      }

      // Pastikan password dan passwordConfirmation cocok
      if (password != passwordConfirmation) {
        return 'Password baru dan konfirmasi password tidak cocok.';
      }

      // Buat body JSON
      Map<String, String> body = {
        'current_password': currentPassword,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };

      // Kirim permintaan HTTP PUT
      final response = await http.put(
        Uri.parse('$baseUrl/updatePassword'),
        headers: {
          'Authorization': 'Bearer $token', // Header otentikasi
          'Content-Type': 'application/json', // Konten JSON
        },
        body: json.encode(body), // Encode body ke JSON
      );

      // Periksa status kode HTTP
      if (response.statusCode == 200) {
        return 'Password berhasil diperbarui';
      } else {
        // Parsing error dari respons API
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        String errorMessage =
            errorResponse['message'] ?? 'Gagal memperbarui password.';
        return 'Error: $errorMessage';
      }
    } catch (e) {
      // Tangani kesalahan pada proses request
      return 'Terjadi kesalahan saat memperbarui password: $e';
    }
  }
}
