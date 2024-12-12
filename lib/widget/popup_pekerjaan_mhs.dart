import 'package:firstapp/controller/Pekerjaan.dart';
import 'package:firstapp/controller/apply.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopUpPekerjaan extends StatelessWidget {
  final Pekerjaan pekerjaan;

  const PopUpPekerjaan({Key? key, required this.pekerjaan}) : super(key: key);

  Future<void> _applyPekerjaan(BuildContext context) async {
    final applyService = Apply();
    final response = await applyService.applyPekerjaan(pekerjaan.pekerjaan_id);

    // Tampilkan hasil respons
    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'],
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'],
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    Navigator.of(context).pop(); // Tutup popup setelah proses selesai
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Dosen : ${pekerjaan.user.nama}',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Text(
              'Nomor Dosen : ${pekerjaan.user.detail_dosen?.no_hp ?? '-'}',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Text(
              'Jenis Pekerjaan : ${pekerjaan.jenis_pekerjaan}',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Text(
              'Nama Pekerjaan : ${pekerjaan.pekerjaan_nama}',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Text(
              'Jumlah Progres : ${pekerjaan.progres.length}',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Text(
              'Nilai Total Jam Kompen : ${pekerjaan.jumlah_jam_kompen}',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Text(
              'Jumlah Anggota : ${pekerjaan.detail_pekerjaan.jumlah_anggota}',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Text(
              'Persyaratan : ${pekerjaan.detail_pekerjaan.persyaratan.map((p) => p.persyaratan_nama).join(', ')}',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Text(
              'Kompetensi : ${pekerjaan.detail_pekerjaan.kompetensi_dosen.map((p) => p.kompetensi_admin.kompetensi_nama).join(', ')}',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${pekerjaan.detail_pekerjaan.deskripsi_tugas}.',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => _applyPekerjaan(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Apply',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
