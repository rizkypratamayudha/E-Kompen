import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controller/dosen_pekerjaan_service.dart';
import '../Model/dosen_pekerjaan_model.dart';
import '../widget/popup_edit_deadline.dart';

class EditDeadlinePage extends StatefulWidget {
  final int pekerjaanId;
  final String pekerjaanNama;

  const EditDeadlinePage({
    Key? key,
    required this.pekerjaanId,
    required this.pekerjaanNama,
  }) : super(key: key);

  @override
  _EditDeadlinePageState createState() => _EditDeadlinePageState();
}

class _EditDeadlinePageState extends State<EditDeadlinePage> {
  final Map<int, int> _tambahHariMap = {};
  final Map<int, DateTime?> _deadlineBaruMap = {};
  final Map<int, TextEditingController> _controllers = {};
  final DosenBuatPekerjaanService _service = DosenBuatPekerjaanService();
  bool _isLoading = false;
  List<AmbilProgres> _progressList = [];
  int _totalJam = 0;
  DateTime _batasPengerjaan = DateTime.now();

  // Tambahkan controller dan variabel untuk deadline
  final TextEditingController _tambahHariController = TextEditingController();
  DateTime? deadlineBaru;

  @override
  void initState() {
    super.initState();
    _fetchProgressData();
  }

  void _fetchProgressData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Ambil data progres dari API
      final progressData =
          await _service.fetchProgressByPekerjaan(widget.pekerjaanId);

      // Tambahkan log untuk memeriksa data
      debugPrint('Progress Data: $progressData');

