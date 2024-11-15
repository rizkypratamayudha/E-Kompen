import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';

class ProfileService {
  final String baseUrl = config.baseUrl;

  Future<String> updatePassword(
    String oldPassword, String newPassword, String confirmPassword) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('${config.baseUrl}/api/updatePassword'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: {
        'current_password': oldPassword,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      },
    );

    if (response.statusCode == 200) {
      await prefs.remove('token'); // Clear token to prompt re-login
      return 'Password berhasil diperbarui. Silakan login ulang.';
    } else {
      final responseData = json.decode(response.body);
      return responseData['error'] ?? 'Terjadi kesalahan';
    }
  } catch (e) {
    return 'Gagal memperbarui password: $e';
  }
}

  // Method to update the profile photo
  Future<String> updateProfilePhoto(String photoPath) async {
    try {
      final token = await _getToken(); // Fetch token from shared preferences
      if (token == null) return 'Token tidak tersedia';

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/updatePhoto'),
      )
        ..headers.addAll(_buildHeaders(token))
        ..files.add(await http.MultipartFile.fromPath('avatar', photoPath));

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final avatarUrl = jsonDecode(responseData.body)['avatar_url'];
        await _saveAvatarUrl(avatarUrl);
        return 'Foto profil berhasil diperbarui';
      } else {
        final error = jsonDecode(responseData.body)['error'] ?? 'Terjadi kesalahan';
        return error;
      }
    } catch (e) {
      return 'Gagal memperbarui foto profil: $e';
    }
  }

  // Helper method to get the JWT token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Helper method to save the avatar URL to SharedPreferences
  Future<void> _saveAvatarUrl(String avatarUrl) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('avatarUrl', avatarUrl);
  }

  // Helper method to build headers with Authorization and JSON content type
  Map<String, String> _buildHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Helper method to handle response processing and return appropriate messages
  String _handleResponse(http.Response response, {required String successMessage}) {
    if (response.statusCode == 200) {
      return successMessage;
    } else {
      final responseData = jsonDecode(response.body);
      return responseData['error'] ?? 'Terjadi kesalahan';
    }
  }
}
