class Gallery {
  final String imageUrl;
  final String title;
  final String date;

  Gallery({required this.imageUrl, required this.title, required this.date});

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      imageUrl: json['foto'] ?? '', // Pastikan sesuai dengan response API
      title: json['title'] ?? 'Untitled',
      date: json['date'] ?? 'Unknown',
    );
  }
}
