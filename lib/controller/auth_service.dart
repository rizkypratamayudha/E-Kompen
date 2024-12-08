import 'dart:convert';
import 'package:firstapp/Model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';

class AuthService {
  final _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> login(
      String username, String password, String role) async {
    final url = Uri.parse('${config.baseUrl}/loginAPI');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'role': role,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          await _storage.write(key: 'token', value: responseData['token']);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('nama', responseData['user']['name']);
          await prefs.setString('username', responseData['user']['username']);
          await prefs.setInt('userId', responseData['user']['id']);

          // Periksa jika avatar null, simpan nilai default
          String avatarUrl = responseData['user']['avatar'] ?? '';
          await prefs.setString('avatarUrl', avatarUrl);

          final user = UserModel.fromJson(responseData['user']);
          return {'success': true, 'user': user};
        } else {
          return {'success': false, 'message': responseData['message']};
        }
      } else {
        return {
          'success': false,
          'message': responseData['message'] ??
              'Terjadi kesalahan, silakan coba lagi'
        };
      }
    } catch (error) {
      print('Error: $error');
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server. Periksa koneksi Anda.'
      };
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _storage.delete(key: 'token');
  }
}
