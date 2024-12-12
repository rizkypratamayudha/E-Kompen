import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firstapp/controller/auth_service.dart';
import '../config/config.dart';
import '../Model/dashboardKapModel.dart';

class ServiceDashboardKap {
  final String baseUrl = config.baseUrl;

  Future<DashboardKap?> fetchDashboard() async {
    try {
      final token = await AuthService().getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token is missing');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/kaprodi/dashboard'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Debugging response
        print('Response body: ${response.body}');

        if (jsonData['success'] == true) {
          return DashboardKap.fromJson(jsonData['data']);
        } else {
          print('Error: API response unsuccessful.');
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
