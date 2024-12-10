class DashboardDsn {
  final User? user;
  final List<Pekerjaan> pekerjaan;
  final List<PendingPekerjaan> pendingPekerjaan;
  final int totalPekerjaan;
  final int totalPekerjaanOpen;
  final int totalPekerjaanClosed;

  DashboardDsn({
    required this.user,
    required this.pekerjaan,
    required this.pendingPekerjaan,
    required this.totalPekerjaan,
    required this.totalPekerjaanOpen,
    required this.totalPekerjaanClosed,
  });

  factory DashboardDsn.fromJson(Map<String, dynamic> json) {
    // Mengambil daftar pekerjaan
    List<Pekerjaan> pekerjaan = (json['pekerjaan'] as List<dynamic>? ?? [])
        .map((item) => Pekerjaan.fromJson(item))
        .toList();

    // Mengambil daftar pekerjaan tertunda
    List<PendingPekerjaan> pendingPekerjaan = (json['pending_pekerjaan'] as List<dynamic>? ?? [])
        .map((item) => PendingPekerjaan.fromJson(item))
        .toList();

    return DashboardDsn(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      pekerjaan: pekerjaan,
      pendingPekerjaan: pendingPekerjaan,
      totalPekerjaan: json['total_pekerjaan'] ?? 0,
      totalPekerjaanOpen: json['total_pekerjaan_open'] ?? 0,
      totalPekerjaanClosed: json['total_pekerjaan_closed'] ?? 0,
    );
  }
}

class User {
  final int userId;
  final String nama;
  final String avatar;

  User({
    required this.userId,
    required this.nama,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      nama: json['nama'],
      avatar: json['avatar'],
    );
  }
}

class Pekerjaan {
  final int pekerjaanId;
  final String pekerjaanNama;
  final String jenisPekerjaan;
  final String status;
  final String? akumulasiDeadline;

  Pekerjaan({
    required this.pekerjaanId,
    required this.pekerjaanNama,
    required this.jenisPekerjaan,
    required this.status,
    this.akumulasiDeadline,
  });

  factory Pekerjaan.fromJson(Map<String, dynamic> json) {
    return Pekerjaan(
      pekerjaanId: json['pekerjaan_id'],
      pekerjaanNama: json['pekerjaan_nama'],
      jenisPekerjaan: json['jenis_pekerjaan'],
      status: json['status'],
      akumulasiDeadline: json['akumulasi_deadline'],
    );
  }
}

class PendingPekerjaan {
  final int pendingPekerjaanId;
  final User user;
  final Pekerjaan pekerjaan;

  PendingPekerjaan({
    required this.pendingPekerjaanId,
    required this.user,
    required this.pekerjaan,
  });

  factory PendingPekerjaan.fromJson(Map<String, dynamic> json) {
    return PendingPekerjaan(
      pendingPekerjaanId: json['t_pending_pekerjaan_id'],
      user: User.fromJson(json['user']),
      pekerjaan: Pekerjaan.fromJson(json['pekerjaan']),
    );
  }
}
