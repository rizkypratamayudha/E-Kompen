class DashboardMhs {
  final User user;
  final List<JamKompen> jamKompen;

  DashboardMhs({required this.user, required this.jamKompen});

  factory DashboardMhs.fromJson(Map<String, dynamic> json) {
    return DashboardMhs(
      user: User.fromJson(json['user']),
      jamKompen: List<JamKompen>.from(
        (json['jamkompen'] ?? []).map((item) => JamKompen.fromJson(item)),
      ),
    );
  }
}

class User {
  final int userId;
  final String username;
  final String name;
  final String avatar;
  final Level level;
  final DetailMahasiswa detailMahasiswa;
  final JamKompen? jamKompen;

  User({
    required this.userId,
    required this.username,
    required this.name,
    required this.avatar,
    required this.level,
    required this.detailMahasiswa,
    this.jamKompen,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? '',
      name: json['nama'] ?? '',
      avatar: json['avatar'] ?? '',
      level: Level.fromJson(json['level'] ?? {}),
      detailMahasiswa: DetailMahasiswa.fromJson(json['detail_mahasiswa'] ?? {}),
      jamKompen: json['jam_kompen'] != null
          ? JamKompen.fromJson(json['jam_kompen'])
          : null,
    );
  }
}

class Level {
  final int levelId;
  final String levelNama;

  Level({
    required this.levelId,
    required this.levelNama,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      levelId: json['level_id'] ?? 0,
      levelNama: json['level_nama'] ?? '',
    );
  }
}

class DetailMahasiswa {
  final String email;
  final String noHp;
  final String angkatan;
  final Prodi prodi;
  final Periode periode;

  DetailMahasiswa({
    required this.email,
    required this.noHp,
    required this.angkatan,
    required this.prodi,
    required this.periode,
  });

  factory DetailMahasiswa.fromJson(Map<String, dynamic> json) {
    return DetailMahasiswa(
      email: json['email'] ?? '',
      noHp: json['no_hp'] ?? '',
      angkatan: json['angkatan'] ?? '',
      prodi: Prodi.fromJson(json['prodi'] ?? {}),
      periode: Periode.fromJson(json['periode'] ?? {}),
    );
  }
}

class Prodi {
  final String prodiNama;

  Prodi({required this.prodiNama});

  factory Prodi.fromJson(Map<String, dynamic> json) {
    return Prodi(
      prodiNama: json['prodi_nama'] ?? '',
    );
  }
}

class Periode {
  final String periodeNama;

  Periode({required this.periodeNama});

  factory Periode.fromJson(Map<String, dynamic> json) {
    return Periode(
      periodeNama: json['periode_nama'] ?? '',
    );
  }
}

class JamKompen {
  final int jamKompenId;
  final int akumulasiJam;
  final List<DetailJamKompen> detailJamKompen;

  JamKompen({
    required this.jamKompenId,
    required this.akumulasiJam,
    required this.detailJamKompen,
  });

  factory JamKompen.fromJson(Map<String, dynamic> json) {
    return JamKompen(
      jamKompenId: json['jam_kompen_id'] ?? 0,
      akumulasiJam: json['akumulasi_jam'] ?? 0,
      detailJamKompen: List<DetailJamKompen>.from(
        (json['detail_jam_kompen'] ?? [])
            .map((item) => DetailJamKompen.fromJson(item)),
      ),
    );
  }
}

class DetailJamKompen {
  final int detailJamKompenId;
  final int matkulId;
  final int jumlahJam;
  final Matkul matkul;

  DetailJamKompen({
    required this.detailJamKompenId,
    required this.matkulId,
    required this.jumlahJam,
    required this.matkul,
  });

  factory DetailJamKompen.fromJson(Map<String, dynamic> json) {
    return DetailJamKompen(
      detailJamKompenId: json['detail_jam_kompen_id'] ?? 0,
      matkulId: json['matkul_id'] ?? 0, // Ambil matkul_nama dari JSON
      jumlahJam: json['jumlah_jam'] ?? 0,
      matkul: Matkul.fromJson(json['matkul'] ?? {}),
    );
  }
}

class Matkul {
  final int matkulId;
  final String matkulKode;
  final String matkulNama;

  Matkul({
    required this.matkulId,
    required this.matkulKode,
    required this.matkulNama,
  });

  factory Matkul.fromJson(Map<String, dynamic> json) {
    return Matkul(
      matkulId: json['matkul_id'] ?? 0,
      matkulKode: json['matkul_kode'] ?? '',
      matkulNama: json['matkul_nama'] ?? 'Tidak Diketahui',
    );
  }
}
