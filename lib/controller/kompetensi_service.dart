import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/kompetensi_model.dart';
import '../config/config.dart';

class KompetensiService {
  final String baseUrl = config.baseUrl;

  Future<List<Kompetensi>> fetchKompetensi(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/kompetensi/$userId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Kompetensi.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load kompetensi');
    }
  }

  Future<bool> addKompetensi(Kompetensi kompetensi) async {
    final response = await http.post(
      Uri.parse('$baseUrl/kompetensi'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(kompetensi.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return false;
    }
  }
  
  // Ambil semester_id dan semester berdasarkan user_id
  Future<Map<String, dynamic>> fetchSemesterByUserId(int userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/semester/user/$userId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return {
        'semester_id': data['semester_id'],
        'semester':
            data['semester'] // Ambil nama semester (misal: "Semester 5")
      };
    } else {
      throw Exception('Failed to load semester data');
    }
  }
}
