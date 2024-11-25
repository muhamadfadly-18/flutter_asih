class Agenda {
  final int id;
  final String judul;
  final String deskripsi;
  final String kategori;

  Agenda({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.kategori,
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      kategori: json['kategori']?['kategori'] ?? '', // Ambil kategori dari objek kategori
    );
  }
}
