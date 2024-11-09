// AuthService.dart

import 'dart:convert';
import 'package:firstapp/Model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';

class AuthService {
  final _storage = FlutterSecureStorage();

  // Fungsi login
  Future<Map<String, dynamic>> login(String username, String password, String role) async {
    final url = Uri.parse('${config.baseUrl}/loginAPI');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        // Simpan token di storage aman
        await _storage.write(key: 'token', value: responseData['token']);
        
        final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nama', responseData['user']['name']);
      await prefs.setString('username', responseData['user']['username']);

        // Buat UserModel dari data yang diterima
        final user = UserModel.fromJson(responseData['user']);

        return {'success': true, 'user': user};
      } else {
        return {'success': false, 'message': responseData['message']};
      }
    } else {
      throw Exception('Gagal terhubung ke server');
    }
  }

  
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  
  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}
