import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/kompetensi_model.dart';
import '../config/config.dart';
import '../Model/kompetensi_admin_model.dart';

class KompetensiService {
  final String baseUrl = config.baseUrl;

  Future<List<Kompetensi>> fetchKompetensi(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/kompetensi/$userId'));
    print('Response: ${response.body}'); // Debug log
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> kompetensiData = data['kompetensi'];

      return kompetensiData.map((json) => Kompetensi.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load kompetensi');
    }
  }

  // Fungsi untuk menambahkan data kompetensi baru
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

  Future<List<KompetensiAdmin>> fetchKompetensiAdmin() async {
    final response = await http.get(Uri.parse('$baseUrl/kompetensi-admin'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => KompetensiAdmin.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Kompetensi Admin');
    }
  }

  Future<Map<String, dynamic>> fetchPeriodeByUserId(int userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/kompetensi/periode/$userId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return {
        'periode_id': data['periode_id'],
        'periode': data['periode_nama'], // Ambil nama periode dari JSON
      };
    } else {
      throw Exception('Failed to load periode data');
    }
  }

  Future<bool> updateKompetensi(int id, Kompetensi kompetensi) async {
    final response = await http.put(
      Uri.parse('$baseUrl/kompetensi/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(kompetensi.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteKompetensi(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/kompetensi/delete/$id'),
    );
    return response.statusCode == 200;
  }

  Future<Kompetensi?> fetchKompetensiDetail(int kompetensiId) async {
    final String apiUrl = '${config.baseUrl}/kompetensi/show/$kompetensiId';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json'
        }, // Pastikan header sesuai API
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          return Kompetensi.fromJson(responseData['data']);
        } else {
          throw Exception(
              responseData['message'] ?? 'Failed to fetch Kompetensi detail');
        }
      } else {
        throw Exception(
            'Failed to fetch Kompetensi detail with status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
