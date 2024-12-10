import 'dart:convert';
import 'package:firstapp/controller/auth_service.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../Model/dashboardDsnModel.dart';

class ServiceDashboardDsn {
  final String baseUrl = config.baseUrl;

  Future<DashboardDsn?> fetchDashboard() async {
    try {
      final token = await AuthService().getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token is missing');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/dosen/dashboard'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Debugging respons
        print('Response body: ${response.body}');

        if (jsonData['status'] == true) {
          return DashboardDsn.fromJson(jsonData);
        } else {
          print('Error: Respons tidak berhasil.');
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