      // Proses data progres
      _progressList = progressData.map((progress) {
        final deadlineAwal = progress.deadline ?? DateTime.now();

        // Hitung deadline baru dengan tambahan hari default
        final deadlineBaruDefault =
            hitungDeadlineBaru(progress.id, deadlineAwal);

        // Simpan ke peta deadline baru
        _deadlineBaruMap[progress.id] = deadlineBaruDefault;

        return AmbilProgres(
          id: progress.id,
          judulProgres: progress.judulProgres,
          jumlahJam: progress.jumlahJam,
          jumlahHari: progress.jumlahHari,
          deadline: progress.deadline,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching progress: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data progres: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Fungsi untuk menghitung deadline baru berdasarkan logika yang diberikan
  DateTime? hitungDeadlineBaru(int progresId, DateTime? originalDeadline) {
    DateTime previousDeadline = DateTime.now(); // Untuk progres pertama

    for (var i = 0; i < _progressList.length; i++) {
      final progress = _progressList[i];
      final currentProgresId = progress.id;

      if (currentProgresId == progresId) {
        return previousDeadline.add(Duration(
          days: (_tambahHariMap[progress.id] ?? 0) + progress.jumlahHari,
        ));
      }

      previousDeadline = _deadlineBaruMap[currentProgresId] ??
          progress.deadline ??
          previousDeadline.add(Duration(days: progress.jumlahHari));
    }

    return null; // Fallback jika ID tidak ditemukan
  }

  @override
  Widget buildBoxEditDeadlinePage(
    int index,
    int progresId, // Gunakan ID unik untuk progres
    String progresNama,
    int jumlahJam,
    String hari,
    DateTime? deadline,
  ) {
    if (!_controllers.containsKey(progresId)) {
      _controllers[progresId] = TextEditingController(
        text: '0', // Nilai default adalah "0"
      );
      _tambahHariMap[progresId] = 0; // Tambahkan nilai default untuk progres
      _deadlineBaruMap[progresId] = hitungDeadlineBaru(progresId, deadline);
    }

    return FractionallySizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFFF4D03F),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Progres ${index + 1}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 60),
            decoration: const BoxDecoration(
              color: Color(0xFF1A6FD3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progres Nama: $progresNama',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                ),
                const Divider(color: Colors.white),
                Text(
                  'Jumlah Jam: $jumlahJam Jam',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                ),
                const Divider(color: Colors.white),
                Text(
                  'Hari yang diperlukan: $hari',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                ),
                const Divider(color: Colors.white),
                Text(
                  'Deadline: ${deadline != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(deadline) : 'Belum membuat deadline'}',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                ),
                const Divider(color: Colors.white),
                TextField(
                    controller: _controllers[progresId],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Tambah hari:',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        // Ambil nilai tambahan hari untuk progres ini
                        int tambahanHari =
                            int.tryParse(value.isEmpty ? '0' : value) ?? 0;
                        _tambahHariMap[progresId] = tambahanHari;

                        // Perhitungan ulang semua deadline baru mulai dari progres ini
                        for (int i = index; i < _progressList.length; i++) {
                          final progress = _progressList[i];

                          // Jika ini adalah progres pertama, gunakan waktu sekarang
                          final previousDeadline = i == 0
                              ? DateTime.now()
                              : _deadlineBaruMap[_progressList[i - 1].id] ??
                                  _progressList[i - 1].deadline ??
                                  DateTime.now();

                          // Hitung deadline baru hanya berdasarkan progres ini
                          final tambahanHariProgres = i == index
                              ? tambahanHari // Gunakan tambahan hari yang baru diubah
                              : _tambahHariMap[progress.id] ?? 0;

                          _deadlineBaruMap[progress.id] = previousDeadline.add(
                            Duration(
                              days: tambahanHariProgres + progress.jumlahHari,
                            ),
                          );
                        }
                      });
                    }),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFADD8E6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Deadline Baru: ${_deadlineBaruMap[progresId] != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(_deadlineBaruMap[progresId]!) : '-'}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _tampilkanAkumulasi() {
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    setState(() {
      _totalJam = _progressList.fold(0, (sum, item) => sum + item.jumlahJam);

      // Hitung batas pengerjaan berdasarkan deadline baru terakhir
      _batasPengerjaan = _deadlineBaruMap[_progressList.last.id] ??
          _progressList.last.deadline ??
          DateTime.now();
    });

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoBox('Jumlah Jam:', '$_totalJam jam'),
              _buildInfoBox(
                'Batas Pengerjaan:',
                dateFormatter.format(_batasPengerjaan),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _simpanAkumulasi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Simpan',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoBox(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _simpanAkumulasi() async {
    try {
      // Siapkan data progres dengan deadline baru
      final progresData = _progressList.map((progress) {
        final currentDeadline =
            _deadlineBaruMap[progress.id] ?? progress.deadline;

        return {
          'progress_id': progress.id,
          'deadline': currentDeadline?.toIso8601String() ??
              DateTime.now().toIso8601String(),
          'hari': progress.jumlahHari, // Kirim nilai hari lama
          'tambah_hari':
              _tambahHariMap[progress.id] ?? 0, // Kirim nilai tambah hari
        };
      }).toList();

      // Kirim data ke server
      await _service.updateDeadline(
        widget.pekerjaanId,
        {
          'akumulasi_deadline': _batasPengerjaan.toIso8601String(),
          'progres_deadlines': progresData,
        },
      );

      // Tampilkan popup
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupEditDeadline(); // Pastikan widget ini ada di `popup_mulai_deadline.dart`
      },
    );
    } catch (e) {
      // Tampilkan notifikasi kegagalan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Deadline: ${widget.pekerjaanNama}',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Widget di bagian atas yang tidak ikut scroll
          CustomEditDeadlinePageWidget(
            pekerjaanNama: widget.pekerjaanNama,
            jumlahProgres: _progressList.length,
          ),
          const SizedBox(height: 16),
          // Expanded untuk bagian yang bisa di-scroll
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _progressList.length,
              itemBuilder: (context, index) {
                final progress = _progressList[index];
                // Jika ini adalah progres pertama, gunakan waktu sekarang
                final previousDeadline = index == 0
                    ? DateTime.now()
                    : DateTime.now().add(
                        Duration(
                          days: _progressList
                              .take(index) // Ambil semua progres sebelum ini
                              .fold(0, (sum, item) => sum + item.jumlahHari),
                        ),
                      );

                final currentDeadline =
                    previousDeadline.add(Duration(days: progress.jumlahHari));

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: buildBoxEditDeadlinePage(
                    index,
                    progress.id, // Kirim ID unik
                    progress.judulProgres,
                    progress.jumlahJam,
                    '${progress.jumlahHari} Hari',
                    progress.deadline,
                  ),
                );
              },
            ),
          ),

          // Tombol Akumulasi di bagian bawah
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 50,
            child: ElevatedButton(
              onPressed: _tampilkanAkumulasi,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Akumulasi',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const Icon(Icons.arrow_upward, color: Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class CustomEditDeadlinePageWidget extends StatelessWidget {
  final String pekerjaanNama;
  final int jumlahProgres;

  const CustomEditDeadlinePageWidget({
    Key? key,
    required this.pekerjaanNama,
    required this.jumlahProgres,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double boxWidth = MediaQuery.of(context).size.width * 0.85;

    return Center(
      child: Container(
        width: boxWidth,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.work_history_outlined,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pekerjaanNama,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const Divider(color: Colors.white),
                  Text(
                    'Progres: $jumlahProgres',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
