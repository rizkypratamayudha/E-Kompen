import 'package:firstapp/Dosen/tambah_progres.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahPekerjaanPage extends StatefulWidget {
  const TambahPekerjaanPage({super.key});

  @override
  _TambahPekerjaanPageState createState() => _TambahPekerjaanPageState();
}

class _TambahPekerjaanPageState extends State<TambahPekerjaanPage> {
  final _formKey = GlobalKey<FormState>();

  Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  final TextEditingController _dateController = TextEditingController();
  String? _nama;
  String? _jenisTugas;
  int? _jumlahAnggota;
  int? _jumlahProgress;
  String? _deskripsi;
  String? _status = "open";
  List<TextEditingController> _persyaratanControllers = [];

  @override
  void dispose() {
    // Membersihkan semua controller saat widget dihancurkan
    for (var controller in _persyaratanControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Pekerjaan',
          style: GoogleFonts.poppins(fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Jenis Tugas',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: ['Penelitian', 'Pengabdian', 'Teknis']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (String? newValue) => _jenisTugas = newValue,
                validator: (value) =>
                    value == null ? 'Mohon pilih jenis tugas' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama Pekerjaan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) => _nama = value,
                validator: (value) =>
                    value!.isEmpty ? 'Mohon masukkan nama pekerjaan' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Jumlah Anggota',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _jumlahAnggota = int.tryParse(value),
                validator: (value) =>
                    value!.isEmpty ? 'Mohon masukkan jumlah anggota' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Jumlah Persyaratan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  int? jumlah = int.tryParse(value);
                  if (jumlah != null) {
                    setState(() {
                      _persyaratanControllers = List.generate(
                        jumlah,
                        (index) => TextEditingController(),
                      );
                    });
                  }
                },
                validator: (value) =>
                    value!.isEmpty ? 'Mohon masukkan jumlah persyaratan' : null,
              ),
              ..._persyaratanControllers.asMap().entries.map((entry) {
                int index = entry.key;
                TextEditingController controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Persyaratan ${index + 1}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Mohon masukkan persyaratan ${index + 1}' : null,
                  ),
                );
              }).toList(),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Jumlah Progress',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _jumlahProgress = int.tryParse(value),
                validator: (value) =>
                    value!.isEmpty ? 'Mohon masukkan jumlah progress' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Deskripsi Tugas',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
                onChanged: (value) => _deskripsi = value,
                validator: (value) =>
                    value!.isEmpty ? 'Mohon masukkan deskripsi' : null,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final userId = await _getUserId();
                        final persyaratanList = _persyaratanControllers
                            .map((controller) => controller.text)
                            .toList();
                        final pekerjaanData = {
                          'userId': userId,
                          'jenisTugas': _jenisTugas!,
                          'nama': _nama!,
                          'jumlahAnggota': _jumlahAnggota!,
                          'persyaratan': persyaratanList,
                          'jumlahProgress': _jumlahProgress!,
                          'deskripsi': _deskripsi!,
                          'status': _status!,
                          'jumlah_jam_kompen': 0,
                          'akumulasi_deadline': "Tidak Ditentukan",
                        };

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TambahProgresPage(pekerjaanData: pekerjaanData),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(130, 50),
                    ),
                    child: Text(
                      "Next",
                      style: GoogleFonts.poppins(
                        color: Colors.white, // Warna teks putih
                        fontSize: 14, // Ukuran font 14
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
