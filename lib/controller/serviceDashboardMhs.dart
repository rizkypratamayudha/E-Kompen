import 'dart:convert';
import 'package:firstapp/controller/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';
import '../Model/dashboardMhsModel.dart';

class ServiceDashboardMhs {
  final String baseUrl = config.baseUrl;
  Future<DashboardMhs?> fetchDashboard() async {
    try {
      final token = await AuthService().getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token is missing');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/mahasiswa/dashboard'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['data'] != null) {
          // Cek dan print data yang diterima
          print('Data received: ${jsonData['data']}');
          return DashboardMhs.fromJson(jsonData['data']);
        } else {
          print('Data field is null.');
          return null;
        }
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
