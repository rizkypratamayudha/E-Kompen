import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controller/dosen_pekerjaan_service.dart';
import '../Model/dosen_pekerjaan_model.dart';
import '../widget/popup_mulai_deadline.dart';

class MulaiDeadlinePage extends StatefulWidget {
  final int pekerjaanId;
  final String pekerjaanNama;

  const MulaiDeadlinePage({
    Key? key,
    required this.pekerjaanId,
    required this.pekerjaanNama,
  }) : super(key: key);

  @override
  _MulaiDeadlinePageState createState() => _MulaiDeadlinePageState();
}

class _MulaiDeadlinePageState extends State<MulaiDeadlinePage> {
  final DosenBuatPekerjaanService _service = DosenBuatPekerjaanService();
  bool _isLoading = false;
  List<AmbilProgres> _progressList = [];
  int _totalJam = 0;
  DateTime _batasPengerjaan = DateTime.now();

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
        return AmbilProgres(
          id: progress.id,
          judulProgres: progress.judulProgres,
          jumlahJam: progress.jumlahJam, // Pastikan jumlahJam diambil
          jumlahHari: progress.jumlahHari, // Pastikan jumlahHari diambil
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

  Widget buildBoxMulaiDeadlinePage(
    int index, // Tambahkan index progres
    String progresNama,
    int jumlahJam,
    String hari,
    String deadline,
  ) {
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
              'Progres ${index + 1}', // Tampilkan nomor progres
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
                  'Deadline: $deadline',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
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
      _batasPengerjaan = DateTime.now().add(
        Duration(
          days: _progressList.fold(0, (sum, item) => sum + item.jumlahHari),
        ),
      );
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
    DateTime previousDeadline = DateTime.now();

    await _service.mulaiDeadline(
      widget.pekerjaanId,
      {
        'akumulasi_deadline': _batasPengerjaan.toIso8601String(),
        'progres_deadlines': _progressList.map((progress) {
          // Hitung deadline progres
          final currentDeadline =
              previousDeadline.add(Duration(days: progress.jumlahHari));
          previousDeadline = currentDeadline;

          return {
            'progress_id': progress.id,
            'deadline': currentDeadline.toIso8601String(),
          };
        }).toList(),
      },
    );

    // Tampilkan popup
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupMulaiDeadline(); // Pastikan widget ini ada di `popup_mulai_deadline.dart`
      },
    );
  } catch (e) {
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
          'Mulai Deadline: ${widget.pekerjaanNama}',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Widget di bagian atas yang tidak ikut scroll
          CustomMulaiDeadlinePageWidget(
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
                  child: buildBoxMulaiDeadlinePage(
                    index,
                    progress.judulProgres,
                    progress.jumlahJam,
                    '${progress.jumlahHari} Hari',
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDeadline),
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

class CustomMulaiDeadlinePageWidget extends StatelessWidget {
  final String pekerjaanNama;
  final int jumlahProgres;

  const CustomMulaiDeadlinePageWidget({
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
