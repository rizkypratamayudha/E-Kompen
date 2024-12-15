import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/dosen_pekerjaan_model.dart';
import '../Model/kompetensi_admin_model.dart';
import '../config/config.dart';

class DosenBuatPekerjaanService {
  final String baseUrl = config.baseUrl;

  // Mengambil pekerjaan berdasarkan user_id
  Future<List<DosenPekerjaan>> fetchPekerjaan(int userId) async {
    final String apiUrl = '$baseUrl/dosen/pekerjaan/$userId';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final pekerjaanData = data['pekerjaan'] as List;
        return pekerjaanData
            .map((json) => DosenPekerjaan.fromJson(json))
            .toList();
      } else {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ??
            'Pekerjaan tidak ditemukan (status ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal memuat data pekerjaan: $e');
    }
  }

  // Menambahkan pekerjaan
  Future<Map<String, dynamic>> tambahPekerjaan(
      DosenPekerjaanCreateRequest request) async {
    final String apiUrl = '$baseUrl/dosen/pekerjaan/create';

    try {
      print("Request payload: ${request.toJson()}"); // Debug print
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;

        return {
          'success': true,
          'jumlahJamKompen': responseData['jumlah_jam_kompen'],
          'akumulasiDeadline': responseData['akumulasi_deadline'],
        };
      } else {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ??
            'Gagal menambahkan pekerjaan (status ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal menambahkan pekerjaan: $e');
    }
  }

  Future<List<KompetensiAdmin>> fetchKompetensiAdmin() async {
    final String apiUrl = '$baseUrl/kompetensi-admin-pekerjaan';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Pastikan mengambil data dari field 'data'
        final kompetensiData = data['data'] as List;

        // Pemetaan data ke dalam model KompetensiAdmin
        return kompetensiData
            .map((json) => KompetensiAdmin.fromJson(json))
            .toList();
      } else {
        throw Exception('Gagal mengambil data kompetensi');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<void> mulaiDeadline(int pekerjaanId, Map<String, dynamic> data) async {
    final String apiUrl = '$baseUrl/pekerjaan/$pekerjaanId/start-deadline';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Gagal memulai deadline');
      }
    } catch (e) {
      throw Exception('Gagal memulai deadline: $e');
    }
  }

  Future<void> updateDeadline(
      int pekerjaanId, Map<String, dynamic> data) async {
    final String apiUrl = '$baseUrl/pekerjaan/$pekerjaanId/update-deadline';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Gagal memulai deadline');
      }
    } catch (e) {
      throw Exception('Gagal memulai deadline: $e');
    }
  }

  // Fungsi untuk mengambil data progress berdasarkan pekerjaan_id
  Future<List<AmbilProgres>> fetchProgressByPekerjaan(int pekerjaanId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/pekerjaan/$pekerjaanId/progress'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> progressData = data['progress'];

      return progressData.map((json) => AmbilProgres.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load progress for pekerjaan ID: $pekerjaanId');
    }
  }

  Future<bool> updatePekerjaan(
      int pekerjaanId, DosenPekerjaanUpdateRequest request) async {
    final String apiUrl = '$baseUrl/pekerjaan/$pekerjaanId';

    try {
      print("Mengirim data ke: $apiUrl");
      print("Payload: ${request.toJson()}");

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return true; // Update berhasil
      } else {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ??
            'Gagal memperbarui pekerjaan (status ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal memperbarui pekerjaan: $e');
    }
  }

  // Fungsi untuk menghapus persyaratan
  Future<bool> deletePersyaratan(int pekerjaanId, int persyaratanId) async {
    final String apiUrl =
        '$baseUrl/pekerjaan/$pekerjaanId/persyaratan/$persyaratanId';

    try {
      print("Menghapus persyaratan dengan ID: $persyaratanId"); // Debug
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print("Response status: ${response.statusCode}"); // Debug
      print("Response body: ${response.body}"); // Debug

      if (response.statusCode == 200) {
        return true; // Penghapusan berhasil
      } else {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ??
            'Gagal menghapus persyaratan (status ${response.statusCode})');
      }
    } catch (e) {
      print("Error di deletePersyaratan: $e"); // Debug
      throw Exception('Gagal menghapus persyaratan: $e');
    }
  }

  // Fungsi untuk menghapus progres
  Future<bool> deleteProgres(int pekerjaanId, int progresId) async {
    final String apiUrl = '$baseUrl/pekerjaan/$pekerjaanId/progres/$progresId';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true; // Penghapusan berhasil
      } else {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ??
            'Gagal menghapus progres (status ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal menghapus progres: $e');
    }
  }

  // Fungsi untuk menghapus kompetensi
  Future<bool> deleteKompetensi(int pekerjaanId, int kompetensiDosenId) async {
    final String apiUrl =
        '$baseUrl/pekerjaan/$pekerjaanId/kompetensi/$kompetensiDosenId';

    try {
      print("Menghapus kompetensi dengan ID: $kompetensiDosenId"); // Debug
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print("Response status: ${response.statusCode}"); // Debug
      print("Response body: ${response.body}"); // Debug

      if (response.statusCode == 200) {
        return true; // Penghapusan berhasil
      } else {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ??
            'Gagal menghapus kompetensi (status ${response.statusCode})');
      }
    } catch (e) {
      print("Error di deleteKompetensi: $e"); // Debug
      throw Exception('Gagal menghapus kompetensi: $e');
    }
  }

  Future<PekerjaanDetail> fetchPekerjaanDetail(int pekerjaanId) async {
    final String apiUrl = '$baseUrl/pekerjaan/$pekerjaanId';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return PekerjaanDetail.fromJson(jsonData);
      } else {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ??
            'Gagal mengambil detail pekerjaan (status ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal mengambil detail pekerjaan: $e');
    }
  }

  // Memperbarui status pekerjaan (Open <-> Closed)
  Future<void> updateStatus(int pekerjaanId, String currentStatus) async {
    final String apiUrl = '$baseUrl/pekerjaan/$pekerjaanId/update-status';

    final newStatus = currentStatus == 'open' ? 'close' : 'open';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': newStatus}),
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Gagal memperbarui status');
      }
    } catch (e) {
      throw Exception('Gagal memperbarui status: $e');
    }
  }

   Future<void> hapusPekerjaan(int pekerjaanId) async {
    final String apiUrl = '$baseUrl/dosen/pekerjaan/delete/$pekerjaanId';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ??
            'Gagal menghapus pekerjaan (status ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal menghapus pekerjaan: $e');
    }
  }

  Future<List<DosenPekerjaanModel>> fetchDaftarMahasiswa(int pekerjaanId) async {
    final String url = '$baseUrl/dosen/lihat-daftar-mahasiswa/$pekerjaanId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['data'] as List)
            .map((item) => DosenPekerjaanModel.fromJson(item))
            .toList();
      } else if (response.statusCode == 404) {
        return []; // Jika tidak ada data
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<void> kickMahasiswa(int pekerjaanId, int userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/dosen/$pekerjaanId/kick-mahasiswa/$userId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus mahasiswa');
    }
  }

  Future<List<Map<String, dynamic>>> getPendingApplicants(int pekerjaanId) async {
    final String url = '$baseUrl/dosen/pending-pekerjaan/$pekerjaanId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Gagal mendapatkan data pelamar pending.');
    }
  }
}
